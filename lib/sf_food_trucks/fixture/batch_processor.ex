defmodule SFFoodTrucks.Fixture.BatchProcessor do
  use GenServer, restart: :temporary

  alias SFFoodTrucks.Fixture.BatchProcessor

  @supervisor SFFoodTrucks.Fixture.BatchProcessorSupervisor
  @default_chunk_size 100

  @spec run(list(), function(), keyword()) :: any()
  def run(items, processor_fn, opts \\ []) do
    handler_pid = Keyword.get(opts, :handler_pid, self())
    chunk_size = Keyword.get(opts, :batch_size, @default_chunk_size)
    cancel_callback = Keyword.get(opts, :cancel_callback, fn _ -> :noop end)

    DynamicSupervisor.start_child(
      @supervisor,
      {BatchProcessor,
       %{
         items: items,
         processor_fn: processor_fn,
         handler_pid: handler_pid,
         chunk_size: chunk_size,
         cancel_callback: cancel_callback
       }}
    )
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg)
  end

  def init(arg) do
    %{
      items: items,
      handler_pid: handler_pid,
      processor_fn: processor_fn,
      chunk_size: chunk_size,
      cancel_callback: cancel_callback
    } = arg

    ref = Process.monitor(handler_pid)

    chunks = Enum.chunk_every(items, chunk_size)
    total = length(chunks)

    send(self(), :next_chunk)

    {:ok,
     %{
       chunks: chunks,
       step: 0,
       total: total,
       handler_pid: handler_pid,
       processor_fn: processor_fn,
       ref: ref,
       cancel_callback: cancel_callback
     }}
  end

  def handle_info(:next_chunk, %{chunks: [items | rest]} = state) do
    # Process.sleep(100)
    %{step: step, total: total, handler_pid: handler_pid, processor_fn: processor_fn} = state

    result =
      try do
        processor_fn.(items)
      rescue
        e -> {:error, e}
      end

    case result do
      {:ok, _success_message} ->
        new_step = step + 1
        counter_progress = progress(new_step, total)

        send(handler_pid, {:update_progress, counter_progress, new_step, total})

        new_state = %{state | chunks: rest, step: new_step}

        if rest != [] do
          send(self(), :next_chunk)
          {:noreply, new_state}
        else
          {:stop, :normal, new_state}
        end

      {:error, error} ->
        send(handler_pid, {:processing_error, progress(step, total), error})
        {:stop, :normal, state}
    end
  end

  def handle_info(
        {:DOWN, ref, :process, handler_pid, _reason},
        %{handler_pid: handler_pid, ref: ref} = state
      ) do
    %{cancel_callback: cancel_callback, step: step, total: total} = state
    cancel_callback.(%{step: step, total: total, progress: progress(step, total)})
    {:stop, :normal, state}
  end

  def handle_info(:cancel, state) do
    %{step: step, total: total, handler_pid: handler_pid} = state

    send(
      handler_pid,
      {:processing_cancelled, %{step: step, total: total, progress: progress(step, total)}}
    )

    {:stop, :normal, state}
  end

  def cancel(pid) do
    send(pid, :cancel)
  end

  defp progress(step, total) do
    floor(step / total * 100)
  end
end
