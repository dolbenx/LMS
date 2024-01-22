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
        uploafile_name: a.uploafile_name
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
end
