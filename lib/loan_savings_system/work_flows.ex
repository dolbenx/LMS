defmodule LoanSavingsSystem.WorkFlows do
  @moduledoc """
  The WorkFlows context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.WorkFlows.WorkFlow

  @doc """
  Returns the list of tbl_workflows.

  ## Examples

      iex> list_tbl_workflows()
      [%WorkFlow{}, ...]

  """
  def list_tbl_workflows do
    Repo.all(WorkFlow)
  end

  @doc """
  Gets a single work_flow.

  Raises `Ecto.NoResultsError` if the Work flow does not exist.

  ## Examples

      iex> get_work_flow!(123)
      %WorkFlow{}

      iex> get_work_flow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_flow!(id), do: Repo.get!(WorkFlow, id)

  @doc """
  Creates a work_flow.

  ## Examples

      iex> create_work_flow(%{field: value})
      {:ok, %WorkFlow{}}

      iex> create_work_flow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_flow(attrs \\ %{}) do
    %WorkFlow{}
    |> WorkFlow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_flow.

  ## Examples

      iex> update_work_flow(work_flow, %{field: new_value})
      {:ok, %WorkFlow{}}

      iex> update_work_flow(work_flow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_flow(%WorkFlow{} = work_flow, attrs) do
    work_flow
    |> WorkFlow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_flow.

  ## Examples

      iex> delete_work_flow(work_flow)
      {:ok, %WorkFlow{}}

      iex> delete_work_flow(work_flow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_flow(%WorkFlow{} = work_flow) do
    Repo.delete(work_flow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_flow changes.

  ## Examples

      iex> change_work_flow(work_flow)
      %Ecto.Changeset{source: %WorkFlow{}}

  """
  def change_work_flow(%WorkFlow{} = work_flow) do
    WorkFlow.changeset(work_flow, %{})
  end

  alias LoanSavingsSystem.WorkFlows.WorkFlowItem

  @doc """
  Returns the list of tbl_workflow_items.

  ## Examples

      iex> list_tbl_workflow_items()
      [%WorkFlowItem{}, ...]

  """
  def list_tbl_workflow_items do
    Repo.all(WorkFlowItem)
  end

  @doc """
  Gets a single work_flow_item.

  Raises `Ecto.NoResultsError` if the Work flow item does not exist.

  ## Examples

      iex> get_work_flow_item!(123)
      %WorkFlowItem{}

      iex> get_work_flow_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_flow_item!(id), do: Repo.get!(WorkFlowItem, id)

  @doc """
  Creates a work_flow_item.

  ## Examples

      iex> create_work_flow_item(%{field: value})
      {:ok, %WorkFlowItem{}}

      iex> create_work_flow_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_flow_item(attrs \\ %{}) do
    %WorkFlowItem{}
    |> WorkFlowItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_flow_item.

  ## Examples

      iex> update_work_flow_item(work_flow_item, %{field: new_value})
      {:ok, %WorkFlowItem{}}

      iex> update_work_flow_item(work_flow_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_flow_item(%WorkFlowItem{} = work_flow_item, attrs) do
    work_flow_item
    |> WorkFlowItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_flow_item.

  ## Examples

      iex> delete_work_flow_item(work_flow_item)
      {:ok, %WorkFlowItem{}}

      iex> delete_work_flow_item(work_flow_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_flow_item(%WorkFlowItem{} = work_flow_item) do
    Repo.delete(work_flow_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_flow_item changes.

  ## Examples

      iex> change_work_flow_item(work_flow_item)
      %Ecto.Changeset{source: %WorkFlowItem{}}

  """
  def change_work_flow_item(%WorkFlowItem{} = work_flow_item) do
    WorkFlowItem.changeset(work_flow_item, %{})
  end

  alias LoanSavingsSystem.WorkFlows.WorkFlowMember

  @doc """
  Returns the list of tbl_workflow_members.

  ## Examples

      iex> list_tbl_workflow_members()
      [%WorkFlowMember{}, ...]

  """
  def list_tbl_workflow_members do
    Repo.all(WorkFlowMember)
  end

  @doc """
  Gets a single work_flow_member.

  Raises `Ecto.NoResultsError` if the Work flow member does not exist.

  ## Examples

      iex> get_work_flow_member!(123)
      %WorkFlowMember{}

      iex> get_work_flow_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_flow_member!(id), do: Repo.get!(WorkFlowMember, id)

  @doc """
  Creates a work_flow_member.

  ## Examples

      iex> create_work_flow_member(%{field: value})
      {:ok, %WorkFlowMember{}}

      iex> create_work_flow_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_flow_member(attrs \\ %{}) do
    %WorkFlowMember{}
    |> WorkFlowMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_flow_member.

  ## Examples

      iex> update_work_flow_member(work_flow_member, %{field: new_value})
      {:ok, %WorkFlowMember{}}

      iex> update_work_flow_member(work_flow_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_flow_member(%WorkFlowMember{} = work_flow_member, attrs) do
    work_flow_member
    |> WorkFlowMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work_flow_member.

  ## Examples

      iex> delete_work_flow_member(work_flow_member)
      {:ok, %WorkFlowMember{}}

      iex> delete_work_flow_member(work_flow_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_flow_member(%WorkFlowMember{} = work_flow_member) do
    Repo.delete(work_flow_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_flow_member changes.

  ## Examples

      iex> change_work_flow_member(work_flow_member)
      %Ecto.Changeset{source: %WorkFlowMember{}}

  """
  def change_work_flow_member(%WorkFlowMember{} = work_flow_member) do
    WorkFlowMember.changeset(work_flow_member, %{})
  end


end
