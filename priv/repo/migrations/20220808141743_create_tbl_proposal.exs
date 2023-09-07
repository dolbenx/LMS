defmodule Loanmanagementsystem.Repo.Migrations.CreateTblProposal do
  use Ecto.Migration

  def change do
    create table(:tbl_proposal) do
      add :first_name, :string
      add :last_name, :string
      add :other_name, :string
      add :title, :string
      add :date_of_birth, :date
      add :identification_type, :string
      add :identification_number, :string
      add :gender, :string
      add :mobile_number, :string
      add :email_address, :string
      add :marital_status, :string
      add :nationality, :string
      add :disability_detail, :string
      add :disability_status, :string
      add :status, :string
      add :number_of_dependants, :integer
      add :userId, :integer
      add :bankId, :integer

      timestamps()
    end

  end
end
