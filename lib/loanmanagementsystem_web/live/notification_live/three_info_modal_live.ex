defmodule LoanmanagementsystemWeb.NotificationLive.ThreeInfoModalLive do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component


  def render(assigns) do
    ~H"""
      <div id={"modal-#{@id}"}>
        <div class="custom-modal-container">
          <div class="custom-modal-container1 custom-modal-center">
            <div class="modal-dialog modal-lg  modal-dialog-centered" role="document" style="max-width: 500px">
              <div class="modal-content"}>
                <div class="modal-header" style="background-color: #313133; color: white; justify-content: center;">
                  <h5 class="modal-title" id="exampleModalLabel"><%= @title %></h5>
                </div>

                <div class="modal-body" style="justify-content: center;">
                  <h3><%= @body %></h3>

                  <div class="modal-footer">
                    <form phx-target={@myself} phx-submit="left_button">
                      <button type="submit" class="btn btn-outline-danger">
                        <%= @left_button %>
                      </button>
                    </form>
                    <form phx-target={@myself} phx-submit="middle_button">
                      <button type="submit" class="btn btn-outline-secondary">
                        <%= @middle_button %>
                      </button>
                    </form>
                    <form phx-target={@myself} phx-submit="right_button">
                      <button type="submit" class="btn btn-outline-success">
                        <%= @right_button %>
                      </button>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def handle_event(target, params, socket), do: handle_event_switch(target, params, socket)

  defp handle_event_switch(target, params, socket) do
    case target do
      "right_button" -> right_button_click(params, socket)
      "left_button" -> left_button_click(params, socket)
      "middle_button" -> middle_button_click(params, socket)
    end
  end

  # Fired when user clicks right button on modal
  defp right_button_click(
         _params,
         %{
           assigns: %{
             right_button_action: action,
             right_button_param: param
           }
         } = socket
       ) do
    send(
      self(),
      {__MODULE__, :button_clicked, %{action: action, param: param}}
    )

    {:noreply, socket}
  end

  defp middle_button_click(
         _params,
         %{
           assigns: %{
             middle_button_action: action,
             right_button_param: param
           }
         } = socket
       ) do
    send(
      self(),
      {__MODULE__, :button_clicked, %{action: action, param: param}}
    )

    {:noreply, socket}
  end

  defp left_button_click(
         _params,
         %{
           assigns: %{
             left_button_action: action,
             right_button_param: param
           }
         } = socket
       ) do
    send(self(), {__MODULE__, :button_clicked, %{action: action, param: param}})
    {:noreply, socket}
  end
end
