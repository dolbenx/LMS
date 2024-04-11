defmodule Loanmanagementsystem.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Loanmanagementsystem.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        auto_password: "some auto_password",
        classification_id: 42,
        external_id: 42,
        is_admin: true,
        is_employee: true,
        is_employer: true,
        is_offtaker: true,
        is_rm: true,
        is_sme: true,
        password: "some password",
        password_fail_count: 42,
        pin: "some pin",
        status: "some status",
        username: "some username"
      })
      |> Loanmanagementsystem.Accounts.create_user()

    user
  end

  @doc """
  Generate a user_bio_data.
  """
  def user_bio_data_fixture(attrs \\ %{}) do
    {:ok, user_bio_data} =
      attrs
      |> Enum.into(%{
        accept_conditions: true,
        age: 42,
        date_of_birth: ~D[2024-03-24],
        email_address: "some email_address",
        first_name: "some first_name",
        gender: "some gender",
        id_number: "some id_number",
        id_type: "some id_type",
        last_name: "some last_name",
        marital_status: "some marital_status",
        mobile_number: "some mobile_number",
        nationality: "some nationality",
        number_of_dependants: 42,
        other_name: "some other_name",
        title: "some title",
        user_id: 42
      })
      |> Loanmanagementsystem.Accounts.create_user_bio_data()

    user_bio_data
  end

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        account_number: "some account_number",
        account_type: "some account_type",
        available_balance: 120.5,
        current_balance: 120.5,
        external_id: 42,
        limit: 120.5,
        mobile_number: "some mobile_number",
        status: "some status",
        total_credited: 120.5,
        total_debited: 120.5,
        user_id: 42,
        user_role_id: 42
      })
      |> Loanmanagementsystem.Accounts.create_account()

    account
  end

  @doc """
  Generate a user_role.
  """
  def user_role_fixture(attrs \\ %{}) do
    {:ok, user_role} =
      attrs
      |> Enum.into(%{
        auth_level: 42,
        permissions: "some permissions",
        role_type: "some role_type",
        session: "some session",
        status: "some status",
        user_id: 42
      })
      |> Loanmanagementsystem.Accounts.create_user_role()

    user_role
  end

  @doc """
  Generate a role.
  """
  def role_fixture(attrs \\ %{}) do
    {:ok, role} =
      attrs
      |> Enum.into(%{
        role_desc: "some role_desc",
        role_group: "some role_group",
        role_str: "some role_str",
        status: "some status"
      })
      |> Loanmanagementsystem.Accounts.create_role()

    role
  end

  @doc """
  Generate a next_of_kin.
  """
  def next_of_kin_fixture(attrs \\ %{}) do
    {:ok, next_of_kin} =
      attrs
      |> Enum.into(%{
        kin_first_name: "some kin_first_name",
        kin_gender: "some kin_gender",
        kin_id_number: "some kin_id_number",
        kin_last_name: "some kin_last_name",
        kin_mobile_number: "some kin_mobile_number",
        kin_other_name: "some kin_other_name",
        kin_personal_email: "some kin_personal_email",
        kin_relationship: "some kin_relationship",
        kin_status: "some kin_status",
        user_id: 42
      })
      |> Loanmanagementsystem.Accounts.create_next_of_kin()

    next_of_kin
  end

  @doc """
  Generate a address_details.
  """
  def address_details_fixture(attrs \\ %{}) do
    {:ok, address_details} =
      attrs
      |> Enum.into(%{
        accomodation_status: "some accomodation_status",
        area: "some area",
        country: 42,
        house_number: "some house_number",
        province: 42,
        street_name: "some street_name",
        town: 42,
        user_id: 42,
        years_at_current_address: 42
      })
      |> Loanmanagementsystem.Accounts.create_address_details()

    address_details
  end

  @doc """
  Generate a user_token.
  """
  def user_token_fixture(attrs \\ %{}) do
    {:ok, user_token} =
      attrs
      |> Enum.into(%{
        context: "some context",
        login_timestamp: ~N[2024-03-24 10:46:00],
        sent_to: "some sent_to",
        token: "some token",
        user_id: 42
      })
      |> Loanmanagementsystem.Accounts.create_user_token()

    user_token
  end
end
