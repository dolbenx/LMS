defmodule Loanmanagementsystem.ProductsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Products

  describe "tbl_products" do
    alias Loanmanagementsystem.Products.Product

    @valid_attrs %{
      clientId: 42,
      code: "some code",
      currencyDecimals: 42,
      currencyId: 42,
      currencyName: "some currencyName",
      defaultPeriod: 42,
      details: "some details",
      interest: 120.5,
      interestMode: "some interestMode",
      interestType: "some interestType",
      maximumPrincipal: 120.5,
      minimumPrincipal: 120.5,
      name: "some name",
      periodType: "some periodType",
      productType: "some productType",
      status: "some status",
      yearLengthInDays: 42
    }
    @update_attrs %{
      clientId: 43,
      code: "some updated code",
      currencyDecimals: 43,
      currencyId: 43,
      currencyName: "some updated currencyName",
      defaultPeriod: 43,
      details: "some updated details",
      interest: 456.7,
      interestMode: "some updated interestMode",
      interestType: "some updated interestType",
      maximumPrincipal: 456.7,
      minimumPrincipal: 456.7,
      name: "some updated name",
      periodType: "some updated periodType",
      productType: "some updated productType",
      status: "some updated status",
      yearLengthInDays: 43
    }
    @invalid_attrs %{
      clientId: nil,
      code: nil,
      currencyDecimals: nil,
      currencyId: nil,
      currencyName: nil,
      defaultPeriod: nil,
      details: nil,
      interest: nil,
      interestMode: nil,
      interestType: nil,
      maximumPrincipal: nil,
      minimumPrincipal: nil,
      name: nil,
      periodType: nil,
      productType: nil,
      status: nil,
      yearLengthInDays: nil
    }

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

  describe "tbl_product_rates" do
    alias Loanmanagementsystem.Products.Product_rates

    @valid_attrs %{
      interest_rates: "some interest_rates",
      processing_fee: "some processing_fee",
      product_id: "some product_id",
      product_name: "some product_name",
      repayment: "some repayment",
      status: "some status",
      tenor: "some tenor"
    }
    @update_attrs %{
      interest_rates: "some updated interest_rates",
      processing_fee: "some updated processing_fee",
      product_id: "some updated product_id",
      product_name: "some updated product_name",
      repayment: "some updated repayment",
      status: "some updated status",
      tenor: "some updated tenor"
    }
    @invalid_attrs %{
      interest_rates: nil,
      processing_fee: nil,
      product_id: nil,
      product_name: nil,
      repayment: nil,
      status: nil,
      tenor: nil
    }

    def product_rates_fixture(attrs \\ %{}) do
      {:ok, product_rates} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product_rates()

      product_rates
    end

    test "list_tbl_product_rates/0 returns all tbl_product_rates" do
      product_rates = product_rates_fixture()
      assert Products.list_tbl_product_rates() == [product_rates]
    end

    test "get_product_rates!/1 returns the product_rates with given id" do
      product_rates = product_rates_fixture()
      assert Products.get_product_rates!(product_rates.id) == product_rates
    end

    test "create_product_rates/1 with valid data creates a product_rates" do
      assert {:ok, %Product_rates{} = product_rates} = Products.create_product_rates(@valid_attrs)
      assert product_rates.interest_rates == "some interest_rates"
      assert product_rates.processing_fee == "some processing_fee"
      assert product_rates.product_id == "some product_id"
      assert product_rates.product_name == "some product_name"
      assert product_rates.repayment == "some repayment"
      assert product_rates.status == "some status"
      assert product_rates.tenor == "some tenor"
    end

    test "create_product_rates/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product_rates(@invalid_attrs)
    end

    test "update_product_rates/2 with valid data updates the product_rates" do
      product_rates = product_rates_fixture()

      assert {:ok, %Product_rates{} = product_rates} =
               Products.update_product_rates(product_rates, @update_attrs)

      assert product_rates.interest_rates == "some updated interest_rates"
      assert product_rates.processing_fee == "some updated processing_fee"
      assert product_rates.product_id == "some updated product_id"
      assert product_rates.product_name == "some updated product_name"
      assert product_rates.repayment == "some updated repayment"
      assert product_rates.status == "some updated status"
      assert product_rates.tenor == "some updated tenor"
    end

    test "update_product_rates/2 with invalid data returns error changeset" do
      product_rates = product_rates_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Products.update_product_rates(product_rates, @invalid_attrs)

      assert product_rates == Products.get_product_rates!(product_rates.id)
    end

    test "delete_product_rates/1 deletes the product_rates" do
      product_rates = product_rates_fixture()
      assert {:ok, %Product_rates{}} = Products.delete_product_rates(product_rates)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product_rates!(product_rates.id) end
    end

    test "change_product_rates/1 returns a product_rates changeset" do
      product_rates = product_rates_fixture()
      assert %Ecto.Changeset{} = Products.change_product_rates(product_rates)
    end
  end
end
