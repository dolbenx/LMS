defmodule LoanmanagementsystemWeb.OfftakerView do
  use LoanmanagementsystemWeb, :view


  def offtaker_has_mou do
    [
      %{name: "Facility Agreement Form", is_required: true},
      %{name: "Guarantee form", is_required: true},
    ]
  end

  def required_document do
    [
      %{name: "Proof of Collateral", is_required: true},
      %{name: "PADDC Collateral Liquidation Letter", is_required: true},
    ]
  end

  def is_required?(state) do
    if state == true do
      "required"
    else
      ""
    end
  end

  def is_required(state) do
    if state == true do
      " (required) "
    else
      " (of each shareholder/director of the business) "
    end
  end
end
