defmodule LoanmanagementsystemWeb.Admin.UserLive.ViewComponent do
  @moduledoc false
  use LoanmanagementsystemWeb, :live_component

  alias Loanmanagementsystem.Accounts

  @impl true

  def update(%{user: user, title: title} = assigns, socket) do
    changeset =  Accounts.change_user(user)

    table = [
       %{head: "FIRST NAME:", value: user.first_name},
       %{head: "LAST NAME:", value: user.last_name},
       %{head: "USERNAME:", value: user.username},
       %{head: "EMAIL:", value: user.email},
       %{head: "GENDER:", value: user.sex},
       %{head: "DOB:", value: user.dob},
       %{head: "ID_No:", value: user.id_no},
       %{head: "PHONE:", value: user.phone},
       %{head: "ADDRESS:", value: user.address}
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
