defmodule Loanmanagementsystem.Services.Api.ApiServices do
  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Services.Api.Utils

  def get_admin_users do
    User
    |> join(:left, [uA], uR in "tbl_user_bio_data", on: uA.id == uR.userId)
    |> where([uA, uR], uA.status == "ACTIVE")
    |> select([uA, uR], %{
      id: uA.id,
      firstName: uR.firstName,
      lastName: uR.lastName,
      otherName: uR.otherName,
      mobileNumber: uR.mobileNumber,
      emailAddress: uR.emailAddress,
      dateOfBirth: uR.dateOfBirth,
      meansOfIdentificationType: uR.meansOfIdentificationType,
      meansOfIdentificationNumber: uR.meansOfIdentificationNumber,
      title: uR.title,
      gender: uR.gender,
      userId: uR.userId
    })
    |> Repo.all()
  end

  def register_user(user_params) do
    user = User.changeset(%User{}, user_params)

    Multi.new()
    |> Multi.insert(:user, user)
    |> Ecto.Multi.insert(:bio, fn %{user: user} ->
        user_bio = user_params |> Map.put("userId", user.id)

        %UserBioData{}
        |> UserBioData.changeset(user_bio)
        # |> Repo.insert()
      end)
    |> Ecto.Multi.insert(:role, fn %{user: user} ->
        role =
        user_params
        |> Map.put("userId", user.id)
        |> Map.put("clientId", user.id)
        |> Map.put("status", "PENDING")

        %UserRole{}
        |> UserRole.changeset(role)
        # |> Repo.insert()
      end)
    |> Repo.transaction()
    |> IO.inspect(label: "oOOOOOOOOOOOOoooooooooooOOOOOOOOOOOOOoooooOOOOOO")
    |> case do
      {:ok, result} ->
          bio = result.bio
          |> Utils.from_struct()
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)

          role = result.role
          |> Utils.from_struct()
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)

          user = result.user
          |> Utils.from_struct()
          |> Map.delete(:password)
          |> Map.delete(:inserted_at)
          |> Map.delete(:updated_at)
          |> Map.delete(:password_fail_count)
          |> Map.delete(:securityQuestionAnswer)
          |> Map.delete(:security_question_fail_count)
          |> Map.delete(:auto_password)
          |> Map.delete(:pin)
          |> Map.delete(:ussdActive)
          |> Map.delete(:securityQuestionId)

        {:ok, %{user: user, bio: bio, role: role}}
      {:error, _key, %Ecto.Changeset{} = changeset, _} ->
        reason = changeset.errors |> Utils.traverse_errors() |> List.first()

        {:error, reason}
      {:error, _key, %Ecto.Changeset{} = changeset, _, _} ->
        reason = changeset.errors |> Utils.traverse_errors() |> List.first()

        {:error, reason}

      {:error, _key, %Ecto.Changeset{} = changeset, _, _, _} ->
        reason = changeset.errors |> Utils.traverse_errors() |> List.first()

        {:error, reason}
    end
  end


end
