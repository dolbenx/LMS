defmodule LoanSavingsSystem.OfftakerTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Offtaker

  describe "tbl_off_taker" do
    alias LoanSavingsSystem.Offtaker.Offtakers

    @valid_attrs %{email: "some email", off_taker_id: "some off_taker_id", offtaker_name: "some offtaker_name", phone_number: "some phone_number", physical_address: "some physical_address", status: "some status"}
    @update_attrs %{email: "some updated email", off_taker_id: "some updated off_taker_id", offtaker_name: "some updated offtaker_name", phone_number: "some updated phone_number", physical_address: "some updated physical_address", status: "some updated status"}
    @invalid_attrs %{email: nil, off_taker_id: nil, offtaker_name: nil, phone_number: nil, physical_address: nil, status: nil}

    def offtakers_fixture(attrs \\ %{}) do
      {:ok, offtakers} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Offtaker.create_offtakers()

      offtakers
    end

    test "list_tbl_off_taker/0 returns all tbl_off_taker" do
      offtakers = offtakers_fixture()
      assert Offtaker.list_tbl_off_taker() == [offtakers]
    end

    test "get_offtakers!/1 returns the offtakers with given id" do
      offtakers = offtakers_fixture()
      assert Offtaker.get_offtakers!(offtakers.id) == offtakers
    end

    test "create_offtakers/1 with valid data creates a offtakers" do
      assert {:ok, %Offtakers{} = offtakers} = Offtaker.create_offtakers(@valid_attrs)
      assert offtakers.email == "some email"
      assert offtakers.off_taker_id == "some off_taker_id"
      assert offtakers.offtaker_name == "some offtaker_name"
      assert offtakers.phone_number == "some phone_number"
      assert offtakers.physical_address == "some physical_address"
      assert offtakers.status == "some status"
    end

    test "create_offtakers/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Offtaker.create_offtakers(@invalid_attrs)
    end

    test "update_offtakers/2 with valid data updates the offtakers" do
      offtakers = offtakers_fixture()
      assert {:ok, %Offtakers{} = offtakers} = Offtaker.update_offtakers(offtakers, @update_attrs)
      assert offtakers.email == "some updated email"
      assert offtakers.off_taker_id == "some updated off_taker_id"
      assert offtakers.offtaker_name == "some updated offtaker_name"
      assert offtakers.phone_number == "some updated phone_number"
      assert offtakers.physical_address == "some updated physical_address"
      assert offtakers.status == "some updated status"
    end

    test "update_offtakers/2 with invalid data returns error changeset" do
      offtakers = offtakers_fixture()
      assert {:error, %Ecto.Changeset{}} = Offtaker.update_offtakers(offtakers, @invalid_attrs)
      assert offtakers == Offtaker.get_offtakers!(offtakers.id)
    end

    test "delete_offtakers/1 deletes the offtakers" do
      offtakers = offtakers_fixture()
      assert {:ok, %Offtakers{}} = Offtaker.delete_offtakers(offtakers)
      assert_raise Ecto.NoResultsError, fn -> Offtaker.get_offtakers!(offtakers.id) end
    end

    test "change_offtakers/1 returns a offtakers changeset" do
      offtakers = offtakers_fixture()
      assert %Ecto.Changeset{} = Offtaker.change_offtakers(offtakers)
    end
  end
end
