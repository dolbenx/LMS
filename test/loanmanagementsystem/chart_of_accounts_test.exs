defmodule Loanmanagementsystem.Chart_of_accountsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Chart_of_accounts

  describe "tbl_chart_of_accounts" do
    alias Loanmanagementsystem.Chart_of_accounts.Chart_of_account

    @valid_attrs %{
      ac_gl_ccy: "some ac_gl_ccy",
      ac_gl_descption: "some ac_gl_descption",
      ac_gl_no: "some ac_gl_no",
      ac_open_date: "some ac_open_date",
      ac_or_gl: "some ac_or_gl",
      ac_status: "some ac_status",
      alt_ac_no: "some alt_ac_no",
      auth_status: "some auth_status",
      branch_code: "some branch_code",
      cust_name: "some cust_name",
      cust_no: "some cust_no",
      gl_branch_res: "some gl_branch_res",
      gl_category: "some gl_category",
      gl_post_type: "some gl_post_type",
      gl_type: "some gl_type",
      leaf_or_node: "some leaf_or_node",
      node_gl: "some node_gl",
      offline_limit: "some offline_limit",
      revaluation: "some revaluation"
    }
    @update_attrs %{
      ac_gl_ccy: "some updated ac_gl_ccy",
      ac_gl_descption: "some updated ac_gl_descption",
      ac_gl_no: "some updated ac_gl_no",
      ac_open_date: "some updated ac_open_date",
      ac_or_gl: "some updated ac_or_gl",
      ac_status: "some updated ac_status",
      alt_ac_no: "some updated alt_ac_no",
      auth_status: "some updated auth_status",
      branch_code: "some updated branch_code",
      cust_name: "some updated cust_name",
      cust_no: "some updated cust_no",
      gl_branch_res: "some updated gl_branch_res",
      gl_category: "some updated gl_category",
      gl_post_type: "some updated gl_post_type",
      gl_type: "some updated gl_type",
      leaf_or_node: "some updated leaf_or_node",
      node_gl: "some updated node_gl",
      offline_limit: "some updated offline_limit",
      revaluation: "some updated revaluation"
    }
    @invalid_attrs %{
      ac_gl_ccy: nil,
      ac_gl_descption: nil,
      ac_gl_no: nil,
      ac_open_date: nil,
      ac_or_gl: nil,
      ac_status: nil,
      alt_ac_no: nil,
      auth_status: nil,
      branch_code: nil,
      cust_name: nil,
      cust_no: nil,
      gl_branch_res: nil,
      gl_category: nil,
      gl_post_type: nil,
      gl_type: nil,
      leaf_or_node: nil,
      node_gl: nil,
      offline_limit: nil,
      revaluation: nil
    }

    def chart_of_account_fixture(attrs \\ %{}) do
      {:ok, chart_of_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chart_of_accounts.create_chart_of_account()

      chart_of_account
    end

    test "list_tbl_chart_of_accounts/0 returns all tbl_chart_of_accounts" do
      chart_of_account = chart_of_account_fixture()
      assert Chart_of_accounts.list_tbl_chart_of_accounts() == [chart_of_account]
    end

    test "get_chart_of_account!/1 returns the chart_of_account with given id" do
      chart_of_account = chart_of_account_fixture()
      assert Chart_of_accounts.get_chart_of_account!(chart_of_account.id) == chart_of_account
    end

    test "create_chart_of_account/1 with valid data creates a chart_of_account" do
      assert {:ok, %Chart_of_account{} = chart_of_account} =
               Chart_of_accounts.create_chart_of_account(@valid_attrs)

      assert chart_of_account.ac_gl_ccy == "some ac_gl_ccy"
      assert chart_of_account.ac_gl_descption == "some ac_gl_descption"
      assert chart_of_account.ac_gl_no == "some ac_gl_no"
      assert chart_of_account.ac_open_date == "some ac_open_date"
      assert chart_of_account.ac_or_gl == "some ac_or_gl"
      assert chart_of_account.ac_status == "some ac_status"
      assert chart_of_account.alt_ac_no == "some alt_ac_no"
      assert chart_of_account.auth_status == "some auth_status"
      assert chart_of_account.branch_code == "some branch_code"
      assert chart_of_account.cust_name == "some cust_name"
      assert chart_of_account.cust_no == "some cust_no"
      assert chart_of_account.gl_branch_res == "some gl_branch_res"
      assert chart_of_account.gl_category == "some gl_category"
      assert chart_of_account.gl_post_type == "some gl_post_type"
      assert chart_of_account.gl_type == "some gl_type"
      assert chart_of_account.leaf_or_node == "some leaf_or_node"
      assert chart_of_account.node_gl == "some node_gl"
      assert chart_of_account.offline_limit == "some offline_limit"
      assert chart_of_account.revaluation == "some revaluation"
    end

    test "create_chart_of_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Chart_of_accounts.create_chart_of_account(@invalid_attrs)
    end

    test "update_chart_of_account/2 with valid data updates the chart_of_account" do
      chart_of_account = chart_of_account_fixture()

      assert {:ok, %Chart_of_account{} = chart_of_account} =
               Chart_of_accounts.update_chart_of_account(chart_of_account, @update_attrs)

      assert chart_of_account.ac_gl_ccy == "some updated ac_gl_ccy"
      assert chart_of_account.ac_gl_descption == "some updated ac_gl_descption"
      assert chart_of_account.ac_gl_no == "some updated ac_gl_no"
      assert chart_of_account.ac_open_date == "some updated ac_open_date"
      assert chart_of_account.ac_or_gl == "some updated ac_or_gl"
      assert chart_of_account.ac_status == "some updated ac_status"
      assert chart_of_account.alt_ac_no == "some updated alt_ac_no"
      assert chart_of_account.auth_status == "some updated auth_status"
      assert chart_of_account.branch_code == "some updated branch_code"
      assert chart_of_account.cust_name == "some updated cust_name"
      assert chart_of_account.cust_no == "some updated cust_no"
      assert chart_of_account.gl_branch_res == "some updated gl_branch_res"
      assert chart_of_account.gl_category == "some updated gl_category"
      assert chart_of_account.gl_post_type == "some updated gl_post_type"
      assert chart_of_account.gl_type == "some updated gl_type"
      assert chart_of_account.leaf_or_node == "some updated leaf_or_node"
      assert chart_of_account.node_gl == "some updated node_gl"
      assert chart_of_account.offline_limit == "some updated offline_limit"
      assert chart_of_account.revaluation == "some updated revaluation"
    end

    test "update_chart_of_account/2 with invalid data returns error changeset" do
      chart_of_account = chart_of_account_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Chart_of_accounts.update_chart_of_account(chart_of_account, @invalid_attrs)

      assert chart_of_account == Chart_of_accounts.get_chart_of_account!(chart_of_account.id)
    end

    test "delete_chart_of_account/1 deletes the chart_of_account" do
      chart_of_account = chart_of_account_fixture()

      assert {:ok, %Chart_of_account{}} =
               Chart_of_accounts.delete_chart_of_account(chart_of_account)

      assert_raise Ecto.NoResultsError, fn ->
        Chart_of_accounts.get_chart_of_account!(chart_of_account.id)
      end
    end

    test "change_chart_of_account/1 returns a chart_of_account changeset" do
      chart_of_account = chart_of_account_fixture()
      assert %Ecto.Changeset{} = Chart_of_accounts.change_chart_of_account(chart_of_account)
    end
  end
end
