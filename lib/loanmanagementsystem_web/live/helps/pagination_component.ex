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
     <div class="flex-reverse flex flex-col-reverse flex-wrap items-center gap-y-2 p-5 sm:flex-row">
        <nav class="mr-auto w-full flex-1 sm:w-auto">
          <ul class="flex w-full mr-0 sm:mr-auto sm:w-auto pagination" id={assigns[:id] || "pagination"}>
            <%= if @total_pages > 1 do %>
              <li class="flex-1 sm:flex-initial">
                <%= prev_link(@params, @page_number) %><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-lucide="chevrons-left" class="lucide lucide-chevrons-left stroke-[1] h-4 w-4"><path d="m11 17-5-5 5-5"></path><path d="m18 17-5-5 5-5"></path></svg>
              </li>
              <%= for num <- start_page(@page_number)..end_page(@page_number, @total_pages) do %>
                <li class={"page-item flex-1 sm:flex-initial #{if @page_number == num, do: "active"}"}>
                <a class="transition duration-200 border items-center justify-center py-2 rounded-md cursor-pointer focus:ring-4 focus:ring-primary focus:ring-opacity-20 focus-visible:outline-none dark:focus:ring-slate-700 dark:focus:ring-opacity-50 [&amp;:hover:not(:disabled)]:bg-opacity-90 [&amp;:hover:not(:disabled)]:border-opacity-90 [&amp;:not(button)]:text-center disabled:opacity-70 disabled:cursor-not-allowed min-w-0 sm:min-w-[40px] shadow-none font-normal flex border-transparent text-slate-800 sm:mr-2 dark:text-slate-300 px-1 sm:px-3"><%= live_patch num, to: "?#{querystring(@params, page: num)}", class: "page-link #{if @page_number == num, do: "active", else: ""}" %></a>
                </li>
              <% end %>
              <li class="flex-1 sm:flex-initial">
                <%= next_link(@params, @page_number, @total_pages) %><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" data-lucide="chevrons-right" class="lucide lucide-chevrons-right stroke-[1] h-4 w-4"><path d="m6 17 5-5-5-5"></path><path d="m13 17 5-5-5-5"></path></svg>
              </li>
            <% end %>
          </ul>
        </nav>
        <div class="">Showing <%= if (@total_entries != 0), do: (@page_number - 1) * @page_size + 1, else: 0  %> to
          <%= if (@page_number * @page_size) > @total_entries, do: @total_entries, else: (@page_number * @page_size) %> of
          <%= @total_entries %> entries
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
