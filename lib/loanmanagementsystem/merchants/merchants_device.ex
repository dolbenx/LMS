defmodule Loanmanagementsystem.Merchants.Merchants_device do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_merchant_device" do
    field :deviceAgentLine, :string
    field :deviceIMEI, :string
    field :deviceModel, :string
    field :deviceName, :string
    field :deviceType, :string
    field :merchantId, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(merchants_device, attrs) do
    merchants_device
    |> cast(attrs, [
      :status,
      :deviceName,
      :deviceType,
      :deviceModel,
      :deviceAgentLine,
      :deviceIMEI,
      :merchantId
    ])

    # |> validate_required([:deviceType, :deviceModel, :deviceAgentLine, :deviceIMEI, :merchantId])
    # |> validate_required([:deviceName, :deviceType, :deviceModel, :deviceAgentLine, :deviceIMEI, :merchantId])
  end
end
