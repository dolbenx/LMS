defmodule SavingsWeb.ExportCsvController do
  use SavingsWeb, :controller
  alias Savings.Service.Export.ExportServices
  alias Savings.ServicesExt.AuditService


  def customer_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=Customer_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, customer_view_content())
  end

  defp customer_view_content() do
    Savings.Service.QueriesExport.customer_export()
    |> Stream.map(&ExportServices.customer_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.customer_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  ##########################################################################################################################

  def tnx_fixed_deps_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=fixed_deposists_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, tnx_fixed_deps_view_content())
  end

  defp tnx_fixed_deps_view_content() do
    Savings.Service.QueriesExport.fix_dep_export()
    |> Stream.map(&ExportServices.tnx_fixed_deps_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.tnx_fixed_deps_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  ##########################################################################################################################

  def partial_divestment_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=partial_divestment_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, partial_divestment_view_content())
  end

  defp partial_divestment_view_content() do
    Savings.Service.QueriesExport.partial_divestment_export()
    |> Stream.map(&ExportServices.partial_divestment_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.partial_divestment_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  ##########################################################################################################################

  def full_divestment_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=full_divestment_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, full_divestment_view_content())
  end

  defp full_divestment_view_content() do
    Savings.Service.QueriesExport.full_divestment_export()
    |> Stream.map(&ExportServices.full_divestment_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.full_divestment_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  ##########################################################################################################################

  def mature_withdraw_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=mature_withdraw_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, mature_withdraw_view_content())
  end

  defp mature_withdraw_view_content() do
    Savings.Service.QueriesExport.mature_withdraw_export()
    |> Stream.map(&ExportServices.mature_withdraw_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.mature_withdraw_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  ##########################################################################################################################

  def all_transactions_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=all_transactions_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, all_transactions_view_content())
  end

  defp all_transactions_view_content() do
    Savings.Service.QueriesExport.all_transactions_export()
    |> Stream.map(&ExportServices.all_transactions_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.all_transactions_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

   ##########################################################################################################################

   def report_fixed_deps_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=fixed_deposists_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, report_fixed_deps_view_content())
  end

  defp report_fixed_deps_view_content() do
    Savings.Service.QueriesExport.fix_dep_report_export()
    |> Stream.map(&ExportServices.fixed_deps_report_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.fixed_deps_report_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

   ##########################################################################################################################

   def report_deposit_summury_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=report_deposit_summury_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, report_deposit_summury_view_content())
  end

  defp report_deposit_summury_view_content() do
    Savings.Service.QueriesExport.report_deposit_summury_export()
    |> Stream.map(&ExportServices.report_deposit_summury_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices.report_deposit_summury_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

   ##########################################################################################################################

   def  report_deposit_interest_view_csv(conn, _params) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename= report_deposit_interest_view_report-#{Savings.Util.Time.local_time2()}.csv"
    )
    |> send_resp(200, report_deposit_interest_view_content())
  end

  defp  report_deposit_interest_view_content() do
    Savings.Service.QueriesExport.report_deposit_interest_export()
    |> Stream.map(&ExportServices.report_deposit_interest_view_row/1)
    |> (fn stream -> Stream.concat(ExportServices. report_deposit_interest_view_header_csv(), stream) end).()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end
end
