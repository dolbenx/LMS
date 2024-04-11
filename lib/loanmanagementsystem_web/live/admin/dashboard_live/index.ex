defmodule LoanmanagementsystemWeb.Admin.DashboardLive.Index do
  use LoanmanagementsystemWeb, :live_view

  @impl true
  def mount(_params, _session, %{assigns: _assigns} = socket) do
    socket =
      assign(socket, :type, "ADMIN")
      |> assign(:error_modal, false)
      |> assign(:info_modal, false)
    {:ok, socket}
  end

end
