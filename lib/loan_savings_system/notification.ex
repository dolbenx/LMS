defmodule LoanSavingsSystem.Notification do
  @moduledoc """
  The Notification context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Notification.OnPlatformNotification

  @doc """
  Returns the list of tbl_on_platform_notifications.

  ## Examples

      iex> list_tbl_on_platform_notifications()
      [%OnPlatformNotification{}, ...]

  """
  def list_tbl_on_platform_notifications do
    Repo.all(OnPlatformNotification)
  end

  @doc """
  Gets a single on_platform_notification.

  Raises `Ecto.NoResultsError` if the On platform notification does not exist.

  ## Examples

      iex> get_on_platform_notification!(123)
      %OnPlatformNotification{}

      iex> get_on_platform_notification!(456)
      ** (Ecto.NoResultsError)

  """
  def get_on_platform_notification!(id), do: Repo.get!(OnPlatformNotification, id)

  @doc """
  Creates a on_platform_notification.

  ## Examples

      iex> create_on_platform_notification(%{field: value})
      {:ok, %OnPlatformNotification{}}

      iex> create_on_platform_notification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_on_platform_notification(attrs \\ %{}) do
    %OnPlatformNotification{}
    |> OnPlatformNotification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a on_platform_notification.

  ## Examples

      iex> update_on_platform_notification(on_platform_notification, %{field: new_value})
      {:ok, %OnPlatformNotification{}}

      iex> update_on_platform_notification(on_platform_notification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_on_platform_notification(%OnPlatformNotification{} = on_platform_notification, attrs) do
    on_platform_notification
    |> OnPlatformNotification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a on_platform_notification.

  ## Examples

      iex> delete_on_platform_notification(on_platform_notification)
      {:ok, %OnPlatformNotification{}}

      iex> delete_on_platform_notification(on_platform_notification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_on_platform_notification(%OnPlatformNotification{} = on_platform_notification) do
    Repo.delete(on_platform_notification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking on_platform_notification changes.

  ## Examples

      iex> change_on_platform_notification(on_platform_notification)
      %Ecto.Changeset{source: %OnPlatformNotification{}}

  """
  def change_on_platform_notification(%OnPlatformNotification{} = on_platform_notification) do
    OnPlatformNotification.changeset(on_platform_notification, %{})
  end

  alias LoanSavingsSystem.Notification.SmsNotificationConfiguration

  @doc """
  Returns the list of tbl_sms_notification_configuration.

  ## Examples

      iex> list_tbl_sms_notification_configuration()
      [%SmsNotificationConfiguration{}, ...]

  """
  def list_tbl_sms_notification_configuration do
    Repo.all(SmsNotificationConfiguration)
  end

  @doc """
  Gets a single sms_notification_configuration.

  Raises `Ecto.NoResultsError` if the Sms notification configuration does not exist.

  ## Examples

      iex> get_sms_notification_configuration!(123)
      %SmsNotificationConfiguration{}

      iex> get_sms_notification_configuration!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sms_notification_configuration!(id), do: Repo.get!(SmsNotificationConfiguration, id)

  @doc """
  Creates a sms_notification_configuration.

  ## Examples

      iex> create_sms_notification_configuration(%{field: value})
      {:ok, %SmsNotificationConfiguration{}}

      iex> create_sms_notification_configuration(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sms_notification_configuration(attrs \\ %{}) do
    %SmsNotificationConfiguration{}
    |> SmsNotificationConfiguration.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sms_notification_configuration.

  ## Examples

      iex> update_sms_notification_configuration(sms_notification_configuration, %{field: new_value})
      {:ok, %SmsNotificationConfiguration{}}

      iex> update_sms_notification_configuration(sms_notification_configuration, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sms_notification_configuration(%SmsNotificationConfiguration{} = sms_notification_configuration, attrs) do
    sms_notification_configuration
    |> SmsNotificationConfiguration.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sms_notification_configuration.

  ## Examples

      iex> delete_sms_notification_configuration(sms_notification_configuration)
      {:ok, %SmsNotificationConfiguration{}}

      iex> delete_sms_notification_configuration(sms_notification_configuration)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sms_notification_configuration(%SmsNotificationConfiguration{} = sms_notification_configuration) do
    Repo.delete(sms_notification_configuration)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sms_notification_configuration changes.

  ## Examples

      iex> change_sms_notification_configuration(sms_notification_configuration)
      %Ecto.Changeset{source: %SmsNotificationConfiguration{}}

  """
  def change_sms_notification_configuration(%SmsNotificationConfiguration{} = sms_notification_configuration) do
    SmsNotificationConfiguration.changeset(sms_notification_configuration, %{})
  end
end
