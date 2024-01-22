defmodule LoanSavingsSystem.Customer_scoresTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Customer_scores

  describe "tbl_customer_score" do
    alias LoanSavingsSystem.Customer_scores.Customer_score

    @valid_attrs %{customer_id: "some customer_id", score_entry: "some score_entry"}
    @update_attrs %{customer_id: "some updated customer_id", score_entry: "some updated score_entry"}
    @invalid_attrs %{customer_id: nil, score_entry: nil}

    def customer_score_fixture(attrs \\ %{}) do
      {:ok, customer_score} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customer_scores.create_customer_score()

      customer_score
    end

    test "list_tbl_customer_score/0 returns all tbl_customer_score" do
      customer_score = customer_score_fixture()
      assert Customer_scores.list_tbl_customer_score() == [customer_score]
    end

    test "get_customer_score!/1 returns the customer_score with given id" do
      customer_score = customer_score_fixture()
      assert Customer_scores.get_customer_score!(customer_score.id) == customer_score
    end

    test "create_customer_score/1 with valid data creates a customer_score" do
      assert {:ok, %Customer_score{} = customer_score} = Customer_scores.create_customer_score(@valid_attrs)
      assert customer_score.customer_id == "some customer_id"
      assert customer_score.score_entry == "some score_entry"
    end

    test "create_customer_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customer_scores.create_customer_score(@invalid_attrs)
    end

    test "update_customer_score/2 with valid data updates the customer_score" do
      customer_score = customer_score_fixture()
      assert {:ok, %Customer_score{} = customer_score} = Customer_scores.update_customer_score(customer_score, @update_attrs)
      assert customer_score.customer_id == "some updated customer_id"
      assert customer_score.score_entry == "some updated score_entry"
    end

    test "update_customer_score/2 with invalid data returns error changeset" do
      customer_score = customer_score_fixture()
      assert {:error, %Ecto.Changeset{}} = Customer_scores.update_customer_score(customer_score, @invalid_attrs)
      assert customer_score == Customer_scores.get_customer_score!(customer_score.id)
    end

    test "delete_customer_score/1 deletes the customer_score" do
      customer_score = customer_score_fixture()
      assert {:ok, %Customer_score{}} = Customer_scores.delete_customer_score(customer_score)
      assert_raise Ecto.NoResultsError, fn -> Customer_scores.get_customer_score!(customer_score.id) end
    end

    test "change_customer_score/1 returns a customer_score changeset" do
      customer_score = customer_score_fixture()
      assert %Ecto.Changeset{} = Customer_scores.change_customer_score(customer_score)
    end
  end
end
