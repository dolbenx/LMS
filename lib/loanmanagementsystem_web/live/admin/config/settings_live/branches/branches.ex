defmodule LoanmanagementsystemWeb.Admin.SettingsLive.Branches do
  use LoanmanagementsystemWeb, :live_view

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Maintenance.Branch
  alias LoanmanagementsystemWeb.Helps.PaginationControl, as: Control



  @impl true
  def mount(_params, _session, socket) do
    bank = Maintenance.list_tbl_banks
    country = Maintenance.list_tbl_country
    province = Maintenance.list_tbl_province
    district = Maintenance.list_tbl_district
    socket =
        assign(socket, :data, [])
        |> assign(bank: bank)
        |> assign(country: country)
        |> assign(province: province)
        |> assign(district: district)
        |> assign(:data_loader, true)
        |> assign(:error, "")
        |> assign(:error_modal, false)
        |> assign(:info_modal, false)
        |> Control.order_by_composer()
        |> Control.i_search_composer()
    {:ok, socket}
  end


  @impl true
  def handle_params(params, _url, socket) do
    if connected?(socket), do: send(self(), {:list_branch, params})
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
    |> assign(:page_title, "Add Branch")
    |> assign(:branch, %Branch{})
  end



  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Branch")
    |> assign(:branch, Maintenance.get_branch!(id))
  end


  @impl true
  def handle_info(data, socket), do: handle_info_switch(socket, data)

  defp handle_info_switch(socket, data) do
    case data do
      :list_branch ->
        list_branch(socket, %{"sort_direction" => "desc", "sort_field" => "id"})

      {:list_branch, params} ->
        list_branch(socket, params)
    end
  end


  defp list_branch(%{assigns: _assigns} = socket, params) do
    data = Maintenance.list_branch(Control.create_table_params(socket, params))
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
      "iSearch" -> list_branch(socket, params)
    end
  end

end
