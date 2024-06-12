defmodule LoanmanagementsystemWeb.Admin.SettingsLive.BanksComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{bank: bank} = assigns, socket) do
    changeset = Maintenance.change_bank(bank)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"bank" => bank}, socket) do
    save_bank(socket, socket.assigns.action, bank)
  end

  defp save_bank(socket, :edit, bank) do
    case Maintenance.update_bank(socket.assigns.bank, bank) do
      {:ok, _settings} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bank Updated Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_bank(%{assigns: assigns} = socket, :new, bank) do
    user = assigns.user
    bank = Map.merge(bank, %{
      "created_by" => user.id,
      "status" => "ACTIVE"
    })

    case Maintenance.create_bank(bank) do
      {:ok, _bank} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bank Added Successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
