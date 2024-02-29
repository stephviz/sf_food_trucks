defmodule SFFoodTrucksWeb.ImporterLive do
  use SFFoodTrucksWeb, :surface_live_view

  alias SFFoodTrucks.Fixture.BatchProcessor
  alias SFFoodTrucks.MessageQueues.MessageHandler
  alias SFFoodTrucksComponents.Icon
  alias Surface.Components.LiveFileInput
  alias Ecto.Changeset

  require Logger

  data show, :boolean, default: false

  data modal_errors, :list, default: []

  data progress, :integer, default: 0

  data state, :atom,
    values: [
      :selecting,
      :selected,
      :uploding,
      :importing,
      :error,
      :success,
      :cancelled,
      :cancelling
    ],
    default: :selecting

  def mount(_params, _session, socket) do
    socket =
      socket
      |> allow_upload(:data_import,
        accept: ~w(.json),
        max_entries: 1,
        max_file_size: 75_000_000,
        progress: &handle_upload_progress/3
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <button phx-click="open_modal" class="test">
      Import
    </button>
    <div>
      <section
        :if={@show}
        aria-hidden="true"
        class="overflow-y-auto overflow-x-hidden fixed z-50 inset-0 flex justify-center items-center"
        :on-click-away="close_import_modal"
        :on-window-keydown={can_close_on_key?(@state)}
        phx-key="escape"
      >
        <div class="px-4 w-96 custom-bg-grey">
          <div class="relative rounded-lg bg-base-100 w-96 pb-6">
            <div :if={@state in [:selecting, :selected]} class="flex justify-end items-center pt-3 pr-3">
              <div class="modal-close cursor-pointer z-50">
                <svg
                  :on-click="close_import_modal"
                  class="fill-current"
                  xmlns="http://www.w3.org/2000/svg"
                  width="18"
                  height="18"
                  viewBox="0 0 18 18"
                >
                  <path d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z">
                  </path>
                </svg>
              </div>
            </div>
            <form id="upload_incidents" class="flex-col" phx-submit="import" phx-change="validate">
              <div :show={@state in [:selecting, :selected]} class="px-10 pb-3 pt-3">
                <div phx-drop-target={@uploads.data_import.ref}>
                  <div class="p-7 font-semibold text-center bg-base-300">
                    <label :show={@state == :selecting} class="w-full h-full cursor-pointer">
                      <Icon.drop_file class="h-16 w-16 inline mb-4" />
                      <div class="text-xl">Drop file here</div>
                      or
                      <LiveFileInput class="hidden" upload={@uploads.data_import} />
                      <span class="text-primary hover:text-primary hover:underline">select file</span>
                      from this computer.
                    </label>
                    <div :show={@state == :selected}>
                      <div class="text-gray-400">Selected file:</div>
                      <div class="mt-2 mb-8">
                        {#for entry <- @uploads.data_import.entries}
                          {entry.client_name}
                        {/for}
                      </div>
                      <div class="text-sm text-gray-400">
                        Click "Import" to start uploading or
                        <button type="button" class="text-primary hover:text-primary hover:underline" :on-click="cancel">
                          choose
                        </button>
                        another file.
                      </div>
                    </div>
                  </div>
                </div>
                <div :for={err <- @modal_errors} class="flex justify-center">
                  <span class="px-2 bg-red-100 text-red-700">{err}</span>
                </div>
              </div>
              <div :if={@state == :uploading} class="px-10 pt-10 h-1/2">
                {#for entry <- @uploads.data_import.entries}
                  <div class="flex flex-col items-center">
                    <div class="mb-2 font-bold text-xl">Preparing import</div>
                    <div class="w-full my-5 flex flex-col items-center">
                      <progress class={progress_color_by_state(@state)} value={entry.progress} max="100" />
                      <div class="mt-4 text-sm">Uploading file... {entry.progress}%</div>
                    </div>
                  </div>
                {/for}
              </div>
              <div :if={@state == :importing} class="px-10 pt-10 h-1/2">
                <div class="flex flex-col items-center">
                  <div class="mb-2 font-bold text-xl">Import in progress</div>
                  <div class="w-full my-5 flex flex-col items-center">
                    <progress class={progress_color_by_state(@state)} value={@progress} max="100" />
                    <div class="mt-4 text-sm">Importing... {@progress}%</div>
                  </div>
                </div>
              </div>
              <div :if={@state == :success} class="px-10 pt-10 h-1/2">
                <div class="flex flex-col items-center">
                  <div class="mb-2 font-bold text-xl">Success!</div>
                  <div class="w-full my-5 flex flex-col items-center">
                    <progress class={progress_color_by_state(@state)} value={@progress} max="100" />
                    <div class="mt-4 text-sm">{@progress}%</div>
                  </div>
                </div>
              </div>
              <div :if={@state == :error} class="px-10 py-5 h-1/2">
                <div class="flex flex-col items-center">
                  <Icon.x_cancel class="w-1/4 text-void m-2 flex items-center" />
                  <div :if={@progress > 0} class="w-full my-5 flex flex-col items-center">
                    <progress class={progress_color_by_state(@state)} value={@progress} max="100" />
                    <div class="mt-4 text-sm">Imported: {@progress}%</div>
                  </div>
                  <div class="my-4 text-sm">{@modal_errors}</div>
                  <div class="text-sm text-gray-400">
                    Click "Ok" to finish or
                    <button type="button" class="text-primary hover:text-primary hover:underline" :on-click="cancel">
                      choose
                    </button>
                    another file.
                  </div>
                </div>
              </div>
              <div :if={@state == :cancelling} class="px-10 pt-10 h-1/2">
                <div class="flex flex-col items-center">
                  <div class="mb-2 font-bold text-xl">Canceling import...</div>
                  <div class="w-full my-5 flex flex-col items-center">
                    <progress class={progress_color_by_state(@state)} value={@progress} max="100" />
                    <div class="mt-4 text-sm">Imported: {@progress}%</div>
                  </div>
                </div>
              </div>
              <div :if={@state == :cancelled} class="px-10 pt-10 h-1/2">
                <div class="flex flex-col items-center">
                  <div class="mb-2 font-bold text-xl">Import cancelled</div>
                  <div class="w-full my-5 flex flex-col items-center">
                    <progress class={progress_color_by_state(@state)} value={@progress} max="100" />
                    <div class="mt-4 text-sm">Total imported before cancelling: {@progress}%</div>
                  </div>
                  <div class="text-sm text-gray-400">
                    Click "Ok" to finish or
                    <button type="button" class="text-primary hover:text-primary hover:underline" :on-click="cancel">
                      choose
                    </button>
                    another file.
                  </div>
                </div>
              </div>
              <div :if={@state == :selected} class="flex justify-center">
                <button
                  type="submit"
                  class="bg-primary group group-hover:bg-primary-focus text-primary-content h-10 px-5 rounded-md mt-5"
                  disabled={@modal_errors != []}
                  phx-disable-with="Import"
                >Import</button>
              </div>
              <div :if={@state in [:uploading, :importing, :cancelling]}>
                <div class="flex justify-center">
                  <button
                    type="button"
                    class="justify-center bg-primary group group-hover:bg-primary-focus text-primary-content h-10 px-5 rounded-md mt-5"
                    :on-click="cancel"
                    disabled={@state == :cancelling}
                    phx-disable-with="Cancel"
                  >Cancel</button>
                </div>
              </div>
              <div :if={@state in [:success, :error, :cancelled]}>
                <div class="flex justify-center">
                  <button
                    type="button"
                    class="justify-center bg-primary group group-hover:bg-primary-focus text-primary-content h-10 px-5 rounded-md mt-5"
                    :on-click="close_import_modal"
                  >OK</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </section>
    </div>
    """
  end

  def handle_event("close_import_modal", _, socket) do
    {:noreply, close(socket)}
  end

  def handle_event(
        "validate",
        _params,
        %{assigns: %{uploads: %{data_import: %{errors: [{_ref, :not_accepted}]}}}} = socket
      ) do
    socket = clear_entries(socket)
    {:noreply, assign(socket, modal_errors: ["File must be JSON"], state: :error)}
  end

  def handle_event(
        "validate",
        _params,
        %{assigns: %{uploads: %{data_import: %{errors: [{_ref, :too_many_files}]}}}} = socket
      ) do
    socket = clear_entries(socket)
    {:noreply, assign(socket, state: :error, modal_errors: ["Only one import allowed at a time"])}
  end

  def handle_event(
        "validate",
        _params,
        %{assigns: %{uploads: %{data_import: %{errors: [{_ref, error}]}}}} = socket
      ) do
    socket = clear_entries(socket)

    {:noreply,
     assign(socket,
       state: :error,
       modal_errors: ["#{Atom.to_string(error) |> String.replace("_", " ")}"]
     )}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, assign(socket, state: :selected, modal_errors: [])}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, reset(socket)}
  end

  def handle_event("cancel", _params, %{assigns: %{state: :importing}} = socket) do
    %{batch_processor_pid: batch_processor_pid} = socket.assigns
    BatchProcessor.cancel(batch_processor_pid)

    {:noreply, assign(socket, state: :cancelling)}
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, reset(socket)}
  end

  def handle_event("import", _params, socket) do
    file_handler = fn %{path: path}, _entry ->
      with {:ok, contents} <- File.read(path),
           {:ok, data} <- Jason.decode(contents) do
        {:ok, data}
      else
        _ ->
          socket =
            socket
            |> assign(:state, :error)
            |> assign(:progress, 0)
            |> assign(:modal_errors, ["Invalid import file"])

          {:noreply, socket}
      end
    end

    case consume_uploaded_entries(socket, :data_import, file_handler) do
      [data] ->
        {:noreply, run_import(socket, data)}

      [] ->
        {:noreply, reset(socket)}

      _error ->
        socket =
          socket
          |> assign(:state, :error)
          |> assign(:progress, 0)
          |> assign(:modal_errors, ["Invalid import file"])

        {:noreply, socket}
    end
  end

  def handle_event("open_modal", _, socket) do
    socket =
      socket
      |> reset()
      |> assign(show: true)

    {:noreply, socket}
  end

  def handle_info({:update_progress, 100, _step, _total}, socket) do
    {:noreply, assign(socket, state: :success, progress: 100)}
  end

  def handle_info({:update_progress, progress, _step, _total}, socket) do
    {:noreply, assign(socket, progress: progress)}
  end

  def handle_info({:processing_cancelled, _info}, socket) do
    {:noreply, assign(socket, state: :cancelled)}
  end

  def handle_info(
        {:processing_error, progress,
         %Changeset{errors: errors, changes: %{message_uuid: message_uuid}}},
        socket
      ) do
    error_msg = "Error on message_uuid #{message_uuid} #{parse_changeset_errors(errors)}"
    {:noreply, processing_error(socket, progress, error_msg)}
  end

  def handle_info({:processing_error, progress, error}, socket) do
    IO.warn("Invalid import file: #{inspect(error)}")

    error =
      if is_binary(error) do
        error
      else
        "Invalid import file"
      end

    {:noreply, processing_error(socket, progress, error)}
  end

  def handle_info(message, socket) do
    IO.warn("Unhandled message received: #{inspect(message)}")
    {:noreply, socket}
  end

  defp run_import(socket, data) do
    cancel_callback = fn %{progress: progress} ->
      Logger.warning(
        "LiveView is no longer available, importing processing cancelled at #{progress}%"
      )
    end

    case BatchProcessor.run(data, &MessageHandler.handle_message/1,
           batch_size: 10,
           cancel_callback: cancel_callback
         ) do
      {:ok, batch_processor_pid} ->
        socket = assign(socket, :state, :importing)

        assign(socket, batch_processor_pid: batch_processor_pid)

      {:error,
       {%Protocol.UndefinedError{
          protocol: Enumerable,
          value: {:error, :unprocessable_file},
          description: ""
        }}} ->
        socket
        |> assign(:state, :error)
        |> assign(:progress, 0)
        |> assign(:modal_errors, ["Unsupported import type"])

      _ ->
        socket
        |> assign(:state, :error)
        |> assign(:progress, 0)
        |> assign(:modal_errors, ["Invalid import file"])
    end
  end

  defp parse_changeset_errors(errors) do
    errors
    |> Enum.map_join(" ", fn {key, {reason, _info}} ->
      "#{key} #{reason}"
    end)
  end

  defp close(socket) do
    socket
    |> reset()
    |> assign(show: false)
  end

  defp reset(socket) do
    socket
    |> clear_entries()
    |> assign(progress: 0, modal_errors: [], state: :selecting)
  end

  defp processing_error(socket, progress, error_msg) do
    assign(socket, progress: progress, state: :error, modal_errors: [error_msg])
  end

  defp clear_entries(%{assigns: %{uploads: %{data_import: %{entries: []}}}} = socket), do: socket

  defp clear_entries(%{assigns: %{uploads: %{data_import: %{entries: entries}}}} = socket) do
    Enum.reduce(entries, socket, fn %{ref: ref}, acc ->
      cancel_upload(acc, :data_import, ref)
    end)
  end

  defp handle_upload_progress(:data_import, entry, socket) do
    socket =
      if entry.done? do
        assign(socket, :state, :importing)
      else
        assign(socket, :state, :uploading)
      end

    {:noreply, socket}
  end

  defp can_close_on_key?(state) when state in [:selecting, :selected], do: "close_import_modal"

  defp can_close_on_key?(_), do: ""

  defp progress_color_by_state(state) when state in [:uploading, :importing, :success] do
    "w-full [&::-webkit-progress-bar]:bg-slate-300 [&::-webkit-progress-value]:bg-accent [&::-moz-progress-bar]:bg-accent"
  end

  defp progress_color_by_state(state) when state in [:cancelling, :cancelled, :error] do
    "w-full [&::-webkit-progress-bar]:bg-slate-300 [&::-webkit-progress-value]:bg-void [&::-moz-progress-bar]:bg-void"
  end
end
