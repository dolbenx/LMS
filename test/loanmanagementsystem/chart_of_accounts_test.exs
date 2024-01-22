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

  describe "tbl_gl_balance" do
    alias Loanmanagementsystem.Chart_of_accounts.Gl_balance

    @valid_attrs %{account_gl_name: "some account_gl_name", account_gl_number: "some account_gl_number", cr_balance: "some cr_balance", currency: "some currency", dr_balance: "some dr_balance", fin_period: "some fin_period", fin_year: "some fin_year", gl_category: "some gl_category", gl_date: "some gl_date", gl_type: "some gl_type", node: "some node"}
    @update_attrs %{account_gl_name: "some updated account_gl_name", account_gl_number: "some updated account_gl_number", cr_balance: "some updated cr_balance", currency: "some updated currency", dr_balance: "some updated dr_balance", fin_period: "some updated fin_period", fin_year: "some updated fin_year", gl_category: "some updated gl_category", gl_date: "some updated gl_date", gl_type: "some updated gl_type", node: "some updated node"}
    @invalid_attrs %{account_gl_name: nil, account_gl_number: nil, cr_balance: nil, currency: nil, dr_balance: nil, fin_period: nil, fin_year: nil, gl_category: nil, gl_date: nil, gl_type: nil, node: nil}

    def gl_balance_fixture(attrs \\ %{}) do
      {:ok, gl_balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chart_of_accounts.create_gl_balance()

      gl_balance
    end

    test "list_tbl_gl_balance/0 returns all tbl_gl_balance" do
      gl_balance = gl_balance_fixture()
      assert Chart_of_accounts.list_tbl_gl_balance() == [gl_balance]
    end

    test "get_gl_balance!/1 returns the gl_balance with given id" do
      gl_balance = gl_balance_fixture()
      assert Chart_of_accounts.get_gl_balance!(gl_balance.id) == gl_balance
    end

    test "create_gl_balance/1 with valid data creates a gl_balance" do
      assert {:ok, %Gl_balance{} = gl_balance} = Chart_of_accounts.create_gl_balance(@valid_attrs)
      assert gl_balance.account_gl_name == "some account_gl_name"
      assert gl_balance.account_gl_number == "some account_gl_number"
      assert gl_balance.cr_balance == "some cr_balance"
      assert gl_balance.currency == "some currency"
      assert gl_balance.dr_balance == "some dr_balance"
      assert gl_balance.fin_period == "some fin_period"
      assert gl_balance.fin_year == "some fin_year"
      assert gl_balance.gl_category == "some gl_category"
      assert gl_balance.gl_date == "some gl_date"
      assert gl_balance.gl_type == "some gl_type"
      assert gl_balance.node == "some node"
    end

    test "create_gl_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.create_gl_balance(@invalid_attrs)
    end

    test "update_gl_balance/2 with valid data updates the gl_balance" do
      gl_balance = gl_balance_fixture()
      assert {:ok, %Gl_balance{} = gl_balance} = Chart_of_accounts.update_gl_balance(gl_balance, @update_attrs)
      assert gl_balance.account_gl_name == "some updated account_gl_name"
      assert gl_balance.account_gl_number == "some updated account_gl_number"
      assert gl_balance.cr_balance == "some updated cr_balance"
      assert gl_balance.currency == "some updated currency"
      assert gl_balance.dr_balance == "some updated dr_balance"
      assert gl_balance.fin_period == "some updated fin_period"
      assert gl_balance.fin_year == "some updated fin_year"
      assert gl_balance.gl_category == "some updated gl_category"
      assert gl_balance.gl_date == "some updated gl_date"
      assert gl_balance.gl_type == "some updated gl_type"
      assert gl_balance.node == "some updated node"
    end

    test "update_gl_balance/2 with invalid data returns error changeset" do
      gl_balance = gl_balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.update_gl_balance(gl_balance, @invalid_attrs)
      assert gl_balance == Chart_of_accounts.get_gl_balance!(gl_balance.id)
    end

    test "delete_gl_balance/1 deletes the gl_balance" do
      gl_balance = gl_balance_fixture()
      assert {:ok, %Gl_balance{}} = Chart_of_accounts.delete_gl_balance(gl_balance)
      assert_raise Ecto.NoResultsError, fn -> Chart_of_accounts.get_gl_balance!(gl_balance.id) end
    end

    test "change_gl_balance/1 returns a gl_balance changeset" do
      gl_balance = gl_balance_fixture()
      assert %Ecto.Changeset{} = Chart_of_accounts.change_gl_balance(gl_balance)
    end
  end

  describe "tbl_gl_daily_balance" do
    alias Loanmanagementsystem.Chart_of_accounts.Gl_balance

    @valid_attrs %{account_gl_name: "some account_gl_name", account_gl_number: "some account_gl_number", cr_balance: "120.5", currency: "some currency", dr_balance: "120.5", fin_period: "some fin_period", fin_year: "some fin_year", gl_category: "some gl_category", gl_date: ~D[2010-04-17], gl_type: "some gl_type", node: "some node"}
    @update_attrs %{account_gl_name: "some updated account_gl_name", account_gl_number: "some updated account_gl_number", cr_balance: "456.7", currency: "some updated currency", dr_balance: "456.7", fin_period: "some updated fin_period", fin_year: "some updated fin_year", gl_category: "some updated gl_category", gl_date: ~D[2011-05-18], gl_type: "some updated gl_type", node: "some updated node"}
    @invalid_attrs %{account_gl_name: nil, account_gl_number: nil, cr_balance: nil, currency: nil, dr_balance: nil, fin_period: nil, fin_year: nil, gl_category: nil, gl_date: nil, gl_type: nil, node: nil}

    def gl_balance_fixture(attrs \\ %{}) do
      {:ok, gl_balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chart_of_accounts.create_gl_balance()

      gl_balance
    end

    test "list_tbl_gl_daily_balance/0 returns all tbl_gl_daily_balance" do
      gl_balance = gl_balance_fixture()
      assert Chart_of_accounts.list_tbl_gl_daily_balance() == [gl_balance]
    end

    test "get_gl_balance!/1 returns the gl_balance with given id" do
      gl_balance = gl_balance_fixture()
      assert Chart_of_accounts.get_gl_balance!(gl_balance.id) == gl_balance
    end

    test "create_gl_balance/1 with valid data creates a gl_balance" do
      assert {:ok, %Gl_balance{} = gl_balance} = Chart_of_accounts.create_gl_balance(@valid_attrs)
      assert gl_balance.account_gl_name == "some account_gl_name"
      assert gl_balance.account_gl_number == "some account_gl_number"
      assert gl_balance.cr_balance == Decimal.new("120.5")
      assert gl_balance.currency == "some currency"
      assert gl_balance.dr_balance == Decimal.new("120.5")
      assert gl_balance.fin_period == "some fin_period"
      assert gl_balance.fin_year == "some fin_year"
      assert gl_balance.gl_category == "some gl_category"
      assert gl_balance.gl_date == ~D[2010-04-17]
      assert gl_balance.gl_type == "some gl_type"
      assert gl_balance.node == "some node"
    end

    test "create_gl_balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.create_gl_balance(@invalid_attrs)
    end

    test "update_gl_balance/2 with valid data updates the gl_balance" do
      gl_balance = gl_balance_fixture()
      assert {:ok, %Gl_balance{} = gl_balance} = Chart_of_accounts.update_gl_balance(gl_balance, @update_attrs)
      assert gl_balance.account_gl_name == "some updated account_gl_name"
      assert gl_balance.account_gl_number == "some updated account_gl_number"
      assert gl_balance.cr_balance == Decimal.new("456.7")
      assert gl_balance.currency == "some updated currency"
      assert gl_balance.dr_balance == Decimal.new("456.7")
      assert gl_balance.fin_period == "some updated fin_period"
      assert gl_balance.fin_year == "some updated fin_year"
      assert gl_balance.gl_category == "some updated gl_category"
      assert gl_balance.gl_date == ~D[2011-05-18]
      assert gl_balance.gl_type == "some updated gl_type"
      assert gl_balance.node == "some updated node"
    end

    test "update_gl_balance/2 with invalid data returns error changeset" do
      gl_balance = gl_balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.update_gl_balance(gl_balance, @invalid_attrs)
      assert gl_balance == Chart_of_accounts.get_gl_balance!(gl_balance.id)
    end

    test "delete_gl_balance/1 deletes the gl_balance" do
      gl_balance = gl_balance_fixture()
      assert {:ok, %Gl_balance{}} = Chart_of_accounts.delete_gl_balance(gl_balance)
      assert_raise Ecto.NoResultsError, fn -> Chart_of_accounts.get_gl_balance!(gl_balance.id) end
    end

    test "change_gl_balance/1 returns a gl_balance changeset" do
      gl_balance = gl_balance_fixture()
      assert %Ecto.Changeset{} = Chart_of_accounts.change_gl_balance(gl_balance)
    end
  end

  describe "tbl_gl_daily_balance" do
    alias Loanmanagementsystem.Chart_of_accounts.Gl_daily__balance

    @valid_attrs %{account_gl_name: "some account_gl_name", account_gl_number: "some account_gl_number", cr_balance: "120.5", currency: "some currency", dr_balance: "120.5", fin_period: "some fin_period", fin_year: "some fin_year", gl_category: "some gl_category", gl_date: ~D[2010-04-17], gl_type: "some gl_type", node: "some node"}
    @update_attrs %{account_gl_name: "some updated account_gl_name", account_gl_number: "some updated account_gl_number", cr_balance: "456.7", currency: "some updated currency", dr_balance: "456.7", fin_period: "some updated fin_period", fin_year: "some updated fin_year", gl_category: "some updated gl_category", gl_date: ~D[2011-05-18], gl_type: "some updated gl_type", node: "some updated node"}
    @invalid_attrs %{account_gl_name: nil, account_gl_number: nil, cr_balance: nil, currency: nil, dr_balance: nil, fin_period: nil, fin_year: nil, gl_category: nil, gl_date: nil, gl_type: nil, node: nil}

    def gl_daily__balance_fixture(attrs \\ %{}) do
      {:ok, gl_daily__balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chart_of_accounts.create_gl_daily__balance()

      gl_daily__balance
    end

    test "list_tbl_gl_daily_balance/0 returns all tbl_gl_daily_balance" do
      gl_daily__balance = gl_daily__balance_fixture()
      assert Chart_of_accounts.list_tbl_gl_daily_balance() == [gl_daily__balance]
    end

    test "get_gl_daily__balance!/1 returns the gl_daily__balance with given id" do
      gl_daily__balance = gl_daily__balance_fixture()
      assert Chart_of_accounts.get_gl_daily__balance!(gl_daily__balance.id) == gl_daily__balance
    end

    test "create_gl_daily__balance/1 with valid data creates a gl_daily__balance" do
      assert {:ok, %Gl_daily__balance{} = gl_daily__balance} = Chart_of_accounts.create_gl_daily__balance(@valid_attrs)
      assert gl_daily__balance.account_gl_name == "some account_gl_name"
      assert gl_daily__balance.account_gl_number == "some account_gl_number"
      assert gl_daily__balance.cr_balance == Decimal.new("120.5")
      assert gl_daily__balance.currency == "some currency"
      assert gl_daily__balance.dr_balance == Decimal.new("120.5")
      assert gl_daily__balance.fin_period == "some fin_period"
      assert gl_daily__balance.fin_year == "some fin_year"
      assert gl_daily__balance.gl_category == "some gl_category"
      assert gl_daily__balance.gl_date == ~D[2010-04-17]
      assert gl_daily__balance.gl_type == "some gl_type"
      assert gl_daily__balance.node == "some node"
    end

    test "create_gl_daily__balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.create_gl_daily__balance(@invalid_attrs)
    end

    test "update_gl_daily__balance/2 with valid data updates the gl_daily__balance" do
      gl_daily__balance = gl_daily__balance_fixture()
      assert {:ok, %Gl_daily__balance{} = gl_daily__balance} = Chart_of_accounts.update_gl_daily__balance(gl_daily__balance, @update_attrs)
      assert gl_daily__balance.account_gl_name == "some updated account_gl_name"
      assert gl_daily__balance.account_gl_number == "some updated account_gl_number"
      assert gl_daily__balance.cr_balance == Decimal.new("456.7")
      assert gl_daily__balance.currency == "some updated currency"
      assert gl_daily__balance.dr_balance == Decimal.new("456.7")
      assert gl_daily__balance.fin_period == "some updated fin_period"
      assert gl_daily__balance.fin_year == "some updated fin_year"
      assert gl_daily__balance.gl_category == "some updated gl_category"
      assert gl_daily__balance.gl_date == ~D[2011-05-18]
      assert gl_daily__balance.gl_type == "some updated gl_type"
      assert gl_daily__balance.node == "some updated node"
    end

    test "update_gl_daily__balance/2 with invalid data returns error changeset" do
      gl_daily__balance = gl_daily__balance_fixture()
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.update_gl_daily__balance(gl_daily__balance, @invalid_attrs)
      assert gl_daily__balance == Chart_of_accounts.get_gl_daily__balance!(gl_daily__balance.id)
    end

    test "delete_gl_daily__balance/1 deletes the gl_daily__balance" do
      gl_daily__balance = gl_daily__balance_fixture()
      assert {:ok, %Gl_daily__balance{}} = Chart_of_accounts.delete_gl_daily__balance(gl_daily__balance)
      assert_raise Ecto.NoResultsError, fn -> Chart_of_accounts.get_gl_daily__balance!(gl_daily__balance.id) end
    end

    test "change_gl_daily__balance/1 returns a gl_daily__balance changeset" do
      gl_daily__balance = gl_daily__balance_fixture()
      assert %Ecto.Changeset{} = Chart_of_accounts.change_gl_daily__balance(gl_daily__balance)
    end
  end

  describe "tbl_accounts_mgt" do
    alias Loanmanagementsystem.Chart_of_accounts.Accounts_mgt

    @valid_attrs %{account_name: "some account_name", account_no: "some account_no", status: "some status", type: "some type"}
    @update_attrs %{account_name: "some updated account_name", account_no: "some updated account_no", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{account_name: nil, account_no: nil, status: nil, type: nil}

    def accounts_mgt_fixture(attrs \\ %{}) do
      {:ok, accounts_mgt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chart_of_accounts.create_accounts_mgt()

      accounts_mgt
    end

    test "list_tbl_accounts_mgt/0 returns all tbl_accounts_mgt" do
      accounts_mgt = accounts_mgt_fixture()
      assert Chart_of_accounts.list_tbl_accounts_mgt() == [accounts_mgt]
    end

    test "get_accounts_mgt!/1 returns the accounts_mgt with given id" do
      accounts_mgt = accounts_mgt_fixture()
      assert Chart_of_accounts.get_accounts_mgt!(accounts_mgt.id) == accounts_mgt
    end

    test "create_accounts_mgt/1 with valid data creates a accounts_mgt" do
      assert {:ok, %Accounts_mgt{} = accounts_mgt} = Chart_of_accounts.create_accounts_mgt(@valid_attrs)
      assert accounts_mgt.account_name == "some account_name"
      assert accounts_mgt.account_no == "some account_no"
      assert accounts_mgt.status == "some status"
      assert accounts_mgt.type == "some type"
    end

    test "create_accounts_mgt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.create_accounts_mgt(@invalid_attrs)
    end

    test "update_accounts_mgt/2 with valid data updates the accounts_mgt" do
      accounts_mgt = accounts_mgt_fixture()
      assert {:ok, %Accounts_mgt{} = accounts_mgt} = Chart_of_accounts.update_accounts_mgt(accounts_mgt, @update_attrs)
      assert accounts_mgt.account_name == "some updated account_name"
      assert accounts_mgt.account_no == "some updated account_no"
      assert accounts_mgt.status == "some updated status"
      assert accounts_mgt.type == "some updated type"
    end

    test "update_accounts_mgt/2 with invalid data returns error changeset" do
      accounts_mgt = accounts_mgt_fixture()
      assert {:error, %Ecto.Changeset{}} = Chart_of_accounts.update_accounts_mgt(accounts_mgt, @invalid_attrs)
      assert accounts_mgt == Chart_of_accounts.get_accounts_mgt!(accounts_mgt.id)
    end

    test "delete_accounts_mgt/1 deletes the accounts_mgt" do
      accounts_mgt = accounts_mgt_fixture()
      assert {:ok, %Accounts_mgt{}} = Chart_of_accounts.delete_accounts_mgt(accounts_mgt)
      assert_raise Ecto.NoResultsError, fn -> Chart_of_accounts.get_accounts_mgt!(accounts_mgt.id) end
    end

    test "change_accounts_mgt/1 returns a accounts_mgt changeset" do
      accounts_mgt = accounts_mgt_fixture()
      assert %Ecto.Changeset{} = Chart_of_accounts.change_accounts_mgt(accounts_mgt)
    end
  end
end
