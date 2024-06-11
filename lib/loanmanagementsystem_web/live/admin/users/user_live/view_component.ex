defmodule LoanmanagementsystemWeb.Admin.UserLive.ViewComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Accounts

  @impl true

  def update(%{user: user, title: title} = assigns, socket) do
    changeset =  Accounts.change_user(user)

    table = [
       %{head: "USERNAME:", value: user.username},
    ]


    {:ok,
     socket
     |> assign(assigns)
     |> assign(table: table)
     |> assign(:title, title)
     |> assign(:changeset, changeset)
     |> assign(:roles, Accounts.list_tbl_roles())

    }
  end



end
