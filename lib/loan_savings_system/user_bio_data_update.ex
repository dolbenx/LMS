defmodule LoanSavingsSystem.UserBioDataUpdate do
  @moduledoc """
  The UserBioDataUpdate context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates

  @doc """
  Returns the list of tbl_user_bio_data_update.

  ## Examples

      iex> list_tbl_user_bio_data_update()
      [%UserBioDataUpdates{}, ...]

  """
  def list_tbl_user_bio_data_update do
    Repo.all(UserBioDataUpdates)
  end

  @doc """
  Gets a single user_bio_data_updates.

  Raises `Ecto.NoResultsError` if the User bio data updates does not exist.

  ## Examples

      iex> get_user_bio_data_updates!(123)
      %UserBioDataUpdates{}

      iex> get_user_bio_data_updates!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_bio_data_updates!(id), do: Repo.get!(UserBioDataUpdates, id)

  @doc """
  Creates a user_bio_data_updates.

  ## Examples

      iex> create_user_bio_data_updates(%{field: value})
      {:ok, %UserBioDataUpdates{}}

      iex> create_user_bio_data_updates(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_bio_data_updates(attrs \\ %{}) do
    %UserBioDataUpdates{}
    |> UserBioDataUpdates.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_bio_data_updates.

  ## Examples

      iex> update_user_bio_data_updates(user_bio_data_updates, %{field: new_value})
      {:ok, %UserBioDataUpdates{}}

      iex> update_user_bio_data_updates(user_bio_data_updates, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_bio_data_updates(%UserBioDataUpdates{} = user_bio_data_updates, attrs) do
    user_bio_data_updates
    |> UserBioDataUpdates.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_bio_data_updates.

  ## Examples

      iex> delete_user_bio_data_updates(user_bio_data_updates)
      {:ok, %UserBioDataUpdates{}}

      iex> delete_user_bio_data_updates(user_bio_data_updates)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_bio_data_updates(%UserBioDataUpdates{} = user_bio_data_updates) do
    Repo.delete(user_bio_data_updates)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_bio_data_updates changes.

  ## Examples

      iex> change_user_bio_data_updates(user_bio_data_updates)
      %Ecto.Changeset{source: %UserBioDataUpdates{}}

  """
  def change_user_bio_data_updates(%UserBioDataUpdates{} = user_bio_data_updates) do
    UserBioDataUpdates.changeset(user_bio_data_updates, %{})
  end
end
