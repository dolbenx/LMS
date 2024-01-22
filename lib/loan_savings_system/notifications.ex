defmodule LoanSavingsSystem.Notifications do
 @moduledoc """
  The Notifications context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Notifications.Sms
  alias LoanSavingsSystem.SystemSetting

  alias  Core.Constants

  @doc """
  Returns the list of tbl_sms.

  ## Examples

      iex> list_tbl_sms()
      [%Sms{}, ...]

  """
  def list_sms do
    Repo.all(Sms)
  end

  @doc """
  Gets a single sms.

  Raises `Ecto.NoResultsError` if the Sms does not exist.

  ## Examples

      iex> get_sms!(123)
      %Sms{}

      iex> get_sms!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sms!(id), do: Repo.get!(Sms, id)

  @doc """
  Creates a sms.

  ## Examples

      iex> create_sms(%{field: value})
      {:ok, %Sms{}}

      iex> create_sms(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sms(attrs \\ %{}) do
    %Sms{}
    |> Sms.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sms.

  ## Examples

      iex> update_sms(sms, %{field: new_value})
      {:ok, %Sms{}}

      iex> update_sms(sms, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sms(%Sms{} = sms, attrs) do
    sms
    |> Sms.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sms.

  ## Examples

      iex> delete_sms(sms)
      {:ok, %Sms{}}

      iex> delete_sms(sms)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sms(%Sms{} = sms) do
    Repo.delete(sms)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sms changes.

  ## Examples

      iex> change_sms(sms)
      %Ecto.Changeset{source: %Sms{}}

  """
  def change_sms(%Sms{} = sms) do
    Sms.changeset(sms, %{})
  end

  def sms_ready() do
    Sms
    |> where([s], s.status == "READY")
    |> Repo.all()
  end

  def get_sms_logs(_params) do
    # status =  if(params["status"], do: params["status"], else: "" )
    # m
    # Sms |> where([sms], sms.status in [""])|> Repo.all()

  end

  def sms_ready(status) do
    case Sms.where(from sms in Sms, where: sms.status == ^status and sms.msg_count < ^SystemSetting.get_settings_by(Constants.sms_max_attempt()), limit: 50) do
      nil->
        []
      sms->
        sms
    end
  end
end
