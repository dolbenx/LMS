defmodule SavingsWeb.PageController do
  use SavingsWeb, :controller
  alias Savings.Repo
alias Savings.Accounts.User
  alias Savings.Accounts.UserRole
alias Savings.Notifications.Sms
alias Savings.UssdLogs.UssdLog
alias Savings.Ussd.UssdRequest
alias Savings.Products.Product
alias Savings.Transactions.Transaction
alias Savings.Emails.Email
  require Record
  import Ecto.Query, warn: false

  def index(conn, _params) do
    render(conn, "index.html")
  end

  # SavingsWeb.PageController.testemail
  def testemail do

        IO.inspect "CONTAINSSSSSSS"

        emailAddress = "dolben800@gmail.com"
        mobile_number = "260978242442"
        defaultCurrencyDecimals = 2
        # emailAddress = String.replace(emailAddress, "-", "@")

        IO.inspect "emailAddress....#{emailAddress}"
        # emailAddress = "dolben800@gmail.com"

        # case validate_email("#{emailAddress}") do
        # 	false ->
        # 		IO.inspect "fail"
        # 		response = "Invalid email address provided. Please go back to enter a valid email address\n\n1. View on ZIPAKE USSD\n2. Send to my email\n\nb. Back \n0. End"
        # 		send_response(conn, response)
        # 	true ->
                query = from au in User,
                    where: (au.username == type(^mobile_number, :string)),
                    select: au
                appUser = Repo.one(query)

                query = from au in Savings.Client.UserBioData, where: au.userId == ^appUser.id, select: au
                userBioData = Repo.one(query)
                html = "<html>"
                    html = html <> "<body>"
                        html = html <> "<div style=\"width: 100%; !important\">"
                            html = html <> "<div style=\"width: 100% !important\">"
                                html = html <> "<img src=\"#{File.cwd!}/priv/static/images/Microfinance-logo2.jpg\" style=\"height: 100px; width: 100px; text-align: right !important\">"
                            html = html <> "<div>"
                            html = html <> "<div style=\"width: 100% !important\">"
                                html = html <> "<h3 style=\"text-align: center !important\">ZIPAKE</h3>"
                                html = html <> "<h5 style=\"text-align: center !important\">Customer Statement Of Account</h5>"
                            html = html <> "<div>"

                            html = html <> "<div class=\"row\">"
                              html = html <> "<div class=\"col-md-6\" style=\"width: 100%; text-align: left; !important\">"
                                  html = html <> "<div style=\"width: 30% float: left !important \">"
                                      html = html <> "<strong>Account Name:</strong> <span>#{userBioData.firstName} #{userBioData.lastName}</span>"
                                  html = html <> "</div>"
                                  html = html <> "<div style=\"width: 30% float: left !important \">"
                                      html = html <> "<strong>Mobile Number:</strong> <span>#{appUser.username}</span>"
                                  html = html <> "</div>"
                                  html = html <> "<div style=\"width: 30% float: left !important \">"
                                      html = html <> "<strong>Statement Date:</strong> <span>#{Date.utc_today}</span>"
                                  html = html <> "</div>"
                              html = html <> "<div>"


                              html = html <> "<div class=\"col-md-6\" style=\"width: 100%; text-align: right; !important\">"
                                  html = html <> "<div style=\"width: 30% float: left !important \">"
                                      html = html <> "<strong>Account Name:</strong> <span>#{userBioData.firstName} #{userBioData.lastName}</span>"
                                  html = html <> "</div>"
                                  html = html <> "<div style=\"width: 30% float: left !important \">"
                                      html = html <> "<strong>Mobile Number:</strong> <span>#{appUser.username}</span>"
                                  html = html <> "</div>"
                                  html = html <> "<div style=\"width: 30% float: left !important \">"
                                      html = html <> "<strong>Statement Date:</strong> <span>#{Date.utc_today}</span>"
                                  html = html <> "</div>"
                              html = html <> "<div>"
                            html = html <> "<div>"



                        html = html <> "</div>"


                        html = html <> "<div style=\"width: 100% !important\">"


                            html = html <> "<table class=\"table table-bordered table-hover table-striped w-100\" style=\"width: 100% !important\">"
                                html = html <> "<thead>"
                                    html = html <> "<tr>"
                                        html = html <> "<th style=\"text-align: left !important padding: 15px !important background-color: #011949 !important color: #fff !important\">Date</th>"
                                        html = html <> "<th style=\"text-align: left !important padding: 15px !important background-color: #011949 !important color: #fff !important\">Transaction Description</th>"
                                        html = html <> "<th style=\"text-align: right !important padding: 15px !important background-color: #011949 !important color: #fff !important\">Debit</th>"
                                        html = html <> "<th style=\"text-align: right !important padding: 15px !important background-color: #011949 !important color: #fff !important\">Credit</th>"
                                        html = html <> "<th style=\"text-align: right !important padding: 15px !important background-color: #011949 !important color: #fff !important\">Balance</th>"
                                    html = html <> "</tr>"
                                html = html <> "</thead>"
                                html = html <> "<tbody>"


                                query = from au in Transaction,
                                    where: (au.userId == type(^appUser.id, :integer)) and au.status == "SUCCESSFUL",
                                    select: au
                                transactions = Repo.all(query)
                                tableEntries = []
                                tableEntries = for x <- 0..(Enum.count(transactions)-1) do
                                    transaction = Enum.at(transactions, x)
                                    tAmount = Float.ceil(transaction.totalAmount, defaultCurrencyDecimals)
                                    tAmount = :erlang.float_to_binary((tAmount), [{:decimals, defaultCurrencyDecimals}])
                                    tdt = transaction.inserted_at
                                    tdt = NaiveDateTime.to_string(tdt)
                                    IO.inspect tdt
                                    tdt = String.slice(tdt, 0, 10)
                                    IO.inspect tdt
                                    tableEntry = "<tr>"
                                        tableEntry = tableEntry <> "<td style=\"text-align: left !important\">#{tdt}</td>"
                                        tableEntry = tableEntry <> "<td style=\"text-align: left !important\">#{transaction.transactionDetail}</td>"
                                        tableEntry = if (transaction.transactionType=="CR") do
                                            tableEntry = tableEntry <> "<td style=\"text-align: right !important\">&nbsp</td>"
                                            tableEntry = tableEntry <> "<td style=\"text-align: right !important\">#{tAmount}</td>"
                                            tableEntry
                                        else
                                            tableEntry = tableEntry <> "<td style=\"text-align: right !important\">#{tAmount}</td>"
                                            tableEntry = tableEntry <> "<td style=\"text-align: right !important\">&nbsp</td>"
                                            tableEntry
                                        end
                                        tableEntry = tableEntry <> "<td style=\"text-align: right !important\">#{:erlang.float_to_binary((Float.ceil(transaction.newTotalBalance, defaultCurrencyDecimals)), [{:decimals, defaultCurrencyDecimals}])}</td>"
                                    tableEntry = tableEntry <> "</tr>"
                                    tableEntries = tableEntries ++ [tableEntry]
                                    tableEntries
                                end

                                tableEntries = Enum.join(tableEntries, "\n")
                                html = html <> tableEntries
                                html = html <> "</tbody>"
                            html = html <> "<table>"



                        html = html <> "</div>"
                    html = html <> "</body>"
                html = "
                <link rel=\"stylesheet\" href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css\" integrity=\"sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T\" crossorigin=\"anonymous\">
                <table class=\"table\">
                          <thead class=\"thead-dark\">
                            <tr>
                              <th scope=\"col\">#</th>
                              <th scope=\"col\">First</th>
                              <th scope=\"col\">Last</th>
                              <th scope=\"col\">Handle</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr>
                              <th scope=\"row\">1</th>
                              <td>Mark</td>
                              <td>Otto</td>
                              <td>@mdo</td>
                            </tr>
                            <tr>
                              <th scope=\"row\">2</th>
                              <td>Jacob</td>
                              <td>Thornton</td>
                              <td>@fat</td>
                            </tr>
                            <tr>
                              <th scope=\"row\">3</th>
                              <td>Larry</td>
                              <td>the Bird</td>
                              <td>@twitter</td>
                            </tr>
                          </tbody>
                        </table>

                        <table class=\"table\">
                          <thead class=\"thead-light\">
                            <tr>
                              <th scope=\"col\">#</th>
                              <th scope=\"col\">First</th>
                              <th scope=\"col\">Last</th>
                              <th scope=\"col\">Handle</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr>
                              <th scope=\"row\">1</th>
                              <td>Mark</td>
                              <td>Otto</td>
                              <td>@mdo</td>
                            </tr>
                            <tr>
                              <th scope=\"row\">2</th>
                              <td>Jacob</td>
                              <td>Thornton</td>
                              <td>@fat</td>
                            </tr>
                            <tr>
                              <th scope=\"row\">3</th>
                              <td>Larry</td>
                              <td>the Bird</td>
                              <td>@twitter</td>
                            </tr>
                          </tbody>
                        </table>"
                showfilename = "Statement of Account for #{userBioData.firstName}  #{userBioData.lastName}"
                {:ok, filename} = PdfGenerator.generate(html, page_size: "A5", filename: showfilename)
                IO.inspect "filename"
                IO.inspect filename
                Email.send_statement_of_account(emailAddress, userBioData, "ZIPAKE", filename)
                # #handleReceiveStatement(conn, mobile_number, cmd, text, checkMenu, selectedIndex)
                # response = "Your statement of account has been sent to the email address (#{emailAddress})\n\nPress \nb. Back"
                # # send_response_mail(conn, response)
                # send_response(conn, response)
    end
end
