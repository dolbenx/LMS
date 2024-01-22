defmodule Intergrator.Intergrations do
  use LoanSavingsSystemWeb, :controller

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.LoanApplications.LoanApplicationsSme

##################################################################################### PBL INTERGRATING #############################################################

  # Intergrator.Intergrations.pbl_product_list
  def pbl_product_list() do
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "PBL Product List",
							conversationid: "#{Timex.now}"
						},
						body: %{
								shortname: "GRIZZLY"
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/prodlist"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["prodlist"]
							IO.inspect list

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end


  # Intergrator.Intergrations.pbl_loan_initiation
  def pbl_loan_initiation(conn, params) do
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "PBL Loan Initiation",
							conversationid: "#{Timex.now}"
						},
						body: %{
              custtype: params["custtype"],
              customerid: params["customerid"],
              branchcode: params["branchcode"],
              nrc: params["nrc"],
              titleid: params["titleid"],
              firstname: params["firstname"],
              middlename: params["middlename"],
              lastname: params["lastname"],
              dob: params["dob"],
              genderid: params["genderid"],
              maritalstatusid: params["maritalstatusid"],
              address1: params["address1"],
              districtid1: params["districtid1"],
              provinceid1: params["provinceid1"],
              countryid1: params["countryid1"],
              postalcode1: params["postalcode1"],
              address2: params["address2"],
              districtid2: params["districtid2"],
              provinceid2: params["provinceid2"],
              countryid2: params["countryid2"],
              postalcode2: params["postalcode1"],
              homephone: params["homephone"],
              workphone: params["workphone"],
              mobileno: params["mobileno"],
              emailid: params["emailid"],
              division: params["division"],
              nationalityid: params["nationalityid"],
              passportno: params["passportno"],
              drivinglicenseno: params["drivinglicenseno"],
              bankaccountno: params["bankaccountno"],
              bankname: params["bankname"],
              bankbranch: params["bankbranch"],
              bankaccounttype: params["bankaccounttype"],
              bankaccountname: params["bankaccountname"],
              employercode: params["employercode"],
              employeeid: params["employeeid"],
              employmenttypeid: params["employmenttypeid"],
              employementstartdate: params["employementstartdate"],
              contractenddate: params["contractenddate"],
              employerproductmapid: params["employerproductmapid"],
              loanamount: params["loanamount"],
              loandate: params["loandate"],
              isforceclosur: params["isforceclosur"],
              forceclosureloanid: params["forceclosureloanid"],
              forceclosuredate: params["forceclosuredate"],
              loantypeid: params["loantypeid"],
              loanpurposeid: params["loanpurposeid"],
              occupation: params["occupation"],
              ispayoff: params["ispayoff"],
              payoffaccountnumber: params["payoffaccountnumber"],
              payoffmode: params["payoffmode"],
              payoffbranch: params["payoffbranch"],
              payoffamount: params["payoffamount"],
              payoffinstitution: params["payoffinstitution"],
              kindetails: [
                %{
                    kinnrcid: params["kinnrcid"],
                    kintitleid: params["kintitleid"],
                    kinfirstname: params["kinfirstname"],
                    kinmiddlename: params["kinmiddlename"],
                    kinlastname: params["kinlastname"],
                    kindob: params["kindob"],
                    kinmaritalstatusid: params["kinmaritalstatusid"],
                    kingenderid: params["kingenderid"],
                    kinrelationshipid: params["kinrelationshipid"],
                    kinplaceofwork: params["kinplaceofwork"],
                    kinoccupation: params["kinoccupation"],
                    kintelephonenumber: params["kintelephonenumber"],
                    kinmobilenumber: params["kintelephonenumber"]
                  }
                ],
              salarydetails: [
                  %{
                    salarycomponent: params["salarycomponent"],
                    amount: params["amount"],
                    salarycomponenttypeid: params["salarycomponenttypeid"]
                  },
                  %{
                    salarycomponent: "NAPSA",
                    amount: 500.0,
                    salarycomponenttypeid: 4
                  },
                  %{
                    salarycomponent: "PAYE",
                    amount: 500.0,
                    salarycomponenttypeid: 5
                  }
                ],
              documents: [
                  %{
                    doctypeid: params["doctypeid"],
                    document: params["document"],
                    document_doccontent: "RDpTUUwgMTAwMCBSb2xlcy50eHQ="
                  }
              ]
            }
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
          header = [
              {"Content-Type", "application/json"},
              {"Authorization", "Basic #{hashkey}"},
              {"Accept", "*/*"}
          ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/initiatepbl"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              rstmsg = bearerBody["body"]["rstmsg"]
              IO.inspect rstmsg
              case rstmsg do
                nil ->
                  "There was an error on iproof"
                _->
                  rstmsg
              end
              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end

  end

   # Intergrator.Intergrations.pbl_payment_inititation
   def pbl_payment_inititation(conn, params) do
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Loan Payment",
							conversationid: "#{Timex.now}"
						},
						body: %{
              nrcnumber: params["nrcnumber"],
              paymentamount: params["paymentamount"],
              loanid: params["loanid"],
              modeofpaymentid: params["modeofpaymentid"],
              paymentdate: params["paymentdate"],
              instrumentnumber: params["instrumentnumber"],
              branchcode: params["branchcode"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/payment/Initiatepayment"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["rstmsg"]
							IO.inspect list

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end

  # Intergrator.Intergrations.pbl_loan_refund
  def pbl_loan_refund(conn, params) do
    IO.inspect params
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Loan Refund Request",
							conversationid: "#{Timex.now}"
						},
						body: %{
              nrcnumber: params["nrcnumber"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/payment/custreqrefund"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["rstmsg"]
							IO.inspect list

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end

  # Intergrator.Intergrations.pbl_affordable_amount
  def pbl_affordable_amount(conn, params) do
    IO.inspect params
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Loan Affordable Amount",
							conversationid: "#{Timex.now}"
						},
						body: %{
              gincome: params["gincome"],
              deduction: params["deduction"],
              shortname: "GRIZZLY",
              epmapid: params["productcode"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/checkpblaffordable"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["Affordability"]
							rstmsg = bearerBody["body"]["rstmsg"]
              IO.inspect "------------------------------------"
							IO.inspect list
              IO.inspect rstmsg

              case rstmsg do
                "I-0 : Successfully completed" ->
                  list |> List.first


                nil ->
                  IO.inspect rstmsg

                _->
                  IO.inspect rstmsg


                [] ->
                  IO.puts("There was a problem")
              end


              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end

  # Intergrator.Intergrations.pbl_mini_statement
  def pbl_mini_statement(conn, params) do
    IO.inspect params
    refnotype = String.to_integer(params["refnotype"])
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Loan Mini Statement",
							conversationid: "#{Timex.now}"
						},
						body: %{
              refnotype: refnotype,
              refnumber: params["refnumber"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/ministatement"

      loans = case HTTPoison.request(:post, url, xml, header) do
        {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
            IO.inspect "000000000000000000"
            IO.inspect reason
            []

        {:ok, struct} ->
            IO.inspect struct.body
            bearerBody =  Jason.decode!(struct.body)
            list = bearerBody["body"]
            loanref = bearerBody["body"]
            rstmsg = bearerBody["body"]["rstmsg"]
            IO.inspect "------------------------------------"
            IO.inspect list
            IO.inspect rstmsg
            IO.inspect loanref

            case rstmsg do

              "I-0 : Successfully completed" ->
                case refnotype do

                  2 ->
                    list

                  1 ->
                    loanref
                end

              nil ->
                IO.inspect rstmsg

              _->
                IO.inspect rstmsg

              [] ->
                IO.puts("There was a problem")
            end

            # bearer = bearerBody["access_token"]
            # IO.inspect bearer
            # random_int2 = to_string(Enum.random(11111111..99999999))
      end
  end

   # Intergrator.Intergrations.pbl_loan_statement
   def pbl_loan_statement(conn, params) do
    IO.inspect params
    refnotype = String.to_integer(params["refnotype"])
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Loan Mini Statement",
							conversationid: "#{Timex.now}"
						},
						body: %{
              refnotype: refnotype,
              refnumber: params["refnumber"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/statement"

      loans = case HTTPoison.request(:post, url, xml, header) do
        {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
            IO.inspect "000000000000000000"
            IO.inspect reason
            []

        {:ok, struct} ->
            IO.inspect struct.body
            bearerBody =  Jason.decode!(struct.body)
            list = bearerBody["body"]
            loanref = bearerBody["body"]
            rstmsg = bearerBody["body"]["rstmsg"]
            IO.inspect "------------------------------------"
            IO.inspect list
            IO.inspect rstmsg
            IO.inspect loanref

            case rstmsg do

              "I-0 : Successfully completed" ->
                case refnotype do

                  2 ->
                    list

                  1 ->
                    loanref
                end

              nil ->
                IO.inspect rstmsg

              _->
                IO.inspect rstmsg

              [] ->
                IO.puts("There was a problem")
            end

            # bearer = bearerBody["access_token"]
            # IO.inspect bearer
            # random_int2 = to_string(Enum.random(11111111..99999999))
      end
  end

  # Intergrator.Intergrations.pbl_cur_sch_balance
  def pbl_cur_sch_balance(conn, params) do
    IO.inspect params
    refnotype = String.to_integer(params["refnotype"])
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Current Schedule Balance",
							conversationid: "#{Timex.now}"
						},
						body: %{
              refnotype: refnotype,
              refnumber: params["refnumber"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/curschbalance"

      loans = case HTTPoison.request(:post, url, xml, header) do
        {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
            IO.inspect "000000000000000000"
            IO.inspect reason
            []

        {:ok, struct} ->
            IO.inspect struct.body
            bearerBody =  Jason.decode!(struct.body)
            list = bearerBody["body"]
            loanref = bearerBody["body"]
            rstmsg = bearerBody["body"]["rstmsg"]
            IO.inspect "------------------------------------"
            IO.inspect list
            IO.inspect rstmsg
            IO.inspect loanref

            case rstmsg do

              "I-0 : Successfully completed" ->
                case refnotype do

                  2 ->
                    list

                  1 ->
                    loanref
                end

              nil ->
                IO.inspect rstmsg

              _->
                IO.inspect rstmsg

              [] ->
                IO.puts("There was a problem")
            end

            # bearer = bearerBody["access_token"]
            # IO.inspect bearer
            # random_int2 = to_string(Enum.random(11111111..99999999))
      end
  end


  # Intergrator.Intergrations.pbl_loan_tracking
  def pbl_loan_tracking(conn, params) do
    IO.inspect params
    refnotype = String.to_integer(params["refnotype"])
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Loan Track",
							conversationid: "#{Timex.now}"
						},
						body: %{
              refnotype: refnotype,
              refnumber: params["refnumber"]
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/track"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]
              loanref = bearerBody["body"]
              rstmsg = bearerBody["body"]["rstmsg"]
              IO.inspect "------------------------------------"
							IO.inspect list
              IO.inspect rstmsg
              IO.inspect loanref

              case rstmsg do

                "I-0 : Successfully completed" ->
                  case refnotype do

                    2 ->
                      list

                    1 ->
                      loanref
                  end

                nil ->
                  IO.inspect rstmsg

                _->
                  IO.inspect rstmsg

                [] ->
                  IO.puts("There was a problem")
              end

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end


  # Intergrator.Intergrations.pbl_loan_test
  def pbl_loan_test() do
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
          header: %{
            orgcode: "MFZ",
            vendorcode: "VM20202800000000036",
            tag: "Product List",
            conversationid: "#{Timex.now}"
          },
          body: %{
            custtype: "Individual",
            customerid: "1",
            branchcode: "700",
            nrc: "365924/10/1",
            titleid: "1",
            firstname: "Davies",
            middlename: "Dolben",
            lastname: "Phiri",
            dob: "1990-05-29",
            genderid: 1,
            maritalstatusid: 1,
            address1: "Lusaka",
            districtid1: 1,
            provinceid1: 1,
            countryid1: 1,
            postalcode1: "Lusaka",
            address2: "Lusaka",
            districtid2: 1,
            provinceid2: 1,
            countryid2: 1,
            postalcode2: "Lusaka",
            homephone: "260978242442",
            workphone: "260978242442",
            mobileno: "260978242442",
            emailid: "davies@probasegroup.com",
            division: "Lusaka",
            nationalityid: 1,
            passportno: "8388293892",
            drivinglicenseno: "99900099",
            bankaccountno: "3847588239492",
            bankname: "Stanbic",
            bankbranch: "Main",
            bankaccounttype: "Current",
            bankaccountname: "Current",
            employercode: "00000073",
            employeeid: 246,
            employmenttypeid: 1,
            employementstartdate: "2022-05-29",
            contractenddate: "2022-05-29",
            employerproductmapid: "c8ea3b11-67e0-4cfc-8954-ab11da36ddaf",
            loanamount: 500.0,
            loandate: "2022-05-29",
            isforceclosur: "YES",
            forceclosureloanid: "1",
            forceclosuredate: "2022-05-29",
            loantypeid: 1,
            loanpurposeid: 1,
            occupation: "Developer",
            ispayoff: "YES",
            payoffaccountnumber: "34433343344",
            payoffmode: "Cash",
            payoffbranch: "Main",
            payoffamount: 500.0,
            payoffinstitution: "Stanbic",
            kindetails: [
              %{
                kinnrcid: "1",
                kintitleid: 1,
                kinfirstname: "Adriel",
                kinmiddlename: "Promise",
                kinlastname: "Phiri",
                kindob: "1990-05-29",
                kinmaritalstatusid: 1,
                kingenderid: 1,
                kinrelationshipid: 1,
                kinplaceofwork: "Probase",
                kinoccupation: "Developer",
                kintelephonenumber: "260978242444",
                kinmobilenumber: "260978242444"
              }
            ],
            salarydetails: [
              %{
                salarycomponent: "Basic",
                amount: 6000.0,
                salarycomponenttypeid: 1
              },
              %{
                salarycomponent: "NAPSA",
                amount: 5000.0,
                salarycomponenttypeid: 4
              },
              %{
                salarycomponent: "PAYE",
                amount: 5000.0,
                salarycomponenttypeid: 5
              }
            ],
            documents: [
              %{
                doctypeid: 1,
                document: "Employee NRC ID",
                document_doccontent: "RDpTUUwgMTAwMCBSb2xlcy50eHQ="
              }
            ]
          }
        }
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
          header = [
              {"Content-Type", "application/json"},
              {"Authorization", "Basic #{hashkey}"},
              {"Accept", "*/*"}
          ]

      url = "http://192.168.218.52/ConnectCoin/api/loan/initiatepbl"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              rstmsg = bearerBody["body"]["rstmsg"]
              IO.inspect rstmsg
              case rstmsg do
                nil ->
                  "There was an error on iproof"
                _->
                  rstmsg
              end
              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end

  end


####################################################################################################################################################################

####################################################################################################################################################################
####################################################################################################################################################################
####################################################################################################################################################################

##################################################################################### SME INTERGRATING #############################################################

  # Intergrator.Intergrations.sme_product_list
  def sme_product_list(financetype) do
    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "PBL Product List",
							conversationid: "#{Timex.now}"
						},
						body: %{
              financetype: financetype
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
        header = [
            {"Content-Type", "application/json"},
            {"Authorization", "Basic #{hashkey}"},
            {"Accept", "*/*"}
        ]

      url = "http://192.168.218.52/connectcoin/api/sme/smeprodlist"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["prodList"]
							IO.inspect list

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end


  def sme_loan_init(conn, params) do

    hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
          header: %{
            orgcode: "MFZ",
            vendorcode: "VM20202800000000036",
            tag: "ORF Loan Initiation",
            conversationid: "#{Timex.now}"
          },
          body: %{
            smedetails: %{
              offtakerid: params["offtakerid"],
              financetype: params["financetype"],
              registrationno: params["registrationno"],
              customername: params["customername"],
              branch: params["branch"]
            },
            invoicedetails: [
              %{
                invoiceno: params["invoiceno"],
                invoicedate: params["invoicedate"],
                invoiceexpirydate: params["invoiceexpirydate"],
                invoicevalue: params["invoicevalue"],
                invoicedetails: params["invoicedetails"],
                invoicedoc: params["invoicedoc"]
              }
            ],
            loandetails: %{
              productcode: params["productcode"],
              loanamount: params["loanamount"],
              Loandate: params["Loandate"],
              Loanpurpose: params["Loanpurpose"],
              Guarantor: params["Guarantor"]
            },
            collateraldocuments: [
              %{
                coldocumentname: params["coldocumentname"],
                coldoc: params["coldoc"],
                coldoc_doccontent: params["coldoc_doccontent"],
                coldetail: params["coldetail"],
                collateralvalue: params["collateralvalue"],
                appraisedvalue: params["appraisedvalue"]
              }
            ],
            loanproofdocuments: [
              %{
                documenttype: params["documenttype"],
                documentdetail: params["documentdetail"],
                loandoc: params["loandoc"],
                loandoc_doccontent: params["loandoc_doccontent"]
              }
            ],
            otherfinancedetails: [
              %{
                fininstitutionname: params["fininstitutionname"],
                facility: params["facility"],
                exposure: params["exposure"],
                maturitydate: params["maturitydate"]
              }
            ]
          }
        }

        IO.inspect "xml3"
				IO.inspect xml
        xml = Jason.encode!(xml)
          header = [
              {"Content-Type", "application/json"},
              {"Authorization", "Basic #{hashkey}"},
              {"Accept", "*/*"}
          ]

      url = "http://192.168.218.52/ConnectCoin/api/sme/smeloanInit"

      loans = case HTTPoison.request(:post, url, xml, header) do
          {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
              IO.inspect "000000000000000000"
              IO.inspect reason
              []

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.sme_path(conn, :sme_loan_products))

          {:ok, struct} ->
              IO.inspect struct.body
              bearerBody =  Jason.decode!(struct.body)
              list = bearerBody["body"]["rstmsg"]
							IO.inspect list

              # bearer = bearerBody["access_token"]
              # IO.inspect bearer
              # random_int2 = to_string(Enum.random(11111111..99999999))
        end
  end






####################################################################################################################################################################
  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end
end
