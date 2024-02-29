defmodule SFFoodTrucks.Fixture.BatchProcessorTest do
  use SFFoodTrucks.DataCase

  alias SFFoodTrucks.Fixture.BatchProcessor

  test "send all progress messages to the liveview process" do
    items = Enum.to_list(1..26)
    {:ok, _pid} = BatchProcessor.run(items, &{:ok, &1}, batch_size: 5)

    assert_receive {:update_progress, 16, 1, 6}
    assert_receive {:update_progress, 33, 2, 6}
    assert_receive {:update_progress, 50, 3, 6}
    assert_receive {:update_progress, 66, 4, 6}
    assert_receive {:update_progress, 83, 5, 6}
    assert_receive {:update_progress, 100, 6, 6}
    refute_receive {:update_progress, _, _, _}
  end

  test "stops normally after handling all items" do
    items = Enum.to_list(1..10)
    {:ok, pid} = BatchProcessor.run(items, &{:ok, &1}, batch_size: 5)

    ref = Process.monitor(pid)

    assert_receive {:update_progress, _, _, _}
    assert_receive {:update_progress, _, _, _}
    refute_receive {:update_progress, _, _, _}
    assert_receive {:DOWN, ^ref, :process, ^pid, _reason}
  end

  test "it calls the given processor function" do
    items = Enum.to_list(1..11)
    test_pid = self()

    processor_fn = fn chunk ->
      send(test_pid, {:processed, chunk})
      {:ok, chunk}
    end

    {:ok, _pid} = BatchProcessor.run(items, processor_fn, batch_size: 5)

    assert_receive {:processed, [1, 2, 3, 4, 5]}
    assert_receive {:update_progress, _, _, _}
    assert_receive {:processed, [6, 7, 8, 9, 10]}
    assert_receive {:update_progress, _, _, _}
    assert_receive {:processed, [11]}
    assert_receive {:update_progress, _, _, _}
    refute_receive {:update_progress, _, _, _}
  end

  defmodule FakeHandler do
    def init(state) do
      {:ok, state}
    end

    def handle_info(_, %{test_pid: test_pid} = state) do
      send(test_pid, :chunk_received)
      # kill after 1st chunk
      {:stop, :shutdown, state}
    end
  end

  test "stop processor if handler dies (e.g. browser reload) and call the cancel_callback for custom logging" do
    items = Enum.to_list(1..1000)
    test_pid = self()
    {:ok, handler_pid} = GenServer.start(FakeHandler, %{test_pid: test_pid})
    cancel_callback = fn info -> send(test_pid, {:cancelled, info}) end
    processor = fn _ -> {:ok, Process.sleep(1)} end

    {:ok, processor_pid} =
      BatchProcessor.run(items, processor,
        handler_pid: handler_pid,
        batch_size: 5,
        cancel_callback: cancel_callback
      )

    ref = Process.monitor(processor_pid)

    assert_receive :chunk_received
    assert_receive {:cancelled, %{step: step, progress: progress}}
    assert step > 0 and progress < 100
    assert_receive {:DOWN, ^ref, :process, ^processor_pid, _reason}
  end

  test "user cancels process" do
    items = Enum.to_list(1..111)
    processor = fn _ -> {:ok, Process.sleep(5)} end
    {:ok, processor_pid} = BatchProcessor.run(items, processor, batch_size: 5)
    ref = Process.monitor(processor_pid)

    send(processor_pid, :cancel)
    assert_receive {:update_progress, _, _, _}

    refute_receive {:update_progress, _, _, _}
    assert_receive {:DOWN, ^ref, :process, ^processor_pid, _reason}
  end

  test "stop processing and send the error to the handler when the processor returns {:error, reason}" do
    items = Enum.to_list(1..20)

    processor = fn chunk ->
      if chunk == [6, 7, 8, 9, 10], do: {:error, "Some error"}, else: {:ok, :noop}
    end

    {:ok, _pid} = BatchProcessor.run(items, processor, batch_size: 5)

    assert_receive {:update_progress, 25, 1, 4}
    assert_receive {:processing_error, 25, "Some error"}
    refute_receive {:update_progress, _, _, _}
  end

  test "stop processing and send the error to the handler on failure (exception)" do
    items = Enum.to_list(1..20)

    processor = fn chunk ->
      if chunk == [6, 7, 8, 9, 10], do: raise("Some error"), else: {:ok, :noop}
    end

    {:ok, _pid} = BatchProcessor.run(items, processor, batch_size: 5)

    assert_receive {:update_progress, 25, 1, 4}
    assert_receive {:processing_error, 25, %RuntimeError{message: "Some error"}}
    refute_receive {:update_progress, _, _, _}
  end
end
