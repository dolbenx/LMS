defmodule Loanmanagementsystem.SettingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Loanmanagementsystem.Settings` context.
  """

  @doc """
  Generate a config_settings.
  """
  def config_settings_fixture(attrs \\ %{}) do
    {:ok, config_settings} =
      attrs
      |> Enum.into(%{
        deleted_at: ~N[2024-03-25 08:48:00],
        description: "some description",
        name: "some name",
        updated_by: "some updated_by",
        value: "some value",
        value_type: "some value_type"
      })
      |> Loanmanagementsystem.Settings.create_config_settings()

    config_settings
  end

  @doc """
  Generate a receivers.
  """
  def receivers_fixture(attrs \\ %{}) do
    {:ok, receivers} =
      attrs
      |> Enum.into(%{
        company: "some company",
        email: "some email",
        name: "some name",
        status: "some status"
      })
      |> Loanmanagementsystem.Settings.create_receivers()

    receivers
  end

  @doc """
  Generate a sms_configs.
  """
  def sms_configs_fixture(attrs \\ %{}) do
    {:ok, sms_configs} =
      attrs
      |> Enum.into(%{
        host: "some host",
        max_attempts: "some max_attempts",
        password: "some password",
        sender: "some sender",
        username: "some username"
      })
      |> Loanmanagementsystem.Settings.create_sms_configs()

    sms_configs
  end
end
