defmodule Loanmanagementsystem.RelationshipManagement do
  @moduledoc """
  The RelationshipManagement context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.RelationshipManagement.Leads
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Products.Product

  @doc """
  Returns the list of tbl_leads.

  ## Examples

      iex> list_tbl_leads()
      [%Leads{}, ...]

  """
  def list_tbl_leads do
    Repo.all(Leads)
  end

  @doc """
  Gets a single leads.

  Raises `Ecto.NoResultsError` if the Leads does not exist.

  ## Examples

      iex> get_leads!(123)
      %Leads{}

      iex> get_leads!(456)
      ** (Ecto.NoResultsError)
Loanmanagementsystem.RelationshipManagement.get_leads!
  """
  def get_leads!(id), do: Repo.get!(Leads, id)

  @doc """
  Creates a leads.

  ## Examples

      iex> create_leads(%{field: value})
      {:ok, %Leads{}}

      iex> create_leads(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leads(attrs \\ %{}) do
    %Leads{}
    |> Leads.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a leads.

  ## Examples

      iex> update_leads(leads, %{field: new_value})
      {:ok, %Leads{}}

      iex> update_leads(leads, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leads(%Leads{} = leads, attrs) do
    leads
    |> Leads.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a leads.

  ## Examples

      iex> delete_leads(leads)
      {:ok, %Leads{}}

      iex> delete_leads(leads)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leads(%Leads{} = leads) do
    Repo.delete(leads)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leads changes.

  ## Examples

      iex> change_leads(leads)
      %Ecto.Changeset{data: %Leads{}}

  """
  def change_leads(%Leads{} = leads, attrs \\ %{}) do
    Leads.changeset(leads, attrs)
  end

  alias Loanmanagementsystem.RelationshipManagement.Proposal

  @doc """
  Returns the list of tbl_proposal.

  ## Examples

      iex> list_tbl_proposal()
      [%Proposal{}, ...]

  """
  def list_tbl_proposal do
    Repo.all(Proposal)
  end

  @doc """
  Gets a single proposal.

  Raises `Ecto.NoResultsError` if the Proposal does not exist.

  ## Examples

      iex> get_proposal!(123)
      %Proposal{}

      iex> get_proposal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_proposal!(id), do: Repo.get!(Proposal, id)

  @doc """
  Creates a proposal.

  ## Examples

      iex> create_proposal(%{field: value})
      {:ok, %Proposal{}}

      iex> create_proposal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_proposal(attrs \\ %{}) do
    %Proposal{}
    |> Proposal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a proposal.

  ## Examples

      iex> update_proposal(proposal, %{field: new_value})
      {:ok, %Proposal{}}

      iex> update_proposal(proposal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_proposal(%Proposal{} = proposal, attrs) do
    proposal
    |> Proposal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a proposal.

  ## Examples

      iex> delete_proposal(proposal)
      {:ok, %Proposal{}}

      iex> delete_proposal(proposal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_proposal(%Proposal{} = proposal) do
    Repo.delete(proposal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking proposal changes.

  ## Examples

      iex> change_proposal(proposal)
      %Ecto.Changeset{data: %Proposal{}}

  """
  def change_proposal(%Proposal{} = proposal, attrs \\ %{}) do
    Proposal.changeset(proposal, attrs)
  end


  def active_loans_by_loan_officer(search_params, page, size) do
    Loans
    |> handle_active_loans_by_loan_officer_filter(search_params)
    # |> order_by([uL, uB, uC, l], desc: l.inserted_at)
    |> compose_active_loans_by_loan_officer_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def active_loans_by_loan_officer(_source, search_params) do
    Loans
    |> handle_active_loans_by_loan_officer_filter(search_params)
    # |> order_by([uL, uB, uC, l], desc: l.inserted_at)
    |> compose_active_loans_by_loan_officer_select()
  end

  defp compose_active_loans_by_loan_officer_select(query) do
    query
    |> join(:left, [uL], uB in UserRole, on: uL.loan_officer_id == uB.userId)
    |> join(:left, [uL], uC in UserBioData, on: uL.loan_officer_id == uC.userId)
    |> join(:left, [uL], l in User, on: uL.loan_officer_id == l.id)
    |> where([uL, uB, uC, l], uL.loan_status == "DISBURSED")
    |> group_by([uL, uB, uC], [uL.loan_officer_id, uL.loan_type, uC.firstName, uC.lastName, uC.otherName])
    |> select(
      [uL, uB, uC, l],
      %{
        total_initiated: count(l.id),
        name: (fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName)),
        loan_type: uL.loan_type,
        principal_amount: sum(uL.principal_amount),
        daily_accrued_interest: sum(uL.daily_accrued_interest),
        daily_accrued_finance_cost: sum(uL.daily_accrued_finance_cost),
        total_interest: sum(uL.daily_accrued_interest + uL.daily_accrued_finance_cost),
        balance: sum(uL.principal_amount + uL.daily_accrued_interest + uL.daily_accrued_finance_cost),
        loan_type: uL.loan_type
      }
    )
  end

  defp handle_active_loans_by_loan_officer_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_active_loans_by_loan_officer_fname_filter(search_params)
    |> handle_active_loans_by_loan_officer_lname_filter(search_params)
    |> handle_active_loans_by_loan_officer_product_filter(search_params)
  end

  defp handle_active_loans_by_loan_officer_fname_filter(query, %{"f_name" => f_name})
       when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
      [uL, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_active_loans_by_loan_officer_fname_filter(query, _params), do: query

  defp handle_active_loans_by_loan_officer_lname_filter(query, %{"l_name" => l_name})
       when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
      [uL, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_active_loans_by_loan_officer_lname_filter(query, _params), do: query

  defp handle_active_loans_by_loan_officer_product_filter(query, %{"p_type" => p_type})
       when byte_size(p_type) > 0 and byte_size(p_type) > 0 do
    query
    |> where(
      [uL],
      fragment("lower(?) LIKE lower(?)", uL.loan_type, ^p_type)
    )
  end
  defp handle_active_loans_by_loan_officer_product_filter(query, _params), do: query


  def due_collected_by_loan_officer(search_params, page, size) do
    Loans
    |> handle_due_collected_by_loan_officer_filter(search_params)
    # |> order_by([uL, uB, uC, l], desc: l.inserted_at)
    |> compose_adue_collected_by_loan_officer_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def due_collected_by_loan_officer(_source, search_params) do
    Loans
    |> handle_due_collected_by_loan_officer_filter(search_params)
    # |> order_by([uL, uB, uC, l], desc: l.inserted_at)
    |> compose_adue_collected_by_loan_officer_select()
  end

  defp compose_adue_collected_by_loan_officer_select(query) do
    query
    |> join(:left, [uL], uB in UserRole, on: uL.loan_officer_id == uB.userId)
    |> join(:left, [uL], uC in UserBioData, on: uL.loan_officer_id == uC.userId)
    |> join(:left, [uL], l in User, on: uL.loan_officer_id == l.id)
    # |> where([uL, uB, uC, l], uL.loan_status == "DISBURSED")
    # |> group_by([uL, uB, uC], [uL.loan_officer_id, uL.loan_type, uC.firstName, uC.lastName, uC.otherName])
    |> select(
      [uL, uB, uC, l],
      %{
        total_initiated: l.id,
        name: (fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName)),
        loan_type: uL.loan_type,
        principal_amount: uL.principal_amount,
        total_interest: uL.daily_accrued_interest,
        loan_type: uL.loan_type,
        total_repaid: uL.total_repaid,
        total_balance: (uL.principal_amount + uL.daily_accrued_interest + uL.daily_accrued_finance_cost),
        disbursedon_date: uL.disbursedon_date,
        principal_amount: uL.principal_amount,
        repayment_amount: uL.repayment_amount,
        total_repayment_derived: uL.total_repayment_derived,
        balance: uL.balance,
        loan_status: uL.loan_status
      }
    )
  end

defp handle_due_collected_by_loan_officer_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
  query
  |> handle_due_collected_by_loan_officer_fname_filter(search_params)
  |> handle_due_collected_by_loan_officer_lname_filter(search_params)
  |> handle_due_collected_by_loan_officer_p_type_filter(search_params)
  |> handle_due_collected_by_loan_officer_p_amount_filter(search_params)
  |> handle_due_collected_by_loan_officer_d_date_filter(search_params)
end

defp handle_due_collected_by_loan_officer_fname_filter(query, %{"f_name" => f_name})
  when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
  query
  |> where(
  [uL, uB, uC],
  fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
  )
end
defp handle_due_collected_by_loan_officer_fname_filter(query, _params), do: query

defp handle_due_collected_by_loan_officer_lname_filter(query, %{"l_name" => l_name})
  when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
  query
  |> where(
  [uL, uB, uC],
  fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
  )
end
defp handle_due_collected_by_loan_officer_lname_filter(query, _params), do: query

defp handle_due_collected_by_loan_officer_p_type_filter(query, %{"p_type" => p_type})
  when byte_size(p_type) > 0 and byte_size(p_type) > 0 do
  query
  |> where(
  [uL, uB, uC],
  fragment("lower(?) LIKE lower(?)", uL.loan_type, ^p_type)
  )
  end
defp handle_due_collected_by_loan_officer_p_type_filter(query, _params), do: query

defp handle_due_collected_by_loan_officer_p_amount_filter(query, %{"p_amount" => p_amount})
  when byte_size(p_amount) > 0 and byte_size(p_amount) > 0 do
  query
  |> where(
    [uL],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uL.principal_amount, ^p_amount)
  )
end
defp handle_due_collected_by_loan_officer_p_amount_filter(query, _params), do: query

defp handle_due_collected_by_loan_officer_d_date_filter(query, %{"from_d_date" => from_d_date, "to_d_date" => to_d_date})
  when byte_size(from_d_date) > 0 and byte_size(to_d_date) > 0 do
  query
  |> where(
    [uL],
    fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", uL.disbursedon_date, ^from_d_date) and
    fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", uL.disbursedon_date, ^to_d_date)
  )
end
defp handle_due_collected_by_loan_officer_d_date_filter(query, _params), do: query

end
