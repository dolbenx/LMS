defmodule LoanmanagementsystemWeb.Helps.ISearchComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="row mb-3">
          <div class="col-sm-12 col-md-12 d-flex align-items-center justify-content-start">
              <form class="dataTables_filter" phx-change="iSearch">
                  <div class="input-group">
                      <div class="input-group-prepend">
                          <span class="input-group-text" id="basic-addon3"><i class="fal fa-search"></i></span>
                      </div>
                      <input type="search" class="form-control" value={@params["filter"]["isearch"]} name="isearch" placeholder="Search" aria-describedby="basic-addon3">
                  </div>
              </form>
          </div>
      </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  #  @impl true
  #  def handle_event("iSearch", params, socket)do
  #    live_patch "iSearch", to: "?"<>querystring params
  #    {:noreply, socket}
  #  end
end
