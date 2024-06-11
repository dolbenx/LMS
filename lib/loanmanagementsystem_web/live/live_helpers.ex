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
      <div data-tw-backdrop="" aria-hidden="true" phx-remove={hide_modal()} style="padding-top:50px;" phx-hook="ScrollLock" tabindex="-1" id="modal" class="modal fade-in fade show group bg-gradient-to-b from-theme-1/50 via-theme-2/50 to-black/50 transition-[visibility,opacity] w-screen h-screen fixed left-0 top-0 [&:not(.show)]:duration-[0s,0.2s] [&:not(.show)]:delay-[0.2s,0s] [&:not(.show)]:invisible [&:not(.show)]:opacity-0 [&.show]:visible [&.show]:opacity-100 [&.show]:duration-[0s,0.4s]">
        <div data-tw-merge="" id="modal-content" class="w-[90%] mx-auto bg-white relative rounded-md shadow-md transition-[margin-top,transform] duration-[0.4s,0.3s] -mt-16 group-[.show]:mt-16 group-[.modal-static]:scale-[1.05] dark:bg-darkmode-600 sm:w-[600px] lg:w-[900px] p-10 text-center">
          <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title"><%= @title %></h5>
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
