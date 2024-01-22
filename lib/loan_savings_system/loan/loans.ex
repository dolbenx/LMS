defmodule LoanSavingsSystem.Loan.Loans do
    use Ecto.Schema
    import Ecto.Changeset

    require Logger
      # alias LoanSavingsSystem.Accounts
      # alias MfzUssd.{Auth, Logs}

      alias LoanSavingsSystem.Repo
      require Record
      import Ecto.Query, only: [from: 2]

    schema "tbl_loans" do
      field :loan_userroleid, :integer
      field :loan_userid, :integer
      field :fee_charges_charged_derived, :float
      field :closedon_date, :date
      field :repay_every, :integer
      field :interest_calculated_from_date, :date
      field :fee_charges_repaid_derived, :float
      field :principal_amount_proposed, :float
      field :principal_writtenoff_derived, :float
      field :total_charges_due_at_disbursement_derived, :float
      field :currency_code, :string
      field :loan_counter, :integer
      field :expected_maturity_date, :date
      field :interest_waived_derived, :float
      field :interest_method, :string
      field :external_id, :string
      field :annual_nominal_interest_rate, :float
      field :actual_nominal_interest_rate, :float
      field :actual_nominal_interest_rate_type, :string
      field :expected_disbursedon_date, :date
      field :account_no, :string
      field :approvedon_userid, :integer
      field :is_npa, :boolean, default: false
      field :interest_charged_derived, :float
      field :fee_charges_writtenoff_derived, :float
      field :disbursedon_userid, :integer
      field :interest_writtenoff_derived, :float
      field :total_writtenoff_derived, :float
      field :is_legacyloan, :boolean, default: false
      field :approvedon_date, :date
      field :interest_outstanding_derived, :float
      field :loan_type, :string
      field :closedon_userid, :integer
      field :term_frequency_type, :string
      field :number_of_repayments, :integer
      field :principal_repaid_derived, :float
      field :principal_amount, :float
      field :penalty_charges_waived_derived, :float
      field :penalty_charges_repaid_derived, :float
      field :total_outstanding_derived, :float
      field :loan_status, :string
      field :term_frequency, :integer
      field :penalty_charges_writtenoff_derived, :float
      field :total_expected_repayment_derived, :float
      field :penalty_charges_charged_derived, :float
      field :withdrawnon_userid, :integer
      field :repay_every_type, :string
      field :penalty_charges_outstanding_derived, :float
      field :rejectedon_date, :date
      field :fee_charges_waived_derived, :float
      field :total_costofloan_derived, :float
      field :writtenoffon_date, :date
      field :product_id, :integer
      field :fee_charges_outstanding_derived, :float
      field :total_expected_costofloan_derived, :float
      field :principal_disbursed_derived, :float
      field :interest_repaid_derived, :float
      field :total_repayment_derived, :float
      field :total_overpaid_derived, :float
      field :withdrawnon_date, :date
      field :total_waived_derived, :float
      field :principal_outstanding_derived, :float
      field :approved_principal, :float
      field :disbursedon_date, :date
      field :rejectedon_userid, :integer
      field :branch_id, :integer
      field :branch_name, :string
      field :company_id, :integer
      field :year_length_in_days, :integer

      timestamps()
    end

    @doc false
    def changeset(loans, attrs) do
      loans
      |> cast(attrs, [:year_length_in_days, :company_id, :branch_id, :branch_name, :loan_userid, :loan_userroleid, :account_no, :external_id, :product_id, :loan_status, :loan_type, :currency_code, :principal_amount_proposed, :principal_amount, :approved_principal, :annual_nominal_interest_rate, :actual_nominal_interest_rate, :actual_nominal_interest_rate_type, :interest_method, :term_frequency, :term_frequency_type, :repay_every, :repay_every_type, :number_of_repayments, :approvedon_date, :approvedon_userid, :expected_disbursedon_date, :disbursedon_date, :disbursedon_userid, :expected_maturity_date, :interest_calculated_from_date, :closedon_date, :closedon_userid, :total_charges_due_at_disbursement_derived, :principal_disbursed_derived, :principal_repaid_derived, :principal_writtenoff_derived, :principal_outstanding_derived, :interest_charged_derived, :interest_repaid_derived, :interest_waived_derived, :interest_writtenoff_derived, :interest_outstanding_derived, :fee_charges_charged_derived, :fee_charges_repaid_derived, :fee_charges_waived_derived, :fee_charges_writtenoff_derived, :fee_charges_outstanding_derived, :penalty_charges_charged_derived, :penalty_charges_repaid_derived, :penalty_charges_waived_derived, :penalty_charges_writtenoff_derived, :penalty_charges_outstanding_derived, :total_expected_repayment_derived, :total_repayment_derived, :total_expected_costofloan_derived, :total_costofloan_derived, :total_waived_derived, :total_writtenoff_derived, :total_outstanding_derived, :total_overpaid_derived, :rejectedon_date, :rejectedon_userid, :withdrawnon_date, :withdrawnon_userid, :writtenoffon_date, :loan_counter, :is_npa, :is_legacyloan])
      |> validate_required([:year_length_in_days, :branch_id, :branch_name, :loan_userid, :loan_userroleid, :account_no, :external_id, :product_id, :loan_status, :loan_type, :currency_code, :principal_amount_proposed, :principal_amount, :approved_principal, :annual_nominal_interest_rate, :actual_nominal_interest_rate, :actual_nominal_interest_rate_type, :interest_method, :term_frequency, :term_frequency_type, :repay_every, :repay_every_type, :number_of_repayments, :approvedon_date, :approvedon_userid, :expected_disbursedon_date, :disbursedon_date, :disbursedon_userid, :expected_maturity_date, :interest_calculated_from_date, :closedon_date, :closedon_userid, :total_charges_due_at_disbursement_derived, :principal_disbursed_derived, :principal_repaid_derived, :principal_writtenoff_derived, :principal_outstanding_derived, :interest_charged_derived, :interest_repaid_derived, :interest_waived_derived, :interest_writtenoff_derived, :interest_outstanding_derived, :fee_charges_charged_derived, :fee_charges_repaid_derived, :fee_charges_waived_derived, :fee_charges_writtenoff_derived, :fee_charges_outstanding_derived, :penalty_charges_charged_derived, :penalty_charges_repaid_derived, :penalty_charges_waived_derived, :penalty_charges_writtenoff_derived, :penalty_charges_outstanding_derived, :total_expected_repayment_derived, :total_repayment_derived, :total_expected_costofloan_derived, :total_costofloan_derived, :total_waived_derived, :total_writtenoff_derived, :total_outstanding_derived, :total_overpaid_derived, :rejectedon_date, :rejectedon_userid, :withdrawnon_date, :withdrawnon_userid, :writtenoffon_date, :loan_counter, :is_npa, :is_legacyloan])
    end

    @doc false
    def changesetForUpdate(loans, attrs) do
      loans
      |> cast(attrs, [:year_length_in_days, :company_id, :branch_id, :branch_name, :loan_userid, :loan_userroleid, :account_no, :external_id, :product_id, :loan_status, :loan_type, :currency_code, :principal_amount_proposed, :principal_amount, :approved_principal, :annual_nominal_interest_rate, :actual_nominal_interest_rate, :actual_nominal_interest_rate_type, :interest_method, :term_frequency, :term_frequency_type, :repay_every, :repay_every_type, :number_of_repayments, :approvedon_date, :approvedon_userid, :expected_disbursedon_date, :disbursedon_date, :disbursedon_userid, :expected_maturity_date, :interest_calculated_from_date, :closedon_date, :closedon_userid, :total_charges_due_at_disbursement_derived, :principal_disbursed_derived, :principal_repaid_derived, :principal_writtenoff_derived, :principal_outstanding_derived, :interest_charged_derived, :interest_repaid_derived, :interest_waived_derived, :interest_writtenoff_derived, :interest_outstanding_derived, :fee_charges_charged_derived, :fee_charges_repaid_derived, :fee_charges_waived_derived, :fee_charges_writtenoff_derived, :fee_charges_outstanding_derived, :penalty_charges_charged_derived, :penalty_charges_repaid_derived, :penalty_charges_waived_derived, :penalty_charges_writtenoff_derived, :penalty_charges_outstanding_derived, :total_expected_repayment_derived, :total_repayment_derived, :total_expected_costofloan_derived, :total_costofloan_derived, :total_waived_derived, :total_writtenoff_derived, :total_outstanding_derived, :total_overpaid_derived, :rejectedon_date, :rejectedon_userid, :withdrawnon_date, :withdrawnon_userid, :writtenoffon_date, :loan_counter, :is_npa, :is_legacyloan])
    end




    #   def createNewLoan(conn, params, current_user_role, current_user, mobileNumber) do

    #       query_params = params;
    #       productId = query_params["productId"];
    #       loanAmount = query_params["amount"];
    #       bch = query_params["bch"];
    #       bch = String.split(bch, "|||");
    #       branchId = Enum.at(bch, 0)
    #       branchId = elem Integer.parse(branchId), 0
    #       branchName = Enum.at(bch, 1)
    #       loanAmount = elem Float.parse(loanAmount), 0
    #       period = query_params["period"];
    #       period = elem Integer.parse(period), 0

    #       query = from cl in LoanSavingsSystem.Products.Product, where: (cl.id== ^productId), select: cl
    #           products = Repo.all(query);
    #           product = Enum.at(products, 0)

    #       rate = product.interest;
    #       annual_period = product.yearLengthInDays;
    #       interestMode = product.interestMode;
    #       interestType = product.interestType;
    #       periodType = product.periodType;

    #       repaymentAmounts = LoanSavingsSystemWeb.ProductController.calculate_monthly_amortization(loanAmount, period, rate, annual_period, interestMode, interestType, periodType)


    #       query = from au in LoanSavingsSystem.Products.ProductCharge,
    #           where: (au.productId == type(^product.id, :integer) and au.chargeWhen == "AT DISBURSEMENT"),
    #           select: au
    #       productCharges = Repo.all(query);
    #       Logger.info "Loan Charges at Disbursement";
    #       Logger.info product.id
    #       Logger.info Enum.count(productCharges);

    #       totalCharge = 0.00;

    #       totalCharge = if Enum.count(productCharges) > 0 do
    #           totalCharge = for x <- 0..(Enum.count(productCharges)-1) do
    #               productCharge = Enum.at(productCharges, x);
    #               chargeId = productCharge.chargeId
    #               Logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    #               Logger.info chargeId
    #               query = from au in LoanSavingsSystem.Charges.Charge,
    #                   where: (au.id == ^chargeId),
    #                   select: au
    #               charges = Repo.all(query);
    #               charge = Enum.at(charges, 0);


    #               totalCharge = case charge.chargeType do
    #                   "FLAT" ->
    #                       totalCharge = totalCharge + charge.chargeAmount
    #                       totalCharge
    #                   "PERCENTAGE" ->
    #                       totalCharge = totalCharge + (charge.chargeAmount*loanAmount/100)
    #                       Logger.info "charge...#{charge.chargeAmount}"
    #                       Logger.info "amount...#{loanAmount}"
    #                       Logger.info "totalCharge...#{totalCharge}"
    #                       totalCharge
    #               end

    #           end
    #       end

    #       totalCharge = if is_nil(totalCharge) do
    #           totalCharge = 0.00
    #       else
    #           totalCharge = Float.ceil(Enum.sum(totalCharge), product.currencyDecimals)
    #       end

    #       lastMonthlyRepayment = Enum.at(repaymentAmounts, Enum.count(repaymentAmounts)-1)
    #       monthlyRepayment = lastMonthlyRepayment["totalPaidInfo"];
    #       lastMonthlyRepaymentDate = case product.periodType do
    #           "Days" ->
    #               endDate = Date.add(Date.utc_today, period)
    #               endDate
    #           "Months" ->
    #               endDate = Date.add(Date.utc_today, period*30)
    #               endDate
    #           "Years" ->
    #               endDate = Date.add(Date.utc_today, period*product.yearLengthInDays)
    #               endDate
    #       end


    #       annual_rate = case interestType do
    #           "Days" ->
    #               rate = rate * annual_period
    #               annual_rate = rate
    #               annual_rate
    #           "Months" ->
    #               rate = rate*12
    #               annual_rate = rate
    #               annual_rate
    #           "Years" ->
    #               annual_rate = rate
    #               annual_rate
    #       end

    #       loanAmountStr = :erlang.float_to_binary(loanAmount, [{:decimals, product.currencyDecimals}])


    #       loan_type = if((current_user_role.roleType=="INDIVIDUAL")) do
    #           loan_type = "INDIVIDUAL";
    #           loan_type
    #       else
    #           if(current_user_role.roleType=="EMPLOYEE") do
    #               loan_type = "SALARY";
    #               loan_type
    #           else
    #               if(current_user_role.roleType=="SME MEMBER") do
    #                   loan_type = "SME LOAN";
    #                   loan_type
    #               else
    #                   loan_type = "INDIVIDUAL";
    #                   loan_type
    #               end
    #           end
    #       end

    #       Logger.info Jason.encode!(repaymentAmounts);
    #       totalInterest = for x <- 1..(Enum.count(repaymentAmounts)-1) do
    #           rA = Enum.at(repaymentAmounts, x);
    #           Logger.info (rA["interestPaid"]);
    #           rA["interestPaid"];
    #       end
    #       Logger.info "Test44.....";
    #       totalInterest = Float.ceil(Enum.sum(totalInterest), product.currencyDecimals)

    #       loanStatus = "APPROVED"
    #       query = from au in LoanSavingsSystem.Loan.Loans,
    #           where: (au.loan_userid == type(^current_user, :integer) and au.loan_status == ^loanStatus),
    #           select: au
    #       userLoans = Repo.all(query);

    #       fee_charges_charged_derived = totalCharge;
    #       closedon_date = nil;
    #       repay_every = 1;
    #       repay_every_type = product.periodType;
    #       interest_calculated_from_date = Date.utc_today;
    #       fee_charges_repaid_derived = 0.00;
    #       principal_amount_proposed = loanAmount;
    #       principal_writtenoff_derived = 0.00;
    #       total_charges_due_at_disbursement_derived = totalCharge;
    #       currency_code = product.currencyName;
    #       loan_counter = Enum.count(userLoans) + 1;
    #       expected_maturity_date = lastMonthlyRepaymentDate;
    #       expected_disbursedon_date = nil;
    #       approvedon_userid = current_user;
    #       interest_charged_derived = totalInterest;
    #       approvedon_date = Date.utc_today;
    #       interest_outstanding_derived = totalInterest;
    #       total_outstanding_derived = (totalInterest+loanAmount);
    #       total_expected_repayment_derived = (totalInterest+loanAmount);
    #       rejectedon_date = nil;
    #       total_costofloan_derived = totalCharge;
    #       fee_charges_outstanding_derived = totalCharge;
    #       total_expected_costofloan_derived = totalCharge;
    #       total_repayment_derived = (totalInterest+loanAmount);
    #       principal_outstanding_derived = loanAmount;
    #       approved_principal = loanAmount;
    #       pad = String.pad_leading("#{(Enum.count(userLoans) + 1)}", 4, "0")
    #       account_no = "mobileNumber#{(pad)}";




    #       account = %LoanSavingsSystem.Accounts.Account{
    #             DateClosed: nil,
    #             accountNo: account_no,
    #             accountType: "LOANS",
    #             accountVersion: "1.0",
    #             blockedByUserId: nil,
    #             blockedReason: nil,
    #             clientId: client.id,
    #             currencyDecimals: product,
    #             currencyId: product,
    #             currencyName: string,
    #             deactivatedReason: string,
    #             derivedAccountBalance: float,
    #             externalId: string,
    #             accountOfficerId: integer,
    #             status: string,
    #             totalCharges: float,
    #             totalDeposits: float,
    #             totalInterestEarned: float,
    #             totalInterestPosted: float,
    #             totalPenalties: float,
    #             totalTax: float,
    #             totalWithdrawals: float,
    #             userId: integer,
    #             userRoleId: integer,
    #             branchId: integer
    #       }
    #       loanIssued = %LoanSavingsSystem.Loan.Loans{
    #           branch_id: branchId,
    #           branch_name: branchName,
    #           loan_userid: loan_userid,
    #           loan_userroleid: loan_userroleid.id,
    #           fee_charges_charged_derived: fee_charges_charged_derived,
    #           closedon_date: closedon_date,
    #           repay_every: repay_every,
    #           interest_calculated_from_date: interest_calculated_from_date,
    #           fee_charges_repaid_derived: fee_charges_repaid_derived,
    #           principal_amount_proposed: principal_amount_proposed,
    #           principal_writtenoff_derived: principal_writtenoff_derived,
    #           total_charges_due_at_disbursement_derived: total_charges_due_at_disbursement_derived,
    #           currency_code: currency_code,
    #           loan_counter: loan_counter,
    #           expected_maturity_date: expected_maturity_date,
    #           interest_waived_derived: interest_waived_derived,
    #           interest_method: interest_method,
    #           external_id: external_id,
    #           annual_nominal_interest_rate: annual_nominal_interest_rate,
    #           actual_nominal_interest_rate: actual_nominal_interest_rate,
    #           actual_nominal_interest_rate_type: actual_nominal_interest_rate_type,
    #           actual_nominal_interest_rate: product.interest,
    #           actual_nominal_interest_rate_type: interestType,
    #           expected_disbursedon_date: expected_disbursedon_date,
    #           account_no: account_no,
    #           approvedon_userid: approvedon_userid,
    #           is_npa: is_npa,
    #           interest_charged_derived: interest_charged_derived,
    #           fee_charges_writtenoff_derived: fee_charges_writtenoff_derived,
    #           disbursedon_userid: disbursedon_userid,
    #           interest_writtenoff_derived: interest_writtenoff_derived,
    #           total_writtenoff_derived: total_writtenoff_derived,
    #           is_legacyloan: is_legacyloan,
    #           approvedon_date: approvedon_date,
    #           interest_outstanding_derived: interest_outstanding_derived,
    #           loan_type: loan_type,
    #           closedon_userid: closedon_userid,
    #           term_frequency_type: term_frequency_type,
    #           number_of_repayments: number_of_repayments,
    #           principal_repaid_derived: principal_repaid_derived,
    #           principal_amount: principal_amount,
    #           penalty_charges_waived_derived: penalty_charges_waived_derived,
    #           penalty_charges_repaid_derived: penalty_charges_repaid_derived,
    #           total_outstanding_derived: total_outstanding_derived,
    #           loan_status: loan_status,
    #           term_frequency: term_frequency,
    #           penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived,
    #           total_expected_repayment_derived: total_expected_repayment_derived,
    #           penalty_charges_charged_derived: penalty_charges_charged_derived,
    #           withdrawnon_userid: withdrawnon_userid,
    #           repay_every_type: repay_every_type,
    #           penalty_charges_outstanding_derived: penalty_charges_outstanding_derived,
    #           rejectedon_date: rejectedon_date,
    #           fee_charges_waived_derived: fee_charges_waived_derived,
    #           total_costofloan_derived: total_costofloan_derived,
    #           writtenoffon_date: writtenoffon_date,
    #           product_id: product_id,
    #           fee_charges_outstanding_derived: fee_charges_outstanding_derived,
    #           total_expected_costofloan_derived: total_expected_costofloan_derived,
    #           principal_disbursed_derived: principal_disbursed_derived,
    #           interest_repaid_derived: interest_repaid_derived,
    #           total_repayment_derived: total_repayment_derived,
    #           total_overpaid_derived: total_overpaid_derived,
    #           withdrawnon_date: withdrawnon_date,
    #           total_waived_derived: total_waived_derived,
    #           principal_outstanding_derived: principal_outstanding_derived,
    #           approved_principal: approved_principal,
    #           disbursedon_date: disbursedon_date,
    #           rejectedon_userid: rejectedon_userid,
    #           company_id: company_id,
    #           year_length_in_days: year_length_in_days
    #       }
    #       loanIssued = Repo.insert!(loanIssued);


    #       if Enum.count(productCharges) > 0 do
    #           for x <- 0..(Enum.count(productCharges)-1) do
    #               productCharge = Enum.at(productCharges, x);
    #               chargeId = productCharge.chargeId
    #               Logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    #               Logger.info chargeId
    #               query = from au in LoanSavingsSystem.Charges.Charge,
    #                   where: (au.id == ^chargeId),
    #                   select: au
    #               charges = Repo.all(query);
    #               charge = Enum.at(charges, 0);


    #               totalCharge = case charge.chargeType do
    #                   "FLAT" ->
    #                       amount = charge.chargeAmount
    #                       amount_outstanding_derived = amount
    #                       amount_paid_derived = 0.00;
    #                       amount_waived_derived = 0.00;
    #                       amount_writtenoff_derived = 0.00;
    #                       calculation_on_amount = loanAmount;
    #                       calculation_percentage = nil;
    #                       charge_amount_or_percentage = charge.chargeAmount;
    #                       charge_calculation_enum = charge.chargeType;
    #                       charge_id = charge.id;
    #                       charge_payment_mode_enum = nil;
    #                       charge_time_enum = productCharge.chargeWhen

    #                       loanIssuedCharge = %LoanSavingsSystem.Loan.LoanCharge{
    #                           amount: amount,
    #                           amount_outstanding_derived: amount_outstanding_derived,
    #                           amount_paid_derived: amount_paid_derived,
    #                           amount_waived_derived: amount_waived_derived,
    #                           amount_writtenoff_derived: amount_writtenoff_derived,
    #                           calculation_on_amount: calculation_on_amount,
    #                           calculation_percentage: calculation_percentage,
    #                           charge_amount_or_percentage: charge_amount_or_percentage,
    #                           charge_calculation_enum: charge_calculation_enum,
    #                           charge_id: charge_id,
    #                           charge_payment_mode_enum: charge_payment_mode_enum,
    #                           charge_time_enum: charge_time_enum,
    #                           due_for_collection_as_of_date: nil,
    #                           is_active: false,
    #                           is_paid_derived: false,
    #                           is_penalty: charge.isPenalty,
    #                           is_waived: false,
    #                           loan_id: loanIssued.id
    #                       }
    #                       loanIssuedCharge = Repo.insert!(loanIssuedCharge);
    #                   "PERCENTAGE" ->

    #                       amount = (charge.chargeAmount*loanAmount/100)
    #                       amount_outstanding_derived = amount
    #                       amount_paid_derived = 0.00;
    #                       amount_waived_derived = 0.00;
    #                       amount_writtenoff_derived = 0.00;
    #                       calculation_on_amount = loanAmount;
    #                       calculation_percentage = nil;
    #                       charge_amount_or_percentage = charge.chargeAmount;
    #                       charge_calculation_enum = charge.chargeType;
    #                       charge_id = charge.id;
    #                       charge_payment_mode_enum = nil;
    #                       charge_time_enum = productCharge.chargeWhen

    #                       loanIssuedCharge = %LoanSavingsSystem.Loan.LoanCharge{
    #                           amount: amount,
    #                           amount_outstanding_derived: amount_outstanding_derived,
    #                           amount_paid_derived: amount_paid_derived,
    #                           amount_waived_derived: amount_waived_derived,
    #                           amount_writtenoff_derived: amount_writtenoff_derived,
    #                           calculation_on_amount: calculation_on_amount,
    #                           calculation_percentage: calculation_percentage,
    #                           charge_amount_or_percentage: charge_amount_or_percentage,
    #                           charge_calculation_enum: charge_calculation_enum,
    #                           charge_id: charge_id,
    #                           charge_payment_mode_enum: charge_payment_mode_enum,
    #                           charge_time_enum: charge_time_enum,
    #                           due_for_collection_as_of_date: nil,
    #                           is_active: false,
    #                           is_paid_derived: false,
    #                           is_penalty: charge.isPenalty,
    #                           is_waived: false,
    #                           loan_id: loanIssued.id
    #                       }
    #                       loanIssuedCharge = Repo.insert!(loanIssuedCharge);
    #               end

    #           end
    #       end


    #       loanIssued;

    #   end







    #   def updateLoanForApprovedPrincipal(conn, params, approvedPrincipal) do

    #       loanAmount = approvedPrincipal


    #       rate = params.actual_nominal_interest_rate;
    #       annual_period = params.year_length_in_days;
    #       interestMode = params.interest_method;
    #       interestType = params.actual_nominal_interest_rate_type;
    #       periodType = params.term_frequency_type;
    #       period = params.term_frequency;

    #       repaymentAmounts = LoanSavingsSystemWeb.ProductController.calculate_monthly_amortization(loanAmount, period, rate, annual_period, interestMode, interestType, periodType)


    #       query = from au in LoanSavingsSystem.Products.ProductCharge,
    #           where: (au.productId == type(^product.id, :integer) and au.chargeWhen == "AT DISBURSEMENT"),
    #           select: au
    #       productCharges = Repo.all(query);
    #       Logger.info "Loan Charges at Disbursement";
    #       Logger.info product.id
    #       Logger.info Enum.count(productCharges);

    #       totalCharge = 0.00;

    #       totalCharge = if Enum.count(productCharges) > 0 do
    #           totalCharge = for x <- 0..(Enum.count(productCharges)-1) do
    #               productCharge = Enum.at(productCharges, x);
    #               chargeId = productCharge.chargeId
    #               Logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    #               Logger.info chargeId
    #               query = from au in LoanSavingsSystem.Charges.Charge,
    #                   where: (au.id == ^chargeId),
    #                   select: au
    #               charges = Repo.all(query);
    #               charge = Enum.at(charges, 0);


    #               totalCharge = case charge.chargeType do
    #                   "FLAT" ->
    #                       totalCharge = totalCharge + charge.chargeAmount
    #                       totalCharge
    #                   "PERCENTAGE" ->
    #                       totalCharge = totalCharge + (charge.chargeAmount*loanAmount/100)
    #                       Logger.info "charge...#{charge.chargeAmount}"
    #                       Logger.info "amount...#{loanAmount}"
    #                       Logger.info "totalCharge...#{totalCharge}"
    #                       totalCharge
    #               end

    #           end
    #       end

    #       totalCharge = if is_nil(totalCharge) do
    #           totalCharge = 0.00
    #       else
    #           totalCharge = Float.ceil(Enum.sum(totalCharge), product.currencyDecimals)
    #       end

    #       lastMonthlyRepayment = Enum.at(repaymentAmounts, Enum.count(repaymentAmounts)-1)
    #       monthlyRepayment = lastMonthlyRepayment["totalPaidInfo"];
    #       lastMonthlyRepaymentDate = case product.periodType do
    #           "Days" ->
    #               endDate = Date.add(Date.utc_today, period)
    #               endDate
    #           "Months" ->
    #               endDate = Date.add(Date.utc_today, period*30)
    #               endDate
    #           "Years" ->
    #               endDate = Date.add(Date.utc_today, period*product.yearLengthInDays)
    #               endDate
    #       end


    #       annual_rate = case interestType do
    #           "Days" ->
    #               rate = rate * annual_period
    #               annual_rate = rate
    #               annual_rate
    #           "Months" ->
    #               rate = rate*12
    #               annual_rate = rate
    #               annual_rate
    #           "Years" ->
    #               annual_rate = rate
    #               annual_rate
    #       end

    #       loanAmountStr = :erlang.float_to_binary(loanAmount, [{:decimals, product.currencyDecimals}])


    #       loan_type = if((current_user_role.roleType=="INDIVIDUAL")) do
    #           loan_type = "INDIVIDUAL";
    #           loan_type
    #       else
    #           if(current_user_role.roleType=="EMPLOYEE") do
    #               loan_type = "SALARY";
    #               loan_type
    #           else
    #               if(current_user_role.roleType=="SME MEMBER") do
    #                   loan_type = "SME LOAN";
    #                   loan_type
    #               else
    #                   loan_type = "INDIVIDUAL";
    #                   loan_type
    #               end
    #           end
    #       end

    #       Logger.info Jason.encode!(repaymentAmounts);
    #       totalInterest = for x <- 1..(Enum.count(repaymentAmounts)-1) do
    #           rA = Enum.at(repaymentAmounts, x);
    #           Logger.info (rA["interestPaid"]);
    #           rA["interestPaid"];
    #       end
    #       Logger.info "Test44.....";
    #       totalInterest = Float.ceil(Enum.sum(totalInterest), product.currencyDecimals)

    #       loanStatus = "APPROVED"
    #       query = from au in LoanSavingsSystem.Loan.Loans,
    #           where: (au.loan_userid == type(^current_user, :integer) and au.loan_status == ^loanStatus),
    #           select: au
    #       userLoans = Repo.all(query);

    #       fee_charges_charged_derived = totalCharge;
    #       closedon_date = nil;
    #       repay_every = 1;
    #       interest_calculated_from_date = Date.utc_today;
    #       total_charges_due_at_disbursement_derived = totalCharge;
    #       currency_code = product.currencyName;
    #       loan_counter = Enum.count(userLoans) + 1;
    #       expected_maturity_date = lastMonthlyRepaymentDate;
    #       interest_waived_derived = 0.00;
    #       interest_method = product.interestMode;
    #       external_id = nil;
    #       annual_nominal_interest_rate = annual_rate;
    #       actual_nominal_interest_rate = product.interest;
    #       actual_nominal_interest_rate_type = product.interestType;
    #       expected_disbursedon_date = Date.utc_today;
    #       approvedon_userid = nil;
    #       is_npa = false;
    #       interest_charged_derived = totalInterest;
    #       fee_charges_writtenoff_derived = 0.00;
    #       interest_writtenoff_derived = 0.00;
    #       total_writtenoff_derived = 0.00;
    #       is_legacyloan = false;
    #       approvedon_date = nil;
    #       interest_outstanding_derived = totalInterest;
    #       loan_type = loan_type;
    #       term_frequency_type = product.periodType;
    #       number_of_repayments = period;
    #       principal_repaid_derived = 0.00;
    #       principal_amount = loanAmount;
    #       penalty_charges_waived_derived = 0.00;
    #       penalty_charges_repaid_derived = 0.00;
    #       total_outstanding_derived = (totalInterest+loanAmount);
    #       loan_status = if(is_nil(current_user_role.companyId)) do
    #           loan_status = "PENDING";
    #           loan_status
    #       else
    #           loan_status = "PENDING COMPANY ADMIN APPROVAL";
    #           loan_status
    #       end

    #       company_id = current_user_role.companyId
    #       term_frequency = period;
    #       penalty_charges_writtenoff_derived = 0.00;
    #       total_expected_repayment_derived = (totalInterest+loanAmount);
    #       penalty_charges_charged_derived = 0.00;
    #       penalty_charges_outstanding_derived = 0.00;
    #       rejectedon_date = nil;
    #       fee_charges_waived_derived = 0.00;
    #       total_costofloan_derived = totalCharge;
    #       writtenoffon_date = nil;
    #       product_id = product.id;
    #       fee_charges_outstanding_derived = totalCharge;
    #       total_expected_costofloan_derived = totalCharge;
    #       principal_disbursed_derived = nil;
    #       interest_repaid_derived = 0.00;
    #       total_repayment_derived = (totalInterest+loanAmount);
    #       total_overpaid_derived = 0.00;
    #       withdrawnon_date = nil;
    #       total_waived_derived = 0.00;
    #       principal_outstanding_derived = loanAmount;
    #       approved_principal = nil;
    #       disbursedon_date = nil;
    #       rejectedon_userid = nil;
    #       loan_userid = current_user;
    #       loan_userroleid = current_user_role;
    #       account_no = nil;
    #       disbursedon_userid = nil;
    #       closedon_userid = nil;
    #       withdrawnon_userid = nil;

    #       loanIssued = %LoanSavingsSystem.Loan.Loans{
    #           branch_id: branchId,
    #           branch_name: branchName,
    #           loan_userid: loan_userid,
    #           loan_userroleid: loan_userroleid.id,
    #           fee_charges_charged_derived: fee_charges_charged_derived,
    #           closedon_date: closedon_date,
    #           repay_every: repay_every,
    #           interest_calculated_from_date: interest_calculated_from_date,
    #           fee_charges_repaid_derived: fee_charges_repaid_derived,
    #           principal_amount_proposed: principal_amount_proposed,
    #           principal_writtenoff_derived: principal_writtenoff_derived,
    #           total_charges_due_at_disbursement_derived: total_charges_due_at_disbursement_derived,
    #           currency_code: currency_code,
    #           loan_counter: loan_counter,
    #           expected_maturity_date: expected_maturity_date,
    #           interest_waived_derived: interest_waived_derived,
    #           interest_method: interest_method,
    #           external_id: external_id,
    #           annual_nominal_interest_rate: annual_nominal_interest_rate,
    #           actual_nominal_interest_rate: actual_nominal_interest_rate,
    #           actual_nominal_interest_rate_type: actual_nominal_interest_rate_type,
    #           actual_nominal_interest_rate: product.interest,
    #           actual_nominal_interest_rate_type: interestType,
    #           expected_disbursedon_date: expected_disbursedon_date,
    #           account_no: account_no,
    #           approvedon_userid: approvedon_userid,
    #           is_npa: is_npa,
    #           interest_charged_derived: interest_charged_derived,
    #           fee_charges_writtenoff_derived: fee_charges_writtenoff_derived,
    #           disbursedon_userid: disbursedon_userid,
    #           interest_writtenoff_derived: interest_writtenoff_derived,
    #           total_writtenoff_derived: total_writtenoff_derived,
    #           is_legacyloan: is_legacyloan,
    #           approvedon_date: approvedon_date,
    #           interest_outstanding_derived: interest_outstanding_derived,
    #           loan_type: loan_type,
    #           closedon_userid: closedon_userid,
    #           term_frequency_type: term_frequency_type,
    #           number_of_repayments: number_of_repayments,
    #           principal_repaid_derived: principal_repaid_derived,
    #           principal_amount: principal_amount,
    #           penalty_charges_waived_derived: penalty_charges_waived_derived,
    #           penalty_charges_repaid_derived: penalty_charges_repaid_derived,
    #           total_outstanding_derived: total_outstanding_derived,
    #           loan_status: loan_status,
    #           term_frequency: term_frequency,
    #           penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived,
    #           total_expected_repayment_derived: total_expected_repayment_derived,
    #           penalty_charges_charged_derived: penalty_charges_charged_derived,
    #           withdrawnon_userid: withdrawnon_userid,
    #           repay_every_type: repay_every_type,
    #           penalty_charges_outstanding_derived: penalty_charges_outstanding_derived,
    #           rejectedon_date: rejectedon_date,
    #           fee_charges_waived_derived: fee_charges_waived_derived,
    #           total_costofloan_derived: total_costofloan_derived,
    #           writtenoffon_date: writtenoffon_date,
    #           product_id: product_id,
    #           fee_charges_outstanding_derived: fee_charges_outstanding_derived,
    #           total_expected_costofloan_derived: total_expected_costofloan_derived,
    #           principal_disbursed_derived: principal_disbursed_derived,
    #           interest_repaid_derived: interest_repaid_derived,
    #           total_repayment_derived: total_repayment_derived,
    #           total_overpaid_derived: total_overpaid_derived,
    #           withdrawnon_date: withdrawnon_date,
    #           total_waived_derived: total_waived_derived,
    #           principal_outstanding_derived: principal_outstanding_derived,
    #           approved_principal: approved_principal,
    #           disbursedon_date: disbursedon_date,
    #           rejectedon_userid: rejectedon_userid,
    #           company_id: company_id
    #       }
    #       loanIssued = Repo.insert!(loanIssued);


    #       if Enum.count(productCharges) > 0 do
    #           for x <- 0..(Enum.count(productCharges)-1) do
    #               productCharge = Enum.at(productCharges, x);
    #               chargeId = productCharge.chargeId
    #               Logger.info "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    #               Logger.info chargeId
    #               query = from au in LoanSavingsSystem.Charges.Charge,
    #                   where: (au.id == ^chargeId),
    #                   select: au
    #               charges = Repo.all(query);
    #               charge = Enum.at(charges, 0);


    #               totalCharge = case charge.chargeType do
    #                   "FLAT" ->
    #                       amount = charge.chargeAmount
    #                       amount_outstanding_derived = amount
    #                       amount_paid_derived = 0.00;
    #                       amount_waived_derived = 0.00;
    #                       amount_writtenoff_derived = 0.00;
    #                       calculation_on_amount = loanAmount;
    #                       calculation_percentage = nil;
    #                       charge_amount_or_percentage = charge.chargeAmount;
    #                       charge_calculation_enum = charge.chargeType;
    #                       charge_id = charge.id;
    #                       charge_payment_mode_enum = nil;
    #                       charge_time_enum = productCharge.chargeWhen

    #                       loanIssuedCharge = %LoanSavingsSystem.Loan.LoanCharge{
    #                           amount: amount,
    #                           amount_outstanding_derived: amount_outstanding_derived,
    #                           amount_paid_derived: amount_paid_derived,
    #                           amount_waived_derived: amount_waived_derived,
    #                           amount_writtenoff_derived: amount_writtenoff_derived,
    #                           calculation_on_amount: calculation_on_amount,
    #                           calculation_percentage: calculation_percentage,
    #                           charge_amount_or_percentage: charge_amount_or_percentage,
    #                           charge_calculation_enum: charge_calculation_enum,
    #                           charge_id: charge_id,
    #                           charge_payment_mode_enum: charge_payment_mode_enum,
    #                           charge_time_enum: charge_time_enum,
    #                           due_for_collection_as_of_date: nil,
    #                           is_active: false,
    #                           is_paid_derived: false,
    #                           is_penalty: charge.isPenalty,
    #                           is_waived: false,
    #                           loan_id: loanIssued.id
    #                       }
    #                       loanIssuedCharge = Repo.insert!(loanIssuedCharge);
    #                   "PERCENTAGE" ->

    #                       amount = (charge.chargeAmount*loanAmount/100)
    #                       amount_outstanding_derived = amount
    #                       amount_paid_derived = 0.00;
    #                       amount_waived_derived = 0.00;
    #                       amount_writtenoff_derived = 0.00;
    #                       calculation_on_amount = loanAmount;
    #                       calculation_percentage = nil;
    #                       charge_amount_or_percentage = charge.chargeAmount;
    #                       charge_calculation_enum = charge.chargeType;
    #                       charge_id = charge.id;
    #                       charge_payment_mode_enum = nil;
    #                       charge_time_enum = productCharge.chargeWhen

    #                       loanIssuedCharge = %LoanSavingsSystem.Loan.LoanCharge{
    #                           amount: amount,
    #                           amount_outstanding_derived: amount_outstanding_derived,
    #                           amount_paid_derived: amount_paid_derived,
    #                           amount_waived_derived: amount_waived_derived,
    #                           amount_writtenoff_derived: amount_writtenoff_derived,
    #                           calculation_on_amount: calculation_on_amount,
    #                           calculation_percentage: calculation_percentage,
    #                           charge_amount_or_percentage: charge_amount_or_percentage,
    #                           charge_calculation_enum: charge_calculation_enum,
    #                           charge_id: charge_id,
    #                           charge_payment_mode_enum: charge_payment_mode_enum,
    #                           charge_time_enum: charge_time_enum,
    #                           due_for_collection_as_of_date: nil,
    #                           is_active: false,
    #                           is_paid_derived: false,
    #                           is_penalty: charge.isPenalty,
    #                           is_waived: false,
    #                           loan_id: loanIssued.id
    #                       }
    #                       loanIssuedCharge = Repo.insert!(loanIssuedCharge);
    #               end

    #           end
    #       end


    #       loanIssued;

    #   end
  end
