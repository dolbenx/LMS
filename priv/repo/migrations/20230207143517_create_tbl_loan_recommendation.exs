defmodule Loanmanagementsystem.Repo.Migrations.CreateTblLoanRecommendation do
  use Ecto.Migration

  def change do
    create table(:tbl_loan_recommendation) do
      add :customer_id, :integer
      add :reference_no, :string
      add :recommended, :string
      add :on_hold, :string
      add :file_sent_to_sale, :string
      add :comments, :text
      add :name, :string
      add :signature, :text
      add :position, :string
      add :date, :string
      add :time_received, :string
      add :time_out, :string
      add :date_received, :string
      add :user_type, :string

      timestamps()
    end

  end
end
