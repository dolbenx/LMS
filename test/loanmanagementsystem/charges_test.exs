defmodule Loanmanagementsystem.ChargesTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Charges

  describe "tbl_charges" do
    alias Loanmanagementsystem.Charges.Charge

    @valid_attrs %{
      chargeAmount: 120.5,
      chargeName: "some chargeName",
      chargeType: "some chargeType",
      chargeWhen: "some chargeWhen",
      clientId: 42,
      currency: "some currency",
      currencyId: 42,
      isPenalty: true,
      status: "some status"
    }
    @update_attrs %{
      chargeAmount: 456.7,
      chargeName: "some updated chargeName",
      chargeType: "some updated chargeType",
      chargeWhen: "some updated chargeWhen",
      clientId: 43,
      currency: "some updated currency",
      currencyId: 43,
      isPenalty: false,
      status: "some updated status"
    }
    @invalid_attrs %{
      chargeAmount: nil,
      chargeName: nil,
      chargeType: nil,
      chargeWhen: nil,
      clientId: nil,
      currency: nil,
      currencyId: nil,
      isPenalty: nil,
      status: nil
    }

    def charge_fixture(attrs \\ %{}) do
      {:ok, charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Charges.create_charge()

      charge
    end

    test "list_tbl_charges/0 returns all tbl_charges" do
      charge = charge_fixture()
      assert Charges.list_tbl_charges() == [charge]
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      assert Charges.get_charge!(charge.id) == charge
    end

    test "create_charge/1 with valid data creates a charge" do
      assert {:ok, %Charge{} = charge} = Charges.create_charge(@valid_attrs)
      assert charge.chargeAmount == 120.5
      assert charge.chargeName == "some chargeName"
      assert charge.chargeType == "some chargeType"
      assert charge.chargeWhen == "some chargeWhen"
      assert charge.clientId == 42
      assert charge.currency == "some currency"
      assert charge.currencyId == 42
      assert charge.isPenalty == true
      assert charge.status == "some status"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Charges.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{} = charge} = Charges.update_charge(charge, @update_attrs)
      assert charge.chargeAmount == 456.7
      assert charge.chargeName == "some updated chargeName"
      assert charge.chargeType == "some updated chargeType"
      assert charge.chargeWhen == "some updated chargeWhen"
      assert charge.clientId == 43
      assert charge.currency == "some updated currency"
      assert charge.currencyId == 43
      assert charge.isPenalty == false
      assert charge.status == "some updated status"
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Charges.update_charge(charge, @invalid_attrs)
      assert charge == Charges.get_charge!(charge.id)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = Charges.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> Charges.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = Charges.change_charge(charge)
    end
  end

  describe "tbl_charges" do
    alias Loanmanagementsystem.Charges.Charge

    @valid_attrs %{
      chargeAmount: 120.5,
      chargeName: "some chargeName",
      chargeType: "some chargeType",
      chargeWhen: "some chargeWhen",
      currency: "some currency",
      currencyId: 42,
      isPenalty: true
    }
    @update_attrs %{
      chargeAmount: 456.7,
      chargeName: "some updated chargeName",
      chargeType: "some updated chargeType",
      chargeWhen: "some updated chargeWhen",
      currency: "some updated currency",
      currencyId: 43,
      isPenalty: false
    }
    @invalid_attrs %{
      chargeAmount: nil,
      chargeName: nil,
      chargeType: nil,
      chargeWhen: nil,
      currency: nil,
      currencyId: nil,
      isPenalty: nil
    }

    def charge_fixture(attrs \\ %{}) do
      {:ok, charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Charges.create_charge()

      charge
    end

    test "list_tbl_charges/0 returns all tbl_charges" do
      charge = charge_fixture()
      assert Charges.list_tbl_charges() == [charge]
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      assert Charges.get_charge!(charge.id) == charge
    end

    test "create_charge/1 with valid data creates a charge" do
      assert {:ok, %Charge{} = charge} = Charges.create_charge(@valid_attrs)
      assert charge.chargeAmount == 120.5
      assert charge.chargeName == "some chargeName"
      assert charge.chargeType == "some chargeType"
      assert charge.chargeWhen == "some chargeWhen"
      assert charge.currency == "some currency"
      assert charge.currencyId == 42
      assert charge.isPenalty == true
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Charges.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{} = charge} = Charges.update_charge(charge, @update_attrs)
      assert charge.chargeAmount == 456.7
      assert charge.chargeName == "some updated chargeName"
      assert charge.chargeType == "some updated chargeType"
      assert charge.chargeWhen == "some updated chargeWhen"
      assert charge.currency == "some updated currency"
      assert charge.currencyId == 43
      assert charge.isPenalty == false
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Charges.update_charge(charge, @invalid_attrs)
      assert charge == Charges.get_charge!(charge.id)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = Charges.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> Charges.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = Charges.change_charge(charge)
    end
  end

  describe "tbl_product_charges" do
    alias Loanmanagementsystem.Charges.Product_charges

    @valid_attrs %{charge_id: 42, product_id: 42, status: "some status"}
    @update_attrs %{charge_id: 43, product_id: 43, status: "some updated status"}
    @invalid_attrs %{charge_id: nil, product_id: nil, status: nil}

    def product_charges_fixture(attrs \\ %{}) do
      {:ok, product_charges} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Charges.create_product_charges()

      product_charges
    end

    test "list_tbl_product_charges/0 returns all tbl_product_charges" do
      product_charges = product_charges_fixture()
      assert Charges.list_tbl_product_charges() == [product_charges]
    end

    test "get_product_charges!/1 returns the product_charges with given id" do
      product_charges = product_charges_fixture()
      assert Charges.get_product_charges!(product_charges.id) == product_charges
    end

    test "create_product_charges/1 with valid data creates a product_charges" do
      assert {:ok, %Product_charges{} = product_charges} = Charges.create_product_charges(@valid_attrs)
      assert product_charges.charge_id == 42
      assert product_charges.product_id == 42
      assert product_charges.status == "some status"
    end

    test "create_product_charges/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Charges.create_product_charges(@invalid_attrs)
    end

    test "update_product_charges/2 with valid data updates the product_charges" do
      product_charges = product_charges_fixture()
      assert {:ok, %Product_charges{} = product_charges} = Charges.update_product_charges(product_charges, @update_attrs)
      assert product_charges.charge_id == 43
      assert product_charges.product_id == 43
      assert product_charges.status == "some updated status"
    end

    test "update_product_charges/2 with invalid data returns error changeset" do
      product_charges = product_charges_fixture()
      assert {:error, %Ecto.Changeset{}} = Charges.update_product_charges(product_charges, @invalid_attrs)
      assert product_charges == Charges.get_product_charges!(product_charges.id)
    end

    test "delete_product_charges/1 deletes the product_charges" do
      product_charges = product_charges_fixture()
      assert {:ok, %Product_charges{}} = Charges.delete_product_charges(product_charges)
      assert_raise Ecto.NoResultsError, fn -> Charges.get_product_charges!(product_charges.id) end
    end

    test "change_product_charges/1 returns a product_charges changeset" do
      product_charges = product_charges_fixture()
      assert %Ecto.Changeset{} = Charges.change_product_charges(product_charges)
    end
  end
end
