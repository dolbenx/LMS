defmodule LoanSavingsSystem.Workers.LoanStatement do
  def generate(entry, _params) do
    entry = entry
    details = map_entry(entry)
    template = read_template(details)
    data = details |> Enum.at(0)

    map = %{
      "loan_officer" => data["loan_officer"],
      # "fees" => data["fees"],
      "processing_fee_percent" => data["processing_fee_percent"] || 10,
      "insurance_percent" => data["insurance_percent"] || 3,
      "processing_fee" => data["processing_fee"],
      "crb" => data["crb"],
      "insurance" => data["insurance"],
      "interest_balance" => data["interest_balance"],
      "fees" => data["fees"],
      "month_installment" => data["month_installment"],
      "net_disbursed" => data["net_disbursed"],
      "name" => data["name"],
      "loan_type" => data["loan_type"],
      "loan_id" => data["loan_id"],
      "repayment_period" => data["repayment_period"],
      "interet_per_month" => data["interet_per_month"],
      "requested_amount" => data["requested_amount"],
      "total_balance" => data["total_balance"],
    }

    template
    |> :bbmustache.render(map, key_type: :binary)
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp read_template(entries) do
    template =
      Application.app_dir(:loanmanagementsystem, "priv/static/reports/loan_statement.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """
        <tr>

            <td>{{ trn_dt }}</td>
            <td>{{ transaction }}</td>
            <td>{{ payment }}</td>
            <td>{{ interest }}</td>
            <td>{{ principle }}</td>
            <td>{{ runningBalance }}</td>

        </tr>

        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp map_entry(entry) do
    Enum.map(entry, fn x ->

      IO.inspect x.runningBalance, label: "x.runningBalance ----------------------"
      %{
        "trn_dt" => to_string(x.trn_dt),
        "application_date" => to_string(x.application_date),
        "transaction" => to_string(x.transaction),
        "mobileNumber" => to_string(x.mobileNumber),
        "name" => to_string(x.name),
        "loan_type" => to_string(x.loan_type),
        "loan_id" => to_string(x.id),
        "loan_officer" => to_string(x.loan_officer),
        "fees" => Number.Delimit.number_to_delimited(x.fees),
        "processing_fee_percent" => Number.Delimit.number_to_delimited(x.processing_fee_percent),
        "insurance_percent" => Number.Delimit.number_to_delimited(x.insurance_percent),
        "processing_fee" => Number.Delimit.number_to_delimited(x.processing_fee),
        "crb" => Number.Delimit.number_to_delimited(x.crb),
        "insurance" => Number.Delimit.number_to_delimited(x.insurance),
        "month_installment" => Number.Delimit.number_to_delimited(x.month_installment),
        "net_disbursed" => Number.Delimit.number_to_delimited(x.net_disbursed),
        "repayment_period" => Number.Delimit.number_to_delimited(x.repayment_period),
        "interet_per_month" => Number.Delimit.number_to_delimited(x.interet_per_month),
        "meansOfIdentificationNumber" => to_string(x.meansOfIdentificationNumber),
        "requested_amount" => Number.Delimit.number_to_delimited(x.requested_amount),
        "loan_interest" => Number.Delimit.number_to_delimited(x.loan_interest),
        "total_pl" => Number.Delimit.number_to_delimited(x.total_pl),
        "principle_balance" => Number.Delimit.number_to_delimited(x.principle_balance),
        "interest_balance" => Number.Delimit.number_to_delimited(x.interest_balance),
        "total_balance" => Number.Delimit.number_to_delimited(x.total_balance),
        "payment" => Number.Delimit.number_to_delimited(x.payment),
        "interest" => Number.Delimit.number_to_delimited(x.interest),
        "principle" => Number.Delimit.number_to_delimited(x.principle),
        "runningBalance" => Number.Delimit.number_to_delimited(x.runningBalance),

      }
    end)
  end
end
