defmodule LoanSavingsSystemWeb.Router do
  use LoanSavingsSystemWeb, :router
  import LoanSavingsSystemWeb.Plugs.Session

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug(LoanSavingsSystemWeb.Plugs.SetUser)
    # plug(LoanSavingsSystemWeb.Plugs.SessionTimeout, timeout_after_seconds: 900)
  end

  pipeline :browser do
    plug(LoanSavingsSystemWeb.Plugs.RequireAdmin)
    plug(LoanSavingsSystemWeb.Plugs.RequireEmployee)
    plug(LoanSavingsSystemWeb.Plugs.RequireEmployer)
    plug(LoanSavingsSystemWeb.Plugs.RequireIndividual)
    plug(LoanSavingsSystemWeb.Plugs.RequireOfftaker)
    plug(LoanSavingsSystemWeb.Plugs.RequireSme)
  end

  pipeline :guest do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end


  pipeline :session do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :loans_admin_app do
    # plug(LoanSavingsSystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :loans_admin_app})
  end

  pipeline :savings_admin_app do
    # plug(LoanSavingsSystemWeb.Plugs.RequireAdminAccess)
    plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :savings_admin_app})
  end

  pipeline :dashboard_layout do
    plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :dashboard_layout})
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  pipeline :employer_app do
    # plug(LoanSavingsSystemWeb.Plugs.RequireEmployerAccess)
    plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :employer_app})
  end

  pipeline :employee_app do
    # plug(LoanSavingsSystemWeb.Plugs.RequireEmployeeAccess)
    plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :employee_app})
  end

  pipeline :individual_app do
    plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :individual_app})
  end

  pipeline :sme_app do
    # plug(LoanSavingsSystemWeb.Plugs.RequireSmeAccess)
     plug(:put_layout, {LoanSavingsSystemWeb.LayoutView, :sme_app})
   end

  scope "/", LoanSavingsSystemWeb do
    pipe_through([:api, :no_layout])
    get("/emulator-ussd", UssdController, :index)
    get("/appusers", UssdController, :index)
    get("/ussd", UssdController, :initiateUssd)
    post("/ussd", UssdController, :initiateUssd)
    get("/mmoney/payment-confirmation", UssdController, :handlePaymentConfirmation)
    get("/api/get-loan-product-by-id", ProductController, :getLoanProductById)
    get("/api/calculate-loan-details", ProductController, :getCalculateLoanDetails)
    get("/api/user/get-user-bio-data-by-id-ajax/:bioDataId", UserController, :getUserBioDataById)
    get("/api/user/get-user-addresses-by-user-id-ajax/:userId", UserController, :getUserAddressesById)
    get("/api/user/get-user-next-of-kin-by-user-id-ajax/:userId", UserController, :getNextOfKinByUserId)
    get("/api/user/get-employer-user-by-mobile-number-and-role-type-ajax/:companyId/:mobileNumber/:roleType", UserController, :getEmployerUserByMobileNumberAndRoleType)

    get("/Loan-emulator-ussd", UssdLoanController, :index)
    get("/appusers", UssdLoanController, :index)
    get("/Loan-ussd", UssdLoanController, :initiateUssd)
  end

  scope "/", LoanSavingsSystemWeb do
    pipe_through([:guest, :no_layout])
    get("/Register", SessionController, :register)
    post("/Register", SessionController, :register_user)
    post("/Register/Indiividual", SessionController, :register_individual)

    get("/Login", SessionController, :new)
    get("/forgot-password", SessionController, :forgot_password)
    post("/forgot-password", SessionController, :post_forgot_password)
    post("/validate-otp", SessionController, :validate_otp)
    get("/new-user-set-password", SessionController, :new_user_set_password)
    post("/new_user_set_password", SessionController, :post_new_user_set_password)
    get("/loan/apply-for-a-loan", LoanController, :loan_product_guest)

    post("/Login", SessionController, :create)
  end


  scope "/", LoanSavingsSystemWeb do
    pipe_through([:session, :no_layout])
    # pipe_through :browser
    # get "/Dashboard", UserController, :dashboard
    get("/", SessionController, :username)
    post("/", SessionController, :get_username)
    get("/forgortFleetHub//password", UserController, :forgot_password)
    post("/confirmation/token", UserController, :token)
    get("/reset/FleetHub/password", UserController, :default_password)
    get "/Users/On/Leave", UserController, :users_on_leave
    post "/Activate/Leave/Account", UserController, :activate_user_on_leave
  end




  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :no_layout])

    get("/logout/current/user", SessionController, :signout)
    get "/Account/Disabled", SessionController, :error_405
    get("/Login", SessionController, :new)
    post("/validate-otp", SessionController, :validate_otp)
    get("/new-user-set-password", SessionController, :new_user_set_password)
    post("/new_user_set_password", SessionController, :post_new_user_set_password)
    get("/loan/apply-for-a-loan", LoanController, :loan_product_guest)
    get("/new-user-role-set-otp", SessionController, :get_login_validate_otp)
    post("/Recover/Password", SessionController, :recover_password)
    get("/Recover/Password/confirm-OTP", SessionController, :get_forgot_password_validate_otp)
    post("/Forgot-Password/validate-otp", SessionController, :forgot_password_validate_otp)
    get("/Forgot-Password/User/set/Password", SessionController, :forgot_password_user_set_password)
    post("/Forgot-Password/new_user_set_password", SessionController, :forgot_password_post_new_user_set_password)
  end





  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :savings_admin_app, :logged_in])

    get("/Savings/dashboard", UserController, :savings_dashboard)
    get("/Savings/User/Logs", UserController, :user_logs)
    get("/Savings/USSD/Logs", UserController, :ussd_logs)
    post "/Savings/Create/User/Role", UserController, :create_roles
    get("/Savings/User/Management", UserController, :user_mgt)

    get("/Savings/all/users", UserController, :list_users)
    get("/Savings/new/user", UserController, :new)
    get "/Savings/Create/User", UserController, :create_user
    post "/Savings/Create/User", UserController, :create_user
    post("/Savings/new/user", UserController, :create)
    get("/Customer/User/Logs", UserController, :user_logs)

    get("/Savings/Products", ProductController, :savings_product)
    post("/Add/Savings/Products", ProductController, :add_savings_product)
    post("/Update/Savings/Products", ProductController, :update_savings_product)
    post("/Approve/Savings/Products", ProductController, :approve_savings_product)

    get("/Products/Divestment", ProductController, :divestment_package)
    post("/Add/Products/Divestment", ProductController, :add_divestment_package)
    post("/Update/Products/Divestment", ProductController, :update_divestment_package)
    post("/Approve/Products/Divestment", ProductController, :approve_divestment_package)

    get("/Savings/Accounts", LoanController, :savings_accounts)
    get("/Fixed/Deposits", LoanController, :fixed_deposits)
    get("/Fixed/Deposits/All", LoanController, :fixed_deps)
    get("/All/Transactions", LoanController, :transactions)
    get("/Customer/All", CustomerController, :all_customer)
    get("/Customer/Details", CustomerController, :customer_details)

    get("/View/Charges", MaintenanceController, :charge)
    post("/Add/Charges", MaintenanceController, :add_charge)

    post("/Generate/Random/Password", UserController, :generate_random_password)

    # --------------------------Brances
    get("/Maintenence/Branch", MaintenanceController, :branch)
    post("/Maintenence/Branch/Add", MaintenanceController, :add_branch)
    post("/Maintenence/Branch/Update", MaintenanceController, :update_branch)
    post("/Maintenence/Branch/Approve", MaintenanceController, :approve_branch)

    # --------------------------Currency
    get("/Maintenence/Currency", MaintenanceController, :currency)
    post("/Maintenence/Currency/Add", MaintenanceController, :add_currency)
    post("/Maintenence/Currency/Update", MaintenanceController, :update_currency)
    post("/Maintenence/Currency/Approve", MaintenanceController, :approve_currency)
    get("/Maintenence/Notifications", MaintenanceController, :notifications)
    post("/Maintenence/Notification/Add", MaintenanceController, :add_notification_config)
    get("/Maintenence/Questions", MaintenanceController, :questions)
    post("/Maintenence/Questions/Add", MaintenanceController, :add_questions)
    post("/Maintenence/Questions/Update", MaintenanceController, :update_questions)
    post("/Question/Disable", MaintenanceController, :question_disable)
    post("/Question/Activate", MaintenanceController, :question_activate)

    # --------------------------Countries
    get("/Maintenence/Country", MaintenanceController, :country)
    post("/Maintenence/Country", MaintenanceController, :handle_bulk_upload)

    get("/Divestment/Reports", ReportController, :divestment_reports)
    get("/old/Generate/Divestment/Reports", ReportController, :generate_divestment_reports)
    get("/Transaction/Reports", ReportController, :transaction_reports)
    get("/Generate/Transaction/Reports", ReportController, :generate_transaction_reports)
    get("/Fixeddeposit/Reports", ReportController, :fixed_deposit_reports)
    get("/Generate/FixedDeposit/Reports", ReportController, :generate_fixed_deposit_reports)
    get("/Customer/Reports", ReportController, :customer_reports)
    get("/Generate/ExpectedMaturity/Reports", ReportController, :generate_customer_reports)

    get("/Savings/Customer/Accounts", CustomerController, :all_savings_customer)

    get("/Savings/Customer/Disable/Ussd", CustomerController, :customer_disable_ussd)
    get("/Savings/Customer/Disable/Login", CustomerController, :customer_disable_login)
    get("/Savings/Customer/Enable/Ussd", CustomerController, :customer_enable_ussd)
    get("/Savings/Customer/Enable/Login", CustomerController, :customer_enable_login)


    get("/Savings/Run-End-Of-Day", EndOfDayRunController, :new)
    post("/Savings/Run-End-Of-Day", EndOfDayRunController, :create)
    get("/Savings/End-Of-Day-History", EndOfDayRunController, :index)
    get("/Savings/End-Of-Day-History-Entries/:endofdayid", EndOfDayRunController, :end_of_day_entries)
    get("/Savings/End-Of-Day-Configurations", EndOfDayRunController, :create_end_of_day_configurations)
    post("/Savings/End-Of-Day-Configurations", EndOfDayRunController, :post_create_end_of_day_configurations)



    get("/View/calendar", EndOfDayRunController, :index_calendar)
    post("/Add/calendar", EndOfDayRunController, :create_calendar)
    get("/view/holidays/:calendarId", EndOfDayRunController, :index_holiday)
    post("/Add/holiday", EndOfDayRunController, :create_holiday)


    get("/Savings/New-Flexcube-Account", FcubeGeneralLedgerController, :new)
    get("/Savings/New-Flexcube-Account/Create", FcubeGeneralLedgerController, :create_gl)
    post("/Savings/New-Flexcube-Account/Create", FcubeGeneralLedgerController, :create_gl)
    get("/Savings/New-Flexcube-Account/:accountId", FcubeGeneralLedgerController, :edit)
    post("/Savings/Update-Flexcube-Account", FcubeGeneralLedgerController, :edit)
    get("/Savings/Update-Flexcube-Account", FcubeGeneralLedgerController, :edit)
    get("/Savings/End-Of-Day-Configurations", FcubeGeneralLedgerController, :get_configurations)
    get("/Savings/View-Flexcube-Accounts", FcubeGeneralLedgerController, :index)
    get("/Savings/View-Flexcube-Requests", FcubeGeneralLedgerController, :index)
    post("/Savings/Update/Flexcube/Account", FcubeGeneralLedgerController, :update_gl_account)
    get("/Savings/Update/Flexcube/Account", FcubeGeneralLedgerController, :update_gl_account)



    post("/reset/password", UserController, :default_password)
    post("/reset/user/password", UserController, :reset_pwd)
    post("/Change/password", UserController, :change_password)
    get("/Change/password", UserController, :new_password)


    get("/Savings/confirm-fixed-deposit/:fixedDepositId", LoanController, :confirmFixedDeposit)

    post("/Generate/Fixed/Deposit/Reports", ReportController, :fixed_deposit_item_lookup)
    post("/Generate/Customer/Divestment/Reports", ReportController, :divestment_item_lookup)
    post("/Generate/Customer/transaction/Reports", ReportController, :all_customer_txn_item_lookup)
    post("/Generate/all/Customer//Reports", ReportController, :all_customer_item_lookup)


  end




  #Add to this route below for both the Maintainance -> LoanCharges and LaonBranches
  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :loans_admin_app, :logged_in])

      get("/Loans/Transaction/Reports", ReportController, :loans_transaction_reports)
      get("/Loans/Customer/Reports", ReportController, :loans_customer_reports)
      get("/Loans/Fixed/Deposits/All", LoanController, :fixed_loans_deps)
      get("/Loans/All/Transactions", LoanController, :loans_transactions)
      # ---------------------------Test
      # get("/User/Management", UserController, :user_mgt)
      get("/Loans/Products", ProductController, :loans_admins_product )
      get("/Loans/Customer/Accounts", CustomerController, :loans_all_loans_customer)
      # ----------------------------------------------------------------
      post("/inform/customer", MaintenanceController, :admin_inform)
      get("/System/User/Permissions/:id", MaintenanceController, :admin_permissions)
      post("/System/User/Permissions", MaintenanceController, :map_admin_permissions)

      get("/Loans/Registered/Individual/Profiles", MaintenanceController, :registered_individual_profiles)
      get("/Approve/Individual/Profiles/:id", MaintenanceController, :approve_individual_registered_user)
      get("/Disable/Individual/Profiles/:id", MaintenanceController, :disable_individual_registered_user)
      get("/Individual/Profiles/Documents/:id", MaintenanceController, :registered_individual_documents)

      get("/Loans/Registered/Company/Profiles", MaintenanceController, :registered_company_profiles)
      get("/Approve/Company/Profiles/:id", MaintenanceController, :admin_approve_registered_company_profiles)
      get("/Disable/Company/Profiles/:id", MaintenanceController, :admin_disables_registered_company_profiles)
      get("/Loans/Registered/Company/Profiles/Users/:id", MaintenanceController, :registered_company_profile_users)
      get("/Loans/Registered/Company/Documents/:id", MaintenanceController, :registered_company_documents)
      get("/Approve/Registered/Company/Users/:id", MaintenanceController, :admin_approve_registered_company_profiles_users)
      get("/Disable/Registered/Company/Users/:id", MaintenanceController, :admin_disable_registered_company_profiles_users)
      get("/View/Registered/Company/Documents", MaintenanceController, :view_registered_company_documents)
      get("/Display/Documents/:path", MaintenanceController, :display_registered_company_documents)


      get("/Document/Files", MaintenanceController, :document_files)
      get("/Loans/Document/Files", MaintenanceController, :loans_document_files)
      get("/Document/File/Activate/:id", MaintenanceController, :activate_file_path)
      get("/Document/File/deactivate/:id", MaintenanceController, :disable_file_path)
      post("/Document/Files", MaintenanceController, :maintain_file_paths)
      get("/Registred/Companies", UserController, :registred_companies)
      get("/Profile/Users/:id", UserController, :profile_users)
      get("/Profile/Users/:id", UserController, :profile_users)
      get("/Profile/Documents/:id", UserController, :profile_documents)

      get("/Document/Types", MaintenanceController, :document_type)
      post("/Document/Type", MaintenanceController, :add_document_type)
      get("/Activate/:id/Document/Type", MaintenanceController, :activate_doc_type)
      get("/Deactivate/:id/Document/Type", MaintenanceController, :deactivate_doc_type)

      get("/Loans/dashboard", UserController, :loans_admin_dashboard)
      post("/Create/User/Roles", UserController, :add_user_roles)
      get("/User/Roles", UserController, :user_roles)
      get("/User/Logs", UserController, :user_logs)
      post "/Create/User/Role", UserController, :create_roles
      post("/Admin/Approve", UserController, :activate_admin)
      get("/Admin/Approve", UserController, :activate_admin)
      post("/Admin/Deactivate", UserController, :deactivate_admin)
      get("/Admin/Deactivate", UserController, :deactivate_admin)
      post("/Admin/Delete", UserController, :delete_admin)
      get("/Admin/Delete", UserController, :delete_admin)


      get("/all/users", UserController, :list_users)
      get("/new/user", UserController, :new)
      get("/User/Username", UserController, :username)
      get "/Create/User", UserController, :create_user
      post "/Create/User", UserController, :create_user
      post("/new/user", UserController, :create)

      # --------------------------Products
      get("/Loan/Products", ProductController, :loan_product)
      post("/Add/Loan/Products", ProductController, :add_loan_product)
      post("/Update/Loan/Products", ProductController, :update_loan_product)
      post("/Approve/Loan/Products", ProductController, :approve_loan_product)
      get("/View/Loans/Product", ProductController, :loans_under_product)
      post("/Create/Walkin/Customer", CustomerController, :create_walkin_customer)
      get("/Update/Customer/Bio", CustomerController, :update_individual)
      post("/Update/Walkin/Customer", CustomerController, :update_walkin_customer)
      post("/Bio/Approve", CustomerController, :approve_individual_bio)
      get("/Bio/Approve", CustomerController, :approve_individual_bio)

      # --------------------------Customers
      post("/Generate/Random/Password/Loan", UserController, :generate_random_password)
      get("/Loan/Customer/Details", CustomerController, :loan_customer_details)
      post("/Customer/Approve", CustomerController, :customer_approve)

      get("/Loans/All/Customer", CustomerController, :all_loan_customer)


      get("/Customer/Employer", CustomerController, :employer)
      post("/Add/Customer/Employer", CustomerController, :add_employer)
      post("/Edit/Employer", CustomerController, :update_employer)
      get("/Add/Employer/Admin", CustomerController, :employer_admin)
      post("/Create/Employer/User", UserController, :create_employer_admin)
      post("/employer/add-employer-role", UserController, :add_employer_admin_role)
      post("/Update/Employer/User", UserController, :update_employer_admin)
      post("/Employer/Approve", CustomerController, :approve_employer)
      post("/Employer/Admin", CustomerController, :create_employer_admin)

      # --------------------------Individual
      get("/Customer/individual", CustomerController, :individual)
      post("/Add/Individual", CustomerController, :add_individual)
      post("/Edit/Individual", CustomerController, :update_individual)
      post("/Approve/Individual", CustomerController, :approve_individual)

      get("/Loans/View/calendar", EndOfDayRunController, :loans_index_calendar)

      # --------------------------SME
      get("/Customer/SME", CustomerController, :sme)
      post("/Add/SME", CustomerController, :add_sme)
      post("/Edit/SME", CustomerController, :update_sme)
      post("/Approve/SME", CustomerController, :approve_sme)
      get("/All/Loan/Transactions", LoanController, :all_loan_transactions)

      get("/Customer/Offtaker", CustomerController, :offtaker)
      post("/Add/Offtaker", CustomerController, :add_offtaker)
      post("/Offtaker/Approve", CustomerController, :approve_offtaker)
      post("/Edit/Offtaker", CustomerController, :update_offtaker)
      get("/Add/Offtaker/Admin", CustomerController, :offtaker_admin)
      post("/Create/Offtaker/User", UserController, :create_offtaker_admin)
      post("/Update/Offtaker/User", UserController, :update_offtaker_admin)

      # --------------------------Loans
      get("/Loans/Accounts", LoanController, :loans_accounts_for_bank_staff)
      get("/Loans/Pending", LoanController, :pending_loans)
      get("/Loans/Counter/Payments", LoanController, :counter_payments)
      get("/Loans/Accounts/:loanId", LoanController, :loan_details_for_bank_staff)


      # --------------------------User Management
      get("/Active/System/Users", UserController, :active_users)
      get("/Inactive/System/Users", UserController, :inactive_users)

      # --------------------------System Configurations
      get("/Settings/MNO", SystemController, :mno)
      post("/Add/MNO/Settings", SystemController, :add_mno_settings)
      get("/Settings/API", SystemController, :api)
      post("/Add/API/Settings", SystemController, :add_api_settings)
      get("/Settings/CBS", SystemController, :bank)
      post("/Add/Bank/Settings", SystemController, :add_bank_settings)
      get("/System/Configurations", SystemController, :system_configurations)

      # --------------------------Reports
      get("/Reports/Loans", ReportController, :loans_report)
      get("/Generate/Reports/Loans", ReportController, :generate_loan_reports)

      # --------------------------Documents
      get("/Maintenence/Document", MaintenanceController, :document)
      post("/Maintenence/Document/Add", MaintenanceController, :add_document)
      post("/Maintenence/Document/Update", MaintenanceController, :update_document)
      post("/Maintenence/Document/Approve", MaintenanceController, :approve_document)

      get("/Loans/Maintenence/Country", MaintenanceController, :loans_country)
      post("/Loans/Maintenence/Country", MaintenanceController, :loans_handle_bulk_upload)


      #------------------------------------------------Maintainance ->>>LoanCharges
      get("/Loans/Maintenence/Charges", MaintenanceController, :loans_charge)
      post("/Loans/Maintenence/Charges/Add", MaintenanceController, :loans_add_charge)
      post("/Loans/Maintenence/Charges/Update", MaintenanceController, :loans_update_charge)
      post("/Loans/Maintenence/Charges/Approve", MaintenanceController, :loans_approve_charge)
      post("/Loans/Maintenence/Charges/Disable", MaintenanceController, :disable_charge)
      get("/Loans/Maintenence/Charges/Disable", MaintenanceController, :disable_charge)
      post("/Loans/Maintenence/Charges/Enable", MaintenanceController, :enable_charge)
      get("/Loans/Maintenence/Charges/Enable", MaintenanceController, :enable_charge)
      #--------------------------------------------------LoanMaintainance -->>>LoanBranches
      get("/Loans/Maintenence/Branch", MaintenanceController, :loans_branch)
      post("/Loans/Maintenence/Branch/Add", MaintenanceController, :loans_add_branch)
      post("/Loans/Maintenence/Branch/Update", MaintenanceController, :loans_update_branch)
      post("/Loans/Maintenence/Branch/Approve", MaintenanceController, :loans_approve_branch)
      post("/Loans/Maintenence/Branch/Disable", MaintenanceController, :disable_branch)
      get("/Loans/Maintenence/Branch/Disable", MaintenanceController, :disable_branch)
      post("/Loans/Maintenence/Branch/Enable", MaintenanceController, :enable_branch)
      get("/Loans/Maintenence/Branch/Enable", MaintenanceController, :enable_branch)
      #----------------------------------------------------------------LoanMaintainance --->>>>>Questions
      get("/Loans/Maintenence/Questions", MaintenanceController, :loans_questions)
      post("/Loans/Maintenence/Questions/Add", MaintenanceController, :loans_add_questions)
      post("/Loans/Maintenence/Questions/Update", MaintenanceController, :loans_update_questions)
      post("/Loans/Maintenence/Question/Disable", MaintenanceController, :loans_question_disable)
      post("/Loans/Maintenence/Question/Activate", MaintenanceController, :loans_question_activate)
      #-----------------------------------------------------------------LoanMaintianance ----->>>>Provinces
      get("/Loans/Maintenence/Province", MaintenanceController, :loans_province)
      post("/Loans/Maintenence/Province/Add", MaintenanceController, :loans_add_province)
      post("/Loans/Maintenence/Province/Update", MaintenanceController, :loans_update_province)
      post("/Loans/Maintenence/Province/Approve", MaintenanceController, :loans_approve_province)
      #------------------------------------------------------------------LoansMaintainance --------->>>>District
      get("/Loans/Maintenence/District", MaintenanceController, :loans_district)
      post("/Loans/Maintenence/District/Add", MaintenanceController, :loans_add_district)
      post("/Loans/Maintenence/District/Update", MaintenanceController, :loans_update_district)
      post("/Loans/Maintenence/District/Approve", MaintenanceController, :loans_approve_district)


      get("/Loans/Announcement", MaintenanceController, :announcement)
      post("/Loans/Announcement", MaintenanceController, :add_announcement)
