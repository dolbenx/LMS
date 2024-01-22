defmodule Loanmanagementsystem.Repo.Migrations.CreateTblEmployee do
  use Ecto.Migration

  def change do
    create table(:tbl_employee) do
      add(:companyId, :integer)
      add(:employerId, :integer)
      add(:userRoleId, :integer)
      add(:userId, :integer)
      add(:status, :string)
      add(:loan_limit, :decimal)
      add(:nrc_image, :text)

      timestamps()
    end

    # create(unique_index(:tbl_employee, [:employerId], name: :unique_employerId))
  end
end
