defmodule Loanmanagementsystem.RelationshipManagement do
  @moduledoc """
  The RelationshipManagement context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.RelationshipManagement.Leads

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
end
