defmodule LoanmanagementsystemWeb.NotificationLive.SuccessModalLive do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component


  def mount(socket) do
    {:ok, socket}
  end

  def handle_event(target, params, socket), do: handle_event_switch(target, params, socket)

  defp handle_event_switch(target, params, socket) do
    case target do
      "right-button-click" -> right_button_click(params, socket)
      "left-button-click" -> left_button_click(params, socket)
    end
  end

  # Fired when user clicks right button on modal
  defp right_button_click(
         _params,
         %{
           assigns: %{
             right_button_action: right_button_action,
             right_button_param: right_button_param
           }
         } = socket
       ) do
    send(
      self(),
      {__MODULE__, :button_clicked, %{action: right_button_action, param: right_button_param}}
    )

    {:noreply, socket}
  end

  defp left_button_click(_params, socket) do
    send(self(), {__MODULE__, :button_clicked, %{action: "dismiss", param: nil}})
    {:noreply, socket}
  end
end
