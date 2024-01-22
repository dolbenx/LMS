defmodule LoanSavingsSystem.ConfirmationNotification do
  @moduledoc """
  The ConfirmationNotification context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.ConfirmationNotification.ConfirmationLoanNotification

  @doc """
  Returns the list of tbl_confirmation_notification.

  ## Examples

      iex> list_tbl_confirmation_notification()
      [%ConfirmationLoanNotification{}, ...]

  """
  def list_tbl_confirmation_notification do
    Repo.all(ConfirmationLoanNotification)
  end

  @doc """
  Gets a single confirmation_loan_notification.

  Raises `Ecto.NoResultsError` if the Confirmation loan notification does not exist.

  ## Examples

      iex> get_confirmation_loan_notification!(123)
      %ConfirmationLoanNotification{}

      iex> get_confirmation_loan_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_confirmation_loan_notification!(id), do: Repo.get!(ConfirmationLoanNotification, id)

  @doc """
  Creates a confirmation_loan_notification.

  ## Examples

      iex> create_confirmation_loan_notification(%{field: value})
      {:ok, %ConfirmationLoanNotification{}}

      iex> create_confirmation_loan_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_confirmation_loan_notification(attrs \\ %{}) do
    %ConfirmationLoanNotification{}
    |> ConfirmationLoanNotification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a confirmation_loan_notification.

  ## Examples

      iex> update_confirmation_loan_notification(confirmation_loan_notification, %{field: new_value})
      {:ok, %ConfirmationLoanNotification{}}

      iex> update_confirmation_loan_notification(confirmation_loan_notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_confirmation_loan_notification(%ConfirmationLoanNotification{} = confirmation_loan_notification, attrs) do
    confirmation_loan_notification
    |> ConfirmationLoanNotification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a confirmation_loan_notification.

  ## Examples

      iex> delete_confirmation_loan_notification(confirmation_loan_notification)
      {:ok, %ConfirmationLoanNotification{}}

      iex> delete_confirmation_loan_notification(confirmation_loan_notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_confirmation_loan_notification(%ConfirmationLoanNotification{} = confirmation_loan_notification) do
    Repo.delete(confirmation_loan_notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking confirmation_loan_notification changes.

  ## Examples

      iex> change_confirmation_loan_notification(confirmation_loan_notification)
      %Ecto.Changeset{source: %ConfirmationLoanNotification{}}

  """
  def change_confirmation_loan_notification(%ConfirmationLoanNotification{} = confirmation_loan_notification) do
    ConfirmationLoanNotification.changeset(confirmation_loan_notification, %{})
  end
end
