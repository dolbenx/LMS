defmodule LoanmanagementsystemWeb.SmeView do
  use LoanmanagementsystemWeb, :view

  def required_documents do
    [
      %{name: "ZRA Tpin", is_required: true},
      %{name: "Incorporation Certificat", is_required: false}
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
      "(Required)"
    else
      "(Optional)"
    end
  end
end
