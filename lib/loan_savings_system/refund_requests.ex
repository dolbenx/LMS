defmodule LoanSavingsSystem.RefundRequests do
  @moduledoc """
  The RefundRequests context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.RefundRequests.RefundRequest

  @doc """
  Returns the list of tbl_refund_requests.

  ## Examples

      iex> list_tbl_refund_requests()
      [%RefundRequest{}, ...]

  """
  def list_tbl_refund_requests do
    Repo.all(RefundRequest)
  end

  @doc """
  Gets a single refund_request.

  Raises `Ecto.NoResultsError` if the Refund request does not exist.

  ## Examples

      iex> get_refund_request!(123)
      %RefundRequest{}

      iex> get_refund_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_refund_request!(id), do: Repo.get!(RefundRequest, id)

  @doc """
  Creates a refund_request.

  ## Examples

      iex> create_refund_request(%{field: value})
      {:ok, %RefundRequest{}}

      iex> create_refund_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_refund_request(attrs \\ %{}) do
    %RefundRequest{}
    |> RefundRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a refund_request.

  ## Examples

      iex> update_refund_request(refund_request, %{field: new_value})
      {:ok, %RefundRequest{}}

      iex> update_refund_request(refund_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_refund_request(%RefundRequest{} = refund_request, attrs) do
    refund_request
    |> RefundRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a refund_request.

  ## Examples

      iex> delete_refund_request(refund_request)
      {:ok, %RefundRequest{}}

      iex> delete_refund_request(refund_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_refund_request(%RefundRequest{} = refund_request) do
    Repo.delete(refund_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking refund_request changes.

  ## Examples

      iex> change_refund_request(refund_request)
      %Ecto.Changeset{source: %RefundRequest{}}

  """
  def change_refund_request(%RefundRequest{} = refund_request) do
    RefundRequest.changeset(refund_request, %{})
  end
end
