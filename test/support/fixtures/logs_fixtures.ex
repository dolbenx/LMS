defmodule Loanmanagementsystem.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Loanmanagementsystem.Logs` context.
  """

  @doc """
  Generate a user_logs.
  """
  def user_logs_fixture(attrs \\ %{}) do
    {:ok, user_logs} =
      attrs
      |> Enum.into(%{
        activity: "some activity",
        user_id: 42
      })
      |> Loanmanagementsystem.Logs.create_user_logs()

    user_logs
  end

  @doc """
  Generate a session_logs.
  """
  def session_logs_fixture(attrs \\ %{}) do
    {:ok, session_logs} =
      attrs
      |> Enum.into(%{
        browser_details: "some browser_details",
        description: "some description",
        device_type: "some device_type",
        device_uuid: "some device_uuid",
        full_browser_name: "some full_browser_name",
        ip_address: "some ip_address",
        known_browser: true,
        portal: "some portal",
        session_id: "some session_id",
        status: true,
        system_platform_name: "some system_platform_name"
      })
      |> Loanmanagementsystem.Logs.create_session_logs()

    session_logs
  end
end
