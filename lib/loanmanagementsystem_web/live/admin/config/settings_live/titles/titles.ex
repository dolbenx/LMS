defmodule LoanmanagementsystemWeb.Admin.SettingsLive.Titles do
  use LoanmanagementsystemWeb, :live_view



  alias Loanmanagementsystem.Configs
  alias Loanmanagementsystem.Configs.Titles
  alias LoanmanagementsystemWeb.Helps.PaginationControl, as: Control



  @impl true
  def mount(_params, _session, socket) do
    socket =
        assign(socket, :data, [])
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
    if connected?(socket), do: send(self(), {:list_titles, params})
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
    |> assign(:page_title, "Add Title")
    |> assign(:titles, %Titles{})
  end



  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Title")
    |> assign(:titles, Configs.get_titles!(id))
  end


  @impl true
  def handle_info(data, socket), do: handle_info_switch(socket, data)

  defp handle_info_switch(socket, data) do
    case data do
      :list_titles ->
        list_titles(socket, %{"sort_direction" => "desc", "sort_field" => "id"})

      {:list_titles, params} ->
        list_titles(socket, params)
    end
  end


  defp list_titles(%{assigns: _assigns} = socket, params) do
    data = Configs.list_titles(Control.create_table_params(socket, params))
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
      "iSearch" -> list_titles(socket, params)
    end
  end

end
