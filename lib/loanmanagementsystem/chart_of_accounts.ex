defmodule Loanmanagementsystem.Chart_of_accounts do
  @moduledoc """
  The Chart_of_accounts context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Chart_of_accounts.Chart_of_account

  @doc """
  Returns the list of tbl_chart_of_accounts.

  ## Examples

      iex> list_tbl_chart_of_accounts()
      [%Chart_of_account{}, ...]

  """
  # Loanmanagementsystem.Chart_of_accounts.list_tbl_chart_of_accounts
  def list_tbl_chart_of_accounts do
    Repo.all(Chart_of_account)
  end

  def list_tbl_chart_of_accounts_all_gl do
    Chart_of_account
    |> order_by([a], desc: a.inserted_at)
    |> Repo.all()
  end

  def list_tbl_chart_of_accounts_leaf do
    Chart_of_account
    |> where(
      [a],
      a.leaf_or_node == "DETAIL" and
        a.auth_status == "AUTHORISED"
    )
    |> select([a], a)
    |> Repo.all()
  end


  def list_tbl_chart_of_accounts_gl(search_params, page, size) do
    Chart_of_account
    |> handle_chart_of_accounts_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_chart_of_accounts_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def list_tbl_chart_of_accounts_gl(_source, search_params) do
    Chart_of_account
    |> handle_chart_of_accounts_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_chart_of_accounts_list()
  end

  defp handle_chart_of_accounts_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
    query
    |> handle_ac_gl_no_filter(search_params)
    |> handle_leaf_or_node_filter(search_params)
    |> handle_gl_branch_res_filter(search_params)
    |> handle_node_gl_filter(search_params)
    |> handle_gl_category_filter(search_params)
    |> handle_ac_gl_descption_filter(search_params)
    |> handle_node_gl_filter(search_params)
    |> handle_created_date_filter(search_params)
  end

  defp handle_chart_of_accounts_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_chart_of_accounts_isearch_filter(query, search_term)
  end

  defp compose_chart_of_accounts_isearch_filter(query, search_term) do
    query
    |> where(
      [a],
      fragment("lower(?) LIKE lower(?)", a.ac_gl_no, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.leaf_or_node, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.ac_gl_descption, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.node_gl, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.gl_category, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.gl_branch_res, ^search_term)
    )
  end

  defp handle_ac_gl_no_filter(query, %{"filter_ac_gl_no" => filter_ac_gl_no}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.ac_gl_no, ^"%#{filter_ac_gl_no}%"))
  end

  defp handle_ac_gl_no_filter(query, %{"filter_ac_gl_no" => filter_ac_gl_no})
       when filter_ac_gl_no == "" or is_nil(filter_ac_gl_no),
       do: query

 defp handle_leaf_or_node_filter(query, %{"filter_leaf_or_node" => filter_leaf_or_node}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.leaf_or_node, ^"%#{filter_leaf_or_node}%"))
  end

  defp handle_leaf_or_node_filter(query, %{"filter_leaf_or_node" => filter_leaf_or_node})
        when filter_leaf_or_node == "" or is_nil(filter_leaf_or_node),
        do: query

  defp handle_gl_branch_res_filter(query, %{"filter_gl_branch_res" => filter_gl_branch_res}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.gl_branch_res, ^"%#{filter_gl_branch_res}%"))
  end

  defp handle_gl_branch_res_filter(query, %{"filter_gl_branch_res" => filter_gl_branch_res})
        when filter_gl_branch_res == "" or is_nil(filter_gl_branch_res),
        do: query

  defp handle_ac_gl_descption_filter(query, %{"filter_ac_gl_descption" => filter_ac_gl_descption}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.ac_gl_descption, ^"%#{filter_ac_gl_descption}%"))
  end

  defp handle_ac_gl_descption_filter(query, %{"filter_ac_gl_descption" => filter_ac_gl_descption})
        when filter_ac_gl_descption == "" or is_nil(filter_ac_gl_descption),
        do: query

  defp handle_node_gl_filter(query, %{"filter_node_gl" => filter_node_gl}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.node_gl, ^"%#{filter_node_gl}%"))
  end

  defp handle_node_gl_filter(query, %{"filter_node_gl" => filter_node_gl})
        when filter_node_gl == "" or is_nil(filter_node_gl),
        do: query

  defp handle_gl_category_filter(query, %{"filter_node_gl" => filter_node_gl}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.node_gl, ^"%#{filter_node_gl}%"))
  end

  defp handle_gl_category_filter(query, %{"filter_node_gl" => filter_node_gl})
        when filter_node_gl == "" or is_nil(filter_node_gl),
        do: query

  defp handle_created_date_filter(query, %{"start_date" => start_date, "end_date" => end_date})
  when byte_size(start_date) > 0 and byte_size(end_date) > 0 do
      query
      |> where(
        [a],
        fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", a.inserted_at, ^start_date) and
          fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", a.inserted_at, ^end_date)
      )
   end

   defp handle_created_date_filter(query, _params), do: query


  defp compose_chart_of_accounts_list(query) do
    query
    |> select(
      [a],
      %{
        id: a.id,
        ac_gl_no: a.ac_gl_no,
        ac_ccy_res: a.ac_ccy_res,
        ac_gl_descption: a.ac_gl_descption,
        ac_open_date: a.ac_open_date,
        ac_or_gl: a.ac_or_gl,
        ac_status: a.ac_status,
        alt_ac_no: a.alt_ac_no,
        auth_status: a.auth_status,
        branch_code: a.branch_code,
        cust_name: a.cust_name,
        cust_no: a.cust_no,
        gl_branch_res: a.gl_branch_res,
        gl_category: a.gl_category,
        gl_post_type: a.gl_post_type,
        gl_type: a.gl_type,
        leaf_or_node: a.leaf_or_node,
        node_gl: a.node_gl,
        overall_limit: a.overall_limit,
        revaluation: a.revaluation,
        uploafile_name: a.uploafile_name,
        ac_gl_ccy: a.ac_gl_ccy
      }
    )
  end

  @doc """
  Gets a single chart_of_account.

  Raises `Ecto.NoResultsError` if the Chart of account does not exist.

  ## Examples

      iex> get_chart_of_account!(123)
      %Chart_of_account{}

      iex> get_chart_of_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chart_of_account!(id), do: Repo.get!(Chart_of_account, id)

  @doc """
  Creates a chart_of_account.

  ## Examples

      iex> create_chart_of_account(%{field: value})
      {:ok, %Chart_of_account{}}

      iex> create_chart_of_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chart_of_account(attrs \\ %{}) do
    %Chart_of_account{}
    |> Chart_of_account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chart_of_account.

  ## Examples

      iex> update_chart_of_account(chart_of_account, %{field: new_value})
      {:ok, %Chart_of_account{}}

      iex> update_chart_of_account(chart_of_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # Loanmanagementsystem.Chart_of_accounts.get_expense_and_liability_accounts
  def get_expense_and_liability_accounts() do
    Chart_of_account
    |> where(
      [cA],
      (cA.ac_status == ^"ACTIVE" or cA.auth_status == ^"AUTHORISED") and
        (cA.gl_category == ^"Expenses" or cA.gl_category == ^"Liabilities")
    )
    |> select([cA], %{
      id: cA.id,
      ac_gl_ccy: cA.ac_gl_ccy,
      ac_ccy_res: cA.ac_ccy_res,
      ac_gl_descption: cA.ac_gl_descption,
      ac_gl_no: cA.ac_gl_no,
      ac_open_date: cA.ac_open_date,
      ac_or_gl: cA.ac_or_gl,
      ac_status: cA.ac_status,
      alt_ac_no: cA.alt_ac_no,
      auth_status: cA.auth_status,
      branch_code: cA.branch_code,
      cust_name: cA.cust_name,
      cust_no: cA.cust_no,
      gl_branch_res: cA.gl_branch_res,
      gl_category: cA.gl_category,
      gl_post_type: cA.gl_post_type,
      gl_type: cA.gl_type,
      leaf_or_node: cA.leaf_or_node,
      node_gl: cA.leaf_or_node,
      overall_limit: cA.overall_limit,
      revaluation: cA.revaluation,
      uploafile_name: cA.uploafile_name
    })
    |> Repo.all()
  end

  def update_chart_of_account(%Chart_of_account{} = chart_of_account, attrs) do
    chart_of_account
    |> Chart_of_account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a chart_of_account.

  ## Examples

      iex> delete_chart_of_account(chart_of_account)
      {:ok, %Chart_of_account{}}

      iex> delete_chart_of_account(chart_of_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chart_of_account(%Chart_of_account{} = chart_of_account) do
    Repo.delete(chart_of_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chart_of_account changes.

  ## Examples

      iex> change_chart_of_account(chart_of_account)
      %Ecto.Changeset{data: %Chart_of_account{}}

  """
  def change_chart_of_account(%Chart_of_account{} = chart_of_account, attrs \\ %{}) do
    Chart_of_account.changeset(chart_of_account, attrs)
  end

  alias Loanmanagementsystem.Chart_of_accounts.Gl_balance

  @doc """
  Returns the list of tbl_gl_balance.

  ## Examples

      iex> list_tbl_gl_balance()
      [%Gl_balance{}, ...]

  """
  def list_tbl_gl_balance do
    Repo.all(Gl_balance)
  end

  @doc """
  Gets a single gl_balance.

  Raises `Ecto.NoResultsError` if the Gl balance does not exist.

  ## Examples

      iex> get_gl_balance!(123)
      %Gl_balance{}

      iex> get_gl_balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gl_balance!(id), do: Repo.get!(Gl_balance, id)

  @doc """
  Creates a gl_balance.

  ## Examples

      iex> create_gl_balance(%{field: value})
      {:ok, %Gl_balance{}}

      iex> create_gl_balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gl_balance(attrs \\ %{}) do
    %Gl_balance{}
    |> Gl_balance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gl_balance.

  ## Examples

      iex> update_gl_balance(gl_balance, %{field: new_value})
      {:ok, %Gl_balance{}}

      iex> update_gl_balance(gl_balance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gl_balance(%Gl_balance{} = gl_balance, attrs) do
    gl_balance
    |> Gl_balance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gl_balance.

  ## Examples

      iex> delete_gl_balance(gl_balance)
      {:ok, %Gl_balance{}}

      iex> delete_gl_balance(gl_balance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gl_balance(%Gl_balance{} = gl_balance) do
    Repo.delete(gl_balance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gl_balance changes.

  ## Examples

      iex> change_gl_balance(gl_balance)
      %Ecto.Changeset{data: %Gl_balance{}}

  """
  def change_gl_balance(%Gl_balance{} = gl_balance, attrs \\ %{}) do
    Gl_balance.changeset(gl_balance, attrs)
  end


  alias Loanmanagementsystem.Chart_of_accounts.Gl_daily__balance

  @doc """
  Returns the list of tbl_gl_daily_balance.

  ## Examples

      iex> list_tbl_gl_daily_balance()
      [%Gl_daily__balance{}, ...]

  """
  def list_tbl_gl_daily_balance do
    Repo.all(Gl_daily__balance)
  end

  @doc """
  Gets a single gl_daily__balance.

  Raises `Ecto.NoResultsError` if the Gl daily  balance does not exist.

  ## Examples

      iex> get_gl_daily__balance!(123)
      %Gl_daily__balance{}

      iex> get_gl_daily__balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gl_daily__balance!(id), do: Repo.get!(Gl_daily__balance, id)

  @doc """
  Creates a gl_daily__balance.

  ## Examples

      iex> create_gl_daily__balance(%{field: value})
      {:ok, %Gl_daily__balance{}}

      iex> create_gl_daily__balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gl_daily__balance(attrs \\ %{}) do
    %Gl_daily__balance{}
    |> Gl_daily__balance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gl_daily__balance.

  ## Examples

      iex> update_gl_daily__balance(gl_daily__balance, %{field: new_value})
      {:ok, %Gl_daily__balance{}}

      iex> update_gl_daily__balance(gl_daily__balance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gl_daily__balance(%Gl_daily__balance{} = gl_daily__balance, attrs) do
    gl_daily__balance
    |> Gl_daily__balance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gl_daily__balance.

  ## Examples

      iex> delete_gl_daily__balance(gl_daily__balance)
      {:ok, %Gl_daily__balance{}}

      iex> delete_gl_daily__balance(gl_daily__balance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gl_daily__balance(%Gl_daily__balance{} = gl_daily__balance) do
    Repo.delete(gl_daily__balance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gl_daily__balance changes.

  ## Examples

      iex> change_gl_daily__balance(gl_daily__balance)
      %Ecto.Changeset{data: %Gl_daily__balance{}}

  """
  def change_gl_daily__balance(%Gl_daily__balance{} = gl_daily__balance, attrs \\ %{}) do
    Gl_daily__balance.changeset(gl_daily__balance, attrs)
  end

  alias Loanmanagementsystem.Chart_of_accounts.Accounts_mgt

  @doc """
  Returns the list of tbl_accounts_mgt.

  ## Examples

      iex> list_tbl_accounts_mgt()
      [%Accounts_mgt{}, ...]

  """
  def list_tbl_accounts_mgt do
    Repo.all(Accounts_mgt)
  end

  @doc """
  Gets a single accounts_mgt.

  Raises `Ecto.NoResultsError` if the Accounts mgt does not exist.

  ## Examples

      iex> get_accounts_mgt!(123)
      %Accounts_mgt{}

      iex> get_accounts_mgt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_accounts_mgt!(id), do: Repo.get!(Accounts_mgt, id)

  @doc """
  Creates a accounts_mgt.

  ## Examples

      iex> create_accounts_mgt(%{field: value})
      {:ok, %Accounts_mgt{}}

      iex> create_accounts_mgt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_accounts_mgt(attrs \\ %{}) do
    %Accounts_mgt{}
    |> Accounts_mgt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a accounts_mgt.

  ## Examples

      iex> update_accounts_mgt(accounts_mgt, %{field: new_value})
      {:ok, %Accounts_mgt{}}

      iex> update_accounts_mgt(accounts_mgt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_accounts_mgt(%Accounts_mgt{} = accounts_mgt, attrs) do
    accounts_mgt
    |> Accounts_mgt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a accounts_mgt.

  ## Examples

      iex> delete_accounts_mgt(accounts_mgt)
      {:ok, %Accounts_mgt{}}

      iex> delete_accounts_mgt(accounts_mgt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_accounts_mgt(%Accounts_mgt{} = accounts_mgt) do
    Repo.delete(accounts_mgt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking accounts_mgt changes.

  ## Examples

      iex> change_accounts_mgt(accounts_mgt)
      %Ecto.Changeset{data: %Accounts_mgt{}}

  """
  def change_accounts_mgt(%Accounts_mgt{} = accounts_mgt, attrs \\ %{}) do
    Accounts_mgt.changeset(accounts_mgt, attrs)
  end
end
