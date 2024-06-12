defmodule LoanmanagementsystemWeb.Admin.SettingsLive.CountriesComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{country: country} = assigns, socket) do
    changeset = Maintenance.change_country(country)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"country" => country}, socket) do
    save_country(socket, socket.assigns.action, country)
  end

  defp save_country(socket, :edit, country) do
    case Maintenance.update_country(socket.assigns.country, country) do
      {:ok, _settings} ->
        {:noreply,
         socket
         |> put_flash(:info, "country Updated Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_country(%{assigns: assigns} = socket, :new, country) do
    user = assigns.user
    country = Map.merge(country, %{
      "created_by" => user.id,
      "status" => "ACTIVE"
    })

    case Maintenance.create_country(country) do
      {:ok, _country} ->
        {:noreply,
         socket
         |> put_flash(:info, "Country Added Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
