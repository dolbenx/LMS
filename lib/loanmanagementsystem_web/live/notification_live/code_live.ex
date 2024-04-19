defmodule LoanmanagementsystemWeb.NotificationLive.CodeLive do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  # Fired when user clicks right button on modal
  def handle_event(target, params, socket) do
    case target do
      "dismiss-modal" ->
        left_button_click(params, socket)

      _data ->
        {:noreply, socket}
    end
  end

  def right_button_click(params, %{assigns: %{right_button_action: action}} = socket) do
    send(self(), {__MODULE__, :button_clicked, %{action: action, param: params}})
    {:noreply, socket}
  end

  def left_button_click(_params, socket) do
    send(self(), {__MODULE__, :button_clicked, %{action: "dismiss", param: nil}})

    {:noreply, socket}
  end
end
