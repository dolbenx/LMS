defmodule Loanmanagementsystem.PaymentTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Payment

  describe "tbl_collection_type" do
    alias Loanmanagementsystem.Payment.Collection

    @valid_attrs %{collection_type_description: "some collection_type_description", system_id: 42}
    @update_attrs %{
      collection_type_description: "some updated collection_type_description",
      system_id: 43
    }
    @invalid_attrs %{collection_type_description: nil, system_id: nil}

    def collection_fixture(attrs \\ %{}) do
      {:ok, collection} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payment.create_collection()

      collection
    end

    test "list_tbl_collection_type/0 returns all tbl_collection_type" do
      collection = collection_fixture()
      assert Payment.list_tbl_collection_type() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Payment.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      assert {:ok, %Collection{} = collection} = Payment.create_collection(@valid_attrs)
      assert collection.collection_type_description == "some collection_type_description"
      assert collection.system_id == 42
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payment.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()

      assert {:ok, %Collection{} = collection} =
               Payment.update_collection(collection, @update_attrs)

      assert collection.collection_type_description == "some updated collection_type_description"
      assert collection.system_id == 43
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Payment.update_collection(collection, @invalid_attrs)
      assert collection == Payment.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Payment.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Payment.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Payment.change_collection(collection)
    end
  end

  describe "tbl_payment_type" do
    alias Loanmanagementsystem.Payment.Payments

    @valid_attrs %{payment_type_description: "some payment_type_description", system_id: 42}
    @update_attrs %{
      payment_type_description: "some updated payment_type_description",
      system_id: 43
    }
    @invalid_attrs %{payment_type_description: nil, system_id: nil}

    def payments_fixture(attrs \\ %{}) do
      {:ok, payments} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payment.create_payments()

      payments
    end

    test "list_tbl_payment_type/0 returns all tbl_payment_type" do
      payments = payments_fixture()
      assert Payment.list_tbl_payment_type() == [payments]
    end

    test "get_payments!/1 returns the payments with given id" do
      payments = payments_fixture()
      assert Payment.get_payments!(payments.id) == payments
    end

    test "create_payments/1 with valid data creates a payments" do
      assert {:ok, %Payments{} = payments} = Payment.create_payments(@valid_attrs)
      assert payments.payment_type_description == "some payment_type_description"
      assert payments.system_id == 42
    end

    test "create_payments/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payment.create_payments(@invalid_attrs)
    end

    test "update_payments/2 with valid data updates the payments" do
      payments = payments_fixture()
      assert {:ok, %Payments{} = payments} = Payment.update_payments(payments, @update_attrs)
      assert payments.payment_type_description == "some updated payment_type_description"
      assert payments.system_id == 43
    end

    test "update_payments/2 with invalid data returns error changeset" do
      payments = payments_fixture()
      assert {:error, %Ecto.Changeset{}} = Payment.update_payments(payments, @invalid_attrs)
      assert payments == Payment.get_payments!(payments.id)
    end

    test "delete_payments/1 deletes the payments" do
      payments = payments_fixture()
      assert {:ok, %Payments{}} = Payment.delete_payments(payments)
      assert_raise Ecto.NoResultsError, fn -> Payment.get_payments!(payments.id) end
    end

    test "change_payments/1 returns a payments changeset" do
      payments = payments_fixture()
      assert %Ecto.Changeset{} = Payment.change_payments(payments)
    end
  end
end
