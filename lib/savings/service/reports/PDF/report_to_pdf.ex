defmodule Savings.Service.ReportToPdf do
  # get Tnx Fixed list

  ##################################################################################################################
  def get_tnx_fixed_deps_list(entries) do
    view_tnx_fixed_deps_list(list_tnx_fixed_deps_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_tnx_fixed_deps_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Transactions/list_tnx_fixed_deps.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """
        <tr>
            <td>{{ customer_names }}</td>
            <td>{{ mobileNumber }}</td>
            <td>{{ customer_identity }}</td>
            <td>{{ account_status }}</td>
            <td>{{ account_number }}</td>
            <td>{{ deposited_amount }}</td>
            <td>{{ deposited_date }}</td>
            <td>{{ txn_status }}</td>
        </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_tnx_fixed_deps_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "customer_names" => to_string(x.customer_names),
        "mobileNumber" => to_string(x.mobileNumber),
        "customer_identity" => to_string(x.customer_identity),
        "account_status" => to_string(x.account_status),
        "account_number" => to_string(x.account_number),
        "deposited_amount" => to_string(x.deposited_amount),
        "deposited_date" => to_string(x.deposited_date),
        "txn_status" => to_string(x.txn_status)
      }
    end)
  end

   ##################################################################################################################

   def get_customer_list(entries) do
    view_customer_list(list_customer_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_customer_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Customers/list_customers.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ customer_names }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ meansOfIdentificationNumber }}</td>
          <td>{{ accountType }}</td>
          <td>{{ account_status }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_customer_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "customer_names" => to_string(x.customer_names),
        "mobileNumber" => to_string(x.mobileNumber),
        "meansOfIdentificationNumber" => to_string(x.meansOfIdentificationNumber),
        "accountType" => to_string(x.accountType),
        "account_status" => to_string(x.account_status)
      }
    end)
  end

   ##################################################################################################################

   def get_partial_divestment_list(entries) do
    view_partial_divestment_list(list_partial_divestment_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_partial_divestment_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Transactions/partial_divestment.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ txn_customerName }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ customer_identity }}</td>
          <td>{{ account_status }}</td>
          <td>{{ account_number }}</td>
          <td>{{ divestmentType }}</td>
          <td>{{ txn_totalAmount }}</td>
          <td>{{ txn_status }}</td>
          <td>{{ divestment_date }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_partial_divestment_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "txn_customerName" => to_string(x.txn_customerName),
        "mobileNumber" => to_string(x.mobileNumber),
        "customer_identity" => to_string(x.customer_identity),
        "account_status" => to_string(x.account_status),
        "account_number" => to_string(x.account_number),
        "divestmentType" => to_string(x.divestmentType),
        "txn_totalAmount" => to_string(x.txn_totalAmount),
        "txn_status" => to_string(x.txn_status),
        "divestment_date" => to_string(x.divestment_date)
      }
    end)
  end

   ##################################################################################################################

   def get_full_divestment_list(entries) do
    view_full_divestment_list(list_full_divestment_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_full_divestment_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Transactions/full_divestment.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ txn_customerName }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ customer_identity }}</td>
          <td>{{ account_status }}</td>
          <td>{{ account_number }}</td>
          <td>{{ divestmentType }}</td>
          <td>{{ txn_totalAmount }}</td>
          <td>{{ txn_status }}</td>
          <td>{{ divestment_date }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_full_divestment_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "txn_customerName" => to_string(x.txn_customerName),
        "mobileNumber" => to_string(x.mobileNumber),
        "customer_identity" => to_string(x.customer_identity),
        "account_status" => to_string(x.account_status),
        "account_number" => to_string(x.account_number),
        "divestmentType" => to_string(x.divestmentType),
        "txn_totalAmount" => to_string(x.txn_totalAmount),
        "txn_status" => to_string(x.txn_status),
        "divestment_date" => to_string(x.divestment_date)
      }
    end)
  end

   ##################################################################################################################

   def get_mature_withdraw_list(entries) do
    view_mature_withdraw_list(list_mature_withdraw_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_mature_withdraw_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Transactions/mature_withdraws.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ txn_customerName }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ customer_identity }}</td>
          <td>{{ account_status }}</td>
          <td>{{ account_number }}</td>
          <td>{{ divestmentType }}</td>
          <td>{{ txn_totalAmount }}</td>
          <td>{{ txn_status }}</td>
          <td>{{ divestment_date }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_mature_withdraw_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "txn_customerName" => to_string(x.txn_customerName),
        "mobileNumber" => to_string(x.mobileNumber),
        "customer_identity" => to_string(x.customer_identity),
        "account_status" => to_string(x.account_status),
        "account_number" => to_string(x.account_number),
        "divestmentType" => to_string(x.divestmentType),
        "txn_totalAmount" => to_string(x.txn_totalAmount),
        "txn_status" => to_string(x.txn_status),
        "divestment_date" => to_string(x.divestment_date)
      }
    end)
  end

   ##################################################################################################################

   def get_all_transactions_list(entries) do
    view_all_transactions_list(list_all_transactions_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_all_transactions_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Transactions/all_transactions.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ txn_customerName }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ customer_identity }}</td>
          <td>{{ account_status }}</td>
          <td>{{ account_number }}</td>
          <td>{{ divestmentType }}</td>
          <td>{{ txn_totalAmount }}</td>
          <td>{{ txn_status }}</td>
          <td>{{ divestment_date }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_all_transactions_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "txn_customerName" => to_string(x.txn_customerName),
        "mobileNumber" => to_string(x.mobileNumber),
        "customer_identity" => to_string(x.customer_identity),
        "account_status" => to_string(x.account_status),
        "account_number" => to_string(x.account_number),
        "divestmentType" => to_string(x.divestmentType),
        "txn_totalAmount" => to_string(x.txn_totalAmount),
        "txn_status" => to_string(x.txn_status),
        "divestment_date" => to_string(x.divestment_date)
      }
    end)
  end


  ##################################################################################################################
  def get_report_fixed_deps_list(entries) do
    view_report_fixed_deps_list(list_report_fixed_deps_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_report_fixed_deps_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Reports/fixed_deposits.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """
        <tr>
            <td>{{ customer_names }}</td>
            <td>{{ startDate }}</td>
            <td>{{ startDate }}</td>
            <td>{{ endDate }}</td>
            <td>{{ product_code }}</td>
            <td>{{ fixedPeriod }}</td>
            <td>{{ interestRate }}</td>
            <td>{{ divestmentType }}</td>
            <td>{{ principalAmount }}</td>
            <td>{{ expectedInterest }}</td>
            <td>{{ totalDepositCharge }}</td>
            <td>{{ accruedInterest }}</td>
            <td>{{ amountDivested }}</td>
        </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_report_fixed_deps_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "customer_names" => to_string(x.customer_names),
        "startDate" => to_string(x.startDate),
        "startDate" => to_string(x.startDate),
        "endDate" => to_string(x.endDate),
        "product_code" => to_string(x.product_code),
        "fixedPeriod" => to_string(x.fixedPeriod),
        "interestRate" => to_string(x.interestRate),
        "divestmentType" => to_string(x.divestmentType),
        "principalAmount" => to_string(x.principalAmount),
        "expectedInterest" => to_string(x.expectedInterest),
        "totalDepositCharge" => to_string(x.totalDepositCharge),
        "accruedInterest" => to_string(x.accruedInterest),
        "amountDivested" => to_string(x.amountDivested),
      }
    end)
  end

   ##################################################################################################################
   def get_report_deposit_summury_list(entries) do
    view_report_deposit_summury_list(list_report_deposit_summury_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_report_deposit_summury_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Reports/deposits_summury.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ product_code }}</td>
          <td>{{ meansOfIdentificationNumber }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ txn_customerName }}</td>
          <td>{{ fdep_startDate }}</td>
          <td>{{ fdep_startDate }}</td>
          <td>{{ fdep_endDate }}</td>
          <td>{{ txn_currency }}</td>
          <td>{{ fdep_principle_amount }}</td>
          <td>{{ product_interest }}</td>
          <td>{{ txn_referenceNo }}</td>
          <td>{{ txn_status }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_report_deposit_summury_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "product_code" => to_string(x.product_code),
        "meansOfIdentificationNumber" => to_string(x.meansOfIdentificationNumber),
        "mobileNumber" => to_string(x.mobileNumber),
        "txn_customerName" => to_string(x.txn_customerName),
        "fdep_startDate" => to_string(x.fdep_startDate),
        "fdep_startDate" => to_string(x.fdep_startDate),
        "fdep_endDate" => to_string(x.fdep_endDate),
        "txn_currency" => to_string(x.txn_currency),
        "fdep_principle_amount" => to_string(x.fdep_principle_amount),
        "product_interest" => to_string(x.product_interest),
        "txn_referenceNo" => to_string(x.txn_referenceNo),
        "txn_status" => to_string(x.txn_status)
      }
    end)
  end

   ##################################################################################################################

   def get_report_deposit_interest_list(entries) do
    view_report_deposit_interest_list(list_report_deposit_interest_entry(entries))
    |> :bbmustache.render(%{"today_date" => to_string(Savings.Util.Time.local_time())},
      key_type: :binary
    )
    |> PdfGenerator.generate_binary!(page_width: "11.695", page_height: "8.26772")
  end

  defp view_report_deposit_interest_list(entries) do
    template =
      Application.app_dir(:savings, "priv/static/PDFs/Reports/deposit_interest.html.eex")
      |> File.read!()

    html_str =
      Enum.map(entries, fn entry ->
        """

        <tr>
          <td>{{ product_code }}</td>
          <td>{{ meansOfIdentificationNumber }}</td>
          <td>{{ mobileNumber }}</td>
          <td>{{ txn_customerName }}</td>
          <td>{{ fdep_startDate }}</td>
          <td>{{ fdep_startDate }}</td>
          <td>{{ fdep_endDate }}</td>
          <td>{{ fdep_principle_amount }}</td>
          <td>{{ product_interest }}</td>
          <td>{{ fdep_accruedInterest }}</td>
          <td>{{ fdep_expectedInterest }}</td>
          <td>{{ txn_referenceNo }}</td>
          <td>{{ txn_status }}</td>
      </tr>
        """
        |> :bbmustache.render(entry, key_type: :binary)
      end)

    body = "<tbody>" <> Enum.join(html_str, "") <> "</tbody>"
    String.replace(template, "<tbody></tbody>", body)
  end

  defp list_report_deposit_interest_entry(entry) do
    Enum.map(entry, fn x ->
      %{
        "product_code" => to_string(x.product_code),
        "meansOfIdentificationNumber" => to_string(x.meansOfIdentificationNumber),
        "mobileNumber" => to_string(x.mobileNumber),
        "txn_customerName" => to_string(x.txn_customerName),
        "fdep_startDate" => to_string(x.fdep_startDate),
        "fdep_startDate" => to_string(x.fdep_startDate),
        "fdep_endDate" => to_string(x.fdep_endDate),
        "fdep_principle_amount" => to_string(x.fdep_principle_amount),
        "product_interest" => to_string(x.product_interest),
        "fdep_accruedInterest" => to_string(x.fdep_accruedInterest),
        "fdep_expectedInterest" => to_string(x.fdep_expectedInterest),
        "txn_referenceNo" => to_string(x.txn_referenceNo),
        "txn_status" => to_string(x.txn_status)
      }
    end)
  end

   ##################################################################################################################
end
