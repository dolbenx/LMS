defmodule Loanmanagementsystem.Employment.Employee_Maintenance do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_employee_maintenance" do
    field :branchId, :integer
    field :departmentId, :integer
    field :employee_number, :string
    field :employee_status, :string
    field :mobile_network_operator, :string
    field :nrc_image, :string
    field :job_title, :string
    field :registered_name_mobile_number, :string
    field :roleTypeId, :integer
    field :userId, :integer

    timestamps()
  end

  @doc false
  def changeset(employee__maintenance, attrs) do
    employee__maintenance
    |> cast(attrs, [
      :mobile_network_operator,
      :registered_name_mobile_number,
      :userId,
      :departmentId,
      :roleTypeId,
      :nrc_image,
      :employee_number,
      :branchId,
      :employee_status,
      :job_title
    ])
    # |> validate_required([
    #   :mobile_network_operator,
    #   :registered_name_mobile_number,
    #   :userId,
    #   :departmentId,
    #   :roleTypeId,
    #   :nrc_image,
    #   :employee_number,
    #   :branchId,
    #   :employee_status,
    #   :job_title
    # ])
  end
end
