defmodule Savings.ProductsTest do
  use Savings.DataCase

  alias Savings.Products

  describe "tbl_product_period" do
    alias Savings.Products.ProductsPeriod

    import Savings.ProductsFixtures

    @invalid_attrs %{periodDays: nil, periodType: nil, productID: nil, status: nil}

    test "list_tbl_product_period/0 returns all tbl_product_period" do
      products_period = products_period_fixture()
      assert Products.list_tbl_product_period() == [products_period]
    end

    test "get_products_period!/1 returns the products_period with given id" do
      products_period = products_period_fixture()
      assert Products.get_products_period!(products_period.id) == products_period
    end

    test "create_products_period/1 with valid data creates a products_period" do
      valid_attrs = %{periodDays: "some periodDays", periodType: "some periodType", productID: 42, status: "some status"}

      assert {:ok, %ProductsPeriod{} = products_period} = Products.create_products_period(valid_attrs)
      assert products_period.periodDays == "some periodDays"
      assert products_period.periodType == "some periodType"
      assert products_period.productID == 42
      assert products_period.status == "some status"
    end

    test "create_products_period/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_products_period(@invalid_attrs)
    end

    test "update_products_period/2 with valid data updates the products_period" do
      products_period = products_period_fixture()
      update_attrs = %{periodDays: "some updated periodDays", periodType: "some updated periodType", productID: 43, status: "some updated status"}

      assert {:ok, %ProductsPeriod{} = products_period} = Products.update_products_period(products_period, update_attrs)
      assert products_period.periodDays == "some updated periodDays"
      assert products_period.periodType == "some updated periodType"
      assert products_period.productID == 43
      assert products_period.status == "some updated status"
    end

    test "update_products_period/2 with invalid data returns error changeset" do
      products_period = products_period_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_products_period(products_period, @invalid_attrs)
      assert products_period == Products.get_products_period!(products_period.id)
    end

    test "delete_products_period/1 deletes the products_period" do
      products_period = products_period_fixture()
      assert {:ok, %ProductsPeriod{}} = Products.delete_products_period(products_period)
      assert_raise Ecto.NoResultsError, fn -> Products.get_products_period!(products_period.id) end
    end

    test "change_products_period/1 returns a products_period changeset" do
      products_period = products_period_fixture()
      assert %Ecto.Changeset{} = Products.change_products_period(products_period)
    end
  end
end
