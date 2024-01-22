defmodule LoanSavingsSystem.IndividualsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Individuals

  describe "tbl_individual" do
    alias LoanSavingsSystem.Individuals.Individual

    @valid_attrs %{age: 42, email_address: "some email_address", first_name: "some first_name", gender: "some gender", home_address: "some home_address", id_number: 42, id_type: "some id_type", individual_id: 42, last_name: "some last_name", mobile_number: "some mobile_number", status: "some status", telco_id: 42, user_role: "some user_role"}
    @update_attrs %{age: 43, email_address: "some updated email_address", first_name: "some updated first_name", gender: "some updated gender", home_address: "some updated home_address", id_number: 43, id_type: "some updated id_type", individual_id: 43, last_name: "some updated last_name", mobile_number: "some updated mobile_number", status: "some updated status", telco_id: 43, user_role: "some updated user_role"}
    @invalid_attrs %{age: nil, email_address: nil, first_name: nil, gender: nil, home_address: nil, id_number: nil, id_type: nil, individual_id: nil, last_name: nil, mobile_number: nil, status: nil, telco_id: nil, user_role: nil}

    def individual_fixture(attrs \\ %{}) do
      {:ok, individual} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Individuals.create_individual()

      individual
    end

    test "list_tbl_individual/0 returns all tbl_individual" do
      individual = individual_fixture()
      assert Individuals.list_tbl_individual() == [individual]
    end

    test "get_individual!/1 returns the individual with given id" do
      individual = individual_fixture()
      assert Individuals.get_individual!(individual.id) == individual
    end

    test "create_individual/1 with valid data creates a individual" do
      assert {:ok, %Individual{} = individual} = Individuals.create_individual(@valid_attrs)
      assert individual.age == 42
      assert individual.email_address == "some email_address"
      assert individual.first_name == "some first_name"
      assert individual.gender == "some gender"
      assert individual.home_address == "some home_address"
      assert individual.id_number == 42
      assert individual.id_type == "some id_type"
      assert individual.individual_id == 42
      assert individual.last_name == "some last_name"
      assert individual.mobile_number == "some mobile_number"
      assert individual.status == "some status"
      assert individual.telco_id == 42
      assert individual.user_role == "some user_role"
    end

    test "create_individual/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Individuals.create_individual(@invalid_attrs)
    end

    test "update_individual/2 with valid data updates the individual" do
      individual = individual_fixture()
      assert {:ok, %Individual{} = individual} = Individuals.update_individual(individual, @update_attrs)
      assert individual.age == 43
      assert individual.email_address == "some updated email_address"
      assert individual.first_name == "some updated first_name"
      assert individual.gender == "some updated gender"
      assert individual.home_address == "some updated home_address"
      assert individual.id_number == 43
      assert individual.id_type == "some updated id_type"
      assert individual.individual_id == 43
      assert individual.last_name == "some updated last_name"
      assert individual.mobile_number == "some updated mobile_number"
      assert individual.status == "some updated status"
      assert individual.telco_id == 43
      assert individual.user_role == "some updated user_role"
    end

    test "update_individual/2 with invalid data returns error changeset" do
      individual = individual_fixture()
      assert {:error, %Ecto.Changeset{}} = Individuals.update_individual(individual, @invalid_attrs)
      assert individual == Individuals.get_individual!(individual.id)
    end

    test "delete_individual/1 deletes the individual" do
      individual = individual_fixture()
      assert {:ok, %Individual{}} = Individuals.delete_individual(individual)
      assert_raise Ecto.NoResultsError, fn -> Individuals.get_individual!(individual.id) end
    end

    test "change_individual/1 returns a individual changeset" do
      individual = individual_fixture()
      assert %Ecto.Changeset{} = Individuals.change_individual(individual)
    end
  end
end
