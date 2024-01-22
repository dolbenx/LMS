defmodule Loanmanagementsystem.LoanServices.Loan do
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Notifications.Messages
  alias Loanmanagementsystem.Loan
  # alias Loanmanagementsystem.Loan.Customer_loan_application
  # alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan.Loan_applicant_collateral
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Loan.Loan_applicant_reference
  alias Loanmanagementsystem.Loan.Loan_customer_details
  # alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Products.Product

  def list_loan_details(conn, _params) do
    user_id = try do conn.assigns.current_user.id rescue _-> "" end
    loans = Loan.track_loan_listing(user_id)
     Messages.success_message("List Loans", %{loans: loans})
   end


   def loan_counts_details(conn, _params) do
      user_id = try do conn.assigns.current_user.id rescue _-> "" end
      disbursed_loan_count = Loanmanagementsystem.Operations.disbursed_loan_count(user_id)
      loan_count= Loanmanagementsystem.Operations.loan_count(user_id)
      pending_loan_count =Loanmanagementsystem.Operations.pending_loan_count(user_id)
      interest_X_balance_amount =  Loanmanagementsystem.Operations.loan_interest_amount(user_id)
     Messages.success_message("Loan Balance and interest amount, plus loan counts", %{interest_X_balance_amount: interest_X_balance_amount,disbursed_loan_count: disbursed_loan_count, loan_count: loan_count, pending_loan_count: pending_loan_count})
   end

   def list_all_company_staff(conn, _params) do
    company_id = try do conn.assigns.current_user.company_id rescue _-> "" end
    staff = Loan.query_company_staff(company_id)
     Messages.success_message("List Staff", %{staff: staff})
   end

   def handle_loan_application(conn, params) do
    customer_id = conn.assigns.current_user.id

    user_role = try do UserRole.find_by(userId: customer_id)rescue _->  nil end
    reference_no = LoanmanagementsystemWeb.IndividualController.generate_reference_no(Integer.to_string(customer_id))

    product = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])


    cro_id = if is_integer(params["cro_id"]) do params["cro_id"] else String.to_integer(params["cro_id"]) end

    product_details = try do Product.find_by(id: params["product_id"]) rescue _->  "" end
    term_in_months = try do
      case String.contains?(String.trim(params["loan_duration_month"]), ".") do
          true ->  String.trim(params["loan_duration_month"]) |> String.to_float()
          false ->  String.trim(params["loan_duration_month"]) |> String.to_integer() end
      rescue _-> 0 end
    loan_amount = try do
      case String.contains?(String.trim(params["requested_amount"]), ".") do
          true ->  String.trim(params["requested_amount"]) |> String.to_float()
          false ->  String.trim(params["requested_amount"]) |> String.to_integer() end
      rescue _-> 0 end
    monthly_interest_rate = product_details.interest / 100
    payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
    monthly_installment = Float.round(payment, 2)
    total_pay_amount = monthly_installment * term_in_months
    total_interest_amount = total_pay_amount - loan_amount
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:laon_details, Loans.changeset(%Loans{}, %{
      product_id: params["product_id"],
      customer_id: customer_id,
      loan_type: product.productType,
      principal_amount: loan_amount,
      principal_amount_proposed: loan_amount,
      loan_status: "PENDING_CREDIT_ANALYST",
      status: "PENDING_CREDIT_ANALYST",
      loan_userroleid: user_role.id,
      reference_no: reference_no,
      requested_amount: loan_amount,
      loan_duration_month: Integer.to_string(term_in_months),
      monthly_installment: Float.to_string(monthly_installment),
      proposed_repayment_date: params["proposed_repayment_date"],
      loan_purpose: params["loan_purpose"],
      application_date: Date.utc_today,
      cro_id: cro_id,
      term_frequency: params["term_frequency"],
      balance: total_pay_amount,
      interest_amount: total_interest_amount
    }))
    |> Ecto.Multi.run(:user_log, fn _repo, %{laon_details: laon_details}->

      relationship_officer = Loan.list_customer_relationship_officer(cro_id)
    #    # ----------------------------------- Collateral
        collateral = if is_nil(params["name_of_details"]) do nil else params["name_of_details"] end
        IO.inspect(collateral, label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx collateral")
        collateral_json = Enum.map(collateral, &Jason.decode!/1)
        IO.inspect(collateral_json, label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx collateral_json")
        if collateral == nil || collateral == [] || collateral == ["undefined"] do
          IO.puts "No Reference Attachment Detected"
        else
          # for x <- 0..(Enum.count(collateral_json)-1) do
          #   collateral_params =
          #   %{
          #       customer_id: laon_details.customer_id,
          #       reference_no: laon_details.reference_no,
          #       asset_value: Enum.at(collateral_json["asset_value"], x),
          #       color:  Enum.at(collateral_json["color"], x),
          #       id_number: Enum.at(collateral_json["id_number_collateral"], x),
          #       name_of_collateral:  Enum.at(collateral_json["name_of_collateral"], x),
          #       #  applicant_signature: applicant_signature_encode_img,
          #       name_of_witness:  params["name_of_witness"],
          #       #  witness_signature: witness_signature_encode_img,
          #       cro_staff_name: "#{relationship_officer.firstname} #{relationship_officer.othername} #{relationship_officer.lastname}",
          #       #  cro_staff_signature:  cro_staff_signature_encode_img,
          #     }
          #   Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
          #   |> Repo.insert()
          # end



          # parsed_data = Enum.map(json_object_strings, fn json_object_string -> json_object_string|> String.trim() |> Jason.decode!() end)


          # for collateral_data <- collateral_json do
          #   collateral_params =
          #     %{
          #       customer_id: laon_details.customer_id,
          #       reference_no: laon_details.reference_no,
          #       asset_value: Map.get(collateral_data, "asset_value"),
          #       color: Map.get(collateral_data, "color"),
          #       id_number: Map.get(collateral_data, "id_number_collateral"),
          #       name_of_collateral: Map.get(collateral_data, "name_of_collateral"),
          #       name_of_witness:  params["name_of_witness"],
          #       cro_staff_name: "#{relationship_officer.firstname} #{relationship_officer.othername} #{relationship_officer.lastname}",
          #     }

          #   Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
          #   |> Repo.insert()
          # end

          Enum.with_index(collateral_json, fn collateral_data, index ->

            collateral_params =
              %{
                customer_id: laon_details.customer_id,
                reference_no: laon_details.reference_no,
                asset_value: Map.get(collateral_data, "asset_value", index),
                color: Map.get(collateral_data, "color", index),
                id_number: Map.get(collateral_data, "id_number_collateral", index),
                name_of_collateral: Map.get(collateral_data, "name_of_collateral", index),
                name_of_witness:  params["name_of_witness"],
                cro_staff_name: "#{relationship_officer.firstname} #{relationship_officer.othername} #{relationship_officer.lastname}",
              }


            Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
            |> Repo.insert()
          end)


        end
        # -------------------------------------Next of Kin
        Nextofkin.changeset(%Nextofkin{}, %{
          userID: customer_id,
          reference_no: laon_details.reference_no,
          kin_first_name: params["kin_first_name"],
          kin_last_name: params["kin_last_name"],
          kin_other_name: params["kin_other_name"],
          # kin_status: params["kin_status"],
          kin_relationship: params["kin_relationship"],
          kin_gender: params["kin_gender122"],
          kin_mobile_number: params["kin_mobile_number"],
        })
        |> Repo.insert()
      # ----------------------------------- Reference
      reference_name = if is_nil(params["name"]) do nil else params["name"] end
      IO.inspect(reference_name, label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx collateral")


      reference_name_json = Enum.map(reference_name, &Jason.decode!/1)
      IO.inspect(reference_name_json, label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx reference_name_json")


      if reference_name == nil || reference_name == [] || reference_name == ["undefined"] do
        IO.puts "No Reference Attachment Detected"
      else
        # for reference_data <- reference_name_json do
        #   reference_params =
        #   %{
        #       customer_id: customer_id,
        #       reference_no: laon_details.reference_no,
        #       name: Map.get(reference_data, "name"),
        #       contact_no: Map.get(reference_data, "contact_no"),
        #     }
        #   Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
        #   |> Repo.insert()
        # end

        Enum.with_index(reference_name_json, fn reference_data, index ->
          reference_params =
            %{
                customer_id: customer_id,
                reference_no: laon_details.reference_no,
                name: Map.get(reference_data, "name", index),
                contact_no: Map.get(reference_data, "contact_no", index),
              }
            Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
            |> Repo.insert()
        end)


      end
      user = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: customer_id)
      address = Loanmanagementsystem.Accounts.Address_Details.find_by(userId: customer_id)
      Loan_customer_details.changeset(%Loan_customer_details{}, %{
        customer_id: customer_id,
        reference_no: laon_details.reference_no,
        firstname: user.firstName,
        surname: user.lastName,
        othername: user.otherName,
        id_type: user.meansOfIdentificationType,
        id_number: user.meansOfIdentificationNumber,
        gender: user.gender,
        marital_status: user.marital_status,
        cell_number: user.mobileNumber,
        email: user.emailAddress,
        dob: "#{user.dateOfBirth}",
        residential_address: address.house_number,
        landmark: address.land_mark,
        town: address.town,
        province: address.province,
      })
      |> Repo.insert()
    end)
    |>IO.inspect(label: "---------------------------- all records")
    |> Repo.transaction()
    |> case do
      {:ok, %{laon_details: laon_details, user_log: _user_log}} ->
        loan_details = Loans.find_by(reference_no: laon_details.reference_no)
        nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: customer_id).meansOfIdentificationNumber rescue _-> "" end

        Loanmanagementsystem.Services.LoanDocumentsUploadsMobile.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "LOAN_DOCUMENTS"})

        Messages.success_message("Successfully Applied for a loan", %{})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        Messages.error_message(reason)
    end
  end


  # def handle_loan_application(conn, params) do
  #   Ecto.Multi.new()
  #     |> Ecto.Multi.insert(:loan_application, Customer_loan_application.changeset(%Customer_loan_application{}, params))
  #     |> Ecto.Multi.run(:user_log, fn(_, %{loan_application: _loan_application}) ->
  #       activity = " \"#{params.first_name}\" \"#{params.last_name}\" has Successfully Applied for a loan "
  #       user_log = %{
  #         user_id:  conn.assigns.current_user.id,
  #         activity: activity
  #         }
  #     UserLogs.changeset(%UserLogs{}, user_log)
  #     |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{loan_application: _loan_application, user_log: _user_log}} ->
  #       Messages.success_message("Successfully Applied for a loan", %{})
  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors) |> List.first()
  #       Messages.error_message(reason)
  #   end
  # end


  def get_loans_by_userid(conn, _params) do
    user_id = conn.assigns.current_user.id

    IO.inspect(user_id, label: "---------------------------id")
    loans = Loanmanagementsystem.Operations.get_loan_by_userid(user_id)
    loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
    Messages.success_message("List All Loans by User Id", %{loans: loans, loan_count: loan_count, loan_info: Loanmanagementsystem.Operations.loan_interest_amount(user_id)})
  end


  def get_last_five_loan_by_userid(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.inspect(user_id, label: "---------------------------id")
    loans = Loanmanagementsystem.Operations.get_last_five_loan_by_userid(user_id)
    loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
    Messages.success_message("List All Loans by User Id", %{loans: loans, loan_count: loan_count, loan_info: Loanmanagementsystem.Operations.loan_interest_amount(user_id)})
  end

  def get_loan_by_loan_id(_conn, params) do
    IO.inspect(params["loan_id"], label: "::::::::::::::::::::::::::")
    loan_id = String.to_integer(params["loan_id"])
    loan = Loanmanagementsystem.Operations.get_loan_by_loan_id(loan_id)

    Messages.success_message("List Loan by Loan ID", %{loan: loan})
  end


  def get_360_view_by_userid(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.inspect(user_id, label: "---------------------------id")
    loans = Loanmanagementsystem.Operations.get_loan_by_userid(user_id)
    loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
    loan_info = Loanmanagementsystem.Operations.loan_interest_amount(user_id)
    user_info = Loanmanagementsystem.Operations.get_user_info_by_user_id(user_id)
    Messages.success_message("360 View by User Id", %{loans: loans, loan_count: loan_count, loan_info: loan_info, user_info: user_info})
  end


  def get_mini_statement_by_user_id(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.inspect(user_id, label: "---------------------------id")
    loans = Loanmanagementsystem.Operations.get_individual_mini_statement(user_id)
    loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
    Messages.success_message("Mini Statement by User Id", %{loans: loans, loan_count: loan_count})
  end

  def get_historical_statement_by_user_id(conn, _params) do
    user_id = conn.assigns.current_user.id
    IO.inspect(user_id, label: "---------------------------id")
    loans = Loanmanagementsystem.Operations.get_individual_historical_statement(user_id)
    loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
    Messages.success_message("Historical Statement by User Id", %{loans: loans, loan_count: loan_count})
  end

  def get_customer_relationship_officer(_conn, _params) do
    relationship_officer = Loan.list_customer_relationship_officer()
    Messages.success_message("All Customer Relationship Officer's", %{relationship_officer: relationship_officer})
  end


  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

end
