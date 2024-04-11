defmodule Loanmanagementsystem.Repo.Migrations.CreateTblUserBioData do
  use Ecto.Migration

  def change do
    create table(:tbl_user_bio_data) do
      add :first_name, :string
      add :last_name, :string
      add :gender, :string
      add :date_of_birth, :date
      add :email_address, :string
      add :id_number, :string
      add :id_type, :string
      add :mobile_number, :string
      add :other_name, :string
      add :title, :string
      add :user_id, :integer
      add :marital_status, :string
      add :nationality, :string
      add :number_of_dependants, :integer
      add :age, :integer
      add :accept_conditions, :boolean, default: false, null: false

      timestamps()
    end
    create unique_index(:tbl_user_bio_data, [:email_address], name: :unique_email_address)
    create unique_index(:tbl_user_bio_data, [:mobile_number], name: :unique_mobile_number)
    create unique_index(:tbl_user_bio_data, [:id_number], name: :unique_id_number)
  end

end
