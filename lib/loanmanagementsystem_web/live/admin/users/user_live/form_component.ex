defmodule LoanmanagementsystemWeb.Admin.UserLive.FormComponent  do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Roles
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{user: user, title: title} = assigns, socket) do
    changeset =  Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:title, title)
     |> assign(:changeset, changeset)
     |> assign(:roles, Roles.list_user_roles())
    }
  end

  @impl true
  def handle_event(target, params, socket), do: handle_event_switch(target, params, socket)


  def handle_event_switch(target, params, socket) do
    case target do
      "validate" -> validate(params, socket)
      "save" -> save_user(socket, socket.assigns.action, params)
    end
  end


  def validate(params, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(params["user"])
      |> Map.put(:action, :validate)
    {:noreply, assign(socket, :changeset, changeset)}
  end

  defp save_user(socket, type, params) do
    params = Utils.to_atomic_map(params)

    handle_user(socket, params, type)
    |> case do
      {:ok, message} ->
        socket =
          socket
          |> put_flash(:info, message)
          |> push_redirect(to: socket.assigns.return_to)
        {:noreply, socket}

      {:error, reason} ->
        socket =
          socket
          |> put_flash(:error, reason)
          |> push_redirect(to: socket.assigns.return_to)
        {:noreply, socket}
    end
  end



  defp handle_user(%{assigns: assigns}, %{user: user}, :new) do
    pwd = Utils.random_string(6)
    user = Map.merge(user, %{
      maker_id: assigns.user.id,
      status: "PENDING_APPROVAL",
      password: pwd,
      blocked: false,
      user_type: assigns.user_type,
    })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, User.changeset(%User{}, user))
    |> Repo.transaction()
    |> case do
      {:ok, _multi} -> {:ok, "User Submitted for Approval."}
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = Utils.traverse_errors(failed_value.errors)
        {:error, reason}
    end
  end


  defp handle_user(%{assigns: assigns} = _socket, %{user: user}, :edit) do
    user = Map.merge(user, %{updated_by: assigns.user.id})

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.update_changeset(assigns.user, user))
    |> Repo.transaction()
    |> case do
      {:ok, _multi} -> {:ok, "User editted Successfully."}
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = Utils.traverse_errors(failed_value.errors)
        {:error, reason}
    end
  end
end
