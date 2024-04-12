defmodule LoanmanagementsystemWeb.Helps.PaginationComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component
  import LoanmanagementsystemWeb.Helps.DataTable

  @distance 5

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(pagination_assigns(assigns[:pagination_data]))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="row">
      <div class="col-sm-12 col-md-5" style="margin: auto;">
        <div class="">Showing <%= if (@total_entries != 0), do: (@page_number - 1) * @page_size + 1, else: 0  %> to
        <%= if (@page_number * @page_size) > @total_entries, do: @total_entries, else: (@page_number * @page_size) %> of
        <%= @total_entries %> entries</div>
      </div>
      <div class="col-sm-12 col-md-7">
        <ul id={assigns[:id] || "pagination"} class="pagination justify-content-end" style="margin: auto;">
            <%= if @total_pages > 1 do %>
                <li class="page-item"><%= prev_link(@params, @page_number) %></li>
                <%= for num <- start_page(@page_number)..end_page(@page_number, @total_pages) do %>
                  <li class={"page-item #{if @page_number == num, do: "active"}"}><%= live_patch num, to: "?#{querystring(@params, page: num)}", class: "page-link #{if @page_number == num, do: "active", else: ""}" %></li>
                <% end %>
                <li class="page-item"><%= next_link(@params, @page_number, @total_pages) %></li>
            <% end %>
          </ul>
      </div>
      </div>
    """
  end

  defp pagination_assigns([]) do
    [
      page_number: 1,
      page_size: 10,
      total_entries: 0,
      total_pages: 0
    ]
  end

  defp pagination_assigns(%Scrivener.Page{} = pagination) do
    [
      page_number: pagination.page_number,
      page_size: pagination.page_size,
      total_entries: pagination.total_entries,
      total_pages: pagination.total_pages
    ]
  end

  def prev_link(conn, current_page) do
    if current_page != 1 do
      live_patch("Prev", to: "?" <> querystring(conn, page: current_page - 1), class: "page-link")
    else
      live_patch("Prev", to: "#", class: "page-link btn-disabled")
    end
  end

  def next_link(conn, current_page, num_pages) do
    if current_page != num_pages do
      live_patch("Next", to: "?" <> querystring(conn, page: current_page + 1), class: "page-link")
    else
      live_patch("Next", to: "#", class: "page-link btn-disabled")
    end
  end

  def start_page(current_page) when current_page - @distance <= 0, do: 1
  def start_page(current_page), do: current_page - @distance

  def end_page(current_page, 0), do: current_page

  def end_page(current_page, total)
      when current_page <= @distance and @distance * 2 <= total do
    @distance * 2
  end

  def end_page(current_page, total) when current_page + @distance >= total, do: total
  def end_page(current_page, _total), do: current_page + @distance - 1
end
