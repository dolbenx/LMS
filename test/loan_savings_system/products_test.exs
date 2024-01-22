defmodule LoanSavingsSystem.ProductsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Products

<<<<<<< HEAD
=======
  describe "tbl_products" do
    alias LoanSavingsSystem.Products.Product

    @valid_attrs %{annual_interest: "some annual_interest", client_id: "some client_id", code: "some code", currency: "some currency", currency_decimals: "some currency_decimals", days_to_dormancy: "some days_to_dormancy", days_to_inactive: "some days_to_inactive", deposit_fee_amount: "some deposit_fee_amount", details: "some details", fixed_period_days: "some fixed_period_days", min_balance_required: "some min_balance_required", name: "some name", withdrawal_fee_amount: "some withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some withdrawal_fee_transfer_to_mobile", year_length_days: "some year_length_days"}
    @update_attrs %{annual_interest: "some updated annual_interest", client_id: "some updated client_id", code: "some updated code", currency: "some updated currency", currency_decimals: "some updated currency_decimals", days_to_dormancy: "some updated days_to_dormancy", days_to_inactive: "some updated days_to_inactive", deposit_fee_amount: "some updated deposit_fee_amount", details: "some updated details", fixed_period_days: "some updated fixed_period_days", min_balance_required: "some updated min_balance_required", name: "some updated name", withdrawal_fee_amount: "some updated withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some updated withdrawal_fee_transfer_to_mobile", year_length_days: "some updated year_length_days"}
    @invalid_attrs %{annual_interest: nil, client_id: nil, code: nil, currency: nil, currency_decimals: nil, days_to_dormancy: nil, days_to_inactive: nil, deposit_fee_amount: nil, details: nil, fixed_period_days: nil, min_balance_required: nil, name: nil, withdrawal_fee_amount: nil, withdrawal_fee_transfer_to_mobile: nil, year_length_days: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_tbl_products/0 returns all tbl_products" do
      product = product_fixture()
      assert Products.list_tbl_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.annual_interest == "some annual_interest"
      assert product.client_id == "some client_id"
      assert product.code == "some code"
      assert product.currency == "some currency"
      assert product.currency_decimals == "some currency_decimals"
      assert product.days_to_dormancy == "some days_to_dormancy"
      assert product.days_to_inactive == "some days_to_inactive"
      assert product.deposit_fee_amount == "some deposit_fee_amount"
      assert product.details == "some details"
      assert product.fixed_period_days == "some fixed_period_days"
      assert product.min_balance_required == "some min_balance_required"
      assert product.name == "some name"
      assert product.withdrawal_fee_amount == "some withdrawal_fee_amount"
      assert product.withdrawal_fee_transfer_to_mobile == "some withdrawal_fee_transfer_to_mobile"
      assert product.year_length_days == "some year_length_days"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.annual_interest == "some updated annual_interest"
      assert product.client_id == "some updated client_id"
      assert product.code == "some updated code"
      assert product.currency == "some updated currency"
      assert product.currency_decimals == "some updated currency_decimals"
      assert product.days_to_dormancy == "some updated days_to_dormancy"
      assert product.days_to_inactive == "some updated days_to_inactive"
      assert product.deposit_fee_amount == "some updated deposit_fee_amount"
      assert product.details == "some updated details"
      assert product.fixed_period_days == "some updated fixed_period_days"
      assert product.min_balance_required == "some updated min_balance_required"
      assert product.name == "some updated name"
      assert product.withdrawal_fee_amount == "some updated withdrawal_fee_amount"
      assert product.withdrawal_fee_transfer_to_mobile == "some updated withdrawal_fee_transfer_to_mobile"
      assert product.year_length_days == "some updated year_length_days"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "tbl_loan_products" do
    alias LoanSavingsSystem.Products.Product

    @valid_attrs %{accounting_type: "some accounting_type", annual_interest: "some annual_interest", code: "some code", currency: "some currency", currency_decimals: "some currency_decimals", deposit_fee_amount: "some deposit_fee_amount", details: "some details", exactly_number_days: "some exactly_number_days", fixed_period_days: "some fixed_period_days", max_interest: "some max_interest", max_number_disburse: "some max_number_disburse", max_number_repayment: "some max_number_repayment", max_principal: "some max_principal", min_balance_required: "some min_balance_required", min_interest: "some min_interest", min_number_disburse: "some min_number_disburse", min_number_repayment: "some min_number_repayment", min_principal: "some min_principal", name: "some name", number_days_month: "some number_days_month", number_days_npa: "some number_days_npa", number_days_year: "some number_days_year", withdrawal_fee_amount: "some withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some withdrawal_fee_transfer_to_mobile"}
    @update_attrs %{accounting_type: "some updated accounting_type", annual_interest: "some updated annual_interest", code: "some updated code", currency: "some updated currency", currency_decimals: "some updated currency_decimals", deposit_fee_amount: "some updated deposit_fee_amount", details: "some updated details", exactly_number_days: "some updated exactly_number_days", fixed_period_days: "some updated fixed_period_days", max_interest: "some updated max_interest", max_number_disburse: "some updated max_number_disburse", max_number_repayment: "some updated max_number_repayment", max_principal: "some updated max_principal", min_balance_required: "some updated min_balance_required", min_interest: "some updated min_interest", min_number_disburse: "some updated min_number_disburse", min_number_repayment: "some updated min_number_repayment", min_principal: "some updated min_principal", name: "some updated name", number_days_month: "some updated number_days_month", number_days_npa: "some updated number_days_npa", number_days_year: "some updated number_days_year", withdrawal_fee_amount: "some updated withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some updated withdrawal_fee_transfer_to_mobile"}
    @invalid_attrs %{accounting_type: nil, annual_interest: nil, code: nil, currency: nil, currency_decimals: nil, deposit_fee_amount: nil, details: nil, exactly_number_days: nil, fixed_period_days: nil, max_interest: nil, max_number_disburse: nil, max_number_repayment: nil, max_principal: nil, min_balance_required: nil, min_interest: nil, min_number_disburse: nil, min_number_repayment: nil, min_principal: nil, name: nil, number_days_month: nil, number_days_npa: nil, number_days_year: nil, withdrawal_fee_amount: nil, withdrawal_fee_transfer_to_mobile: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_tbl_loan_products/0 returns all tbl_loan_products" do
      product = product_fixture()
      assert Products.list_tbl_loan_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.accounting_type == "some accounting_type"
      assert product.annual_interest == "some annual_interest"
      assert product.code == "some code"
      assert product.currency == "some currency"
      assert product.currency_decimals == "some currency_decimals"
      assert product.deposit_fee_amount == "some deposit_fee_amount"
      assert product.details == "some details"
      assert product.exactly_number_days == "some exactly_number_days"
      assert product.fixed_period_days == "some fixed_period_days"
      assert product.max_interest == "some max_interest"
      assert product.max_number_disburse == "some max_number_disburse"
      assert product.max_number_repayment == "some max_number_repayment"
      assert product.max_principal == "some max_principal"
      assert product.min_balance_required == "some min_balance_required"
      assert product.min_interest == "some min_interest"
      assert product.min_number_disburse == "some min_number_disburse"
      assert product.min_number_repayment == "some min_number_repayment"
      assert product.min_principal == "some min_principal"
      assert product.name == "some name"
      assert product.number_days_month == "some number_days_month"
      assert product.number_days_npa == "some number_days_npa"
      assert product.number_days_year == "some number_days_year"
      assert product.withdrawal_fee_amount == "some withdrawal_fee_amount"
      assert product.withdrawal_fee_transfer_to_mobile == "some withdrawal_fee_transfer_to_mobile"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.accounting_type == "some updated accounting_type"
      assert product.annual_interest == "some updated annual_interest"
      assert product.code == "some updated code"
      assert product.currency == "some updated currency"
      assert product.currency_decimals == "some updated currency_decimals"
      assert product.deposit_fee_amount == "some updated deposit_fee_amount"
      assert product.details == "some updated details"
      assert product.exactly_number_days == "some updated exactly_number_days"
      assert product.fixed_period_days == "some updated fixed_period_days"
      assert product.max_interest == "some updated max_interest"
      assert product.max_number_disburse == "some updated max_number_disburse"
      assert product.max_number_repayment == "some updated max_number_repayment"
      assert product.max_principal == "some updated max_principal"
      assert product.min_balance_required == "some updated min_balance_required"
      assert product.min_interest == "some updated min_interest"
      assert product.min_number_disburse == "some updated min_number_disburse"
      assert product.min_number_repayment == "some updated min_number_repayment"
      assert product.min_principal == "some updated min_principal"
      assert product.name == "some updated name"
      assert product.number_days_month == "some updated number_days_month"
      assert product.number_days_npa == "some updated number_days_npa"
      assert product.number_days_year == "some updated number_days_year"
      assert product.withdrawal_fee_amount == "some updated withdrawal_fee_amount"
      assert product.withdrawal_fee_transfer_to_mobile == "some updated withdrawal_fee_transfer_to_mobile"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "tbl_savings_products" do
    alias LoanSavingsSystem.Products.Product

    @valid_attrs %{annual_interest: "some annual_interest", client_id: "some client_id", code: "some code", currency: "some currency", currency_decimals: "some currency_decimals", days_to_dormancy: "some days_to_dormancy", days_to_inactive: "some days_to_inactive", deposit_fee_amount: "some deposit_fee_amount", details: "some details", fixed_period_days: "some fixed_period_days", max_number_disburse: "some max_number_disburse", min_balance_required: "some min_balance_required", min_number_disburse: "some min_number_disburse", name: "some name", withdrawal_fee_amount: "some withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some withdrawal_fee_transfer_to_mobile", year_length_days: "some year_length_days"}
    @update_attrs %{annual_interest: "some updated annual_interest", client_id: "some updated client_id", code: "some updated code", currency: "some updated currency", currency_decimals: "some updated currency_decimals", days_to_dormancy: "some updated days_to_dormancy", days_to_inactive: "some updated days_to_inactive", deposit_fee_amount: "some updated deposit_fee_amount", details: "some updated details", fixed_period_days: "some updated fixed_period_days", max_number_disburse: "some updated max_number_disburse", min_balance_required: "some updated min_balance_required", min_number_disburse: "some updated min_number_disburse", name: "some updated name", withdrawal_fee_amount: "some updated withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some updated withdrawal_fee_transfer_to_mobile", year_length_days: "some updated year_length_days"}
    @invalid_attrs %{annual_interest: nil, client_id: nil, code: nil, currency: nil, currency_decimals: nil, days_to_dormancy: nil, days_to_inactive: nil, deposit_fee_amount: nil, details: nil, fixed_period_days: nil, max_number_disburse: nil, min_balance_required: nil, min_number_disburse: nil, name: nil, withdrawal_fee_amount: nil, withdrawal_fee_transfer_to_mobile: nil, year_length_days: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_tbl_savings_products/0 returns all tbl_savings_products" do
      product = product_fixture()
      assert Products.list_tbl_savings_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.annual_interest == "some annual_interest"
      assert product.client_id == "some client_id"
      assert product.code == "some code"
      assert product.currency == "some currency"
      assert product.currency_decimals == "some currency_decimals"
      assert product.days_to_dormancy == "some days_to_dormancy"
      assert product.days_to_inactive == "some days_to_inactive"
      assert product.deposit_fee_amount == "some deposit_fee_amount"
      assert product.details == "some details"
      assert product.fixed_period_days == "some fixed_period_days"
      assert product.max_number_disburse == "some max_number_disburse"
      assert product.min_balance_required == "some min_balance_required"
      assert product.min_number_disburse == "some min_number_disburse"
      assert product.name == "some name"
      assert product.withdrawal_fee_amount == "some withdrawal_fee_amount"
      assert product.withdrawal_fee_transfer_to_mobile == "some withdrawal_fee_transfer_to_mobile"
      assert product.year_length_days == "some year_length_days"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.annual_interest == "some updated annual_interest"
      assert product.client_id == "some updated client_id"
      assert product.code == "some updated code"
      assert product.currency == "some updated currency"
      assert product.currency_decimals == "some updated currency_decimals"
      assert product.days_to_dormancy == "some updated days_to_dormancy"
      assert product.days_to_inactive == "some updated days_to_inactive"
      assert product.deposit_fee_amount == "some updated deposit_fee_amount"
      assert product.details == "some updated details"
      assert product.fixed_period_days == "some updated fixed_period_days"
      assert product.max_number_disburse == "some updated max_number_disburse"
      assert product.min_balance_required == "some updated min_balance_required"
      assert product.min_number_disburse == "some updated min_number_disburse"
      assert product.name == "some updated name"
      assert product.withdrawal_fee_amount == "some updated withdrawal_fee_amount"
      assert product.withdrawal_fee_transfer_to_mobile == "some updated withdrawal_fee_transfer_to_mobile"
      assert product.year_length_days == "some updated year_length_days"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

>>>>>>> teddy
  describe "tbl_savings_products" do
    alias LoanSavingsSystem.Products.Product_savings

    @valid_attrs %{annual_interest: "some annual_interest", client_id: "some client_id", code: "some code", currency: "some currency", currency_decimals: "some currency_decimals", days_to_dormancy: "some days_to_dormancy", days_to_inactive: "some days_to_inactive", deposit_fee_amount: "some deposit_fee_amount", details: "some details", fixed_period_days: "some fixed_period_days", max_number_disburse: "some max_number_disburse", min_balance_required: "some min_balance_required", min_number_disburse: "some min_number_disburse", name: "some name", withdrawal_fee_amount: "some withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some withdrawal_fee_transfer_to_mobile", year_length_days: "some year_length_days"}
    @update_attrs %{annual_interest: "some updated annual_interest", client_id: "some updated client_id", code: "some updated code", currency: "some updated currency", currency_decimals: "some updated currency_decimals", days_to_dormancy: "some updated days_to_dormancy", days_to_inactive: "some updated days_to_inactive", deposit_fee_amount: "some updated deposit_fee_amount", details: "some updated details", fixed_period_days: "some updated fixed_period_days", max_number_disburse: "some updated max_number_disburse", min_balance_required: "some updated min_balance_required", min_number_disburse: "some updated min_number_disburse", name: "some updated name", withdrawal_fee_amount: "some updated withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some updated withdrawal_fee_transfer_to_mobile", year_length_days: "some updated year_length_days"}
    @invalid_attrs %{annual_interest: nil, client_id: nil, code: nil, currency: nil, currency_decimals: nil, days_to_dormancy: nil, days_to_inactive: nil, deposit_fee_amount: nil, details: nil, fixed_period_days: nil, max_number_disburse: nil, min_balance_required: nil, min_number_disburse: nil, name: nil, withdrawal_fee_amount: nil, withdrawal_fee_transfer_to_mobile: nil, year_length_days: nil}

    def product_savings_fixture(attrs \\ %{}) do
      {:ok, product_savings} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product_savings()

      product_savings
    end

    test "list_tbl_savings_products/0 returns all tbl_savings_products" do
      product_savings = product_savings_fixture()
      assert Products.list_tbl_savings_products() == [product_savings]
    end

    test "get_product_savings!/1 returns the product_savings with given id" do
      product_savings = product_savings_fixture()
      assert Products.get_product_savings!(product_savings.id) == product_savings
    end

    test "create_product_savings/1 with valid data creates a product_savings" do
      assert {:ok, %Product_savings{} = product_savings} = Products.create_product_savings(@valid_attrs)
      assert product_savings.annual_interest == "some annual_interest"
      assert product_savings.client_id == "some client_id"
      assert product_savings.code == "some code"
      assert product_savings.currency == "some currency"
      assert product_savings.currency_decimals == "some currency_decimals"
      assert product_savings.days_to_dormancy == "some days_to_dormancy"
      assert product_savings.days_to_inactive == "some days_to_inactive"
      assert product_savings.deposit_fee_amount == "some deposit_fee_amount"
      assert product_savings.details == "some details"
      assert product_savings.fixed_period_days == "some fixed_period_days"
      assert product_savings.max_number_disburse == "some max_number_disburse"
      assert product_savings.min_balance_required == "some min_balance_required"
      assert product_savings.min_number_disburse == "some min_number_disburse"
      assert product_savings.name == "some name"
      assert product_savings.withdrawal_fee_amount == "some withdrawal_fee_amount"
      assert product_savings.withdrawal_fee_transfer_to_mobile == "some withdrawal_fee_transfer_to_mobile"
      assert product_savings.year_length_days == "some year_length_days"
    end

    test "create_product_savings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_savings(@invalid_attrs)
    end

    test "update_product_savings/2 with valid data updates the product_savings" do
      product_savings = product_savings_fixture()
      assert {:ok, %Product_savings{} = product_savings} = Products.update_product_savings(product_savings, @update_attrs)
      assert product_savings.annual_interest == "some updated annual_interest"
      assert product_savings.client_id == "some updated client_id"
      assert product_savings.code == "some updated code"
      assert product_savings.currency == "some updated currency"
      assert product_savings.currency_decimals == "some updated currency_decimals"
      assert product_savings.days_to_dormancy == "some updated days_to_dormancy"
      assert product_savings.days_to_inactive == "some updated days_to_inactive"
      assert product_savings.deposit_fee_amount == "some updated deposit_fee_amount"
      assert product_savings.details == "some updated details"
      assert product_savings.fixed_period_days == "some updated fixed_period_days"
      assert product_savings.max_number_disburse == "some updated max_number_disburse"
      assert product_savings.min_balance_required == "some updated min_balance_required"
      assert product_savings.min_number_disburse == "some updated min_number_disburse"
      assert product_savings.name == "some updated name"
      assert product_savings.withdrawal_fee_amount == "some updated withdrawal_fee_amount"
      assert product_savings.withdrawal_fee_transfer_to_mobile == "some updated withdrawal_fee_transfer_to_mobile"
      assert product_savings.year_length_days == "some updated year_length_days"
    end

    test "update_product_savings/2 with invalid data returns error changeset" do
      product_savings = product_savings_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product_savings(product_savings, @invalid_attrs)
      assert product_savings == Products.get_product_savings!(product_savings.id)
    end

    test "delete_product_savings/1 deletes the product_savings" do
      product_savings = product_savings_fixture()
      assert {:ok, %Product_savings{}} = Products.delete_product_savings(product_savings)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_savings!(product_savings.id) end
    end

    test "change_product_savings/1 returns a product_savings changeset" do
      product_savings = product_savings_fixture()
      assert %Ecto.Changeset{} = Products.change_product_savings(product_savings)
    end
  end

  describe "tbl_loan_products" do
    alias LoanSavingsSystem.Products.Product_loan

    @valid_attrs %{accounting_type: "some accounting_type", annual_interest: "some annual_interest", code: "some code", currency: "some currency", currency_decimals: "some currency_decimals", deposit_fee_amount: "some deposit_fee_amount", details: "some details", exactly_number_days: "some exactly_number_days", fixed_period_days: "some fixed_period_days", max_interest: "some max_interest", max_number_disburse: "some max_number_disburse", max_number_repayment: "some max_number_repayment", max_principal: "some max_principal", min_balance_required: "some min_balance_required", min_interest: "some min_interest", min_number_disburse: "some min_number_disburse", min_number_repayment: "some min_number_repayment", min_principal: "some min_principal", name: "some name", number_days_month: "some number_days_month", number_days_npa: "some number_days_npa", number_days_year: "some number_days_year", withdrawal_fee_amount: "some withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some withdrawal_fee_transfer_to_mobile"}
    @update_attrs %{accounting_type: "some updated accounting_type", annual_interest: "some updated annual_interest", code: "some updated code", currency: "some updated currency", currency_decimals: "some updated currency_decimals", deposit_fee_amount: "some updated deposit_fee_amount", details: "some updated details", exactly_number_days: "some updated exactly_number_days", fixed_period_days: "some updated fixed_period_days", max_interest: "some updated max_interest", max_number_disburse: "some updated max_number_disburse", max_number_repayment: "some updated max_number_repayment", max_principal: "some updated max_principal", min_balance_required: "some updated min_balance_required", min_interest: "some updated min_interest", min_number_disburse: "some updated min_number_disburse", min_number_repayment: "some updated min_number_repayment", min_principal: "some updated min_principal", name: "some updated name", number_days_month: "some updated number_days_month", number_days_npa: "some updated number_days_npa", number_days_year: "some updated number_days_year", withdrawal_fee_amount: "some updated withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some updated withdrawal_fee_transfer_to_mobile"}
    @invalid_attrs %{accounting_type: nil, annual_interest: nil, code: nil, currency: nil, currency_decimals: nil, deposit_fee_amount: nil, details: nil, exactly_number_days: nil, fixed_period_days: nil, max_interest: nil, max_number_disburse: nil, max_number_repayment: nil, max_principal: nil, min_balance_required: nil, min_interest: nil, min_number_disburse: nil, min_number_repayment: nil, min_principal: nil, name: nil, number_days_month: nil, number_days_npa: nil, number_days_year: nil, withdrawal_fee_amount: nil, withdrawal_fee_transfer_to_mobile: nil}

    def product_loan_fixture(attrs \\ %{}) do
      {:ok, product_loan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product_loan()

      product_loan
    end

    test "list_tbl_loan_products/0 returns all tbl_loan_products" do
      product_loan = product_loan_fixture()
      assert Products.list_tbl_loan_products() == [product_loan]
    end

    test "get_product_loan!/1 returns the product_loan with given id" do
      product_loan = product_loan_fixture()
      assert Products.get_product_loan!(product_loan.id) == product_loan
    end

    test "create_product_loan/1 with valid data creates a product_loan" do
      assert {:ok, %Product_loan{} = product_loan} = Products.create_product_loan(@valid_attrs)
      assert product_loan.accounting_type == "some accounting_type"
      assert product_loan.annual_interest == "some annual_interest"
      assert product_loan.code == "some code"
      assert product_loan.currency == "some currency"
      assert product_loan.currency_decimals == "some currency_decimals"
      assert product_loan.deposit_fee_amount == "some deposit_fee_amount"
      assert product_loan.details == "some details"
      assert product_loan.exactly_number_days == "some exactly_number_days"
      assert product_loan.fixed_period_days == "some fixed_period_days"
      assert product_loan.max_interest == "some max_interest"
      assert product_loan.max_number_disburse == "some max_number_disburse"
      assert product_loan.max_number_repayment == "some max_number_repayment"
      assert product_loan.max_principal == "some max_principal"
      assert product_loan.min_balance_required == "some min_balance_required"
      assert product_loan.min_interest == "some min_interest"
      assert product_loan.min_number_disburse == "some min_number_disburse"
      assert product_loan.min_number_repayment == "some min_number_repayment"
      assert product_loan.min_principal == "some min_principal"
      assert product_loan.name == "some name"
      assert product_loan.number_days_month == "some number_days_month"
      assert product_loan.number_days_npa == "some number_days_npa"
      assert product_loan.number_days_year == "some number_days_year"
      assert product_loan.withdrawal_fee_amount == "some withdrawal_fee_amount"
      assert product_loan.withdrawal_fee_transfer_to_mobile == "some withdrawal_fee_transfer_to_mobile"
    end

    test "create_product_loan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_loan(@invalid_attrs)
    end

    test "update_product_loan/2 with valid data updates the product_loan" do
      product_loan = product_loan_fixture()
      assert {:ok, %Product_loan{} = product_loan} = Products.update_product_loan(product_loan, @update_attrs)
      assert product_loan.accounting_type == "some updated accounting_type"
      assert product_loan.annual_interest == "some updated annual_interest"
      assert product_loan.code == "some updated code"
      assert product_loan.currency == "some updated currency"
      assert product_loan.currency_decimals == "some updated currency_decimals"
      assert product_loan.deposit_fee_amount == "some updated deposit_fee_amount"
      assert product_loan.details == "some updated details"
      assert product_loan.exactly_number_days == "some updated exactly_number_days"
      assert product_loan.fixed_period_days == "some updated fixed_period_days"
      assert product_loan.max_interest == "some updated max_interest"
      assert product_loan.max_number_disburse == "some updated max_number_disburse"
      assert product_loan.max_number_repayment == "some updated max_number_repayment"
      assert product_loan.max_principal == "some updated max_principal"
      assert product_loan.min_balance_required == "some updated min_balance_required"
      assert product_loan.min_interest == "some updated min_interest"
      assert product_loan.min_number_disburse == "some updated min_number_disburse"
      assert product_loan.min_number_repayment == "some updated min_number_repayment"
      assert product_loan.min_principal == "some updated min_principal"
      assert product_loan.name == "some updated name"
      assert product_loan.number_days_month == "some updated number_days_month"
      assert product_loan.number_days_npa == "some updated number_days_npa"
      assert product_loan.number_days_year == "some updated number_days_year"
      assert product_loan.withdrawal_fee_amount == "some updated withdrawal_fee_amount"
      assert product_loan.withdrawal_fee_transfer_to_mobile == "some updated withdrawal_fee_transfer_to_mobile"
    end

    test "update_product_loan/2 with invalid data returns error changeset" do
      product_loan = product_loan_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product_loan(product_loan, @invalid_attrs)
      assert product_loan == Products.get_product_loan!(product_loan.id)
    end

    test "delete_product_loan/1 deletes the product_loan" do
      product_loan = product_loan_fixture()
      assert {:ok, %Product_loan{}} = Products.delete_product_loan(product_loan)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_loan!(product_loan.id) end
    end

    test "change_product_loan/1 returns a product_loan changeset" do
      product_loan = product_loan_fixture()
      assert %Ecto.Changeset{} = Products.change_product_loan(product_loan)
    end
  end

  describe "tbl_products" do
    alias LoanSavingsSystem.Products.Product

    @valid_attrs %{clientId: 42, code: "some code", currencyDecimals: 42, currencyId: 42, currencyName: "some currencyName", defaultPeriod: 42, details: "some details", interest: 120.5, interestMode: "some interestMode", interestType: "some interestType", maximumPrincipal: 120.5, minimumPrincipal: 120.5, name: "some name", periodType: "some periodType", productType: "some productType", status: "some status", yearLengthInDays: 42}
    @update_attrs %{clientId: 43, code: "some updated code", currencyDecimals: 43, currencyId: 43, currencyName: "some updated currencyName", defaultPeriod: 43, details: "some updated details", interest: 456.7, interestMode: "some updated interestMode", interestType: "some updated interestType", maximumPrincipal: 456.7, minimumPrincipal: 456.7, name: "some updated name", periodType: "some updated periodType", productType: "some updated productType", status: "some updated status", yearLengthInDays: 43}
    @invalid_attrs %{clientId: nil, code: nil, currencyDecimals: nil, currencyId: nil, currencyName: nil, defaultPeriod: nil, details: nil, interest: nil, interestMode: nil, interestType: nil, maximumPrincipal: nil, minimumPrincipal: nil, name: nil, periodType: nil, productType: nil, status: nil, yearLengthInDays: nil}

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_tbl_products/0 returns all tbl_products" do
      product = product_fixture()
      assert Products.list_tbl_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.clientId == 42
      assert product.code == "some code"
      assert product.currencyDecimals == 42
      assert product.currencyId == 42
      assert product.currencyName == "some currencyName"
      assert product.defaultPeriod == 42
      assert product.details == "some details"
      assert product.interest == 120.5
      assert product.interestMode == "some interestMode"
      assert product.interestType == "some interestType"
      assert product.maximumPrincipal == 120.5
      assert product.minimumPrincipal == 120.5
      assert product.name == "some name"
      assert product.periodType == "some periodType"
      assert product.productType == "some productType"
      assert product.status == "some status"
      assert product.yearLengthInDays == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.clientId == 43
      assert product.code == "some updated code"
      assert product.currencyDecimals == 43
      assert product.currencyId == 43
      assert product.currencyName == "some updated currencyName"
      assert product.defaultPeriod == 43
      assert product.details == "some updated details"
      assert product.interest == 456.7
      assert product.interestMode == "some updated interestMode"
      assert product.interestType == "some updated interestType"
      assert product.maximumPrincipal == 456.7
      assert product.minimumPrincipal == 456.7
      assert product.name == "some updated name"
      assert product.periodType == "some updated periodType"
      assert product.productType == "some updated productType"
      assert product.status == "some updated status"
      assert product.yearLengthInDays == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "tbl_product_charge" do
    alias LoanSavingsSystem.Products.ProductCharge

    @valid_attrs %{chargeId: 42, productId: 42, valuation: 120.5}
    @update_attrs %{chargeId: 43, productId: 43, valuation: 456.7}
    @invalid_attrs %{chargeId: nil, productId: nil, valuation: nil}

    def product_charge_fixture(attrs \\ %{}) do
      {:ok, product_charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product_charge()

      product_charge
    end

    test "list_tbl_product_charge/0 returns all tbl_product_charge" do
      product_charge = product_charge_fixture()
      assert Products.list_tbl_product_charge() == [product_charge]
    end

    test "get_product_charge!/1 returns the product_charge with given id" do
      product_charge = product_charge_fixture()
      assert Products.get_product_charge!(product_charge.id) == product_charge
    end

    test "create_product_charge/1 with valid data creates a product_charge" do
      assert {:ok, %ProductCharge{} = product_charge} = Products.create_product_charge(@valid_attrs)
      assert product_charge.chargeId == 42
      assert product_charge.productId == 42
      assert product_charge.valuation == 120.5
    end

    test "create_product_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_charge(@invalid_attrs)
    end

    test "update_product_charge/2 with valid data updates the product_charge" do
      product_charge = product_charge_fixture()
      assert {:ok, %ProductCharge{} = product_charge} = Products.update_product_charge(product_charge, @update_attrs)
      assert product_charge.chargeId == 43
      assert product_charge.productId == 43
      assert product_charge.valuation == 456.7
    end

    test "update_product_charge/2 with invalid data returns error changeset" do
      product_charge = product_charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product_charge(product_charge, @invalid_attrs)
      assert product_charge == Products.get_product_charge!(product_charge.id)
    end

    test "delete_product_charge/1 deletes the product_charge" do
      product_charge = product_charge_fixture()
      assert {:ok, %ProductCharge{}} = Products.delete_product_charge(product_charge)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_charge!(product_charge.id) end
    end

    test "change_product_charge/1 returns a product_charge changeset" do
      product_charge = product_charge_fixture()
      assert %Ecto.Changeset{} = Products.change_product_charge(product_charge)
    end
  end
end
