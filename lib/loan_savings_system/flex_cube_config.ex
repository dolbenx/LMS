defmodule LoanSavingsSystem.FlexCubeConfig do
  @moduledoc """
  The FlexCubeConfig context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.FlexCubeConfig.FlexCubeConfigs

  @doc """
  Returns the list of flexcubeconfigs.

  ## Examples

      iex> list_flexcubeconfigs()
      [%FlexCubeConfigs{}, ...]

  """
  def list_flexcubeconfigs do
    Repo.all(FlexCubeConfigs)
  end

  @doc """
  Gets a single flex_cube_configs.

  Raises `Ecto.NoResultsError` if the Flex cube configs does not exist.

  ## Examples

      iex> get_flex_cube_configs!(123)
      %FlexCubeConfigs{}

      iex> get_flex_cube_configs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flex_cube_configs!(id), do: Repo.get!(FlexCubeConfigs, id)

  @doc """
  Creates a flex_cube_configs.

  ## Examples

      iex> create_flex_cube_configs(%{field: value})
      {:ok, %FlexCubeConfigs{}}

      iex> create_flex_cube_configs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flex_cube_configs(attrs \\ %{}) do
    %FlexCubeConfigs{}
    |> FlexCubeConfigs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flex_cube_configs.

  ## Examples

      iex> update_flex_cube_configs(flex_cube_configs, %{field: new_value})
      {:ok, %FlexCubeConfigs{}}

      iex> update_flex_cube_configs(flex_cube_configs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flex_cube_configs(%FlexCubeConfigs{} = flex_cube_configs, attrs) do
    flex_cube_configs
    |> FlexCubeConfigs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a flex_cube_configs.

  ## Examples

      iex> delete_flex_cube_configs(flex_cube_configs)
      {:ok, %FlexCubeConfigs{}}

      iex> delete_flex_cube_configs(flex_cube_configs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flex_cube_configs(%FlexCubeConfigs{} = flex_cube_configs) do
    Repo.delete(flex_cube_configs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flex_cube_configs changes.

  ## Examples

      iex> change_flex_cube_configs(flex_cube_configs)
      %Ecto.Changeset{source: %FlexCubeConfigs{}}

  """
  def change_flex_cube_configs(%FlexCubeConfigs{} = flex_cube_configs) do
    FlexCubeConfigs.changeset(flex_cube_configs, %{})
  end
end