#      get("/Announcement", MaintenanceController, :announcement)
      get("/Emails", MaintenanceController, :emails)
      get("/Sms", MaintenanceController, :sms)
      post("/Announcement", MaintenanceController, :add_announcement)
      get("/Resend/Sms", MaintenanceController, :resend_sms)
      get("/Resend/Email", MaintenanceController, :resend_email)


      #------------------------------------------------------------------LoansUserManagement ------->>>> System Users
      get("/Loans/User/Management", UserController, :loans_user_mgt)
      post("/Loans/User/Management/Add", UserController, :loans_create_user)
      post("/Loans/User/Management/Update", UserController, :loans_update_user)


      get("/Loans/Document/Types", MaintenanceController, :loans_document_type)
      post("/Loans/Document/Type", MaintenanceController, :loans_add_document_type)
      get("/Loans/Activate/:id/Document/Type", MaintenanceController, :activate_doc_type)
      get("/Loans/Deactivate/:id/Document/Type", MaintenanceController, :deactivate_doc_type)

      get("/Loans/New-Flexcube-Account", FcubeGeneralLedgerController, :loans_new)
      get("/Loans/New-Flexcube-Account/Create", FcubeGeneralLedgerController, :loans_create_gl)
      post("/Loans/New-Flexcube-Account/Create", FcubeGeneralLedgerController, :loans_create_gl)
      get("/Loans/End-Of-Day-Configurations", EndOfDayRunController, :loans_create_end_of_day_configurations)
      get("/Loans/View-Flexcube-Accounts", FcubeGeneralLedgerController, :loans_index)
      get("/Loans/View-Flexcube-Requests", FcubeGeneralLedgerController, :loans_index)
      get("/Loans/Run-End-Of-Day", EndOfDayRunController, :loans_new)
      get("/Loans/End-Of-Day-History", EndOfDayRunController, :loans_index)



      get("/Loans/User/Logs", UserController, :loans_user_logs)
      #---------------------------------------------------------------------------MaintiananceCompany
      get("/Loans/Maintenence/Company", MaintenanceController, :loans_maintain_company)
      post("/Loans/Maintenence/Create/new/Company", MaintenanceController, :loans_add_company)
      post("/Loans/Maintenence/Create/Edit/Company", MaintenanceController, :loans_update_company)
      get("/Loans/Maintenence/Create/Edit/Company", MaintenanceController, :loans_update_company)
      post("/Loans/Maintenence/Admin/deactivate/Company", MaintenanceController, :loans_deactivate_company)
      post("/Loans/Maintenence/Admin/activate/Company", MaintenanceController, :loans_activate_company)


      get("/Loans/Maintenence/Companies/Employer/Customer/Employee", CustomerController, :loans_view_employer_staff)
      post("/Loans/Maintenence/Companies/Employer/Customer/Employee" , CustomerController, :loans_handle_bulk_upload_of_employee)
      post("/Loans/Maintenence/Companies/Employer/Customer/Edit/Employee", CustomerController, :loans_update_employee)
      post("/Loans/Maintenence/Companies/Create/Customer/Employee", CustomerController, :loans_create_employee)
      post("/Loans/Maintenence/Companies/Employee/Disable", CustomerController, :loans_disable_employee)
      post("/Loans/Maintenence/Companies/Employee/Activate", CustomerController, :loans_enable_employee)
      post("/Loans/Employer/Add-Employer-Employee-Role", UserController, :loans_add_employer_employee_role)

         # --------------------------Currency
      get("/Loans/Maintenence/Currency", MaintenanceController, :loans_currency)
      post("/Loans/Maintenence/Currency/Add", MaintenanceController, :loans_add_currency)
      post("/Loans/Maintenence/Currency/Update", MaintenanceController, :loans_update_currency)
      post("/Loans/Maintenence/Currency/Approve", MaintenanceController, :loans_approve_currency)



      # --------------------------Reports
      get("/Loans/Disbursed/Reports", ReportController, :loans_disbursed_reports)
      get("/Loans/Disbursement/Reports", ReportController, :loans_disbursement_reports)
      get("/Loans/Rejected/Reports", ReportController, :loans_rejected_reports)


      get("/Loans/Register/SME", MaintenanceController, :registered_sme)
      get("/Loans/Register/Individual", MaintenanceController, :registered_individual_profiles)
      get("/Loans/Register/Employer", MaintenanceController, :registered_company_profiles)
      get("/Loans/All/Transactions", LoanController, :loans_transactions)


      get("/Loans/View/SMS", MaintenanceController, :sms)
      get("/Loans/View/Email", MaintenanceController, :emails)


      # ---------------------------------------miz----------------------------
      get("/Loans/User/Role/Management", UserController, :user_roles_mgt)
      get("/Loans/User/Role/Management/edit", UserController, :edit_user_roles)
      post("/Loans/User/Role/Management/edit", UserController, :edit_user_roles)
      get("/Create/New/User/Roles", UserController, :create_user_role)
      post("/Create/New/User/Roles", UserController, :create_user_role)
      get("/Loans/User/Role/Management/view", UserController, :view_user_roles)

      get("/Loans/User/logs", UserController, :loans_user_logs)
      get("/Loans/Ussd/logs", UserController, :loans_ussd_logs)

      # ------------------------------------------miz end-------------------------

  end


  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :sme_app, :logged_in])

    get("/Sme/User/Logs", SmeController, :sme_user_logs)
    get("/Sme/Announcements", SmeController, :sme_announcements)

    get("/display/document/:path/doc", Sme360Controller, :display_document)
    get("/display/:path/doc", Sme360Controller, :display_doc)
    get("/Sme/360/view", Sme360Controller, :index)
    post("/Company/documets", SmeController, :add_documents)
    post("/Offtaker/documets", SmeController, :add_off_documents)
    get("/view/:path/documents", SmeController, :view_documents)
    get("/disable/document/:id", SmeController, :disable_document)
    get("/SME/Off/Takers", SmeController, :off_takers)
    get("/company/details", SmeController, :company_details)
    post("/register/offtaker", SmeController, :register_offtaker)
    post("/check/company/reg/number", SmeController, :existance_of_offtaker)
    get("/Offtaker/:id/Documents", SmeController, :offtaker_document)
    post("/update/permissions", SmeController, :update_permissions)
    post("/get/permissions", SmeController, :get_permissions)

    post("/update/permissions", SmeController, :update_permissions)
    post("/get/permissions", SmeController, :get_permissions)

    get("/SME/Dashboard", UserController, :sme_dashboard)
    get("/Login", SessionController, :new)
    post("/validate-otp", SessionController, :validate_otp)
    get("/new-user-role-set-otp", SessionController, :get_login_validate_otp)
    get("/new-user-set-password", SessionController, :new_user_set_password)
    post("/new_user_set_password", SessionController, :post_new_user_set_password)
    get("/sme/loan/apply-for-a-loan", LoanController, :loan_product)
    get("/view/terms/conditions", LoanController, :terms_conditions)
    get("/view/direct_debit", LoanController, :direct_debit)
    get("/loans/individual/create-new-loan", LoanController, :createNewLoan)
    get("/apply/for/loans", SmeController, :apply_for_loan)
    post("/post/apply/for/loans", SmeController, :submit_loan_application)
    get("/loan/tracker", LoanController, :loan_tracker)

    get("/edit/:id/offtaker", SmeController, :edit_offtaker)
    post("/update/sme", SmeController, :update_company)
    get("/Company/Documents", SmeController, :company_documents)
    get("/Activate/Sme/:id/Documents", SmeController, :activate_documents)
    get("/company/document/:path", SmeController, :display_pdf)


    post("/SME/View/Afordable/Amount", SmeController, :get_sme_affordable_amoutn)

    # ================== SME PROFILE USER
    post("/change", UserManagementController, :change_password)
    get("/Disable/:id/user", UserManagementController, :disable_user)
    get("/Activate/:id/user", UserManagementController, :activate_user)
    post("/Update/user", UserManagementController, :update_user)
    get("/Profile/Users", SmeController, :user_management)
    post("/Profile/Users", SmeController, :add_user)
    get("/Disable/:id/user", SmeController, :disable_user)
    get("/Activate/:id/user", SmeController, :activate_user)
    post("/Update/user", SmeController, :update_user)


    #============== SME LOAN APPLYING
    get("/Sme/:id/Loan/Calculations", SmeLoansController, :loan_calculation)
    post("/Sme/loan/view/terms/conditions", SmeLoansController, :terms_conditions)
