defmodule LoanmanagementsystemWeb.LiveHelpers do
  @moduledoc """
  LiveHelpers
  """

  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.document_index_path(@socket, :index)}>
        <.live_component
          module={LoansWeb.DocumentLive.FormComponent}
          id={@document.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.document_index_path(@socket, :index)}
          document: @document
        />
      </.modal>
  """

  def modal(assigns) do
    assigns =
      assign_new(assigns, :return_to, fn -> nil end)
      |> assign_new(:title, fn -> nil end)
    ~H"""
    <div id="modal" class="modal fade-in fade show" phx-remove={hide_modal()} phx-hook="ScrollLock"
      style="display: block; padding-right: 15px; background-color: rgba(0, 0, 0, 0.4); backdrop-filter: blur(5px);"
      tabindex="-1" role="dialog" aria-hidden="true" data-backdrop="static" >
         <div id="modal-content" class="modal-dialog modal-xl fade-in-scale" role="document" phx-click-away={JS.dispatch("click", to: "#close")}
            phx-window-keydown={JS.dispatch("click", to: "#close")} phx-key="escape"
          >
          <div class="modal-content" style="max-height: 90vh">
            <div class="modal-header">
              <h5 class="modal-title"><%= @title %></h5>
              <%= if @return_to do %>
                <%= live_patch "✖", to: @return_to, id: "close", class: "phx-modal-close close",
                  phx_click: hide_modal()
                %>
              <% else %>
                <a id="close" href="#" class="phx-modal-close close" phx-click={hide_modal()}>✖</a>
              <% end %>
            </div>
            <div class="modal-body" style="overflow-y: auto";>
         <%= render_slot(@inner_block) %>
            </div>
          </div>
        </div>
      </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  @doc """
  Renders a component inside the `LoanmanagementsystemWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal LoanmanagementsystemWeb.UserLive.FormComponent,
        id: @user.id || :new,
        action: @live_action,
        user: @user,
        return_to: Routes.user_index_path(@socket, :index) %>
  """
  def live_modal(component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(LoanmanagementsystemWeb.ModalComponent, modal_opts)
  end

  @doc """
  Page transitions with Phoenix LiveView

  ## Examples

      <div class="transition duration-100 ease-out opacity-0 scale-95" {page_transition("opacity-0 scale-95", "opacity-100 scale-100")}> ... </div>
  """
  def page_transition(from, to) do
    %{
      id: Ecto.UUID.generate,
      "phx-hook": "PageTransaction",
      "data-transition-from": from,
      "data-transition-to": to
    }
    end
end
