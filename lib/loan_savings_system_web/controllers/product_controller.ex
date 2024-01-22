defmodule LoanSavingsSystemWeb.ProductController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Products
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.Divestments
  alias LoanSavingsSystem.Divestments.DivestmentPackage
  alias LoanSavingsSystem.Products.Product
  alias LoanSavingsSystem.SystemSetting
  alias LoanSavingsSystem.Charges
  alias LoanSavingsSystem.Charges.Charge
  alias LoanSavingsSystem.Products.ProductCharge
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Client.UserBioData
  require Record
  require Logger
  import Ecto.Query, warn: false

  require Logger

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def loan_product(conn, _params) do
    currencies = SystemSetting.list_tbl_currency()
    loan_products = Products.list_loan_products()
    charges = Charges.list_tbl_charge()
    render(conn, "loan_product.html", loan_products: loan_products, currencies: currencies, charges: charges)
  end

  def add_loan_product(conn, params) do
    IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect params
    clientId = get_session(conn, :client_id)
    params = Map.put(params, "clientId", clientId)
    currencyVal = params["currencyName"];
    currencyVal = String.split(currencyVal, "|||")
    currencyId = Enum.at(currencyVal, 0)
    currencyName = Enum.at(currencyVal, 1)
    params = Map.put(params, "currencyId", currencyId)
    params = Map.put(params, "currencyName", currencyName)
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "productType", "LOANS")
    IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect params
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:loans_products, Product.changeset(%Product{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{loans_products: loans_products} ->
      activity = "Created new Loan Product with code \"#{loans_products.code}\""

        user_log = %{
              user_id: conn.assigns.user.id,
              activity: activity
        }
        UserLogs.changeset(%UserLogs{}, user_log)
        |> Repo.insert()
      end)

      |> Repo.transaction()
      |> case do
        {:ok, %{loans_products: loans_products, user_log: _user_log}} ->

          Logger.info loans_products.id
          Logger.info Enum.count(params["productCharge"])
          clientId = get_session(conn, :client_id)
          Logger.info "<<<<<<<<<<<<<<<<<<<<<<<<"
          Logger.info (clientId);

          prod_id = loans_products.id
          for x <- 0..(Enum.count(params["productCharge"])-1) do
            Logger.info ">>>>>>>>>>>>"
            product_charge =
            %{
                productId: prod_id,
                chargeId: Enum.at(params["productCharge"], x),
                valuation:  nil
            }
            ProductCharge.changeset(%ProductCharge{}, product_charge)
            |> Repo.insert()
          end

          conn
          |> put_flash(:info, "Loan Product Created successfully.")
          |> redirect(to: Routes.product_path(conn, :loan_product))
        {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.product_path(conn, :loan_product))
          end
      #|> Ecto.Multi.run(:divestment, fn _repo, %{loans_products: loans_products} ->

      #end)




    #   {:error, _failed_operation, failed_value, _changes_so_far} ->
    #     reason = traverse_errors(failed_value.errors) |> List.first()

    #     conn
    #     |> put_flash(:error, reason)
    #     |> redirect(to: Routes.product_path(conn, :savings_product))
    # end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))



  end

  def update_loan_product(conn, params) do
    loans_products = Products.get_product!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:loans_products, Product.changeset(loans_products, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{loans_products: loans_products}) ->
        activity = "Updated Loan Product with code \"#{loans_products.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{loans_products: _loans_products, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Loan Product updated successfully")
        |> redirect(to: Routes.product_path(conn, :loan_product))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.product_path(conn, :loan_product))
    end
  end

  def approve_loan_product(conn, params) do
    loans_products = Products.get_product!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:loans_products, Product.changeset(loans_products, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{loans_products: _loans_products}) ->
        activity = "Loans Product approved with code \"#{loans_products.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{loans_products: _loans_products, user_log: _user_log}} ->
        conn |> json(%{message: "Loans Product approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end




















  def savings_product(conn, _params) do
    currencies = SystemSetting.list_tbl_currency()
    divestpackages = Divestments.list_tbl_divestment_package()
    charges = Charges.list_tbl_charge()
    savings_products = Products.list_savings_products()
    savings_product_charges = Products.list_charges()
    savings_product_charges = Jason.encode!(savings_product_charges)
    list_divestment_packages = Products.list_divestment_packages();
    list_divestment_packages = Jason.encode!(list_divestment_packages)
    IO.inspect savings_product_charges
    render(conn, "savings_product.html", list_divestment_packages: list_divestment_packages, savings_products: savings_products, savings_product_charges: savings_product_charges, currencies: currencies, charges: charges, divestpackages: divestpackages)
  end

  def loans_admins_product(conn, _params) do

    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Product List",
							conversationid: "#{Timex.now}"
						},
						body: %{
								shortname: "GRIZZLY"
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
      xml = Jason.encode!(xml)
          header = [
              {"Content-Type", "application/json"},
              {"Authorization", "Basic #{hashkey}"},
              {"Accept", "*/*"}
          ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/prodlist"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["prodlist"]
							IO.inspect list

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end

        IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<MIZ<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        IO.inspect loans
        loans =
          case loans do
              :timeout -> []
              nil -> []
               _ -> loans
          end

          IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
          IO.inspect loans

        IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        IO.inspect loans
    render(conn, "loans_product.html", loans: loans)
  end

  def add_savings_product(conn, params) do
    IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect params
    clientId = get_session(conn, :client_id)
    params = Map.put(params, "clientId", clientId)
    currencyVal = params["currencyName"];
    currencyVal = String.split(currencyVal, "|||")
    currencyId = Enum.at(currencyVal, 0)
    currencyName = Enum.at(currencyVal, 1)
    params = Map.put(params, "currencyId", currencyId)
    params = Map.put(params, "currencyName", currencyName)
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "productType", "SAVINGS")
    IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect params
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:savings_products, Product.changeset(%Product{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{savings_products: savings_products} ->
      activity = "Created new Savings Product with code \"#{savings_products.code}\""

        user_log = %{
              user_id: conn.assigns.user.id,
              activity: activity
        }
        UserLogs.changeset(%UserLogs{}, user_log)
        |> Repo.insert()
      end)

      |> Repo.transaction()
      |> case do
        {:ok, %{savings_products: savings_products, user_log: _user_log}} ->

          Logger.info savings_products.id
          Logger.info Enum.count(params["productCharge"])
          clientId = get_session(conn, :client_id)
          Logger.info "<<<<<<<<<<<<<<<<<<<<<<<<"
          Logger.info (clientId);

          prod_id = savings_products.id
          for x <- 0..(Enum.count(params["productCharge"])-1) do
            Logger.info ">>>>>>>>>>>>"
            z = Enum.at(params["productCharge"], x)
            query = from cl in Charge, where: (cl.id== ^z), select: cl
              chg = Repo.one(query);
            product_charge =
            %{
                productId: prod_id,
                chargeId: Enum.at(params["productCharge"], x),
                chargeWhen: chg.chargeWhen,
                # valuation:  nil
            }
            ProductCharge.changeset(%ProductCharge{}, product_charge)
            |> Repo.insert()
          end

          Logger.info savings_products.id
          Logger.info Enum.count(params["startPeriodDays"])
          clientId = get_session(conn, :client_id)
          Logger.info "<<<<<<<<<<<<<<<<<<<<<<<<"
          Logger.info (clientId);

          prod_id = savings_products.id
          for x <- 0..(Enum.count(params["startPeriodDays"])-1) do
            Logger.info ">>>>>>>>>>>>"
            divestment =
            %{
                startPeriodDays: Enum.at(params["startPeriodDays"], x),
                endPeriodDays: Enum.at(params["endPeriodDays"], x),
                divestmentValuation: Enum.at(params["divestmentValuation"], x),
                productId: prod_id,
                status: params["status"],
                clientId: clientId
            }
            DivestmentPackage.changeset(%DivestmentPackage{}, divestment)
            |> Repo.insert()
          end

          conn
          |> put_flash(:info, "Savings Product Created successfully.")
          |> redirect(to: Routes.product_path(conn, :savings_product))
        {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.product_path(conn, :savings_product))
          end
      #|> Ecto.Multi.run(:divestment, fn _repo, %{savings_products: savings_products} ->

      #end)




    #   {:error, _failed_operation, failed_value, _changes_so_far} ->
    #     reason = traverse_errors(failed_value.errors) |> List.first()

    #     conn
    #     |> put_flash(:error, reason)
    #     |> redirect(to: Routes.product_path(conn, :savings_product))
    # end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))



  end

  def update_savings_product(conn, params) do
    savings_products = Products.get_product!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:savings_products, Product.changeset(savings_products, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{savings_products: savings_products}) ->
        activity = "Updated Savings Product with code \"#{savings_products.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{savings_products: _savings_products, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Savings Product updated successfully")
        |> redirect(to: Routes.product_path(conn, :savings_product))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.product_path(conn, :savings_product))
    end
  end

  def approve_savings_product(conn, params) do
    savings_products = Products.get_product!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:savings_products, Product.changeset(savings_products, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{savings_products: _savings_products}) ->
        activity = "Savings Product approved with code \"#{savings_products.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{savings_products: _savings_products, user_log: _user_log}} ->
        conn |> json(%{message: "Savings Product approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end



































  def divestment_package(conn, _params) do
    divestments = Divestments.list_tbl_divestment_package()
    render(conn, "divestment_package.html", divestments: divestments)
  end

  def add_divestment_package(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:divestments, DivestmentPackage.changeset(%DivestmentPackage{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{divestments: divestments} ->
      activity = "Created new Divestment with code \"#{divestments.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{divestments: _divestments, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Divestment Package Created successfully.")
        |> redirect(to: Routes.product_path(conn, :divestment_package))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.product_path(conn, :divestment_package))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_divestment_package(conn, params) do
    divestments = Divestments.get_divestment_package!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:divestments, DivestmentPackage.changeset(divestments, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{divestments: divestments}) ->
        activity = "Updated Divestment Package with code \"#{divestments.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{divestments: _divestments, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Divestment Package updated successfully")
        |> redirect(to: Routes.product_path(conn, :divestment_package))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.product_path(conn, :divestment_package))
    end
  end

  def approve_divestment_package(conn, params) do
    divestments = Divestments.get_divestment_package!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:divestments, DivestmentPackage.changeset(divestments, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{divestments: _divestments}) ->
        activity = "Divestment Package approved with code \"#{divestments.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{divestments: _divestments, user_log: _user_log}} ->
        conn |> json(%{message: "Divestment Package approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end



  def loans_under_product(conn, %{"code" => code}) do
     #loan_product = Products.prod_data(code)
     #loan_transaction = Loan.get_loan_tran(code)
     query = from cl in LoanSavingsSystem.Products.Product, where: (cl.code== ^code), select: cl
         products = Repo.all(query);
         loan_product = Enum.at(products, 0)

     query = from cl in LoanSavingsSystem.Loan.Loans,
         join: user in User,
         join: userBioData in UserBioData,
         join: userRole in UserRole,
            on:
            cl.loan_userid == user.id and
            cl.loan_userroleid == userRole.id and
            user.id == userBioData.userId,
         where: (cl.product_id== ^loan_product.id),
         select: %{cl: cl, user: user, userRole: userRole, userBioData: userBioData}
     loan_transaction = Repo.all(query);
     render(conn, "loan_under_product.html", loan_transaction: loan_transaction, loan_product: loan_product)
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end




  #Teddy+Russel
  def getLoanProductById(conn, dd) do
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        Logger.info  "-----------"
        Logger.info  "Get Product By Id"
        Logger.info  body

        query_params = conn.query_params;
        productId = query_params["productId"];


        query = from cl in LoanSavingsSystem.Products.Product, where: (cl.id== ^productId), select: cl
            products = Repo.all(query);
            product = Enum.at(products, 0)

        response = %{
            product: %{
                id: product.id,
                interestRate: product.interest,
                interestType: product.interestType,
                interestMode: product.interestMode,
                minimumPrincipal: product.minimumPrincipal,
                maximumPrincipal: product.maximumPrincipal,
                minimumPeriod: product.minimumPeriod,
                maximumPeriod: product.maximumPeriod,
                periodType: product.periodType,
                name: product.name,
                currency: product.currencyName
            },
            status: 0

        }
        send_response(conn, response);
    end


    def getCalculateLoanDetails(conn, dd) do
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        Logger.info  "-----------"
        Logger.info  "Get Product By Id"
        Logger.info  body

        query_params = conn.query_params;
        productId = query_params["productId"];
        amount = conn.query_params["amount"];
        amount = elem Float.parse(amount), 0
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



        #repaymentAmount = calculate_maturity_repayments(amount, period, rate, annual_period, interestMode, interestType, periodType)


        repaymentAmount = calculate_monthly_amortization(amount, period, rate, annual_period, interestMode, interestType, periodType)

        response = %{
            repayments: %{
                repaymentSchedule: repaymentAmount
            },
            status: 0,
            currency: product.currencyName

        }

        send_response(conn, response);
    end


    def monthlyPayment(loanAmount, monthlyInterestRate, periodInMonths) do
        #x = loanAmount * monthlyInterestRate / ( 1 - 1 / :math.pow(1 + monthlyInterestRate, periodInMonths) );
        #x
        a = monthlyInterestRate*loanAmount * (:math.pow((1 + monthlyInterestRate), periodInMonths));
        b = ((:math.pow((1 + monthlyInterestRate), periodInMonths)) - 1)
        x = a/b
        x
    end

    def calculate_monthly_amortization(principal, period, rate, annual_period, interestMode, interestType, periodType) do
        rate = rate/100

        Logger.info "rate...#{rate}";

        case periodType do
            "Months" ->
                rate = case interestType do
                    "Days" ->
                        rate = rate * annual_period
                        rate = rate/12
                        rate = rate
                        rate
                    "Months" ->
                        rate = rate
                        rate = rate
                        rate
                    "Years" ->
                        rate = rate/12
                        rate
                end
                Logger.info "monthly period type for period of #{period} months at #{rate}% per #{interestType}";
                monthlyPayment = monthlyPayment(principal, rate, period);
                #monthlyPayment = Float.ceil(monthlyPayment, 2)
                Logger.info "monthlyPayment...#{monthlyPayment}";

                Logger.info "==============================";

                #res = Enum.reduce(1..period, principal, fn(x, accum) ->
                #    Logger.info "Payment number...#{x}";
                #    interestPaid  = accum * rate;
                #    #interestPaid = Float.ceil(interestPaid, 2)
                #    Logger.info "interestPaid...#{interestPaid}";
                #    principalPaid = monthlyPayment - interestPaid;
                #    #principalPaid = Float.ceil(principalPaid, 2)
                #    Logger.info "principalPaid...#{principalPaid}";
                #    newBalance    = accum      - principalPaid;
                #    #newBalance = Float.ceil(newBalance, 2)
                #    Logger.info "newBalance...#{newBalance}";
                #    Logger.info "==============================";
                #    accum = newBalance;

                #end)



                holder = [%{"principal"=>principal}]
                res = Enum.reduce(1..period, holder, fn(x, accum1) ->
                    #Logger.info "Payment number...#{x}";
                    size = Enum.count(accum1);
                    #Logger.info "accum1 size...#{size}";
                    #Logger.info Jason.encode!(accum1);
                    y = x - 1;
                    #Logger.info "y...#{y}";
                    accum = Enum.at(accum1, y)
                    #Logger.info Jason.encode!(accum);
                    accum = accum["principal"]
                    #Logger.info "principal...#{accum}";
                    interestPaid  = accum * rate;
                    #interestPaid = Float.ceil(interestPaid, 2)
                    #Logger.info "interestPaid...#{interestPaid}";
                    principalPaid = monthlyPayment - interestPaid;
                    #principalPaid = Float.ceil(principalPaid, 2)
                    #Logger.info "principalPaid...#{principalPaid}";
                    newBalance    = accum      - principalPaid;
                    #newBalance = Float.ceil(newBalance, 2)
                    #Logger.info "newBalance...#{newBalance}";
                    #Logger.info "==============================";
                    accum = newBalance;
                    accum1 = accum1 ++ [%{"principal"=>newBalance, "principalPaid"=>principalPaid, "interestPaid"=>interestPaid,
                        "principalInfo"=>Float.ceil(newBalance, 2), "principalPaidInfo"=>Float.ceil(principalPaid, 2),
                        "interestPaidInfo"=>Float.ceil(interestPaid, 2), "totalPaidInfo"=>Float.ceil((interestPaid + principalPaid), 2)}]
                    accum1

                end)
                #Logger.info "map...";
                #Logger.info res;
                res


            "Days" ->
                Logger.info "daily period type";
                principal
            "Years" ->
                Logger.info "yearly period type";
                principal
        end
    end






    def calculate_maturity_repayments(amount, period, rate, annual_period, interestMode, interestType, periodType) do
        Logger.info "################"
        Logger.info amount
        #Logger.info period
        #Logger.info "Rate ...#{rate}"
        #Logger.info annual_period
        Logger.info interestType
        Logger.info interestMode
        Logger.info periodType
        Logger.info annual_period

        rate = case interestType do
            "Days" ->
                rate = rate * annual_period
                rate = rate/100
                rate = rate/annual_period
                rate
            "Months" ->
                rate = rate*12
                rate = rate/100
                rate = rate/annual_period
                rate
            "Years" ->
                rate = rate/100
                Logger.info rate
                rate = rate/annual_period
                Logger.info rate
                rate
        end

        Logger.info "+++++++++++++++++"
        Logger.info rate

        totalRepayable = 0.00;
        y = 1;

        case interestMode do
            "FLAT" ->
                incurredInterest = amount * rate * period
                Logger.info "#{amount} * #{rate} * #{period} * "
                Logger.info incurredInterest
                totalPayableAtEnd = incurredInterest + amount;
                totalPayableAtEnd
            "COMPOUND INTEREST" ->
                rate__ = (1+rate);
                number_of_repayments = 1
                raisedVal = :math.pow(rate__, (number_of_repayments))
                Logger.info raisedVal
                a = rate*raisedVal
                b = raisedVal - 1
                c = a/b
                totalPayableInMonthX = amount * ((rate*(raisedVal))/(raisedVal - 1));
                Logger.info totalPayableInMonthX
                #realMonthlyRepayment = amount * (rate) * (1)
                totalPayableInMonthX
        end
    end

    def calculate_interest_for_days(amount, period, rate, annual_period, number_of_repayments) do
        #Logger.info "################"
        #Logger.info amount
        #Logger.info period
        #Logger.info rate
        #Logger.info annual_period
        #Logger.info number_of_repayments
        rate = rate/100
        nperiod = period/annual_period
        #Logger.info "+++++++++++++++++"
        #Logger.info rate
        #Logger.info nperiod
        #interest = (amount * (period/30) * mrate)
        #interest = ((rate/100)/12) * amount
        totalRepay = amount * (1 + (rate*nperiod))
        interest = totalRepay - amount
    end





    def calculate_monthly_repayments(amount, period, rate, annual_period, number_of_repayments) do
        Logger.info "################"
        Logger.info amount
        #Logger.info period
        #Logger.info "Rate ...#{rate}"
        #Logger.info annual_period
        Logger.info number_of_repayments
        rate = rate/100
        rate_ = (rate/12)
        nperiod = period/12
        Logger.info "+++++++++++++++++"
        Logger.info rate_
        #Logger.info nperiod
        #totalRepay = amount * (1 + (rate*nperiod))
        #interest = totalRepay - amount

        totalRepayable = 0.00;
        y = 1;


        rate__ = (1+rate_);
        raisedVal = :math.pow(rate__, (number_of_repayments))
        Logger.info raisedVal
        a = rate_*raisedVal
        b = raisedVal - 1
        c = a/b
        totalPayableInMonthX = amount * ((rate_*(raisedVal))/(raisedVal - 1));
        Logger.info totalPayableInMonthX
        #realMonthlyRepayment = amount * (rate_) * (1)
        totalPayableInMonthX
    end


    def send_response(conn, response) do
        Logger.info  "Test!"
        Logger.info  Jason.encode!(response)
        send_resp(conn, :ok, Jason.encode!(response))
    end
end
