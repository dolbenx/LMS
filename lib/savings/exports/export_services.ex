defmodule Savings.Service.Export.ExportServices do
  use SavingsWeb, :controller

  def binary_to_string(str),
    do: if(is_binary(str), do: Enum.join(for <<c::utf8 <- str>>, do: <<c::utf8>>), else: str)


  ######################################################################################################################################

  def customer_view_header_csv(),
  do: [
    [
      "Customer Name",
      "Mobile Phone",
      "Account #",
      "Account Type",
      "Account Status"
    ]
  ]

def customer_view_header(),
  do: [
    ["Customer Name", bg_color: "#ebe8e8", bold: true],
    ["Mobile Phone", bg_color: "#ebe8e8", bold: true],
    ["Account #", bg_color: "#ebe8e8", bold: true],
    ["Account Type", bg_color: "#ebe8e8", bold: true],
    ["Account Status", bg_color: "#ebe8e8", bold: true]
  ]

def customer_view_row(post) do
  [
    post.customer_names |> binary_to_string(),
    post.mobileNumber |> binary_to_string(),
    post.meansOfIdentificationNumber |> binary_to_string(),
    post.accountType |> binary_to_string(),
    post.account_status |> binary_to_string()
  ]
end


######################################################################################################################################

  def tnx_fixed_deps_view_header_csv(),
    do: [
      [
        "Customer Name",
        "Mobile Phone",
        "ID",
        "Account Status",
        "Account #",
        "Deposit Amount",
        "Deposited Date",
        "Txn Status"
      ]
    ]

  def tnx_fixed_deps_view_header(),
    do: [
      ["Customer Name", bg_color: "#ebe8e8", bold: true],
      ["Mobile Phone", bg_color: "#ebe8e8", bold: true],
      ["ID", bg_color: "#ebe8e8", bold: true],
      ["Account Status", bg_color: "#ebe8e8", bold: true],
      ["Account #", bg_color: "#ebe8e8", bold: true],
      ["Deposit Amount", bg_color: "#ebe8e8", bold: true],
      ["Deposited Date", bg_color: "#ebe8e8", bold: true],
      ["Txn Status", bg_color: "#ebe8e8", bold: true]
    ]

  def tnx_fixed_deps_view_row(post) do
    [
      post.customer_names |> binary_to_string(),
      post.mobileNumber |> binary_to_string(),
      post.customer_identity |> binary_to_string(),
      post.account_status |> binary_to_string(),
      post.account_number |> binary_to_string(),
      post.deposited_amount |> binary_to_string() |> to_string,
      post.deposited_date |> binary_to_string() |> to_string,
      post.txn_status |> binary_to_string() |> to_string
    ]
  end

  ######################################################################################################################################
  def partial_divestment_view_header_csv(),
    do: [
      [
        "Customer Name",
        "Mobile Phone",
        "ID",
        "Account Status",
        "Account #",
        "Deposit Amount",
        "Deposited Date",
        "Txn Status"
      ]
    ]

  def partial_divestment_view_header(),
    do: [
      ["Customer Name", bg_color: "#ebe8e8", bold: true],
      ["Mobile Phone", bg_color: "#ebe8e8", bold: true],
      ["ID", bg_color: "#ebe8e8", bold: true],
      ["Account Status", bg_color: "#ebe8e8", bold: true],
      ["Account #", bg_color: "#ebe8e8", bold: true],
      ["Deposit Amount", bg_color: "#ebe8e8", bold: true],
      ["Deposited Date", bg_color: "#ebe8e8", bold: true],
      ["Txn Status", bg_color: "#ebe8e8", bold: true]
    ]

  def partial_divestment_view_row(post) do
    [
      post.customer_names |> binary_to_string(),
      post.mobileNumber |> binary_to_string(),
      post.customer_identity |> binary_to_string(),
      post.account_status |> binary_to_string(),
      post.account_number |> binary_to_string(),
      post.deposited_amount |> binary_to_string() |> to_string,
      post.deposited_date |> binary_to_string() |> to_string,
      post.txn_status |> binary_to_string() |> to_string
    ]
  end

  ######################################################################################################################################
  def full_divestment_view_header_csv(),
    do: [
      [
        "Customer Name",
        "Mobile Phone",
        "ID",
        "Account Status",
        "Account #",
        "Deposit Amount",
        "Deposited Date",
        "Txn Status"
      ]
    ]

  def full_divestment_view_header(),
    do: [
      ["Customer Name", bg_color: "#ebe8e8", bold: true],
      ["Mobile Phone", bg_color: "#ebe8e8", bold: true],
      ["ID", bg_color: "#ebe8e8", bold: true],
      ["Account Status", bg_color: "#ebe8e8", bold: true],
      ["Account #", bg_color: "#ebe8e8", bold: true],
      ["Deposit Amount", bg_color: "#ebe8e8", bold: true],
      ["Deposited Date", bg_color: "#ebe8e8", bold: true],
      ["Txn Status", bg_color: "#ebe8e8", bold: true]
    ]

  def full_divestment_view_row(post) do
    [
      post.customer_names |> binary_to_string(),
      post.mobileNumber |> binary_to_string(),
      post.customer_identity |> binary_to_string(),
      post.account_status |> binary_to_string(),
      post.account_number |> binary_to_string(),
      post.deposited_amount |> binary_to_string() |> to_string,
      post.deposited_date |> binary_to_string() |> to_string,
      post.txn_status |> binary_to_string() |> to_string
    ]
  end

  ######################################################################################################################################

  def mature_withdraw_view_header_csv(),
    do: [
      [
        "Customer Name",
        "Mobile Phone",
        "ID",
        "Account Status",
        "Account #",
        "Deposit Amount",
        "Deposited Date",
        "Txn Status"
      ]
    ]

  def mature_withdraw_view_header(),
    do: [
      ["Customer Name", bg_color: "#ebe8e8", bold: true],
      ["Mobile Phone", bg_color: "#ebe8e8", bold: true],
      ["ID", bg_color: "#ebe8e8", bold: true],
      ["Account Status", bg_color: "#ebe8e8", bold: true],
      ["Account #", bg_color: "#ebe8e8", bold: true],
      ["Deposit Amount", bg_color: "#ebe8e8", bold: true],
      ["Deposited Date", bg_color: "#ebe8e8", bold: true],
      ["Txn Status", bg_color: "#ebe8e8", bold: true]
    ]

  def mature_withdraw_view_row(post) do
    [
      post.customer_names |> binary_to_string(),
      post.mobileNumber |> binary_to_string(),
      post.customer_identity |> binary_to_string(),
      post.account_status |> binary_to_string(),
      post.account_number |> binary_to_string(),
      post.deposited_amount |> binary_to_string() |> to_string,
      post.deposited_date |> binary_to_string() |> to_string,
      post.txn_status |> binary_to_string() |> to_string
    ]
  end
  ######################################################################################################################################
  def all_transactions_view_header_csv(),
    do: [
      [
        "Customer Name",
        "Mobile Phone",
        "ID",
        "Account Status",
        "Account #",
        "Deposit Amount",
        "Deposited Date",
        "Txn Status"
      ]
    ]

  def all_transactions_view_header(),
    do: [
      ["Customer Name", bg_color: "#ebe8e8", bold: true],
      ["Mobile Phone", bg_color: "#ebe8e8", bold: true],
      ["ID", bg_color: "#ebe8e8", bold: true],
      ["Account Status", bg_color: "#ebe8e8", bold: true],
      ["Account #", bg_color: "#ebe8e8", bold: true],
      ["Deposit Amount", bg_color: "#ebe8e8", bold: true],
      ["Deposited Date", bg_color: "#ebe8e8", bold: true],
      ["Txn Status", bg_color: "#ebe8e8", bold: true]
    ]

  def all_transactions_view_row(post) do
    [
      post.customer_names |> binary_to_string(),
      post.mobileNumber |> binary_to_string(),
      post.customer_identity |> binary_to_string(),
      post.account_status |> binary_to_string(),
      post.account_number |> binary_to_string(),
      post.deposited_amount |> binary_to_string() |> to_string,
      post.deposited_date |> binary_to_string() |> to_string,
      post.txn_status |> binary_to_string() |> to_string
    ]
  end


  ######################################################################################################################################

  def fixed_deps_report_view_header_csv(),
    do: [
      [
        "Customer Name",
        "Start Date",
        "Start Time",
        "End Date",
        "Product Code",
        "Tenure",
        "Interest Rate(%)",
        "Divestment Type",
        "Principal Amount",
        "Expected Interest",
        "Total Charges",
        "Accrued Interest",
        "Divest Amount",
      ]
    ]

  def fixed_deps_report_view_header(),
    do: [
      ["Customer Name", bg_color: "#ebe8e8", bold: true],
      ["Start Date", bg_color: "#ebe8e8", bold: true],
      ["Start Time", bg_color: "#ebe8e8", bold: true],
      ["End Date", bg_color: "#ebe8e8", bold: true],
      ["Product Code", bg_color: "#ebe8e8", bold: true],
      ["Tenure", bg_color: "#ebe8e8", bold: true],
      ["Interest Rate(%)", bg_color: "#ebe8e8", bold: true],
      ["Divestment Type", bg_color: "#ebe8e8", bold: true],
      ["Principal Amount", bg_color: "#ebe8e8", bold: true],
      ["Expected Interest", bg_color: "#ebe8e8", bold: true],
      ["Total Charges", bg_color: "#ebe8e8", bold: true],
      ["Accrued Interest", bg_color: "#ebe8e8", bold: true],
      ["Divest Amount", bg_color: "#ebe8e8", bold: true],
    ]

  def fixed_deps_report_view_row(post) do
    [
      post.customer_names |> binary_to_string(),
      post.startDate |> binary_to_string() |> to_string,
      post.startDate |> binary_to_string() |> to_string,
      post.endDate |> binary_to_string() |> to_string,
      post.product_code |> binary_to_string(),
      post.fixedPeriod |> binary_to_string() |> to_string,
      post.interestRate |> binary_to_string() |> to_string,
      post.divestmentType |> binary_to_string() |> to_string,
      post.principalAmount |> binary_to_string(),
      post.expectedInterest |> binary_to_string(),
      post.totalDepositCharge |> binary_to_string() |> to_string,
      post.accruedInterest |> binary_to_string() |> to_string,
      post.amountDivested |> binary_to_string() |> to_string,
    ]
  end
  ######################################################################################################################################

  def report_deposit_summury_view_header_csv(),
  do: [
    [
      "Product Code(tenour)",
      "Customer ID",
      "Moble No.",
      "Customer Name",
      "Value Date",
      "Value Time",
      "Maturity Date",
      "Currency",
      "Principal Amount",
      "Rate",
      "User Refference No",
      "Transaction Status",
    ]
  ]

