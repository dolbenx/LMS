defmodule LoanmanagementsystemWeb.SessionLive.Index do
  use LoanmanagementsystemWeb, :live_view

  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Workers.Utlis.Utils
  alias Loanmanagementsystem.Workers.Utlis.Cache


  @impl true
  def mount(_params, _session, %{assigns: _assigns} = socket) do
    changeset =  Accounts.login_user(%User{})

    {:ok,
      socket
      |> assign(:title, "Sign Up")
      |> assign(:info_modal, false)
      |> assign(error_modal: false)
      |> assign(:user, %User{})
      |> assign(:changeset, changeset)
      |> assign(:trigger_submit, false)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:params, params)
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, _) do
    socket
  end


  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "User Registration")
    |> assign(:user, %User{})
  end


  @impl true
  def handle_event(target, params, socket), do: handle_event_switch(target, params, socket)

  def handle_event_switch(target, params, socket) do
    case target do
      "validate" -> validate(params, socket)
      "submit" -> {:noreply, assign(socket, trigger_submit: true)}
    end
  end


  def validate(params, socket) do
    params = Utils.to_atomic_map(params)
    changeset =
      socket.assigns.user
      |> Accounts.login_user(params.user)
      |> Map.put(:action, :validate)

      Task.start(fn -> Cache.put(changeset.changes, :login) end)

    {:noreply, assign(socket, :changeset, changeset)}
  end

end
