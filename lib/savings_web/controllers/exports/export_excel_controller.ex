defmodule SavingsWeb.ExportExcelController do
  use SavingsWeb, :controller
  alias Savings.Service.Export.ExportServices
  alias SavingsWeb.ExportController
  alias Savings.Transactions
  alias Savings.ServicesExt.AuditService
  alias Elixlsx.{Workbook, Sheet}
  use PipeTo.Override
  # use SavingsWeb, :universal


  def customer_view_excel(conn, _params) do
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=Customer_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
    )
    |> send_resp(
      200,
      customer_view_content(
        Savings.Service.QueriesExport.customer_export()
      )
    )
  end

  def customer_view_content(data) do
    report_generator_customer_view(data)
    |> Elixlsx.write_to_memory("Customer.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def report_generator_customer_view(posts) do
    rows = posts |> Enum.map(&ExportServices.customer_view_row/1)

    %Workbook{
      sheets: [
        %Sheet{
          name: "Customer Report",
          rows: [ExportServices.customer_view_header()] ++ rows
        }
      ]
    }
  end

#####################################################################################################################

  def tnx_fixed_deps_view_excel(conn, _params) do
    conn
    |> put_resp_content_type("text/xlsx")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=fixed_deposists_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
    )
    |> send_resp(
      200,
      fixed_deps_view_content(
        Savings.Service.QueriesExport.fix_dep_export()
      )
    )
  end

  def fixed_deps_view_content(data) do
    report_generator_fixed_deps_view(data)
    |> Elixlsx.write_to_memory("FixedDeposistsReport.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def report_generator_fixed_deps_view(posts) do
    rows = posts |> Enum.map(&ExportServices.tnx_fixed_deps_view_row/1)

    %Workbook{
      sheets: [
        %Sheet{
          name: "Fixed Deposit Report",
          rows: [ExportServices.tnx_fixed_deps_view_header()] ++ rows
        }
      ]
    }
  end

#####################################################################################################################

def partial_divestment_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=partial_divestment_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    partial_divestment_view_content(
      Savings.Service.QueriesExport.partial_divestment_export()
    )
  )
end

def partial_divestment_view_content(data) do
  report_generator_partial_divestment_view(data)
  |> Elixlsx.write_to_memory("partial_divestment.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_partial_divestment_view(posts) do
  rows = posts |> Enum.map(&ExportServices.partial_divestment_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "Partial Divestment Report",
        rows: [ExportServices.partial_divestment_view_header()] ++ rows
      }
    ]
  }
end
#####################################################################################################################

def full_divestment_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=full_divestment_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    full_divestment_view_content(
      Savings.Service.QueriesExport.full_divestment_export()
    )
  )
end

def full_divestment_view_content(data) do
  report_generator_full_divestment_view(data)
  |> Elixlsx.write_to_memory("full_divestment.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_full_divestment_view(posts) do
  rows = posts |> Enum.map(&ExportServices.full_divestment_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "Full Divestment Report",
        rows: [ExportServices.full_divestment_view_header()] ++ rows
      }
    ]
  }
end
#####################################################################################################################

def mature_withdraw_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=mature_withdraw_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    mature_withdraw_view_content(
      Savings.Service.QueriesExport.mature_withdraw_export()
    )
  )
end

def mature_withdraw_view_content(data) do
  report_generator_mature_withdraw_view(data)
  |> Elixlsx.write_to_memory("mature_withdraw.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_mature_withdraw_view(posts) do
  rows = posts |> Enum.map(&ExportServices.mature_withdraw_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "Mature Withdraw Report",
        rows: [ExportServices.mature_withdraw_view_header()] ++ rows
      }
    ]
  }
end
#####################################################################################################################

def all_transactions_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=all_transactions_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    all_transactions_view_content(
      Savings.Service.QueriesExport.all_transactions_export()
    )
  )
end

def all_transactions_view_content(data) do
  report_generator_all_transactions_view(data)
  |> Elixlsx.write_to_memory("all_transactions.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_all_transactions_view(posts) do
  rows = posts |> Enum.map(&ExportServices.all_transactions_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "All Transactions Report",
        rows: [ExportServices.all_transactions_view_header()] ++ rows
      }
    ]
  }
end

#####################################################################################################################

def report_fixed_deps_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=fixed_deposists_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    report_fixed_deps_view_content(
      Savings.Service.QueriesExport.fix_dep_report_export()
    )
  )
end

def report_fixed_deps_view_content(data) do
  report_generator_report_fixed_deps_view(data)
  |> Elixlsx.write_to_memory("FixedDeposistsReport.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_report_fixed_deps_view(posts) do
  rows = posts |> Enum.map(&ExportServices.fixed_deps_report_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "Fixed Deposit Report",
        rows: [ExportServices.fixed_deps_report_view_header()] ++ rows
      }
    ]
  }
end

#####################################################################################################################

def report_deposit_summury_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=report_deposit_summury_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    report_deposit_summury_view_content(
      Savings.Service.QueriesExport.report_deposit_summury_export()
    )
  )
end

def report_deposit_summury_view_content(data) do
  report_generator_report_deposit_summury_view(data)
  |> Elixlsx.write_to_memory("report_deposit_summury.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_report_deposit_summury_view(posts) do
  rows = posts |> Enum.map(&ExportServices.report_deposit_summury_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "Deposit Summury Report",
        rows: [ExportServices.report_deposit_summury_view_header()] ++ rows
      }
    ]
  }
end
#####################################################################################################################

def report_deposit_interest_view_excel(conn, _params) do
  conn
  |> put_resp_content_type("text/xlsx")
  |> put_resp_header(
    "content-disposition",
    "attachment; filename=report_deposit_interest_view_report-#{Savings.Util.Time.local_time2()}.xlsx"
  )
  |> send_resp(
    200,
    report_deposit_interest_view_content(
      Savings.Service.QueriesExport.report_deposit_interest_export()
    )
  )
end

def report_deposit_interest_view_content(data) do
  report_generator_report_deposit_interest_view(data)
  |> Elixlsx.write_to_memory("report_deposit_interest.xlsx")
  |> elem(1)
  |> elem(1)
end

def report_generator_report_deposit_interest_view(posts) do
  rows = posts |> Enum.map(&ExportServices.report_deposit_interest_view_row/1)

  %Workbook{
    sheets: [
      %Sheet{
        name: "Deposit Interest Report",
        rows: [ExportServices.report_deposit_interest_view_header()] ++ rows
      }
    ]
  }
end
#####################################################################################################################
end
