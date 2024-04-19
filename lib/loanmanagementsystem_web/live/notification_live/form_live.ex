defmodule LoanmanagementsystemWeb.NotificationLive.FormLive do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component


  def mount(socket) do
    {:ok, socket}
  end

  # Fired when user clicks right button on modal
  def handle_event(target, params, socket) do
    case target do
      "submit-all-data" ->
        right_button_click(params, socket)

      "dismiss-modal" ->
        left_button_click(params, socket)

      "change-modal-data" ->
        change_modal_data(params, socket)

      _data ->
        {:noreply, socket}
    end
  end

  def right_button_click(params, %{assigns: %{right_button_action: right_button_action}} = socket) do
    send(self(), {__MODULE__, :button_clicked, %{action: right_button_action, param: params}})
    {:noreply, socket}
  end

  def left_button_click(_params, socket) do
    send(self(), {__MODULE__, :button_clicked, %{action: "dismiss", param: nil}})

    {:noreply, socket}
  end

  def change_modal_data(params, socket) do
    form =
      Enum.map(socket.assigns.form, fn map ->
        Enum.reduce(params["_target"], %{}, fn target, item ->
          if map.name == target do
            new_map = Map.merge(map, %{value: params[target]})
            Map.merge(item, new_map)
          else
            Map.merge(item, map)
          end
        end)
      end)

    socket = assign(socket, :form, form)
    {:noreply, socket}
  end
end
