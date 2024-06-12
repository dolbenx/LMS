defmodule LoanmanagementsystemWeb.Admin.SettingsLive.DistrictsComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{district: district} = assigns, socket) do
    changeset = Maintenance.change_district(district)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"district" => district}, socket) do
    save_district(socket, socket.assigns.action, district)
  end

  defp save_district(socket, :edit, district) do
    case Maintenance.update_district(socket.assigns.district, district) do
      {:ok, _district} ->
        {:noreply,
         socket
         |> put_flash(:info, "District Updated Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_district(%{assigns: assigns} = socket, :new, district) do
    user = assigns.user
    district = Map.merge(district, %{
      "created_by" => user.id,
      "status" => "ACTIVE"
    })

    case Maintenance.create_district(district) do
      {:ok, _district} ->
        {:noreply,
         socket
         |> put_flash(:info, "District Added Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
