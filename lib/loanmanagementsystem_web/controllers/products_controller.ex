defmodule LoanmanagementsystemWeb.ProductsController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Products.Product
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Products.Product_rates


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
		       [module_callback: &LoanmanagementsystemWeb.ProductsController.authorize_role/1]
		       when action not in [


						:admin_activate_product,
						:admin_add_product,
						:admin_all_products,
						:admin_charge_lookup,
						:admin_deactivate_product,
						:admin_update_product,
						:admin_view_add_product,
						:calculate_page_num,
						:calculate_page_size,
						:chip,
						:entries,
						:generate_product_ref_id,
						:inactive_products,
						:oct_product_charge_lookup,
						:pending_products,
						:product_item_lookup,
						:search_options,
						:total_entries,
						:traverse_errors,
            :admin_edit_product,
            :admin_update_product_details
		            ]

		  use PipeTo.Override

  def admin_all_products(conn, _params) do
    products = Loanmanagementsystem.Products.list_tbl_products()

    render(conn, "add_products.html",
      products: products,
      currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
      classifications: Loanmanagementsystem.Maintenance.list_tbl_classification(),
      accounts: Loanmanagementsystem.Chart_of_accounts.list_tbl_chart_of_accounts(),
      charges: Loanmanagementsystem.Charges.list_tbl_charges()
    )
  end

  def admin_edit_product(conn, params) do

    # IO.inspect(params, label: "CHECK MY PRODUCT")
    products = Loanmanagementsystem.Products.list_tbl_products()
    product_detail = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])

    get_product_by = Loanmanagementsystem.Products.get_product_by_product_id(params["product_id"])
    product_currency = Loanmanagementsystem.Maintenance.Currency.find_by(id: product_detail.currencyId)
    get_product_principal_acc = Loanmanagementsystem.Chart_of_accounts.Chart_of_account.find_by(id: product_detail.principle_account_id)
    get_product_interest_acc = Loanmanagementsystem.Chart_of_accounts.Chart_of_account.find_by(id: product_detail.interest_account_id)
    get_product_charges_acc = Loanmanagementsystem.Chart_of_accounts.Chart_of_account.find_by(id: product_detail.charges_account_id)
    get_product_rates = Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"])

    render(conn, "edit_products.html",
      products: products,
      currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
      classifications: Loanmanagementsystem.Maintenance.list_tbl_classification(),
      accounts: Loanmanagementsystem.Chart_of_accounts.list_tbl_chart_of_accounts(),
      charges: Loanmanagementsystem.Charges.list_tbl_charges(),
      product_detail: product_detail,
      get_product_by: get_product_by,
      product_currency: product_currency,
      get_product_principal_acc: get_product_principal_acc,
      get_product_interest_acc: get_product_interest_acc,
      get_product_charges_acc: get_product_charges_acc,
      get_product_rates: get_product_rates
    )
  end

  def admin_view_add_product(conn, _params) do
    render(conn, "add_new_product.html",
      products: Loanmanagementsystem.Products.list_tbl_products(),
      currencies: Loanmanagementsystem.Maintenance.list_tbl_currency(),
      classifications: Loanmanagementsystem.Maintenance.list_tbl_classification(),
      accounts: Loanmanagementsystem.Chart_of_accounts.list_tbl_chart_of_accounts(),
      charges: Loanmanagementsystem.Charges.list_tbl_charges()
    )
  end

  def inactive_products(conn, _params),
    do:
      render(conn, "inactive_products.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "DISABLED"))
      )

  def pending_products(conn, _params),
    do:
      render(conn, "pending_products.html",
        products:
          Loanmanagementsystem.Products.list_tbl_products()
          |> Enum.reject(&(&1.status != "PENDING"))
      )

  def admin_charge_lookup(conn, %{"charge_id" => charge_id}) do
    charge_details = Loanmanagementsystem.Products.admin_charges_lookup(charge_id)
    json(conn, %{"data" => List.wrap(charge_details)})
  end

  # LoanmanagementsystemWeb.ProductsController.generate_product_ref_id()

  def generate_product_ref_id do
    Loanmanagementsystem.Products.Product.last(1)
    |> case do
      nil ->
        "000"

      _ ->
        case Loanmanagementsystem.Products.Product.last().reference_id == nil do
          true ->
            "000"

          false ->
            a = Loanmanagementsystem.Products.Product.last().reference_id
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

  # LoanmanagementsystemWeb.ProductsController.chip(["1", "2", "3"])
  def chip(list) do
    list
    count = Enum.count(list)

    for [x, y] <- Enum.chunk_every(list, 2), reduce: %{} do
      acc -> Map.put(acc, {x, y}, true)
    end
  end

  def admin_add_product(conn, params) do
    # IO.inspect(params["charge_id"], label: "check my charge_id")
    # params = Map.put(params, "charge_id", params["charge_id_str"])
    IO.inspect(params, label: "check my charge_id")

    # def create_user_role(conn, %{"user_role" => params, "role_str" => role_str}) do
    #   IO.inspect(role_str, label: "Am here ba TEDDY Masumbi\n\n\n\n\n\n\n\n\n\n")
    #   params = Map.put(params, "role_str", role_str)
    case params["charge_id_str"] do
      nil ->
        no_charge = %{id: ["0"]}
        IO.inspect(no_charge, label: "check my no_charge")

        params = Map.put(params, "charge_id", no_charge)
        clientId = conn.assigns.user.id
        currency_in_decimal = 2
        params = Map.put(params, "clientId", clientId)
        currencyVal = params["currencyName"]
        currencyVal = String.split(currencyVal, "|||")
        currencyId = Enum.at(currencyVal, 0)
        currency_name = Enum.at(currencyVal, 1)
        params = Map.put(params, "currencyId", currencyId)
        params = Map.put(params, "currencyName", currency_name)
        params = Map.put(params, "status", "INACTIVE")
        # params = Map.put(params, "productType", "LOANS")
        params = Map.put(params, "currencyDecimals", currency_in_decimal)

        new_param =
          Map.merge(params, %{
            "reference_id" => String.to_integer(generate_product_ref_id())
          })

        Ecto.Multi.new()
        |> Ecto.Multi.insert(:add_product, Product.changeset(%Product{}, new_param))
        |> Ecto.Multi.run(:user_los, fn _repo, %{add_product: add_product} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Added #{add_product.name} Successfully",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_product: add_product}} ->
            product_id_to_log =
              try do
                Loanmanagementsystem.Products.Product.find_by(reference_id: new_param["reference_id"]).id
              rescue
                _ -> ""
              end

            params["repayment_log"]
            |> Enum.with_index()
            |> Enum.each(fn {x, index} ->
              log_product = %{
                product_name: new_param["name"],
                repayment: Enum.at(params["repayment_log"], index),
                tenor: Enum.at(params["tenor_log"], index),
                processing_fee: Enum.at(params["processing_fee_log"], index),
                interest_rates: Enum.at(params["interest_rates_log"], index),
                status: "ACTIVE",
                product_id: product_id_to_log,
                arrangement_fee: params["loan_arrangement_fee"],
                finance_cost: params["finance_cost"],
              }

              Product_rates.changeset(%Product_rates{}, log_product)
              |> Repo.insert()
            end)

            conn
            |> put_flash(:info, "You Have Successfully Added A #{add_product.name} Product")
            |> redirect(to: Routes.products_path(conn, :admin_all_products))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.products_path(conn, :admin_all_products))
        end
      _ ->

        params = Map.put(params, "charge_id", params["charge_id_str"])

        clientId = conn.assigns.user.id
        currency_in_decimal = 2
        params = Map.put(params, "clientId", clientId)
        currencyVal = params["currencyName"]
        currencyVal = String.split(currencyVal, "|||")
        currencyId = Enum.at(currencyVal, 0)
        currency_name = Enum.at(currencyVal, 1)
        params = Map.put(params, "currencyId", currencyId)
        params = Map.put(params, "currencyName", currency_name)
        params = Map.put(params, "status", "INACTIVE")
        # params = Map.put(params, "productType", "LOANS")
        params = Map.put(params, "currencyDecimals", currency_in_decimal)

        new_param =
          Map.merge(params, %{
            "reference_id" => String.to_integer(generate_product_ref_id())
          })

        Ecto.Multi.new()
        |> Ecto.Multi.insert(:add_product, Product.changeset(%Product{}, new_param))
        |> Ecto.Multi.run(:user_los, fn _repo, %{add_product: add_product} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Added #{add_product.name} Successfully",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_product: add_product}} ->
            product_id_to_log =
              try do
                Loanmanagementsystem.Products.Product.find_by(reference_id: new_param["reference_id"]).id
              rescue
                _ -> ""
              end

            params["repayment_log"]
            |> Enum.with_index()
            |> Enum.each(fn {x, index} ->
              log_product = %{
                product_name: new_param["name"],
                repayment: Enum.at(params["repayment_log"], index),
                tenor: Enum.at(params["tenor_log"], index),
                processing_fee: Enum.at(params["processing_fee_log"], index),
                interest_rates: Enum.at(params["interest_rates_log"], index),
                status: "ACTIVE",
                product_id: product_id_to_log
              }

              Product_rates.changeset(%Product_rates{}, log_product)
              |> Repo.insert()
            end)

            conn
            |> put_flash(:info, "You Have Successfully Added A #{add_product.name} Product")
            |> redirect(to: Routes.products_path(conn, :admin_all_products))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.products_path(conn, :admin_all_products))
        end

    end
  end

  def admin_update_product(conn, params) do
    IO.inspect(params, label: "product edit")

    params = Map.put(params, "charge_id", params["charge_id_str"])

    product = Loanmanagementsystem.Products.get_product!(params["product_id"])
    price_rate_id = Loanmanagementsystem.Products.get_product_rates!(params["price_rate_id"])
    clientId = conn.assigns.user.id
    currency_in_decimal = 2
    params = Map.put(params, "clientId", clientId)
    currencyVal = params["currencyName"]
    currencyVal = String.split(currencyVal, "|||")
    currencyId = Enum.at(currencyVal, 0)
    currency_name = Enum.at(currencyVal, 1)
    params = Map.put(params, "currencyId", currencyId)
    params = Map.put(params, "currencyName", currency_name)
    params = Map.put(params, "status", "INACTIVE")
    # params = Map.put(params, "productType", "LOANS")
    params = Map.put(params, "currencyDecimals", currency_in_decimal)

    new_param =
      Map.merge(params, %{
        "reference_id" => String.to_integer(generate_product_ref_id())
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:add_product, Product.changeset(product, new_param))
    |> Ecto.Multi.run(:user_los, fn _repo, %{add_product: add_product} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Update #{add_product.name} Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_product: add_product}} ->

        params["repayment_log"]
        |> Enum.with_index()
        |> Enum.each(fn {_x, index} ->
          log_product = %{
            product_name: new_param["name"],
            repayment: Enum.at(params["repayment_log"], index),
            tenor: Enum.at(params["tenor_log"], index),
            processing_fee: Enum.at(params["processing_fee_log"], index),
            interest_rates: Enum.at(params["interest_rates_log"], index),
            status: "ACTIVE",
            product_id: add_product.id
          }

          Product_rates.changeset(price_rate_id, log_product)
          |> Repo.update()
        end)

        conn
        |> put_flash(:info, "You Have Successfully Updated #{add_product.name} Product")
        |> redirect(to: Routes.products_path(conn, :admin_all_products))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.products_path(conn, :admin_all_products))
    end
  end

  def admin_activate_product(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_product,
      Product.changeset(
        Loanmanagementsystem.Products.get_product!(params["id"]),
        Map.merge(params, %{"status" => "ACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_product: _activate_product} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated Product Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Product Activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_product(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_product,
      Product.changeset(
        Loanmanagementsystem.Products.get_product!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_product: _activate_product} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated Product Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Product Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def product_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Products.product_list(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end

  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)

  def oct_product_charge_lookup(conn, %{"product_charge_id" => product_charge_id}) do
    product_charge_details = Loanmanagementsystem.Charges.otc_get_charge_lookup(product_charge_id)
    json(conn, %{"data" => List.wrap(product_charge_details)})
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")


    def admin_update_product_details(conn, params) do
      IO.inspect(params, label: "product edit")

      # params = Map.put(params, "charge_id", params["charge_id_str"])
      IO.inspect(params["price_rate_id"], label: "CHeck price_rate_id")

      product = Loanmanagementsystem.Products.get_product!(params["product_id"])
      price_rate_id = Loanmanagementsystem.Products.get_product_rates!(params["price_rate_id"])
      clientId = conn.assigns.user.id
      # currency_in_decimal = 2
      # params = Map.put(params, "clientId", clientId)
      # currencyVal = params["currencyName"]
      # currencyVal = String.split(currencyVal, "|||")
      # currencyId = Enum.at(currencyVal, 0)
      # currency_name = Enum.at(currencyVal, 1)
      # params = Map.put(params, "currencyId", currencyId)
      # params = Map.put(params, "currencyName", currency_name)
      # params = Map.put(params, "status", "INACTIVE")
      # # params = Map.put(params, "productType", "LOANS")
      # params = Map.put(params, "currencyDecimals", currency_in_decimal)

      # new_param =
      #   Map.merge(params, %{
      #     "reference_id" => String.to_integer(generate_product_ref_id())
      #   })

      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_product, Product.changeset(product, params))
      |> Ecto.Multi.run(:user_los, fn _repo, %{update_product: update_product} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Update #{update_product.name} Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{update_product: update_product}} ->

          params["repayment_log"]
          |> Enum.with_index()
          |> Enum.each(fn {_x, index} ->
            log_product = %{
              product_name: params["name"],
              repayment: Enum.at(params["repayment_log"], index),
              tenor: Enum.at(params["tenor_log"], index),
              processing_fee: Enum.at(params["processing_fee_log"], index),
              interest_rates: Enum.at(params["interest_rates_log"], index),
              status: "ACTIVE",
              product_id: update_product.id,
              arrangement_fee: params["loan_arrangement_fee"],
              finance_cost: params["finance_cost"],
            }

            Product_rates.changeset(price_rate_id, log_product)
            |> Repo.update()
          end)

          conn
          |> put_flash(:info, "You Have Successfully Updated #{update_product.name} Product")
          |> redirect(to: Routes.products_path(conn, :admin_all_products))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.products_path(conn, :admin_all_products))
      end
    end



  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:product, :create}
      act when act in ~w(index view)a -> {:product, :view}
      act when act in ~w(update edit)a -> {:product, :edit}
      act when act in ~w(change_status)a -> {:product, :change_status}
      _ -> {:product, :unknown}
    end
  end

end
