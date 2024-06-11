defmodule LoanmanagementsystemWeb.Admin.SettingsLive.TitlesComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Configs
  alias Loanmanagementsystem.Workers.Utlis.Utils

  @impl true
  def update(%{titles: titles} = assigns, socket) do
    changeset = Configs.change_titles(titles)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"titles" => titles}, socket) do
    save_title(socket, socket.assigns.action, titles)
  end

  defp save_title(socket, :edit, titles) do
    case Configs.update_titles(socket.assigns.titles, titles) do
      {:ok, _settings} ->
        {:noreply,
         socket
         |> put_flash(:info, "title updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_title(%{assigns: assigns} = socket, :new, titles) do
    user = assigns.user
    titles = Map.merge(titles, %{
      "maker_id" => user.id,
      "status" => "ACTIVE",
      "reference" => Utils.time_stamp_ref()
    })

    case Configs.create_titles(titles) do
      {:ok, _titles} ->
        {:noreply,
         socket
         |> put_flash(:info, "Title added successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
