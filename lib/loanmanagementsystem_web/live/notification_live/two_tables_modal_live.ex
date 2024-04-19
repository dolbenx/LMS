defmodule LoanmanagementsystemWeb.NotificationLive.TwoTablesModalLive do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  # Fired when user clicks right button on modal
  def handle_event(target, params, socket) do
    case target do
      "two_table_dismiss" ->
        right_button_click(params, socket)

      _data ->
        {:noreply, socket}
    end
  end

  defp right_button_click(
         _params,
         %{
           assigns: %{
             left_button_action: left_button_action,
             left_button_param: left_button_param
           }
         } = socket
       ) do
    send(
      self(),
      {__MODULE__, :button_clicked, %{action: left_button_action, param: left_button_param}}
    )

    {:noreply, socket}
  end

  # defp left_button_click(
  #        _params,
  #        %{
  #          assigns: %{
  #            left_button_action: left_button_action,
  #            left_button_param: left_button_param
  #          }
  #        } = socket
  #      ) do
  #   send(
  #     self(),
  #     {__MODULE__, :button_clicked, %{action: left_button_action, param: left_button_param}}
  #   )

  #   {:noreply, socket}
  # end

  # defp dismiss_transaction_summary(_params, socket) do
  #   send(self(), {__MODULE__, :button_clicked, %{action: "dismiss", param: "kill"}})

  #   {:noreply, socket}
  # end
end