#------------------------------------------------------------
    get("/Sme/Loan/Products", SmeController, :sme_loan_products)
    get("/Sme/View/Loans/Status", SmeController, :sme_loan_trucking)
    post("/Sme/View/Loans/Status/Filter", SmeController, :get_sme_loan_trucking)
    get("/Sme/Refund/Loan", SmeController, :refund_loan)
    post("/Sme/Refund/Loan/Request", SmeController, :sme_refund_request)
    get("/Sme/apply/for/a/loans", SmeLoansController, :apply)
    get("/Sme/Loan/Repay", SmeController, :repay)
    post("/Sme/Loan/Repayment", SmeController, :sme_repayment)
    get("/api/get/loan/product/by/id", SmeLoansController, :get_loan_product_by_Id)
    get("/api/calculate/loan/details", SmeLoansController, :calculate_loan_details)
    get("/Sme/loan/create-new-loan", SmeLoansController, :create_new_loan)
    get("/Sme/Loans/Accounts/:loanId", SmeLoansController, :loan_details)

    get("/Sme/min/statement/report", SmeController, :min_statement)
    post("/SME/Mini-Statement/Reports", SmeController, :get_min_statement)
    get("/Sme/Historical/Statement/Report", SmeController, :historical_statement)
    post("/SME/Loan-Statement/Reports", SmeController, :get_historical_statement)

    get("/SME/360/View", SmeController, :sme360view)
    post("/SME/Loan/Application", SmeController, :sme_apply_loan)


    post("/change", SmeController, :change_password)

  end

  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :employee_app, :logged_in])

    get("/Employee/dashboard", UserController, :employee_dashboard)
    get("/Employee/loan/apply-for-a-loan", EmployeeController, :apply)
    post("/Employee/Loan/Application", EmployeeController, :employee_apply_loan)
    get("/Employee/loan/Savings", EmployeeController, :apply)
    get("/Employee/Loans/Tracking", EmployeeController, :employee_loan_trucking)
    post("/Employee/View/Loans/Status/Filter", EmployeeController, :get_employee_loan_trucking)
    get("/Employee/Refund/Loan", EmployeeController, :refund_loan)
    post("/Employee/Refund/Loan/Request", EmployeeController, :employee_refund_request)
    get("/Employee/Loan/Repay", EmployeeController, :repay)
    post("/Employee/Loan/Repayment", EmployeeController, :employee_loan_repayment)
    get("/Employee/360/view", EmployeeController, :all_view)
    get("/Generate/Employee/Reports", EmployeeController, :generate_mini_report)
    post("/Employee/Mini-Statement/Reports", EmployeeController, :employee_mini_report)
    get("/Generate/Employee/History/Reports", EmployeeController, :generate_historical_report)
    post("/Employee/Loan-Statement/Reports", EmployeeController, :employee_historical_report)


    post("/Employee/View/Afordable/Amount", EmployeeController, :get_employee_affordable_amoutn)

    # ====================================  APIs ========

    get("/api/get-loan-product-by-id", ProductController, :getLoanProductById)
    get("calculate/loan/details", ProductController, :getCalculateLoanDetails)
    get("/get/user/bio/data/by/id/:bioDataId", UserController, :getUserBioDataById)
    get("/get/user/addresses/by/user/:userId", UserController, :getUserAddressesById)
    get("/get/user/next/of/kin/by/user/id/:userId", UserController, :getNextOfKinByUserId)
    # get("/api/user/get-employer-user-by-mobile-number-and-role-type-ajax/:companyId/:mobileNumber/:roleType", UserController, :getEmployerUserByMobileNumberAndRoleType)
  end




  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :employer_app, :logged_in])

    get("/Employer/dashboard", UserController, :employer_dashboard)
    # get("/Employer/User/Management", UserController, :user_mgt)
    get "/Employer/User/Roles", UserController, :user_roles
    post "/Employer/Create/User/Role", UserController, :create_roles

    get("/Employer/all/users", UserController, :list_users)
    get("/Employer/new/user", UserController, :new)
    get "/Employer/Create/User", UserController, :create_user
    post("/Employer/new/user", UserController, :create)

    get("/Employer/Employee/Loans", EmployerController, :employer_staff_loan)
    get("/Employer/Employee/Repayment", EmployerController, :employer_staff_repayment)
    get("/Employer/Employee/Staff", EmployerController, :employer_staff)
    get("/Employer/Admin", EmployerController, :employer_admin)
    get("/Employer/Employee/Report", EmployerController, :employer_staff_report)

  end

  scope "/", LoanSavingsSystemWeb do
    pipe_through([:browser, :individual_app, :logged_in])

    get("/Login", SessionController, :new)
    post("/validate-otp", SessionController, :validate_otp)
    get("/new-user-role-set-otp", SessionController, :get_login_validate_otp)
    get("/new-user-set-password", SessionController, :new_user_set_password)
    post("/new_user_set_password", SessionController, :post_new_user_set_password)

    get("/Individual/Loan/dashboard", IndividualController, :individual_dashboard)
    get("/Individual/Loan/Products", IndividualController, :individual_loan_product)
    post("/Individual/Loan/Application", IndividualController, :individual_loan_application)
    get("/Individual/Loan/Repayment", IndividualController, :loans_repayments_for_individual)
    post("/Individual/Loan/Repayment/Initiation", IndividualController, :individual_loan_repayment)
    get("/Individual/Loan/Refund", IndividualController, :individual_refund_loans)
    post("/Individual/Loan/Refund/Request", IndividualController, :individual_refund_request)
    get("/Individual/Loan/Tracking", IndividualController, :individual_loans_tracking)
    post("/Individual/View/Loans/Status/Filter", IndividualController, :get_individual_loan_trucking)


    get("/Generate/Individual/Reports", IndividualController, :generate_individual_mini_report)
    post("/Individual/Mini-Statement/Reports", IndividualController, :individual_mini_report)
    get("/Generate/Individual/History/Reports", IndividualController, :generate_individual_historical_report)
    post("/Individual/Loan-Statement/Reports", IndividualController, :individual_loan_statement_report)

    get("/Individual/Customer/360-View", IndividualController, :customer_view)

    post("/Individual/View/Afordable/Amount", IndividualController, :get_individual_affordable_amoutn)
  end

  scope "/", LoanSavingsSystemWeb do
    pipe_through([:api, :no_layout])
    get("/emulator-ussd", UssdController, :index)
    get("/appusers", UssdController, :index)
    get("/ussd", UssdController, :initiateUssd)
    get("/api/get-loan-product-by-id", ProductController, :getLoanProductById)
    get("/api/calculate-loan-details", ProductController, :getCalculateLoanDetails)
    get("/api/user/get-user-bio-data-by-id-ajax/:bioDataId", UserController, :getUserBioDataById)
    get("/api/user/get-user-addresses-by-user-id-ajax/:userId", UserController, :getUserAddressesById)
    get("/api/user/get-user-next-of-kin-by-user-id-ajax/:userId", UserController, :getNextOfKinByUserId)
    get("/api/user/get-employer-user-by-mobile-number-and-role-type-ajax/:companyId/:mobileNumber/:roleType", UserController, :getEmployerUserByMobileNumberAndRoleType)
    get("/api/user/get-bank-staff-by-mobile-number-and-role-type-ajax/:mobileNumber", UserController, :getBankStaffByMobileNumber)
    get("/api/user/get-bank-staff-by-branch-id/:branchId", UserController, :getBankStaffByBranchId)
    get("/api/workflows/get-workflow-members/:workflowId", UserController, :getWorkflowMembersByWorkflowId)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LoanSavingsSystemWeb do
  #   pipe_through :api
  # end
end
