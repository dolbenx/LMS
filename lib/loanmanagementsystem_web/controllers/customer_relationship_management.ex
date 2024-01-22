defmodule LoanmanagementsystemWeb.CustomerRelationshipManagementController do
  use LoanmanagementsystemWeb, :controller
  use Ecto.Schema

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.RelationshipManagement.{Leads, Proposal}
  # alias Loanmanagementsystem.Accounts.{User}
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.RelationshipManagement.Leads
  # alias Loanmanagementsystem.Accounts.UserRole
  # alias Loanmanagementsystem.Accounts.UserBioData

  import Ecto.Query, warn: false
  require Logger

  # plug(
  #   LoanmanagementsystemWeb.Plugs.RequireAuth
  #   when action in [
  #          :user_creation,
  #          :student_dashboard
  #        ]
  # )


  # plug(
  #   LoanmanagementsystemWeb.Plugs.EnforcePasswordPolicy
  #   when action not in [
  #          :new_password,
  #          :change_password,
  #          :user_creation,
  #          :student_dashboard
  #        ]
  # )

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
      [module_callback: &LoanmanagementsystemWeb.CustomerRelationshipManagementController.authorize_role/1]
      when action not in [
          :activate_lead,
          :activate_proposal,
          :add_proposal,
          :appointment,
          :communication,
          :contact,
          :create_lead,
          :customer,
          :customer_acquisition,
          :customer_relation_management,
          :deactivate_lead,
          :deactivate_proposal,
          :innactive_customers,
          :lead_owner_efficiency,
          :leeds,
          :leeds_details,
          :mou_maintenance,
          :mou_meeting_notes,
          :portfolio_analytics,
          :proposal,
          :prospects_engaged,
          :sales_funnel,
          :traverse_errors,
          :update_lead,
          :update_proposal,
          :all_leed,
          :admin_update_lead

       ]

use PipeTo.Override



  def customer_relation_management(conn, _params) do
    render(conn, "customer_relation_management.html")
  end

  def leeds(conn, _request) do
    current_user_id = conn.assigns.user.id
    lead = Loanmanagementsystem.RelationshipManagement.list_tbl_leads() |> Enum.reject(&(&1.userId != current_user_id))
    render(conn, "leads.html", lead: lead)
  end

  def all_leed(conn, _request) do
    current_user_id = conn.assigns.user.id
    lead = Loanmanagementsystem.RelationshipManagement.list_tbl_leads() |> Enum.reject(&(&1.userId != current_user_id))
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
        status: "PENDING",
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
  # def prospects_engaged(conn, _request), do: render(conn, "prospects_engaged.html")
  def innactive_customers(conn, _request) do
    role = Loanmanagementsystem.Accounts.get_user_role_type_for_inactive()
    render(conn, "innactive_customers.html", role: role)
  end
  def lead_owner_efficiency(conn, _request), do: render(conn, "lead_owner_efficiency.html")
  def customer_acquisition(conn, _request), do: render(conn, "customer_acquisition.html")
  def portfolio_analytics(conn, _request), do: render(conn, "portfolio_analytics.html")
  def traverse_errors(errors), do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

  def prospects_engaged(conn, _request) do
    current_user_id = conn.assigns.user.id
    lead = Loanmanagementsystem.RelationshipManagement.list_tbl_leads() |> Enum.reject(&(&1.userId != current_user_id || &1.status != "Active" ))
    render(conn, "prospects_engaged.html", lead: lead)
  end



  def admin_update_lead(conn, params) do
    # user = Loanmanagementsystem.Accounts.get_user!(params["id"])
    # user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    # user_bio_data = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])
    # otp = to_string(Enum.random(1111..9999))
    lead_status = params["lead_status"]
    lead = Loanmanagementsystem.RelationshipManagement.get_leads!(params["id"])
    # otp = to_string(Enum.random(1111..9999))

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_lead,
      Leads.changeset(lead, %{
        status: "#{lead_status}",
        comment: params["comment"],
      })
    )

    # |> Ecto.Multi.run(:push_to_user_table, fn _repo,
    #     %{
    #       update_lead: _update_lead
    #     } ->
    #       User.changeset(%User{}, %{
    #           username: lead.email_address,
    #           status: "INCOMPLETE_PROFILE",
    #           password: LoanmanagementsystemWeb.UserController.random_string(),
    #           auto_password: "Y",
    #           password_fail_count: 0
    #     })
    #     |> Repo.insert()
    # end)

    # |> Ecto.Multi.run(:push_to_user_roles_table, fn _repo,
    #     %{
    #       update_lead: _update_lead, push_to_user_table: push_to_user_table
    #     } ->
    #       UserRole.changeset(%UserRole{}, %{
    #       roleType: "INDIVIDUALS",
    #       status: "PENDING",
    #       otp: otp,
    #       userId: push_to_user_table.id
    #     })
    #     |> Repo.insert()
    # end)

    # |> Ecto.Multi.run(:push_to_user_bio_data, fn _repo,
    #     %{
    #       update_lead: _update_lead, push_to_user_table: push_to_user_table
    #     } ->
    #       UserBioData.changeset(%UserBioData{}, %{
    #         emailAddress: lead.email_address,
    #         firstName: lead.first_name,
    #         gender: lead.gender,
    #         lastName: lead.last_name,
    #         meansOfIdentificationNumber: lead.identification_number,
    #         meansOfIdentificationType: "NRC",
    #         mobileNumber: lead.mobile_number,
    #         userId: push_to_user_table.id
    #     })
    #     |> Repo.insert()
    # end)

    # |> Ecto.Multi.run(:push_to_user_bio_data, fn _repo,
    #                                             %{
    #                                               push_to_user_table: _push_to_user_table,
    #                                               update_lead: _update_lead
    #                                             } ->
    #   UserBioData.changeset(UserBioData, %{
    #     emailAddress: lead.email_address,
    #     firstName: lead.first_name,
    #     gender: lead.gender,
    #     lastName: lead.last_name,
    #     meansOfIdentificationNumber: lead.identification_number,
    #     meansOfIdentificationType: "NRC",
    #     mobileNumber: lead.mobile_number,

    #   })
    #   |> Repo.insert()
    # end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{

                                      update_lead: _update_lead
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_lead: _update_lead}} ->
        conn
        |> put_flash(:info, "You have Successfully Updated lead")
        |> redirect(to: Routes.customer_relationship_management_path(conn, :leeds))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_relationship_management_path(conn, :leeds))
    end
  end





  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:customer_relation_management, :create}
      act when act in ~w(index view)a -> {:customer_relation_management, :view}
      act when act in ~w(update edit)a -> {:customer_relation_management, :edit}
      act when act in ~w(change_status)a -> {:customer_relation_management, :change_status}
      _ -> {:customer_relation_management, :unknown}
    end
  end

end
