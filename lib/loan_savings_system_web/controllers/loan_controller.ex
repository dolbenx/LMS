defmodule LoanSavingsSystemWeb.LoanController do
    use LoanSavingsSystemWeb, :controller

    alias LoanSavingsSystem.Repo
    alias LoanSavingsSystem.Logs.UserLogs
    alias LoanSavingsSystem.Accounts
    alias LoanSavingsSystem.Accounts.User
    alias LoanSavingsSystem.Accounts.Account
    alias LoanSavingsSystem.Customers
   # alias LoanSavingsSystem.Savings
    alias LoanSavingsSystem.Transactions
    alias LoanSavingsSystem.FixedDeposit
    alias LoanSavingsSystem.Charges
    alias LoanSavingsSystem.Products.Product
    alias LoanSavingsSystem.Accounts.UserRole
    alias LoanSavingsSystem.Accounts.User
    alias LoanSavingsSystem.Client.UserBioData
    alias LoanSavingsSystem.ConfirmationNotification.ConfirmationLoanNotification
    alias LoanSavingsSystem.Companies.Company
    alias LoanSavingsSystem.Companies.Branch
    alias LoanSavingsSystem.WorkFlows
    alias LoanSavingsSystem.WorkFlows.WorkFlow
    alias LoanSavingsSystem.WorkFlows.WorkFlowMember
    alias LoanSavingsSystem.WorkFlows.WorkFlowItem
    alias LoanSavingsSystem.Loan.Loans



    require Logger
      # alias LoanSavingsSystem.Accounts
      # alias MfzUssd.{Auth, Logs}

      alias LoanSavingsSystem.Repo
      require Record
      import Ecto.Query, only: [from: 2]

      plug(
      LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
        when action not in [:new_password, :change_password]
      )

      #plug(
        # LoanSavingsSystemWeb.Plugs.SavingsDashboardAccess
        # when action in [
        #   :savings_accounts,
        #   :fixed_deposits,
        #   :fixed_deps,
        #   :transactions
        # ]
      #)

      def loans_transactions(conn, _params) do
          transactions = Transactions.list_transactions()
          render(conn, "loans_transactions.html",transactions: transactions)
      end

    def loans_accounts(conn, _params) do

          current_user = get_session(conn, :current_user);
          current_user_role = get_session(conn, :current_user_role);
          if(current_user_role.roleType=="COMPANY ADMIN" || current_user_role.roleType=="EMPLOYEE") do
              companyId = current_user_role.companyId
              query = from cl in LoanSavingsSystem.Loan.Loans,
                  join: user in User,
                  join: userBioData in UserBioData,
                  join: userRole in UserRole,
                  join: loanProduct in Product,
                  on:
                  cl.loan_userid == user.id and
                  cl.loan_userroleid == userRole.id and
                  cl.product_id == loanProduct.id and
                  cl.company_id == ^companyId and
                  user.id == userBioData.userId,
              select: %{cl: cl, user: user, userRole: userRole, userBioData: userBioData, loanProduct: loanProduct}
              loan_transaction = Repo.all(query);
              render(conn, "loans_accounts.html", loan_transaction: loan_transaction)
          end

          if(current_user_role.roleType=="INDIVIDUAL") do
              query = from cl in LoanSavingsSystem.Loan.Loans,
                  join: user in User,
                  join: userBioData in UserBioData,
                  join: userRole in UserRole,
                  join: loanProduct in Product,
                  on:
                  cl.loan_userid == user.id and
                  cl.loan_userroleid == userRole.id and
                  cl.product_id == loanProduct.id and
                  is_nil(cl.company_id) and
                  user.id == userBioData.userId,
              where: (user.id == ^current_user),
              select: %{cl: cl, user: user, userRole: userRole, userBioData: userBioData, loanProduct: loanProduct}
              loan_transaction = Repo.all(query);
              render(conn, "loans_accounts.html", loan_transaction: loan_transaction)
          end

          if(current_user_role.roleType=="BACKOFFICE_ADMIN") do


              query = from cl in LoanSavingsSystem.Loan.Loans,
                  join: user in User,
                  join: userBioData in UserBioData,
                  join: userRole in UserRole,
                  join: loanProduct in Product,
                  on:
                  cl.loan_userid == user.id and
                  cl.loan_userroleid == userRole.id and
                  cl.product_id == loanProduct.id and
                  user.id == userBioData.userId and
                  cl.branch_id == ^current_user_role.branchId,
              select: %{cl: cl, user: user, userRole: userRole, userBioData: userBioData, loanProduct: loanProduct}
              loan_transaction = Repo.all(query);
              render(conn, "loans_accounts.html", loan_transaction: loan_transaction)
          end

    end

    def savings_accounts(conn, _params) do
      savings_accounts = Accounts.list_tbl_account()
      render(conn, "savings_accounts.html", savings_accounts: savings_accounts)
    end

    def fixed_deposits(conn, %{"customer_id" => customer_id}) do
      customer_data = Customers.customer_data(customer_id)
      fixed_deposits = Customers.get_fixed_deposits(customer_id)
      render(conn, "fixed_deposits.html", fixed_deposits: fixed_deposits, customer_data: customer_data)
    end

    def fixed_deps(conn, _params) do
      fixed_deps = FixedDeposit.list_transactions()
      render(conn, "fixed_deps.html", fixed_deps: fixed_deps)
    end




      def confirmFixedDeposit(conn, params) do
          ref = params["fixedDepositId"];
          fd = Repo.get!(LoanSavingsSystem.FixedDeposit.FixedDeposits, ref)
          fdStatus = "SUCCESSFUL"
          query = from cl in LoanSavingsSystem.FixedDeposit.FixedDepositTransaction, where: (cl.fixedDepositId== ^fd.id and cl.status == ^fdStatus), select: cl
          fdTransaction = Repo.one(query);
          query = from cl in LoanSavingsSystem.Transactions.Transaction, where: (cl.id== ^fdTransaction.transactionId), select: cl
          transaction = Repo.one(query);

          if(is_nil(transaction)) do
              conn
              |> put_flash(:error, "Invalid transaction. A pending transaction could not be found")
              |> redirect(to: "/Fixed/Deposits/All")
          else
              url = "https://172.27.162.100:7936/mfzipake";
              xml = "<COMMAND><TYPE>TXNEQREQ</TYPE><EXTTRID>#{transaction.orderRef}</EXTTRID></COMMAND>";
              IO.inspect "xml"
              IO.inspect xml
              options = [ssl: [{:versions, [:'tlsv1']}], recv_timeout: 5000];
              header = [{"Content-Type", "application/xml"}];

              case HTTPoison.post(url, xml, header, options) do
                  {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                      IO.inspect ">>>>>>>>>>>>>>>>>"
                      IO.inspect reason
                      response = %{
                          Message: "BA3 ",
                          ClientState: 1,
                          Type: "Response"
                      }
                      conn
                          |> put_flash(:error, "We could not confirm this payment")
                          |> redirect(to: "/Fixed/Deposits/All")
                  {:ok, struct} ->
                      IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                      IO.inspect  (struct)
                      t = struct
                      |> Map.get(:body)

                      IO.inspect t
                      response = %{
                          Message: "BA3 ",
                          ClientState: 1,
                          Type: "Response"
                      }
                      conn
                      |> put_flash(:info, "Fixed deposit confirmed successfully")
                      |> redirect(to: "/Fixed/Deposits/All")
              end
          end
      end

    def transactions(conn, _params) do
      transactions = Transactions.list_transactions()
      render(conn, "transactions.html",transactions: transactions)
    end

    def formatNumb(num) do
      num = Float.ceil(num, 2)
      num = :erlang.float_to_binary((num), [{:decimals, 2}])
      num
    end

    def loan_product(conn, _params) do
      productType = "LOANS"
      productStatus = "ACTIVE"
      #<%= if rem(index, 3)==1 do%><% end%><% else %>
      query = from uB in LoanSavingsSystem.Products.Product, where: (uB.productType == ^productType and uB.status == ^productStatus), select: uB
            loanProducts = Repo.all(query)

      query = from cl in LoanSavingsSystem.Companies.Branch, select: cl
          branches = Repo.all(query);
      render(conn, "loan_product.html",products: loanProducts, branches: branches)
    end



    def terms_conditions(conn, params) do

      query_params = conn.query_params;
      productId = query_params["productId"];
      loanAmount = conn.query_params["amount"];
      bch = conn.query_params["bch"];
      loanAmount = elem Float.parse(loanAmount), 0
      period = query_params["period"];
      period = elem Integer.parse(period), 0

      query = from cl in LoanSavingsSystem.Products.Product, where: (cl.id== ^productId), select: cl
          products = Repo.all(query);
          product = Enum.at(products, 0)

      rate = product.interest;
      annual_period = product.yearLengthInDays;
      interestMode = product.interestMode;
      interestType = product.interestType;
      periodType = product.periodType;

      repaymentAmount = LoanSavingsSystemWeb.ProductController.calculate_monthly_amortization(loanAmount, period, rate, annual_period, interestMode, interestType, periodType)


      query = from au in LoanSavingsSystem.Products.ProductCharge,
          where: (au.productId == type(^product.id, :integer)),
          select: au
      productCharges = Repo.all(query);
      Logger.info "Loan Charges at Disbursement";
      Logger.info product.id
      Logger.info Enum.count(productCharges);

      totalCharge = 0.00;

      totalCharge = if Enum.count(productCharges) > 0 do
          totalCharge = for x <- 0..(Enum.count(productCharges)-1) do
              productCharge = Enum.at(productCharges, x);
              chargeId = productCharge.chargeId
              Logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
              Logger.info chargeId
              query = from au in LoanSavingsSystem.Charges.Charge,
                  where: (au.id == ^chargeId),
                  select: au
              charges = Repo.all(query);
              charge = Enum.at(charges, 0);


              totalCharge = case charge.chargeType do
                  "FLAT" ->
                      totalCharge = totalCharge + charge.chargeAmount
                      totalCharge
                  "PERCENTAGE" ->
                      totalCharge = totalCharge + (charge.chargeAmount*loanAmount/100)
                      Logger.info "charge...#{charge.chargeAmount}"
                      Logger.info "amount...#{loanAmount}"
                      Logger.info "totalCharge...#{totalCharge}"
                      totalCharge
              end

          end
      end

      totalCharge = if is_nil(totalCharge) do
          totalCharge = 0.00
      else
          totalCharge = Float.ceil(Enum.sum(totalCharge), product.currencyDecimals)
      end

      monthlyRepayment = Enum.at(repaymentAmount, Enum.count(repaymentAmount)-1)
      monthlyRepayment = monthlyRepayment["totalPaidInfo"];
      loanAmount = :erlang.float_to_binary(loanAmount, [{:decimals, product.currencyDecimals}])
      bchDetails = String.split(bch, "|||");
      branchId = Enum.at(bchDetails, (0));
      branchName = Enum.at(bchDetails, (1));

      render(conn, "terms_conditions.html", monthlyRepayment: monthlyRepayment, product: product, loanAmount: loanAmount, period: period,
          totalCharge: totalCharge, branchId: branchId, branchName: branchName)
    end



      def createNewLoan(conn, params) do
          params = conn.query_params;
          current_user_role = get_session(conn, :current_user_role);
          current_user = get_session(conn, :current_user);
          Logger.info "Test....."
          loanIssued = LoanSavingsSystem.Loan.Loans.createNewLoan(conn, params, current_user_role, current_user);

          if(!is_nil(loanIssued)) do
              conn
              |> put_flash(:info, "Loan request submitted successfully")
              |> redirect(to: Routes.customer_path(conn, :all_loan_customer))
          else
              conn
              |> put_flash(:error, "Loan request could not be submitted successfully. Please try again")
              |> redirect(to: Routes.customer_path(conn, :all_loan_customer))
          end
      end


      def loan_details(conn, params) do
          sts = Jason.encode!(params)
          loanId = params["loanId"];
          query = from cl in LoanSavingsSystem.Loan.Loans,
                  join: user in User,
                  join: userBioData in UserBioData,
                  join: userRole in UserRole,
                  join: loanProduct in Product,
                  on:
                  cl.loan_userid == user.id and
                  cl.loan_userroleid == userRole.id and
                  cl.product_id == loanProduct.id and
                  user.id == userBioData.userId,
              where: (cl.id == type(^loanId, :integer)),
              select: %{cl: cl, user: user, userRole: userRole, userBioData: userBioData, loanProduct: loanProduct}
          loans = Repo.all(query);
          loan = Enum.at(loans, 0)


          userRoleStatus = "ACTIVE"
          query = from user in User,
                  join: userBioData in UserBioData,
                  join: userRole in UserRole,
                  on:
                  user.id == userBioData.userId and
                  user.id == userRole.userId,
              where: (userRole.status == type(^userRoleStatus, :string)),
              select: %{user: user, userRole: userRole, userBioData: userBioData}
          loanOfficerList = Repo.all(query);


          current_user = get_session(conn, :current_user);
          current_user_role = get_session(conn, :current_user_role);

          query = from workflow in WorkFlow,
              where: (is_nil(workflow.deletedAt) and workflow.branchId == ^current_user_role.branchId),
              select: workflow
          workFlows = Repo.all(query);

          if(Enum.count(workFlows)>0) do

              if(Enum.count(workFlows)==0) do
                  workflowMembers = nil
                  workFlowItems = nil
                  currentWorkflowMember = nil

                  approvalActive = false;
                  render(conn, "xyz.html", approvalActive: approvalActive, currentWorkflowMember: currentWorkflowMember, sts: sts, loan: loan, loanId: loanId, loanOfficerList: loanOfficerList, workflowMembers: workflowMembers, workFlowItems: workFlowItems)
              else
                  workFlow = Enum.at(workFlows, 0)
                  workflowMembers = nil;
                  entityType = "LOANS";
                  query = from cl in LoanSavingsSystem.WorkFlows.WorkFlowItem,
                      join: user in User,
                      join: userBioData in UserBioData,
                      join: branch in Branch,
                      join: loan in Loans,
                      join: userRec in User,
                      join: userBioDataRec in UserBioData,
                      on:
                      cl.createdByUserId == user.id and
                      user.id == userBioData.userId and
                      cl.workflowItemRecipientUserId == userRec.id and
                      userRec.id == userBioDataRec.userId and
                      branch.id == cl.branchId and
                      loan.id == cl.entityId,
                  where: ((cl.createdByUserId == ^current_user) or (cl.workflowItemRecipientUserId == ^current_user)) and cl.entityId == ^loanId and (cl.entityType == ^entityType),
                  order_by: [desc: cl.inserted_at],
                  select: %{cl: cl, user: user, branch: branch, userBioData: userBioData, loan: loan, userRec: userRec, userBioDataRec: userBioDataRec}
                  workFlowItems = Repo.all(query);


                  query = from workflowMember in WorkFlowMember,
                      where: workflowMember.workFlowId == ^workFlow.id and workflowMember.userId == ^current_user and workflowMember.userRoleId == ^current_user_role.id,
                      select: workflowMember
                  workflowMembers = Repo.all(query);

                  if(Enum.count(workflowMembers)>0) do
                      currentWorkflowMember = Enum.at(workflowMembers, 0);



                      query = from workflowMember in WorkFlowMember,
                          where: workflowMember.workFlowId == ^workFlow.id,
                          select: workflowMember
                      allWorkflowMembers = Repo.all(query);

                      approvalActive = if (Enum.count(allWorkflowMembers) == currentWorkflowMember.orderPosition) do
                          approvalActive = true
                          approvalActive
                      else
                          approvalActive = false
                          approvalActive
                      end
                      render(conn, "xyz.html", approvalActive: approvalActive, currentWorkflowMember: currentWorkflowMember, sts: sts, loan: loan, loanId: loanId, loanOfficerList: loanOfficerList, workflowMembers: workflowMembers, workFlowItems: workFlowItems)
                  else
                      currentWorkflowMember = nil
                      approvalActive = false
                      render(conn, "xyz.html", approvalActive: approvalActive, currentWorkflowMember: currentWorkflowMember, sts: sts, loan: loan, loanId: loanId, loanOfficerList: loanOfficerList, workflowMembers: workflowMembers, workFlowItems: workFlowItems)
                  end
              end



          else

          end
      end


      def admin_approve_loan(conn, params) do
              query = from loan in Loans,
                  where: loan.id == ^params["loanId"],
                  select: loan
              loans = Repo.all(query);
              loan = Enum.at(loans, 0);

              accountOfficerId = params["accountOfficerId"];
              comment = params["comment"];
              approvedAmount = params["approvedAmount"];
              fee_charges_repaid_derived = params["fee_charges_repaid_derived"];
              expected_maturity_date = params["expected_maturity_date"];
              approvedon_userid = params["approvedon_userid"];
              approvedon_date = params["approvedon_date"];
              fee_charges_outstanding_derived = params["fee_charges_outstanding_derived"];
              account_no = params["account_no"];
              approve_or_disapprove = params["approve_or_disapprove"];
              case approve_or_disapprove do
                  "APPROVE" ->
                      Ecto.Multi.new()
                      #|> Ecto.Multi.insert(:account, Account.changeset(%Account{}, %{accountOfficerId: accountOfficerId, branchId: branchId, userRoleId: userRoleId,
                      #    deactivatedReason: deactivatedReason, blockedReason: blockedReason, clientId: clientId, accountNo: accountNo,
                      #    externalId: externalId, accountType: accountType, DateClosed: DateClosed, currencyId: currencyId,
                      #    currencyDecimals: currencyDecimals, currencyName: currencyName, totalDeposits: totalDeposits, totalWithdrawals: totalWithdrawals,
                      #    totalCharges: totalCharges, totalPenalties: totalPenalties, totalInterestEarned: totalInterestEarned, totalInterestPosted: totalInterestPosted,
                      #    totalTax: totalTax, accountVersion: accountVersion, derivedAccountBalance: derivedAccountBalance,
                      #    userId: userId, blockedByUserId: blockedByUserId, status: status}))
                      |> Ecto.Multi.update(:loan, Loans.changeset(loan, %{loan_status: "APPROVED", loan_notes: comment, approved_principal: approvedAmount,
                          fee_charges_repaid_derived: fee_charges_repaid_derived, expected_maturity_date: expected_maturity_date, approvedon_userid: approvedon_userid,
                          approvedon_date: approvedon_date, fee_charges_outstanding_derived: fee_charges_outstanding_derived, account_no: account_no
                       }))
                      |> Ecto.Multi.run(:user_log, fn (_, %{loan: _loan}) ->
                          activity = "Loan approved with code \"#{loan.id}\""

                          user_logs = %{
                            user_id: conn.assigns.user.id,
                            activity: activity
                          }

                          UserLogs.changeset(%UserLogs{}, user_logs)
                          |> Repo.insert()

                          confirmation__loan__notification = %{

                            message: "Dear customer, Your loan was approved",
                            sentByUserRoleId: params["user_roleId"],
                            sentByUserId: params["id"]
                          }

                          ConfirmationLoanNotification.changeset(%ConfirmationLoanNotification{}, confirmation__loan__notification)
                          |>Repo.insert()
                      end)
                      |> Repo.transaction()
                      |> case do
                        {:ok, %{loan: _loan, user_log: _user_log}} ->
                          conn |> json(%{message: "Loan approved  successfully", status: 0})
                          {:error, _failed_operation, failed_value, _changes_so_far} ->
                            reason = traverse_errors(failed_value.errors) |> List.first()
                            conn |> json(%{message: reason, status: 1})
                      end
                  "DISAPPROVE" ->
                      Ecto.Multi.new()
                      |> Ecto.Multi.update(:loan, Loans.changeset(loan, %{loan_status: "DISAPPROVED", loan_notes: comment}))
                      |> Ecto.Multi.run(:user_log, fn (_, %{loan: _loan}) ->
                          activity = "Loan disapproved with code \"#{loan.id}\""

                          user_logs = %{
                            user_id: conn.assigns.user.id,
                            activity: activity
                          }

                          UserLogs.changeset(%UserLogs{}, user_logs)
                          |> Repo.insert()

                          confirmation__loan__notification = %{

                            message: "Dear customer, Your loan was disapproved",
                            sentByUserRoleId: params["user_roleId"],
                            sentByUserId: params["id"]
                          }

                          ConfirmationLoanNotification.changeset(%ConfirmationLoanNotification{}, confirmation__loan__notification)
                          |>Repo.insert()
                      end)
                      |> Repo.transaction()
                      |> case do
                        {:ok, %{loan: _loan, user_log: _user_log}} ->
                          conn |> json(%{message: "Loan was disapproved", status: 0})
                          {:error, _failed_operation, failed_value, _changes_so_far} ->
                            reason = traverse_errors(failed_value.errors) |> List.first()
                            conn |> json(%{message: reason, status: 1})
                      end
                  "FORWARD FOR APPROVAL" ->
                      current_user_role = get_session(conn, :current_user_role);
                      query = from workflow in WorkFlow,
                          where: (is_nil(workflow.deletedAt) and workflow.branchId == ^current_user_role.branchId),
                          select: workflow
                      workFlows = Repo.all(query);

                      if(Enum.count(workFlows)==0) do
                          #Throw error
                          url = "/Loans/Accounts/#{loan.id}"
                          conn
                          |> put_flash(:error, "Loan request could not be forwarded for approval. You have no workflows for this process")
                          |> redirect(to: url)
                      else
                          workFlow = Enum.at(workFlows, 0)
                          query = from workflowMember in WorkFlowMember,
                              where: workflowMember.workFlowId == ^workFlow.id,
                              select: workflowMember
                          workflowMembers = Repo.all(query);

                          if ((!is_nil(workflowMembers) && Enum.count(workflowMembers)>0)) do
                              entityType = "LOANS"
                              query = from workflowItem in WorkFlowItem,
                                 where: workflowItem.workFlowId == ^workFlow.id and workflowItem.entityId == ^loan.id and workflowItem.entityType == ^entityType,
                                 select: workflowItem
                              workflowItems = Repo.all(query);

                              if(Enum.count(workflowItems)==0) do
                                  workflowMemberFirst = Enum.at(workflowMembers, 0)
                                  status = "APPROVED & FORWARDED WORKFLOW ITEM"
                                  branchId = loan.branch_id
                                  createdByUserId = current_user_role.userId
                                  createdByUserRoleId = current_user_role.id
                                  entityId = loan.id
                                  entityType = "LOANS"
                                  notes = comment
                                  offTakerId = nil;
                                  actionTaken = nil;
                                  workflowItemRecipientUserId = workflowMemberFirst.userId
                                  workflowItemRecipientUserRoleId = workflowMemberFirst.userRoleId
                                  currentWorkflowPosition = Enum.count(workflowItems) + 1
                                  workflowItem = %WorkFlowItem{workFlowId: workFlow.id, actionTaken: actionTaken, branchId: branchId,
                                      createdByUserId: createdByUserId, createdByUserRoleId: createdByUserRoleId, entityId: entityId,
                                      entityType: entityType, notes: notes, offTakerId: offTakerId, status: status,
                                      workflowItemRecipientUserId: workflowItemRecipientUserId, workflowItemRecipientUserRoleId: workflowItemRecipientUserRoleId,
                                      currentWorkflowPosition: currentWorkflowPosition
                                  }
                                  Repo.insert(workflowItem);

                                  url = "/Loans/Accounts/#{loan.id}"

                                  conn
                                  |> put_flash(:info, "Loan request forwarded successfully")
                                  |> redirect(to: url)
                              else
                                  workflowItemLast = Enum.at(workflowItems, Enum.count(workflowItems)-1)
                                  workflowMemberNext = Enum.at(workflowMembers, workflowItemLast.currentWorkflowPosition)
                                  workflowMemberPrevious = Enum.at(workflowMembers, (workflowItemLast.currentWorkflowPosition - 1))
                                  status = "APPROVED & FORWARDED WORKFLOW ITEM"
                                  branchId = loan.branch_id
                                  createdByUserId = current_user_role.userId
                                  createdByUserRoleId = current_user_role.id
                                  entityId = loan.id
                                  entityType = "LOANS"
                                  notes = comment
                                  offTakerId = nil;
                                  actionTaken = nil;
                                  workflowItemRecipientUserId = workflowMemberNext.userId
                                  workflowItemRecipientUserRoleId = workflowMemberNext.userRoleId
                                  currentWorkflowPosition = Enum.count(workflowItems) + 1
                                  workflowItem = %WorkFlowItem{workFlowId: workFlow.id, actionTaken: actionTaken, branchId: branchId,
                                      createdByUserId: createdByUserId, createdByUserRoleId: createdByUserRoleId, entityId: entityId,
                                      entityType: entityType, notes: notes, offTakerId: offTakerId, status: status,
                                      workflowItemRecipientUserId: workflowItemRecipientUserId, workflowItemRecipientUserRoleId: workflowItemRecipientUserRoleId,
                                      currentWorkflowPosition: currentWorkflowPosition
                                  }
                                  Repo.insert(workflowItem);


                                  workflowItemLast = LoanSavingsSystem.WorkFlows.WorkFlowItem.changesetForUpdate(workflowItemLast,
                                  %{
                                      actionTaken: "APPROVED & FORWARDED WORKFLOW ITEM"
                                  })

                                  Repo.update!(workflowItemLast)

                                  url = "/Loans/Accounts/#{loan.id}"
                                  conn
                                  |> put_flash(:info, "Loan request forwarded successfully")
                                  |> redirect(to: url)
                              end
                          else
                              #Throw error
                          end
                      end
                  "APPROVE WORKFLOW LOAN" ->
                      current_user_role = get_session(conn, :current_user_role);
                      current_user = get_session(conn, :current_user);
                      query = from workflow in WorkFlow,
                          where: (is_nil(workflow.deletedAt) and workflow.branchId == ^current_user_role.branchId),
                          select: workflow
                      workFlows = Repo.all(query);

                      if(Enum.count(workFlows)==0) do
                          #Throw error
                          url = "/Loans/Accounts/#{loan.id}"
                          conn
                          |> put_flash(:error, "Loan request could not be forwarded for approval. You have no workflows for this process")
                          |> redirect(to: url)
                      else
                          workFlow = Enum.at(workFlows, 0)
                          query = from workflowMember in WorkFlowMember,
                              where: workflowMember.workFlowId == ^workFlow.id,
                              select: workflowMember
                          workflowMembers = Repo.all(query);

                          if ((!is_nil(workflowMembers) && Enum.count(workflowMembers)>0)) do
                              entityType = "LOANS"
                              query = from workflowItem in WorkFlowItem,
                                 where: workflowItem.workFlowId == ^workFlow.id and workflowItem.entityId == ^loan.id and workflowItem.entityType == ^entityType,
                                 select: workflowItem
                              workflowItems = Repo.all(query);

                              if(Enum.count(workflowItems)==0) do
                                  url = "/Loans/Accounts/#{loan.id}"

                                  conn
                                  |> put_flash(:error, "Loan request can not be forwarded for approval successfully")
                                  |> redirect(to: url)
                              else
                                  workflowItemLast = Enum.at(workflowItems, Enum.count(workflowItems)-1)
                                    #Dummy
                                    loanAmount = "0.00";
                                  loanAmount = elem Float.parse(loanAmount), 0
                                  IO.inspect loanAmount
                                  workflowItemLast = LoanSavingsSystem.WorkFlows.WorkFlowItem.changesetForUpdate(workflowItemLast,
                                  %{
                                      actionTaken: "APPROVED FOR DISBURSEMENT"
                                  })

                                  Repo.update!(workflowItemLast)


                                  workflowItemLast = LoanSavingsSystem.WorkFlows.WorkFlowItem.changesetForUpdate(workflowItemLast,
                                  %{
                                      actionTaken: "APPROVED FOR DISBURSEMENT"
                                  })

                                  loan = LoanSavingsSystem.Loan.Loans.changesetForUpdate(loan, %{loan_status: "APPROVED",
                                      approved_principal: approvedAmount, approvedon_date: Date.utc_today, approvedon_userid: current_user,
                                      })
                                  Repo.update!(workflowItemLast)

                                  url = "/Loans/Accounts/#{loan.id}"
                                  conn
                                  |> put_flash(:info, "Loan request approved successfully")
                                  |> redirect(to: url)
                              end
                          else
                              #Throw error
                          end
                      end
              end
      end



      def company_admin_approve_loan(conn, params) do
          query = from au in LoanSavingsSystem.Loan.Loans,
              where: (au.id == type(^params["loanId"], :integer)),
              select: au
          loans = Repo.all(query);
          loan = Enum.at(loans, 0);
          current_user_role = get_session(conn, :current_user_role);
          current_user = get_session(conn, :current_user);

          Ecto.Multi.new()
          |> Ecto.Multi.update(:loan, LoanSavingsSystem.Loan.Loans.changesetForUpdate(loan, %{loan_status: "PENDING"}))
          |> Ecto.Multi.run(:user_log, fn (_, %{loan: _loan}) ->
              activity = "Loan approved by company admin with code \"#{loan.id}\""

              user_logs = %{
                user_id: conn.assigns.user.id,
                activity: activity
              }

              UserLogs.changeset(%UserLogs{}, user_logs)
              |> Repo.insert()

              confirmation__loan__notification = %{

                recipientUserID: loan.loan_userid,
                recipientUserRoleId: loan.loan_userroleid,
                message: "Dear customer, Your loan was approved by your company and forwarded to the bank for approval",
                sentByUserRoleId: current_user_role.id,
                sentByUserId: current_user
              }

              ConfirmationLoanNotification.changeset(%ConfirmationLoanNotification{}, confirmation__loan__notification)
              |>Repo.insert()
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{loan: _loan, user_log: _user_log}} ->
              conn
              |> put_flash(:info, "Loan request approved successfully")
              |> redirect(to: Routes.customer_path(conn, :all_loan_customer))
            {:error, _failed_operation, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors) |> List.first()
                conn |> json(%{message: reason, status: 1})
          end
      end

    def traverse_errors(errors) do
      for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
    end


      def send_response(conn, response) do
          Logger.info  "Test!"
          Logger.info  Jason.encode!(response)
          send_resp(conn, :ok, Jason.encode!(response))
      end




  end


  defmodule Date_format do
    def iso_date, do: Date.utc_today |> Date.to_iso8601

    def iso_date(year, month, day), do: Date.from_erl!({year, month, day}) |> Date.to_iso8601

    def long_date, do: Date.utc_today |> long_date

    def long_date(year, month, day), do: Date.from_erl!({year, month, day}) |> long_date

    @months  Enum.zip(1..12, ~w[January February March April May June July August September October November December])
             |> Map.new
    @weekdays  Enum.zip(1..7, ~w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday])
               |> Map.new
    def long_date(date) do
      weekday = Date.day_of_week(date)
      "#{@weekdays[weekday]}, #{@months[date.month]} #{date.day}, #{date.year}"
    end
  end

  defmodule Interpreter do
      def interpreteLoanStatus(status, whoAmI) do
          status_ = case whoAmI do
              "INDIVIDUAL" ->
                  status_ = case status do
                      "PENDING" ->
                          "Pending Approval From Bank"
                      "APPROVED" ->
                          "Approved By Bank"
                      "DISBURSED" ->
                          "Disbursed To Your Account"
                  end
              "BACKOFFICE_ADMIN" ->
                  status_ = case status do
                      "PENDING" ->
                          "Pending Approval From Bank"
                      "APPROVED" ->
                          "Approved By Bank"
                      "DISBURSED" ->
                          "Disbursed To Your Account"
                  end
              "EMPLOYEE" ->
                  status_ = case status do
                      "PENDING" ->
                          "Pending Approval From Bank"
                      "PENDING COMPANY ADMIN APPROVAL" ->
                          "Pending Approval From Company Admin"
                      "APPROVED" ->
                          "Approved By Bank"
                      "DISBURSED" ->
                          "Disbursed To Your Account"
                  end
              "COMPANY ADMIN" ->
                  status_ = case status do
                      "PENDING" ->
                          "Pending Approval From Bank"
                      "PENDING COMPANY ADMIN APPROVAL" ->
                          "Pending Approval From Company Admin"
                      "APPROVED" ->
                          "Approved By Bank"
                      "DISBURSED" ->
                          "Disbursed To Your Account"
                  end

          end


          status_
      end

  end
