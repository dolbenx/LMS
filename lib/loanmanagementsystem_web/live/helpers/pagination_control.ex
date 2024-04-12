defmodule LoanmanagementsystemWeb.Helps.PaginationControl do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    """
  end

  def order_by_composer(socket, params \\ %{"sort_direction" => "desc", "sort_field" => "id"}) do
    if params["sort_direction"],
       do: assign(socket,
         order_by: %{"sort_direction" => params["sort_direction"],
           "sort_field" => params["sort_field"]}),
       else: socket
  end

  def i_search_composer(socket, params \\ %{"isearch" => ""}) do
    if params["isearch"],
       do: assign(socket, isearch: %{"isearch" => params["isearch"]}),
       else: socket
  end


  def create_table_params(%{assigns: assigns} = _socket, params) do
    first_filter = assigns.params["filter"] || %{}
    second_filter = params["filter"] || %{}

    pa = Map.merge(params, assigns.params)
    # |> Map.delete("isearch")
    if pa["filter"] != nil do
      Map.merge(pa, %{
        "filter" =>
          Map.merge(first_filter, second_filter)
          |> Map.merge(assigns.isearch)
      })
      |> Map.merge(%{"order_by" => assigns.order_by})
    else
      Map.merge(pa, %{"filter" => Map.merge(params, assigns.isearch)})
      |> Map.merge(%{"order_by" => assigns.order_by})
    end
  end

  def boolean_status_ui(status) do
    if status == true, do: """
      <span class="badge badge-success badge-pill"> Active </span>
      """

    if status == false, do: """
      <span class="badge badge-danger badge-pill"> Disabled </span>
    """

    if status == nil, do: "
      <span class='badge badge-danger badge-pill'> Pending Approval </span>
    "
  end
end
