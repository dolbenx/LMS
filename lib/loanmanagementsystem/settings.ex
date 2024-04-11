defmodule Loanmanagementsystem.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Settings.ConfigSettings
  alias Loanmanagementsystem.Workers.Utlis.NumberFunctions

  @doc """
  Returns the list of tbl_config_settings.

  ## Examples

      iex> list_tbl_config_settings()
      [%ConfigSettings{}, ...]

  """
  def list_tbl_config_settings do
    Repo.all(ConfigSettings)
  end

  @doc """
  Gets a single config_settings.

  Raises `Ecto.NoResultsError` if the Config settings does not exist.

  ## Examples

      iex> get_config_settings!(123)
      %ConfigSettings{}

      iex> get_config_settings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_config_settings!(id), do: Repo.get!(ConfigSettings, id)

  @doc """
  Creates a config_settings.

  ## Examples

      iex> create_config_settings(%{field: value})
      {:ok, %ConfigSettings{}}

      iex> create_config_settings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_config_settings(attrs \\ %{}) do
    %ConfigSettings{}
    |> ConfigSettings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a config_settings.

  ## Examples

      iex> update_config_settings(config_settings, %{field: new_value})
      {:ok, %ConfigSettings{}}

      iex> update_config_settings(config_settings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_config_settings(%ConfigSettings{} = config_settings, attrs) do
    config_settings
    |> ConfigSettings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a config_settings.

  ## Examples

      iex> delete_config_settings(config_settings)
      {:ok, %ConfigSettings{}}

      iex> delete_config_settings(config_settings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_config_settings(%ConfigSettings{} = config_settings) do
    Repo.delete(config_settings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking config_settings changes.

  ## Examples

      iex> change_config_settings(config_settings)
      %Ecto.Changeset{data: %ConfigSettings{}}

  """
  def change_config_settings(%ConfigSettings{} = config_settings, attrs \\ %{}) do
    ConfigSettings.changeset(config_settings, attrs)
  end

  def create_settings(attrs \\ %{}) do
    %ConfigSettings{}
    |> ConfigSettings.changeset(attrs)
    |> Repo.insert()
  end


  def update_settings(%ConfigSettings{} = system, attrs) do
    system
    |> ConfigSettings.changeset(attrs)
    |> Repo.update()
  end


  def get_license_approval_configs() do
    ConfigSettings
    |> where([a], a.name == "license_auth_levels")
    |> Repo.all()
    |> List.last()
  end

  def get_setting_configuration(name) do
    settings = Repo.get_by(ConfigSettings, name: name)
    if settings == nil, do: %ConfigSettings{}, else: settings
  end


  def get_all_settings_configuration do
    ConfigSettings_conf
    |> order_by(asc: :id)
    |> Repo.all()
  end



  def search_for_name_configuration(query) do
    ConfigSettings
    |> where([a], like(a.name, ^"%#{query}%"))
    |> order_by(asc: :id)
    |> Repo.all()
  end

  def update_config_settings_value(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {attrs, index}, multi ->
      Ecto.Multi.run(multi, {:settings, index}, fn _repo, _ ->
        {:ok, Repo.get(ConfigSettings, attrs.id)}
      end)
      |> Ecto.Multi.update({:update, index}, fn all ->
        settings = all[{:settings, index}]
        ConfigSettings.changeset(settings, attrs)
      end)
    end)
    |> Repo.transaction()

  end


  def date_time_calculator(setting) do
    value = NumberFunctions.convert_to_int(setting.value || "0.0")

    case setting.value_type do
      #      "years" -> value * 60 * 60 * 24 * 12
      "days" -> value * 60 * 60 * 24
      "hours" -> value * 60 * 60
      "minutes" -> value * 60
      "seconds" -> value
      _ -> value
    end

  end


  alias Loanmanagementsystem.Settings.Receivers

  @doc """
  Returns the list of tbl_notification_receivers.

  ## Examples

      iex> list_tbl_notification_receivers()
      [%Receivers{}, ...]

  """
  def list_tbl_notification_receivers do
    Repo.all(Receivers)
  end

  @doc """
  Gets a single receivers.

  Raises `Ecto.NoResultsError` if the Receivers does not exist.

  ## Examples

      iex> get_receivers!(123)
      %Receivers{}

      iex> get_receivers!(456)
      ** (Ecto.NoResultsError)

  """
  def get_receivers!(id), do: Repo.get!(Receivers, id)

  @doc """
  Creates a receivers.

  ## Examples

      iex> create_receivers(%{field: value})
      {:ok, %Receivers{}}

      iex> create_receivers(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_receivers(attrs \\ %{}) do
    %Receivers{}
    |> Receivers.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a receivers.

  ## Examples

      iex> update_receivers(receivers, %{field: new_value})
      {:ok, %Receivers{}}

      iex> update_receivers(receivers, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_receivers(%Receivers{} = receivers, attrs) do
    receivers
    |> Receivers.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a receivers.

  ## Examples

      iex> delete_receivers(receivers)
      {:ok, %Receivers{}}

      iex> delete_receivers(receivers)
      {:error, %Ecto.Changeset{}}

  """
  def delete_receivers(%Receivers{} = receivers) do
    Repo.delete(receivers)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking receivers changes.

  ## Examples

      iex> change_receivers(receivers)
      %Ecto.Changeset{data: %Receivers{}}

  """
  def change_receivers(%Receivers{} = receivers, attrs \\ %{}) do
    Receivers.changeset(receivers, attrs)
  end

  alias Loanmanagementsystem.Settings.SmsConfigs

  @doc """
  Returns the list of tbl_sms_configuration.

  ## Examples

      iex> list_tbl_sms_configuration()
      [%SmsConfigs{}, ...]

  """
  def list_tbl_sms_configuration do
    Repo.all(SmsConfigs)
  end

  @doc """
  Gets a single sms_configs.

  Raises `Ecto.NoResultsError` if the Sms configs does not exist.

  ## Examples

      iex> get_sms_configs!(123)
      %SmsConfigs{}

      iex> get_sms_configs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sms_configs!(id), do: Repo.get!(SmsConfigs, id)

  @doc """
  Creates a sms_configs.

  ## Examples

      iex> create_sms_configs(%{field: value})
      {:ok, %SmsConfigs{}}

      iex> create_sms_configs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sms_configs(attrs \\ %{}) do
    %SmsConfigs{}
    |> SmsConfigs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sms_configs.

  ## Examples

      iex> update_sms_configs(sms_configs, %{field: new_value})
      {:ok, %SmsConfigs{}}

      iex> update_sms_configs(sms_configs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sms_configs(%SmsConfigs{} = sms_configs, attrs) do
    sms_configs
    |> SmsConfigs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sms_configs.

  ## Examples

      iex> delete_sms_configs(sms_configs)
      {:ok, %SmsConfigs{}}

      iex> delete_sms_configs(sms_configs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sms_configs(%SmsConfigs{} = sms_configs) do
    Repo.delete(sms_configs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sms_configs changes.

  ## Examples

      iex> change_sms_configs(sms_configs)
      %Ecto.Changeset{data: %SmsConfigs{}}

  """
  def change_sms_configs(%SmsConfigs{} = sms_configs, attrs \\ %{}) do
    SmsConfigs.changeset(sms_configs, attrs)
  end
end
