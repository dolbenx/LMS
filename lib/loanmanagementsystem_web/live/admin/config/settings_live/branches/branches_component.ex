defmodule LoanmanagementsystemWeb.Admin.SettingsLive.BranchesComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{branch: branch} = assigns, socket) do
    changeset = Maintenance.change_branch(branch)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"branch" => branch}, socket) do
    save_branch(socket, socket.assigns.action, branch)
  end

  defp save_branch(socket, :edit, branch) do
    case Maintenance.update_branch(socket.assigns.branch, branch) do
      {:ok, _settings} ->
        {:noreply,
         socket
         |> put_flash(:info, "Branch Updated Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_branch(%{assigns: assigns} = socket, :new, branch) do
    user = assigns.user
    branch = Map.merge(branch, %{
      "created_by" => user.id,
      "status" => "ACTIVE"
    })

    case Maintenance.create_branch(branch) do
      {:ok, _branch} ->
        {:noreply,
         socket
         |> put_flash(:info, "Branch Added Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