def report_deposit_summury_view_header(),
  do: [
    ["Product Code(tenour)", bg_color: "#ebe8e8", bold: true],
    ["Customer ID", bg_color: "#ebe8e8", bold: true],
    ["Moble No.", bg_color: "#ebe8e8", bold: true],
    ["Customer Name", bg_color: "#ebe8e8", bold: true],
    ["Value Date", bg_color: "#ebe8e8", bold: true],
    ["Value Time", bg_color: "#ebe8e8", bold: true],
    ["Maturity Date", bg_color: "#ebe8e8", bold: true],
    ["Currency", bg_color: "#ebe8e8", bold: true],
    ["Principal Amount", bg_color: "#ebe8e8", bold: true],
    ["Rate", bg_color: "#ebe8e8", bold: true],
    ["User Refference No", bg_color: "#ebe8e8", bold: true],
    ["Transaction Status", bg_color: "#ebe8e8", bold: true]
  ]

def report_deposit_summury_view_row(post) do
  [
    post.product_code |> binary_to_string(),
    post.meansOfIdentificationNumber |> binary_to_string(),
    post.mobileNumber |> binary_to_string(),
    post.txn_customerName |> binary_to_string(),
    post.fdep_startDate |> binary_to_string(),
    post.fdep_startDate |> binary_to_string(),
    post.fdep_endDate |> binary_to_string(),
    post.txn_currency |> binary_to_string(),
    post.fdep_principle_amount |> binary_to_string(),
    post.product_interest |> binary_to_string() |> to_string,
    post.txn_referenceNo |> binary_to_string() |> to_string,
    post.txn_status |> binary_to_string() |> to_string
  ]
