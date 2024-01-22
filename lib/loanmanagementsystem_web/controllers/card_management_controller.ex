defmodule LoanmanagementsystemWeb.CardManagementController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema
  import Ecto.Query, warn: false
  require Logger

  alias Loanmanagementsystem.Repo

    plug LoanmanagementsystemWeb.Plugs.Authenticate,
        [module_callback: &LoanmanagementsystemWeb.CreditMonitoringController.authorize_role/1]
        when action not in [
            :cards
        ]

use PipeTo.Override

  def cards(conn, _params) do
    render(conn, "cards.html")
  end


  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")




    def authorize_role(conn) do
      case Phoenix.Controller.action_name(conn) do
        act when act in ~w(new create)a -> {:credit_monitoring, :create}
        act when act in ~w(index view)a -> {:credit_monitoring, :view}
        act when act in ~w(update edit)a -> {:credit_monitoring, :edit}
        act when act in ~w(change_status)a -> {:credit_monitoring, :change_status}
        _ -> {:credit_monitoring, :unknown}
      end
    end


end
