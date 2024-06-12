defmodule LoanmanagementsystemWeb.Admin.SettingsLive.ProvincesComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{province: province} = assigns, socket) do
    changeset = Maintenance.change_province(province)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"province" => province}, socket) do
    save_province(socket, socket.assigns.action, province)
  end

  defp save_province(socket, :edit, province) do
    case Maintenance.update_province(socket.assigns.province, province) do
      {:ok, _settings} ->
        {:noreply,
         socket
         |> put_flash(:info, "Province Updated Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_province(%{assigns: assigns} = socket, :new, province) do
    user = assigns.user
    province = Map.merge(province, %{
      "created_by" => user.id,
      "status" => "ACTIVE"
    })

    case Maintenance.create_province(province) do
      {:ok, _province} ->
        {:noreply,
         socket
         |> put_flash(:info, "Province Added Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