end

######################################################################################################################################

def report_deposit_interest_view_header_csv(),
do: [
  [
    "Product Code(tenour)",
    "Customer ID",
    "Moble No.",
    "Customer Name",
    "Value Date",
    "Value Time",
    "Maturity Date",
    "Principal Amount",
    "Rate (%)",
    "Interest Expense as @ Today",
    "Interest YTD",
    "User Reference No",
    "Status"
  ]
]

def report_deposit_interest_view_header(),
do: [
  ["Product Code(tenour)", bg_color: "#ebe8e8", bold: true],
  ["Customer ID", bg_color: "#ebe8e8", bold: true],
  ["Moble No.", bg_color: "#ebe8e8", bold: true],
  ["Customer Name", bg_color: "#ebe8e8", bold: true],
  ["Value Date", bg_color: "#ebe8e8", bold: true],
  ["Value Time", bg_color: "#ebe8e8", bold: true],
  ["Maturity Date", bg_color: "#ebe8e8", bold: true],
  ["Principal Amount", bg_color: "#ebe8e8", bold: true],
  ["Rate (%)", bg_color: "#ebe8e8", bold: true],
  ["Interest Expense as @ Today", bg_color: "#ebe8e8", bold: true],
  ["Interest YTD", bg_color: "#ebe8e8", bold: true],
  ["User Reference No", bg_color: "#ebe8e8", bold: true],
  ["Status", bg_color: "#ebe8e8", bold: true]
]

def report_deposit_interest_view_row(post) do
[
  post.product_code |> binary_to_string(),
  post.meansOfIdentificationNumber |> binary_to_string(),
  post.mobileNumber |> binary_to_string(),
  post.txn_customerName |> binary_to_string(),
  post.fdep_startDate |> binary_to_string(),
  post.fdep_startDate |> binary_to_string(),
  post.fdep_endDate |> binary_to_string(),
  post.fdep_principle_amount |> binary_to_string(),
  post.product_interest |> binary_to_string(),
  post.fdep_accruedInterest |> binary_to_string() |> to_string,
  post.fdep_expectedInterest |> binary_to_string() |> to_string,
  post.txn_referenceNo |> binary_to_string() |> to_string,
  post.txn_status |> binary_to_string() |> to_string
]
end

######################################################################################################################################


end
