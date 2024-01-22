defmodule LoanSavingsSystem.Ussd do
  @moduledoc """
  The Ussd context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Ussd.UssdRequest

  @doc """
  Returns the list of ussd_requests.

  ## Examples

      iex> list_ussd_requests()
      [%UssdRequest{}, ...]

  """
  def list_ussd_requests do
    Repo.all(UssdRequest)
  end

  @doc """
  Gets a single ussd_request.

  Raises `Ecto.NoResultsError` if the Ussd request does not exist.

  ## Examples

      iex> get_ussd_request!(123)
      %UssdRequest{}

      iex> get_ussd_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ussd_request!(id), do: Repo.get!(UssdRequest, id)

  @doc """
  Creates a ussd_request.

  ## Examples

      iex> create_ussd_request(%{field: value})
      {:ok, %UssdRequest{}}

      iex> create_ussd_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ussd_request(attrs \\ %{}) do
    %UssdRequest{}
    |> UssdRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ussd_request.

  ## Examples

      iex> update_ussd_request(ussd_request, %{field: new_value})
      {:ok, %UssdRequest{}}

      iex> update_ussd_request(ussd_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ussd_request(%UssdRequest{} = ussd_request, attrs) do
    ussd_request
    |> UssdRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ussd_request.

  ## Examples

      iex> delete_ussd_request(ussd_request)
      {:ok, %UssdRequest{}}

      iex> delete_ussd_request(ussd_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ussd_request(%UssdRequest{} = ussd_request) do
    Repo.delete(ussd_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ussd_request changes.

  ## Examples

      iex> change_ussd_request(ussd_request)
      %Ecto.Changeset{source: %UssdRequest{}}

  """
  def change_ussd_request(%UssdRequest{} = ussd_request) do
    UssdRequest.changeset(ussd_request, %{})
  end
end
