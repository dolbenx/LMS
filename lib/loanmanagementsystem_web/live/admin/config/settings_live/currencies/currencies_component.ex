defmodule LoanmanagementsystemWeb.Admin.SettingsLive.CurrenciesComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{currency: currency} = assigns, socket) do
    changeset = Maintenance.change_currency(currency)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"currency" => currency}, socket) do
    save_currency(socket, socket.assigns.action, currency)
  end

  defp save_currency(socket, :edit, currency) do
    case Maintenance.update_currency(socket.assigns.currency, currency) do
      {:ok, _currency} ->
        {:noreply,
         socket
         |> put_flash(:info, "Currency Updated Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_currency(%{assigns: assigns} = socket, :new, currency) do
    user = assigns.user
    currency = Map.merge(currency, %{
      "created_by" => user.id,
      "status" => "ACTIVE"
    })

    case Maintenance.create_currency(currency) do
      {:ok, _currency} ->
        {:noreply,
         socket
         |> put_flash(:info, "Currency Added Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
