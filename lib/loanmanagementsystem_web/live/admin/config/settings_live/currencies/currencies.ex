defmodule LoanmanagementsystemWeb.Admin.SettingsLive.Currencies do
  use LoanmanagementsystemWeb, :live_view

  alias Loanmanagementsystem.Maintenance
  alias Loanmanagementsystem.Maintenance.Currency
  alias LoanmanagementsystemWeb.Helps.PaginationControl, as: Control



  @impl true
  def mount(_params, _session, socket) do
    country = Maintenance.list_tbl_country
    socket =
        assign(socket, :data, [])
        |> assign(:data_loader, true)
        |> assign(country: country)
        |> assign(:error, "")
        |> assign(:error_modal, false)
        |> assign(:info_modal, false)
        |> Control.order_by_composer()
        |> Control.i_search_composer()
    {:ok, socket}
  end


  @impl true
  def handle_params(params, _url, socket) do
    if connected?(socket), do: send(self(), {:list_currency, params})
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
    |> assign(:page_title, "Add Currency")
    |> assign(:currency, %Currency{})
  end



  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Currency")
    |> assign(:currency, Maintenance.get_currency!(id))
  end


  @impl true
  def handle_info(data, socket), do: handle_info_switch(socket, data)

  defp handle_info_switch(socket, data) do
    case data do
      :list_currency ->
        list_currency(socket, %{"sort_direction" => "desc", "sort_field" => "id"})

      {:list_currency, params} ->
        list_currency(socket, params)
    end
  end


  defp list_currency(%{assigns: _assigns} = socket, params) do
    data = Maintenance.list_currency(Control.create_table_params(socket, params))
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
      "iSearch" -> list_currency(socket, params)
    end
  end

end
