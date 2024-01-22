defmodule Loanmanagementsystem.SystemSetting do
  @moduledoc """
  The SystemSetting context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.SystemSetting.SystemSettings

  @doc """
  Returns the list of tbl_system_settings.

  ## Examples

      iex> list_tbl_system_settings()
      [%SystemSettings{}, ...]

  """
  def list_tbl_system_settings do
    Repo.all(SystemSettings)
  end

  # def get_settings_by(name) do
  #   case SystemSettings.find_by(name: name) do
  #     nil ->
  #       []

  #     setting ->
  #       setting.value
  #   end
  # end

  def get_settings_by(sender) do
    Repo.get_by(SystemSettings, sender: sender)
  end

  @doc """
  Gets a single system_settings.

  Raises `Ecto.NoResultsError` if the System settings does not exist.

  ## Examples

      iex> get_system_settings!(123)
      %SystemSettings{}

      iex> get_system_settings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system_settings!(id), do: Repo.get!(SystemSettings, id)

  @doc """
  Creates a system_settings.

  ## Examples

      iex> create_system_settings(%{field: value})
      {:ok, %SystemSettings{}}

      iex> create_system_settings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # Loanmanagementsystem.SystemSetting.create_system_settings()
  def create_system_settings(attrs \\ %{}) do
    %SystemSettings{}
    |> SystemSettings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a system_settings.

  ## Examples

      iex> update_system_settings(system_settings, %{field: new_value})
      {:ok, %SystemSettings{}}

      iex> update_system_settings(system_settings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system_settings(%SystemSettings{} = system_settings, attrs) do
    system_settings
    |> SystemSettings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a system_settings.

  ## Examples

      iex> delete_system_settings(system_settings)
      {:ok, %SystemSettings{}}

      iex> delete_system_settings(system_settings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system_settings(%SystemSettings{} = system_settings) do
    Repo.delete(system_settings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system_settings changes.

  ## Examples

      iex> change_system_settings(system_settings)
      %Ecto.Changeset{source: %SystemSettings{}}

  """
  def change_system_settings(%SystemSettings{} = system_settings) do
    SystemSettings.changeset(system_settings, %{})
  end
end
