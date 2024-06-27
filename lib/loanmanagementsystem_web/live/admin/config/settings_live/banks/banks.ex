defmodule LoanmanagementsystemWeb.Admin.SettingsLive.Banks do
  use LoanmanagementsystemWeb, :live_view

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Maintenance.Bank
  alias LoanmanagementsystemWeb.Helps.PaginationControl, as: Control
  alias LoanmanagementsystemWeb.NotificationLive.{ ErrorModalLive, InfoModalLive, SuccessModalLive }




  @impl true
  def mount(_params, _session, socket) do
    country = Maintenance.list_tbl_country
    province = Maintenance.list_tbl_province
    district = Maintenance.list_tbl_district
    socket =
        assign(socket, :data_loader, [])
        |> assign(:data, [])
        |> assign(country: country)
        |> assign(province: province)
        |> assign(district: district)
        |> assign(:info_modal, false)
        |> assign(error_modal: false)
        |> assign(error_message: "")
        |> assign(success_modal: false)
        |> assign(:page_title, "Banks")
        |> assign(show_modal: false)
        |> Control.order_by_composer()
        |> Control.i_search_composer()
    {:ok, socket}
  end


  @impl true
  def handle_params(params, _url, socket) do
    if connected?(socket), do: send(self(), {:list_bank, params})
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
    |> assign(:page_title, "Add Bank")
    |> assign(:bank, %Bank{})
  end

  defp apply_action(socket, :show_alert, %{"id" => id}) do
    socket
    |> assign(:page_title, "Approve Bank")
    |> assign(:bank, Maintenance.get_bank!(id))
  end


  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bank")
    |> assign(:bank, Maintenance.get_bank!(id))
  end


  @impl true
  def handle_info(data, socket), do: handle_info_switch(socket, data)

  defp handle_info_switch(socket, data) do
    case data do
      :list_bank ->
        list_bank(socket, %{"sort_direction" => "desc", "sort_field" => "id"})

      {:list_bank, params} ->
        list_bank(socket, params)

      {:handle_bank, params} ->
        handle_bank(socket, params)

      {:approve, params} ->
        if connected?(socket), do: send(self(), {:handle_bank, params})
        {:noreply, assign(socket, :info_wording, "Processing")}

      {:delete, params} ->
        if connected?(socket), do: send(self(), {:handle_bank, params})
        {:noreply, assign(socket, :info_wording, "Processing")}

      {:reject, params} ->
        if connected?(socket), do: send(self(), {:handle_bank, params})
        {:noreply, assign(socket, :info_wording, "Processing")}

      {:deactivate, params} ->
          if connected?(socket), do: send(self(), {:handle_bank, params})
          {:noreply, assign(socket, :info_wording, "Processing")}

      {:activate, params} ->
        if connected?(socket), do: send(self(), {:handle_bank, params})
        {:noreply, assign(socket, :info_wording, "Processing")}


      {InfoModalLive, _, %{action: action, param: params}} ->
        if action == "process" do
          case params["action"] do
            "approve" ->
              if connected?(socket), do: send(self(), {:approve, params})
              {:noreply, assign(socket, :info_wording, "Processing")}

            "reject" ->
              if connected?(socket), do: send(self(), {:reject, params})
              {:noreply, assign(socket, :info_wording, "Processing")}
            "delete" ->
              if connected?(socket), do: send(self(), {:delete, params})
              {:noreply, assign(socket, :info_wording, "Processing")}
            "activate" ->
              if connected?(socket), do: send(self(), {:activate, params})
              {:noreply, assign(socket, :info_wording, "Processing")}
            "deactivate" ->
              if connected?(socket), do: send(self(), {:deactivate, params})
              {:noreply, assign(socket, :info_wording, "Processing")}
          end
        else
          {
            :noreply,
            assign(socket, :info_modal, false)
            |> assign(:info_message, "Yes")
            |> assign(:info_wording, "Yes")
          }
        end

        {SuccessModalLive, :button_clicked, _} ->
          {:noreply, push_redirect(socket, to: Routes.bank_index_path(socket, :index))}

        {ErrorModalLive, :button_clicked, _} ->
          {:noreply, push_redirect(socket, to: Routes.bank_index_path(socket, :index))}


    end
  end

  defp handle_bank(%{assigns: assigns} = socket, params) do
    bank = Maintenance.get_bank!(params["id"])
    params = %{status: switch_status(params["action"])}

    Ecto.Multi.new()
    |> Ecto.Multi.update(:bank, Bank.changeset(bank, params))
    |> Repo.transaction()
    |> case do
      {:ok, _} -> ErrorHelper.get_results(socket, {:ok, "Bank updated Successfully."})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = Utils.traverse_errors(failed_value.errors)
          ErrorHelper.get_results(socket, {:error, reason})
    end
  end

  defp switch_status(action) do
    case action do
      "approve" -> "APPROVED"
      "reject" -> "REJECTED"
      "activate" -> "ACTIVE"
      "deactivate" -> "DEACTIVATED"
      "delete" -> "DELETED"
      _ -> "PENDING_APPROVAL"
    end
  end

  defp open_modal(socket) do
    {:noreply, assign(socket, show_modal: true, page: "Filter Banks")}
  end

  defp list_bank(%{assigns: _assigns} = socket, params) do
    data = Maintenance.list_bank(Control.create_table_params(socket, params))
    {
      :noreply,
      assign(socket, :data, data)
      |> assign(data_loader: false)
      |> assign(params: params)
    }
  end


  @impl true
  def handle_event(target, value, socket), do: handle_event_switch(target, value, socket)

  defp handle_event_switch(target, params, socket) do
    case target do
      "iSearch" -> list_bank(socket, params)

      "approve" ->
        {
          :noreply,
          assign(socket, :info_modal, true)
          |> assign(:info_message, "Are you sure you want to approve bank?")
          |> assign(:info_modal_param, Map.merge(params, %{"action" => "approve"}))
          |> assign(:info_wording, "Approve")
        }
      "reject" ->
        {
          :noreply,
          assign(socket, :info_modal, true)
          |> assign(:info_message, "Are you sure you want to reject bank?")
          |> assign(:info_modal_param, Map.merge(params, %{"action" => "reject"}))
          |> assign(:info_wording, "Reject")
        }
      "delete" ->
        {
          :noreply,
          assign(socket, :info_modal, true)
          |> assign(:info_message, "Are you sure you want to delete bank?")
          |> assign(:info_modal_param, Map.merge(params, %{"action" => "delete"}))
          |> assign(:info_wording, "Delete")
        }

      "deactivate" ->
        {
          :noreply,
          assign(socket, :info_modal, true)
          |> assign(:info_message, "Are you sure you want to deactivate bank?")
          |> assign(:info_modal_param, Map.merge(params, %{"action" => "deactivate"}))
          |> assign(:info_wording, "Deactivate")
        }

      "activate" ->
        {
          :noreply,
          assign(socket, :info_modal, true)
          |> assign(:info_message, "Are you sure you want to activate bank?")
          |> assign(:info_modal_param, Map.merge(params, %{"action" => "activate"}))
          |> assign(:info_wording, "Activate")
        }

      "open_modal" -> open_modal(socket)

      "filter" -> list_bank(socket, params)

       "reload" -> {:noreply, push_redirect(socket, to: Routes.settings_banks_path(socket, :index))}
    end
  end

end
