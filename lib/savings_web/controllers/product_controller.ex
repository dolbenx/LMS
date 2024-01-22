defmodule SavingsWeb.ProductController do
  use SavingsWeb, :controller

  alias Savings.Repo
  alias Savings.Products
  alias Savings.Logs.UserLogs
  alias Savings.Divestments
  alias Savings.Divestments.DivestmentPackage
  alias Savings.Products.Product
  alias Savings.SystemSetting
  alias Savings.Charges
  alias Savings.Charges.Charge
  alias Savings.Products.ProductCharge
  alias Savings.Accounts.UserRole
  alias Savings.Accounts.User
  alias Savings.Client.UserBioData
  require Record
  require Logger
  import Ecto.Query, warn: false

  def savings_product(conn, _params) do
    currencies = SystemSetting.list_tbl_currency()
    divestpackages = Divestments.list_tbl_divestment_package()
    charges = Charges.list_tbl_charge()
    savings_products = Products.get_all_savings_products()
    savings_product_charges = Products.list_charges()
    savings_product_charges = Jason.encode!(savings_product_charges)
    list_divestment_packages = Products.list_divestment_packages()
    list_divestment_packages = Jason.encode!(list_divestment_packages)

    list_product_period = Products.list_product_periods()
    list_product_periods = Jason.encode!(list_product_period)

    render(conn, "savings_product.html",
      list_divestment_packages: list_divestment_packages,
      savings_products: savings_products,
      savings_product_charges: savings_product_charges,
      currencies: currencies,
      charges: charges,
      divestpackages: divestpackages,
      products: Savings.Products.list_tbl_products(),
      currencies: Savings.SystemSetting.list_tbl_currency(),
      # classifications: Savings.Maintenance.list_tbl_classification(),
      # accounts: Savings.Chart_of_accounts.list_tbl_chart_of_accounts(),
      charges: Savings.Charges.list_tbl_charge(),
      list_product_periods: list_product_periods
    )
  end

  def add_savings_product(conn, params) do
    IO.inspect("++++++++++++++++++++++++++++++++++++++++++")
    IO.inspect(params)
    clientId = get_session(conn, :client_id)
    params = Map.put(params, "clientId", clientId)
    selected_currency = Savings.SystemSetting.get_currency!(params["currencyId"])

    # currencyVal = params["currencyName"]
    # currencyVal = String.split(currencyVal, "|||")
    # currencyId = Enum.at(currencyVal, 0)
    # currencyName = Enum.at(currencyVal, 1)
    params = Map.put(params, "currencyId", selected_currency.id)
    params = Map.put(params, "currencyName", selected_currency.name)
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "productType", "SAVINGS")
    IO.inspect("++++++++++++++++++++++++++++++++++++++++++")
    IO.inspect(params)

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
        Logger.info(savings_products.id)
        Logger.info(Enum.count(params["period_periodDays"]))
        clientId = get_session(conn, :client_id)
        Logger.info("<<<<<<<<<<<<<<<<<<<<<<<<")
        Logger.info(clientId)

        prod_id = savings_products.id

        for x <- 0..(Enum.count(params["period_periodDays"]) - 1) do
          Logger.info(">>>>>>>>>>>>")
          # z = Enum.at(params["periodDays"], x)
          # query = from cl in Charge, where: cl.id == ^z, select: cl
          # chg = Repo.one(query)

          product_charge = %{
            productID: prod_id,
            periodDays: Enum.at(params["period_periodDays"], x),
            periodType: Enum.at(params["period_periodType"], x),
            status: "ACTIVE",
            interest: Enum.at(params["periodinterest"], x),
            interestType: Enum.at(params["periodinterestType"], x),
            defaultPeriod: Enum.at(params["perioddefaultPeriod"], x),
            yearLengthInDays: Enum.at(params["periodyearLengthInDays"], x)
          }

          Savings.Products.ProductsPeriod.changeset(
            %Savings.Products.ProductsPeriod{},
            product_charge
          )
          |> Repo.insert()
        end

        Logger.info(savings_products.id)
        Logger.info(Enum.count(params["startPeriodDays"]))
        clientId = get_session(conn, :client_id)
        Logger.info("<<<<<<<<<<<<<<<<<<<<<<<<")
        Logger.info(clientId)

        prod_id = savings_products.id

        for x <- 0..(Enum.count(params["startPeriodDays"]) - 1) do
          Logger.info(">>>>>>>>>>>>")

          divestment = %{
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

    # |> Ecto.Multi.run(:divestment, fn _repo, %{savings_products: savings_products} ->

    # end)

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

  # SavingsWeb.ProductController.generate_product_ref_id()

  def generate_product_ref_id do
    Savings.Products.Product.last(1)
    |> case do
      nil ->
        "000"

      _ ->
        case Savings.Products.Product.last().reference_id == nil do
          true ->
            "000"

          false ->
            a = Savings.Products.Product.last().reference_id
            b = a + 1
            c = Integer.to_charlist(b) |> length

            if c == 1 do
              "00#{b}"
            else
              if c == 2 do
                "0#{b}"
              else
                "#{b}"
              end
            end
        end
    end
  end

  def update_savings_product(conn, params) do
    savings_products = Products.get_product!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:savings_products, Product.changeset(savings_products, params))
    |> Ecto.Multi.run(:user_log, fn _, %{savings_products: savings_products} ->
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

  def activate_savings_product(conn, params) do
    savings_products = Savings.Products.get_product!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :savings_products,
      Product.changeset(savings_products, %{status: "ACTIVE"})
    )
    |> Ecto.Multi.run(:user_log, fn _, %{savings_products: savings_products} ->
      activity = "Activated Savings Product with code \"#{savings_products.id}\""

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
        conn |> json(%{message: "Savings Product Activated Successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def disable_savings_product(conn, params) do
    savings_products = Savings.Products.get_product!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :savings_products,
      Product.changeset(savings_products, %{status: "DISABLED"})
    )
    |> Ecto.Multi.run(:user_log, fn _, %{savings_products: savings_products} ->
      activity = "Disabled Savings Product with code \"#{savings_products.id}\""

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
        conn |> json(%{message: "Savings Product Disabled Successfully", status: 0})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
    end
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end
end
