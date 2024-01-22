defmodule Loanmanagementsystem.Repo.Migrations.AlterAddApplicantSignatureToTblUserBioData do
  use Ecto.Migration

  def change do
    alter table(:tbl_user_bio_data) do
      add :applicant_signature_image, :text
    end
  end
end
