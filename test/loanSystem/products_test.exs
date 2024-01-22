defmodule LoanSystem.ProductsTest do
  use LoanSystem.DataCase

  alias LoanSystem.Products

  describe "tbl_products" do
    alias LoanSystem.Products.Product

    @valid_attrs %{annual_interest: "some annual_interest", code: "some code", currency: "some currency", currency_decimals: "some currency_decimals", days_to_dormancy: "some days_to_dormancy", days_to_inactive: "some days_to_inactive", deposit_fee_amount: "some deposit_fee_amount", details: "some details", fixed_period_days: "some fixed_period_days", min_balance_required: "some min_balance_required", name: "some name", withdrawal_fee_amount: "some withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some withdrawal_fee_transfer_to_mobile", year_length_days: "some year_length_days"}
    @update_attrs %{annual_interest: "some updated annual_interest", code: "some updated code", currency: "some updated currency", currency_decimals: "some updated currency_decimals", days_to_dormancy: "some updated days_to_dormancy", days_to_inactive: "some updated days_to_inactive", deposit_fee_amount: "some updated deposit_fee_amount", details: "some updated details", fixed_period_days: "some updated fixed_period_days", min_balance_required: "some updated min_balance_required", name: "some updated name", withdrawal_fee_amount: "some updated withdrawal_fee_amount", withdrawal_fee_transfer_to_mobile: "some updated withdrawal_fee_transfer_to_mobile", year_length_days: "some updated year_length_days"}
    @invalid_attrs %{annual_interest: nil, code: nil, currency: nil, currency_decimals: nil, days_to_dormancy: nil, days_to_inactive: nil, deposit_fee_amount: nil, details: nil, fixed_period_days: nil, min_balance_required: nil, name: nil, withdrawal_fee_amount: nil, withdrawal_fee_transfer_to_mobile: nil, year_length_days: nil}

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
end
