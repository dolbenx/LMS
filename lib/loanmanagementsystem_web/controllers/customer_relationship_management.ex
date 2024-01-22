defmodule LoanmanagementsystemWeb.CustomerRelationshipManagementController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.RelationshipManagement.{Leads, Proposal}
  alias Loanmanagementsystem.Accounts.{User}
  alias Loanmanagementsystem.Logs.UserLogs

  import Ecto.Query, warn: false
  require Logger

  plug(
    LoanmanagementsystemWeb.Plugs.RequireAuth
    when action in [
           :user_creation,
           :student_dashboard
         ]
  )

  plug(
    LoanmanagementsystemWeb.Plugs.EnforcePasswordPolicy
    when action not in [
           :new_password,
           :change_password,
           :user_creation,
           :student_dashboard
         ]
  )

  def customer_relation_management(conn, _params) do
    render(conn, "customer_relation_management.html")
  end

  def leeds(conn, _request) do
    lead = Loanmanagementsystem.RelationshipManagement.list_tbl_leads()
    render(conn, "leads.html", lead: lead)
  end

  def create_lead(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_leaad,
      Leads.changeset(%Leads{}, %{
        date_of_birth: params["date_of_birth"],
        email_address: params["email_address"],
        first_name: params["first_name"],
        gender: params["gender"],
        identification_number: params["identification_number"],
        identification_type: "National Registration Card",
        last_name: params["last_name"],

        marital_status: params["marital_status"],
        mobile_number: params["mobile_number"],
        nationality: params["nationality"],
        other_name: params["other_name"],
        title: params["title"],

        userId: conn.assigns.user.id,
        status: "INACTIVE",
        disability_detail: params["disability_detail"],
        disability_status: params["disability_status"],
        number_of_dependants: params["number_of_dependants"]
      }))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_leaad: _add_leaad} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created A Leed Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Created A Lead")
        |> redirect(to: Routes.customer_relationship_management_path(conn, :leeds))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_relationship_management_path(conn, :leeds))
    end
  end

  def update_lead(conn, params) do

    update_lead = Loanmanagementsystem.RelationshipManagement.get_leads!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_lead,
    Leads.changeset(update_lead, %{

      date_of_birth: params["date_of_birth"],
      email_address: params["email_address"],
      first_name: params["first_name"],
      gender: params["gender"],
      identification_number: params["identification_number"],
      last_name: params["last_name"],
      marital_status: params["marital_status"],
      mobile_number: params["mobile_number"],
      nationality: params["nationality"],
      other_name: params["other_name"],
      title: params["title"],
      number_of_dependants: params["number_of_dependants"]

    }))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_lead: _update_lead} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated A Leed Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated A Lead")
        |> redirect(to: Routes.customer_relationship_management_path(conn, :leeds))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_relationship_management_path(conn, :leeds))
    end
  end


  def activate_lead(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_lead,
      Leads.changeset(
        Loanmanagementsystem.RelationshipManagement.get_leads!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_lead: _activate_lead} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Lead Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You have Successfully Activated A Lead!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def deactivate_lead(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_lead,
      Leads.changeset(
        Loanmanagementsystem.RelationshipManagement.get_leads!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_lead: _activate_lead} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Lead Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You have Successfully Deactivated A Lead!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def proposal(conn, _request) do
    proposal = Loanmanagementsystem.RelationshipManagement.list_tbl_proposal()
    render(conn, "proposal.html", proposal: proposal)
  end

  def add_proposal(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_proposal,
    Proposal.changeset(%Proposal{}, %{
        date_of_birth: params["date_of_birth"],
        email_address: params["email_address"],
        first_name: params["first_name"],
        gender: params["gender"],
        identification_number: params["identification_number"],
        identification_type: "National Registration Card",
        last_name: params["last_name"],

        marital_status: params["marital_status"],
        mobile_number: params["mobile_number"],
        nationality: params["nationality"],
        other_name: params["other_name"],
        title: params["title"],

        userId: conn.assigns.user.id,
        status: "INACTIVE",
        disability_detail: params["disability_detail"],
        disability_status: params["disability_status"],
        number_of_dependants: params["number_of_dependants"]
      }))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_proposal: _add_proposal} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Created A Proposal Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Created A Proposal")
        |> redirect(to: Routes.customer_relationship_management_path(conn, :proposal))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_relationship_management_path(conn, :proposal))
    end
  end

  def update_proposal(conn, params) do

    update_proposal = Loanmanagementsystem.RelationshipManagement.get_proposal!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_proposal,
    Proposal.changeset(update_proposal, %{

      date_of_birth: params["date_of_birth"],
      email_address: params["email_address"],
      first_name: params["first_name"],
      gender: params["gender"],
      identification_number: params["identification_number"],
      last_name: params["last_name"],
      marital_status: params["marital_status"],
      mobile_number: params["mobile_number"],
      nationality: params["nationality"],
      other_name: params["other_name"],
      title: params["title"],
      number_of_dependants: params["number_of_dependants"]

    }))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_proposal: _update_proposal} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated A Proposal Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _msg} ->
        conn
        |> put_flash(:info, "You have Successfully Updated A Proposal")
        |> redirect(to: Routes.customer_relationship_management_path(conn, :proposal))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_relationship_management_path(conn, :proposal))
    end
  end

  def activate_proposal(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_proposal,
      Proposal.changeset(
        Loanmanagementsystem.RelationshipManagement.get_proposal!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_proposal: _activate_proposal} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Proposal Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You have Successfully Activated A Proposal!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def deactivate_proposal(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :deactivate_proposal,
      Proposal.changeset(
        Loanmanagementsystem.RelationshipManagement.get_proposal!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{deactivate_proposal: _deactivate_proposal} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Proposal Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "You have Successfully Deactivated A Proposal!"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def customer(conn, _request), do: render(conn, "customer.html")
  def contact(conn, _request), do: render(conn, "contact.html")
  def communication(conn, _request), do: render(conn, "communication.html")
  def appointment(conn, _request), do: render(conn, "appointment.html")
  def mou_meeting_notes(conn, _request), do: render(conn, "mou_meeting_notes.html")
  def mou_maintenance(conn, _request), do: render(conn, "mou_maintenance.html")
  def leeds_details(conn, _request), do: render(conn, "leeds_details.html")
  def sales_funnel(conn, _request), do: render(conn, "sales_funnel.html")
  def prospects_engaged(conn, _request), do: render(conn, "prospects_engaged.html")
  def innactive_customers(conn, _request), do: render(conn, "innactive_customers.html")
  def lead_owner_efficiency(conn, _request), do: render(conn, "lead_owner_efficiency.html")
  def customer_acquisition(conn, _request), do: render(conn, "customer_acquisition.html")
  def portfolio_analytics(conn, _request), do: render(conn, "portfolio_analytics.html")
  def traverse_errors(errors), do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
