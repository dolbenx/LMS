defmodule Loanmanagementsystem.Email_configs do
  @moduledoc """
  The Email_configs context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Email_configs.Email_config_sender

  @doc """
  Returns the list of tbl_email_sender.

  ## Examples

      iex> list_tbl_email_sender()
      [%Email_config_sender{}, ...]

  """
  def list_tbl_email_sender do
    Repo.all(Email_config_sender)
  end

  @doc """
  Gets a single email_config_sender.

  Raises `Ecto.NoResultsError` if the Email config sender does not exist.

  ## Examples

      iex> get_email_config_sender!(123)
      %Email_config_sender{}

      iex> get_email_config_sender!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email_config_sender!(id), do: Repo.get!(Email_config_sender, id)

  @doc """
  Creates a email_config_sender.

  ## Examples

      iex> create_email_config_sender(%{field: value})
      {:ok, %Email_config_sender{}}

      iex> create_email_config_sender(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email_config_sender(attrs \\ %{}) do
    %Email_config_sender{}
    |> Email_config_sender.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a email_config_sender.

  ## Examples

      iex> update_email_config_sender(email_config_sender, %{field: new_value})
      {:ok, %Email_config_sender{}}

      iex> update_email_config_sender(email_config_sender, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email_config_sender(%Email_config_sender{} = email_config_sender, attrs) do
    email_config_sender
    |> Email_config_sender.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a email_config_sender.

  ## Examples

      iex> delete_email_config_sender(email_config_sender)
      {:ok, %Email_config_sender{}}

      iex> delete_email_config_sender(email_config_sender)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email_config_sender(%Email_config_sender{} = email_config_sender) do
    Repo.delete(email_config_sender)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email_config_sender changes.

  ## Examples

      iex> change_email_config_sender(email_config_sender)
      %Ecto.Changeset{data: %Email_config_sender{}}

  """
  def change_email_config_sender(%Email_config_sender{} = email_config_sender, attrs \\ %{}) do
    Email_config_sender.changeset(email_config_sender, attrs)
  end

  alias Loanmanagementsystem.Email_configs.Email_config_receiver

  @doc """
  Returns the list of tbl_email_receiver.

  ## Examples

      iex> list_tbl_email_receiver()
      [%Email_config_receiver{}, ...]

  """
  def list_tbl_email_receiver do
    Repo.all(Email_config_receiver)
  end

  @doc """
  Gets a single email_config_receiver.

  Raises `Ecto.NoResultsError` if the Email config receiver does not exist.

  ## Examples

      iex> get_email_config_receiver!(123)
      %Email_config_receiver{}

      iex> get_email_config_receiver!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email_config_receiver!(id), do: Repo.get!(Email_config_receiver, id)

  @doc """
  Creates a email_config_receiver.

  ## Examples

      iex> create_email_config_receiver(%{field: value})
      {:ok, %Email_config_receiver{}}

      iex> create_email_config_receiver(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email_config_receiver(attrs \\ %{}) do
    %Email_config_receiver{}
    |> Email_config_receiver.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a email_config_receiver.

  ## Examples

      iex> update_email_config_receiver(email_config_receiver, %{field: new_value})
      {:ok, %Email_config_receiver{}}

      iex> update_email_config_receiver(email_config_receiver, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email_config_receiver(%Email_config_receiver{} = email_config_receiver, attrs) do
    email_config_receiver
    |> Email_config_receiver.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a email_config_receiver.

  ## Examples

      iex> delete_email_config_receiver(email_config_receiver)
      {:ok, %Email_config_receiver{}}

      iex> delete_email_config_receiver(email_config_receiver)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email_config_receiver(%Email_config_receiver{} = email_config_receiver) do
    Repo.delete(email_config_receiver)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email_config_receiver changes.

  ## Examples

      iex> change_email_config_receiver(email_config_receiver)
      %Ecto.Changeset{data: %Email_config_receiver{}}

  """
  def change_email_config_receiver(%Email_config_receiver{} = email_config_receiver, attrs \\ %{}) do
    Email_config_receiver.changeset(email_config_receiver, attrs)
  end
end
