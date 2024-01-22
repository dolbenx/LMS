defmodule LoanmanagementsystemWeb.OfftakerManagementView do
  use LoanmanagementsystemWeb, :view

  def required_document do
    [
      %{name: "PACRA Certificate", is_required: true},
      %{name: "TPIN Certificate", is_required: true}
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
      " (optional) "
    end
  end
end
