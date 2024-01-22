defmodule SavingsWeb.UssdController do
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


    def initiateUssd(conn, dd) do

        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        IO.inspect  "-----------"
        IO.inspect  "Debug USSD Controller Starts here"
        IO.inspect  body

        query_params = conn.query_params
        session_id = query_params["SESSION_ID"]
        query_params = conn.query_params
        IO.inspect  Jason.encode!(query_params)
        mobile_number = query_params["MOBILE_NUMBER"]
        text = query_params["USSD_BODY"]
        cmd = query_params["SERVICE_KEY"]
        orginal_short_code = cmd

        IO.inspect cmd

        subscriberInput = query_params["USSD_BODY"]

        cmd = if (String.equivalent?(cmd, "254*30")) do

            IO.inspect "temporary ussd code"
            cmd = "*115#"
            cmd

        else
            text
        end

        # if mobile_number == "260978242442" do

            query = from au in UssdRequest, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                ussdRequests = Repo.all(query)

            text = if (Enum.count(ussdRequests) == 0) do
                text = text <> "*"
                IO.inspect  "No Ussd Requests"
                IO.inspect  text

                ussdRequest = %UssdRequest{}
                ussdRequest = %UssdRequest{mobile_number: mobile_number, request_data: text, session_id: session_id, session_ended: 0}

                case Repo.insert(ussdRequest) do
                    {:ok, ussdRequest} ->
                        query = from au in UssdRequest, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                        ussdRequest = Repo.one(query)
                        ussdRequest.request_data
                    {:error, changeset} ->
                        IO.inspect("Fail")
                        nil
                end
            else
                IO.inspect  "Ussd Requests Exist"
                IO.inspect  text

                text = String.trim_leading(text, "*")
                ussdRequest = Enum.at(ussdRequests, 0)

                IO.inspect ussdRequest.request_data
                reqdat = ussdRequest.request_data

                reqdat = String.trim_trailing(reqdat, " ")
                text = reqdat <> text <> "*"
                text = String.replace(text, "*B*", "*b*")
                IO.inspect  text

                attrs = %{request_data: text}
                ussdRequest
                |> UssdRequest.changesetForUpdate(attrs)
                |> Repo.update()
                text

            end
                IO.inspect "Text===========>"
                IO.inspect text

                    if(is_nil(text)) do

                        response = "Technical issues experienced. Press\n\nb. Back\n"
                        send_response(conn, response)
                    else

                        clientId = 1
                        IO.inspect clientId

                        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number, select: au
                            appusers = Repo.all(query)
                            IO.inspect  Enum.count(appusers)

                            IO.inspect  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
                            tempText = text
                            IO.inspect tempText

                            text = if String.ends_with?(tempText, "*b*") do
                                tempText = "115#*"
                            else

                                b_located = String.contains?(tempText, "*b*")

                                text = if b_located == true do

                                    tempCheckMenu = String.split(tempText, "*b*")
                                    IO.inspect tempCheckMenu
                                    tempCheckMenuFirst = Enum.at(tempCheckMenu, 0)
                                    IO.inspect tempCheckMenuFirst
                                    tempCheckMenuLength = Enum.count(tempCheckMenu)
                                    IO.inspect tempCheckMenuLength

                                    text = if Enum.count(tempCheckMenu) > 1 do

                                        IO.inspect "tempCheckMenuLast"
                                        tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1)
                                        IO.inspect tempCheckMenuLast

                                        text = if String.length(tempCheckMenuLast) > 0 do
                                            strlen_ = String.length(tempCheckMenuLast) - 1
                                            tempCheckMenuLast = String.slice(tempCheckMenuLast, 0, strlen_)
                                            tempText = "115#*#{tempCheckMenuLast}*"

                                            else
                                                text
                                            end
                                        end
                                    else

                                        b_located = String.contains?(tempText, "*0*")
                                        text = if b_located == true do
                                            text = false
                                        else
                                            text
                                        end
                                    end
                            end

                            IO.inspect("!!!!!!!")
                            IO.inspect(text)

                    if(text) do

                        if (Enum.count(appusers)>0) do
                            IO.inspect("==2222=================")
                            IO.inspect text

                            welcome_menu(conn, mobile_number, cmd, text)
                        else

                            IO.inspect(cmd)
                            IO.inspect(mobile_number)

                            IO.inspect("short_code...")
                            IO.inspect(cmd)
                            IO.inspect("text...")
                            IO.inspect(text)

                            if text do

                                if(text == "115*") do

                                    response = "Welcome to MFZ. \n\nType your first name"
                                    send_response(conn, response)

                                else

                                    checkMenu = String.split(text, "*")
                                    checkMenuLength = Enum.count(checkMenu)

                                    IO.inspect(checkMenuLength)
                                    IO.inspect"9999999999999999999999999999999999999999999"
                                    IO.inspect(checkMenu)
                                    case checkMenuLength do

                                        2 ->

                                            response = "Welcome to MFZ ZIPAKE \n\n1. Read Terms & Conditions \n2. Accept Terms & Conditions"
                                            send_response(conn, response)

                                        3 ->
                                            valueEntered = Enum.at(checkMenu, 1)
                                            IO.inspect (valueEntered)
                                            case valueEntered do

                                                "1" ->
                                                    response = "Summarized Terms & Conditions\n
                                                        i. Age 18+
                                                        ii. Min deposit K50
                                                        iii. Interest rates based on deposit tenure
                                                        iv. No 3rd party deposits
                                                        v. No withdrawals during term
                                                    \n\n 1. Proceeed"
                                                    send_response(conn, response)
                                                "2" ->
                                                        mobileNumber = mobile_number
                                                        IO.inspect mobileNumber

                                                        mobileNumberTruncated = String.slice(mobileNumber, 3..11)


                                                        params = %{
                                                            airtel_mobile: mobileNumberTruncated
                                                        }

                                                        custPush = Savings.Service.Momo.AirtelServices.customer_kyc(params)
                                                        statusCode = custPush.status_code

                                                        IO.inspect "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"

                                                        case statusCode do

                                                            200 ->
                                                                body =  Jason.decode!(custPush.body)
                                                                fname = body["data"]["first_name"]
                                                                IO.inspect fname
                                                                lname = body["data"]["last_name"]

                                                                IO.inspect lname
                                                                nrc = mobile_number

                                                                IO.inspect nrc
                                                                pin = "2023"
                                                                IO.inspect pin

                                                                pinEnc = Savings.Accounts.User.encrypt_password(pin)
                                                                pinEnc = String.trim_trailing(pinEnc, " ")
                                                                IO.inspect("fname..." <> fname)
                                                                IO.inspect("lname..." <> lname)
                                                                IO.inspect("nrc..." <> nrc)
                                                                IO.inspect("pinEnc..." <> pinEnc)

                                                                securityQuestionAnswer = "bingo"
                                                                securityQuestionAnswer = String.trim(securityQuestionAnswer)
                                                                securityQuestionAnswer = String.downcase(securityQuestionAnswer)
                                                                IO.inspect securityQuestionAnswer

                                                                sqSelectedId = 1

                                                                clientId = 1
                                                                appUser = %Savings.Accounts.User{canOperate: true, ussdActive: 1, username: mobile_number, clientId: clientId, status: "ACTIVE", pin: pinEnc, securityQuestionId: sqSelectedId, securityQuestionAnswer: securityQuestionAnswer}

                                                                case Repo.insert(appUser) do

                                                                    {:ok, appUser} ->
                                                                        userId = appUser.id
                                                                        firstName = fname
                                                                        lastName = lname
                                                                        meansOfIdentificationType = "NRC"
                                                                        meansOfIdentificationNumber = mobile_number

                                                                        appUserBioData = %Savings.Client.UserBioData{firstName: firstName, lastName: lastName, userId: userId, clientId: clientId,
                                                                            mobileNumber: mobile_number, meansOfIdentificationType: meansOfIdentificationType,
                                                                            meansOfIdentificationNumber: meansOfIdentificationNumber}

                                                                        case Repo.insert(appUserBioData) do

                                                                            {:ok, appUserBioData} ->
                                                                                status = "ACTIVE"
                                                                                roleType = "INDIVIDUAL"
                                                                                otp = Enum.random(1_000..9_999)
                                                                                otp = "#{otp}"
                                                                                appUserRole = %Savings.Accounts.UserRole{roleType: roleType, status: status, userId: userId, clientId: clientId, otp: otp}

                                                                                case Repo.insert(appUserRole) do

                                                                                    {:ok, appUserRole} ->
                                                                                        accountNo = mobile_number
                                                                                        accountType = "SAVINGS"
                                                                                        accountVersion = 1.0
                                                                                        clientId = 1
                                                                                        currencyDecimals = 2
                                                                                        currencyId = 1
                                                                                        currencyName = "ZMW"
                                                                                        status = "ACTIVE"
                                                                                        totalCharges = 0.00
                                                                                        totalDeposits = 0.00
                                                                                        totalInterestEarned = 0.00
                                                                                        totalInterestPosted = 0.00
                                                                                        totalPenalties = 0.00
                                                                                        totalTax = 0.00
                                                                                        totalWithdrawals = 0.00
                                                                                        derivedAccountBalance = 0.00
                                                                                        userId = appUser.id
                                                                                        userRoleId = appUserRole.id

                                                                                        account = %Savings.Accounts.Account{
                                                                                            accountNo: accountNo,
                                                                                            accountType: accountType,
                                                                                            accountVersion: accountVersion,
                                                                                            clientId: clientId,
                                                                                            currencyDecimals: currencyDecimals,
                                                                                            currencyId: currencyId,
                                                                                            currencyName: currencyName,
                                                                                            status: status,
                                                                                            totalCharges: totalCharges,
                                                                                            totalDeposits: totalDeposits,
                                                                                            totalInterestEarned: totalInterestEarned,
                                                                                            totalInterestPosted: totalInterestPosted,
                                                                                            totalPenalties: totalPenalties,
                                                                                            derivedAccountBalance: derivedAccountBalance,
                                                                                            totalTax: totalTax,
                                                                                            totalWithdrawals: totalWithdrawals,
                                                                                            userId: userId,
                                                                                            userRoleId: userRoleId,
                                                                                        }

                                                                                        case Repo.insert(account) do

                                                                                        {:ok, account} ->

                                                                                            #response = %{
                                                                                            #    Message: "Your new MFZ account has been setup for you. Press\n\nb. Back",
                                                                                            #    ClientState: 1,
                                                                                            #    Type: "Response",
                                                                                            #    key: "BA3"
                                                                                            #}

                                                                                            logUssdRequest(appUser.id, "NEW CLIENT", nil, "SUCCESS", mobile_number, "New client profile created successfully")

                                                                                            naive_datetime = Timex.now
                                                                                            sms = %{

                                                                                                mobile: mobile_number,
                                                                                                msg: "Dear #{firstName}, Thank You for registering for Zipake Savings. Go to *115# to start Saving . Click https://mfz.co.zm to read detail Ts& Cs.",
                                                                                                status: "READY",
                                                                                                type: "SMS",
                                                                                                msg_count: "1",
                                                                                                date_sent: naive_datetime
                                                                                            }

                                                                                            Sms.changeset(%Sms{}, sms)
                                                                                            |> Repo.insert()

                                                                                            response = "Your new Zipake account has been setup for you. Go to *115# to start Saving"
                                                                                            send_response_with_header(conn, response)

                                                                                        {:error, changeset} ->

                                                                                            IO.inspect("Fail")
                                                                                            #response = %{
                                                                                            #    Message: "Your new MFZ account could not be setup for you. Press\n\nb. Back",
                                                                                            #    ClientState: 1,
                                                                                            #    Type: "Response",
                                                                                            #    key: "BA3"
                                                                                            #}
                                                                                            logUssdRequest(conn.assigns.user.id, "NEW CLIENT", nil, "FAILED", mobile_number, "New client profile creation Failed")

                                                                                            response = "Your new MFZ account could not be setup for you. Press\n\nb. Back"
                                                                                            send_response(conn, response)

                                                                                        end

                                                                                    {:error, changeset} ->

                                                                                        IO.inspect("Fail")
                                                                                        #response = %{
                                                                                        #    Message: "Your new MFZ account could not be setup for you. Press\n\nb. Back",
                                                                                        #    ClientState: 1,
                                                                                        #    Type: "Response",
                                                                                        #    key: "BA3"
                                                                                        #}

                                                                                        response = "Your new MFZ account could not be setup for you. Press\n\nb. Back"
                                                                                        send_response(conn, response)
                                                                                end

                                                                            {:error, changeset} ->

                                                                                IO.inspect("Fail")
                                                                                #response = %{
                                                                                #    Message: "Your new MFZ account could not be setup for you. Press\n\nb. Back",
                                                                                #    ClientState: 1,
                                                                                #    Type: "Response",
                                                                                #    key: "BA3"
                                                                                #}

                                                                                response = "Your new MFZ account could not be setup for you. Press\n\nb. Back"
                                                                                send_response(conn, response)

                                                                        end

                                                                    {:error, changeset} ->

                                                                        IO.inspect("Fail")

                                                                        response = "Your MFZ Zipake account could not be setup for you. Press\n\nb. Back"
                                                                        send_response(conn, response)

                                                                end
                                                        end
                                            end

                                        4 ->

                                            response = "Accept Ts & Cs\n\n1. Enter 1 to accept \n0. Enter 0 to Decline"
                                            send_response(conn, response)

                                        5 ->
                                            valueEntered = Enum.at(checkMenu, 3)
                                                case valueEntered do

                                                    "1" ->
                                                        mobileNumber = mobile_number
                                                        IO.inspect mobileNumber

                                                        mobileNumberTruncated = String.slice(mobileNumber, 3..11)


                                                        params = %{
                                                            airtel_mobile: mobileNumberTruncated
                                                        }

                                                        custPush = Savings.Service.Momo.AirtelServices.customer_kyc(params)
                                                        statusCode = custPush.status_code

                                                        IO.inspect "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"

                                                        case statusCode do

                                                        200 ->
                                                            body =  Jason.decode!(custPush.body)
                                                            fname = body["data"]["first_name"]
                                                            IO.inspect fname
                                                            lname = body["data"]["last_name"]

                                                            IO.inspect lname
                                                            nrc = mobile_number

                                                            IO.inspect nrc
                                                            pin = "2023"
                                                            IO.inspect pin

                                                            pinEnc = Savings.Accounts.User.encrypt_password(pin)
                                                            pinEnc = String.trim_trailing(pinEnc, " ")
                                                            IO.inspect("fname..." <> fname)
                                                            IO.inspect("lname..." <> lname)
                                                            IO.inspect("nrc..." <> nrc)
                                                            IO.inspect("pinEnc..." <> pinEnc)

                                                            securityQuestionAnswer = "bingo"
                                                            securityQuestionAnswer = String.trim(securityQuestionAnswer)
                                                            securityQuestionAnswer = String.downcase(securityQuestionAnswer)
                                                            IO.inspect securityQuestionAnswer

                                                            sqSelectedId = 1

                                                            clientId = 1
                                                            appUser = %Savings.Accounts.User{canOperate: true, ussdActive: 1, username: mobile_number, clientId: clientId, status: "ACTIVE", pin: pinEnc, securityQuestionId: sqSelectedId, securityQuestionAnswer: securityQuestionAnswer}

                                                            case Repo.insert(appUser) do

                                                                {:ok, appUser} ->
                                                                    userId = appUser.id
                                                                    firstName = fname
                                                                    lastName = lname
                                                                    meansOfIdentificationType = "NRC"
                                                                    meansOfIdentificationNumber = mobile_number

                                                                    appUserBioData = %Savings.Client.UserBioData{firstName: firstName, lastName: lastName, userId: userId, clientId: clientId,
                                                                        mobileNumber: mobile_number, meansOfIdentificationType: meansOfIdentificationType,
                                                                        meansOfIdentificationNumber: meansOfIdentificationNumber}

                                                                    case Repo.insert(appUserBioData) do

                                                                        {:ok, appUserBioData} ->
                                                                            status = "ACTIVE"
                                                                            roleType = "INDIVIDUAL"
                                                                            otp = Enum.random(1_000..9_999)
                                                                            otp = "#{otp}"
                                                                            appUserRole = %Savings.Accounts.UserRole{roleType: roleType, status: status, userId: userId, clientId: clientId, otp: otp}

                                                                            case Repo.insert(appUserRole) do

                                                                                {:ok, appUserRole} ->
                                                                                    accountNo = mobile_number
                                                                                    accountType = "SAVINGS"
                                                                                    accountVersion = 1.0
                                                                                    clientId = 1
                                                                                    currencyDecimals = 2
                                                                                    currencyId = 1
                                                                                    currencyName = "ZMW"
                                                                                    status = "ACTIVE"
                                                                                    totalCharges = 0.00
                                                                                    totalDeposits = 0.00
                                                                                    totalInterestEarned = 0.00
                                                                                    totalInterestPosted = 0.00
                                                                                    totalPenalties = 0.00
                                                                                    totalTax = 0.00
                                                                                    totalWithdrawals = 0.00
                                                                                    derivedAccountBalance = 0.00
                                                                                    userId = appUser.id
                                                                                    userRoleId = appUserRole.id

                                                                                    account = %Savings.Accounts.Account{
                                                                                        accountNo: accountNo,
                                                                                        accountType: accountType,
                                                                                        accountVersion: accountVersion,
                                                                                        clientId: clientId,
                                                                                        currencyDecimals: currencyDecimals,
                                                                                        currencyId: currencyId,
                                                                                        currencyName: currencyName,
                                                                                        status: status,
                                                                                        totalCharges: totalCharges,
                                                                                        totalDeposits: totalDeposits,
                                                                                        totalInterestEarned: totalInterestEarned,
                                                                                        totalInterestPosted: totalInterestPosted,
                                                                                        totalPenalties: totalPenalties,
                                                                                        derivedAccountBalance: derivedAccountBalance,
                                                                                        totalTax: totalTax,
                                                                                        totalWithdrawals: totalWithdrawals,
                                                                                        userId: userId,
                                                                                        userRoleId: userRoleId,
                                                                                    }

                                                                                    case Repo.insert(account) do

                                                                                    {:ok, account} ->

                                                                                        #response = %{
                                                                                        #    Message: "Your new MFZ account has been setup for you. Press\n\nb. Back",
                                                                                        #    ClientState: 1,
                                                                                        #    Type: "Response",
                                                                                        #    key: "BA3"
                                                                                        #}

                                                                                        logUssdRequest(appUser.id, "NEW CLIENT", nil, "SUCCESS", mobile_number, "New client profile created successfully")

                                                                                        naive_datetime = Timex.now
                                                                                        sms = %{

                                                                                            mobile: mobile_number,
                                                                                            msg: "Dear #{firstName}, Thank You for registering for Zipake Savings. Go to *115# to start Saving . Click https://mfz.co.zm to read detail Ts& Cs.",
                                                                                            status: "READY",
                                                                                            type: "SMS",
                                                                                            msg_count: "1",
                                                                                            date_sent: naive_datetime
                                                                                        }

                                                                                        Sms.changeset(%Sms{}, sms)
                                                                                        |> Repo.insert()

                                                                                        response = "Your new Zipake account has been setup for you. Go to *115# to start Saving"
                                                                                        send_response_with_header(conn, response)

                                                                                    {:error, changeset} ->

                                                                                        IO.inspect("Fail")
                                                                                        #response = %{
                                                                                        #    Message: "Your new MFZ account could not be setup for you. Press\n\nb. Back",
                                                                                        #    ClientState: 1,
                                                                                        #    Type: "Response",
                                                                                        #    key: "BA3"
                                                                                        #}
                                                                                        logUssdRequest(conn.assigns.user.id, "NEW CLIENT", nil, "FAILED", mobile_number, "New client profile creation Failed")

                                                                                        response = "Your new MFZ account could not be setup for you. Press\n\nb. Back"
                                                                                        send_response(conn, response)

                                                                                    end

                                                                                {:error, changeset} ->

                                                                                    IO.inspect("Fail")
                                                                                    #response = %{
                                                                                    #    Message: "Your new MFZ account could not be setup for you. Press\n\nb. Back",
                                                                                    #    ClientState: 1,
                                                                                    #    Type: "Response",
                                                                                    #    key: "BA3"
                                                                                    #}

                                                                                    response = "Your new MFZ account could not be setup for you. Press\n\nb. Back"
                                                                                    send_response(conn, response)
                                                                            end

                                                                        {:error, changeset} ->

                                                                            IO.inspect("Fail")
                                                                            #response = %{
                                                                            #    Message: "Your new MFZ account could not be setup for you. Press\n\nb. Back",
                                                                            #    ClientState: 1,
                                                                            #    Type: "Response",
                                                                            #    key: "BA3"
                                                                            #}

                                                                            response = "Your new MFZ account could not be setup for you. Press\n\nb. Back"
                                                                            send_response(conn, response)

                                                                    end

                                                                {:error, changeset} ->

                                                                    IO.inspect("Fail")

                                                                    response = "Your MFZ Zipake account could not be setup for you. Press\n\nb. Back"
                                                                    send_response(conn, response)

                                                            end

                                                    "0" ->
                                                        response = "Thank you and good bye."
                                                        send_response_with_header(conn, response)
                                                end
                                            _->

                                                response = "We could not create a profile for you at the moment. Please check back later"
                                                send_response(conn, response)
                                        end

                                    end
                                end

                            else

                                #response = %{
                                #	Message: "Invalid input provided",
                                #	ClientState: 1,
                                #	Type: "Response",
                                #	key: "BA1"
                                #}

                                response = "Invalid input provided."
                                send_response(conn, response)
                            end
                        end
                    else

                        response = "Thank you and Good Bye."
                        send_response_with_header(conn, response)
                    end
            end
        # else

        #     response = "The system is under maintenance."
        #     send_response_with_header(conn, response)
        # end
    end

    def welcome_menu(conn, mobile_number, cmd, text) do
        IO.inspect "Welcome menu ======================"
        IO.inspect text

        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number, select: au
        users = Repo.all(query)
        user = Enum.at(users, 0)

        userId = user.id
        query = from au in Savings.Accounts.UserRole, where: (au.userId == ^userId and au.roleType == "INDIVIDUAL"), select: au
            customers = Repo.all(query)

        IO.inspect "customers count"
        IO.inspect Enum.count(customers)


        if (Enum.count(customers)>0) do

            checkMenu = String.split(text, "\*")
            checkMenuLength = Enum.count(checkMenu)
            IO.inspect(checkMenuLength)

            if checkMenuLength==2 do

                response = "Welcome to Zipake saving\n\n1. Fixed Term Saving\n2. Withdraw\n3. Early Withdraw\n4. Check Balance\n5. SMS Statement\n6. Ts & Cs"
                send_response(conn, response)
            end
            if checkMenuLength>2 do

                valueEntered = Enum.at(checkMenu, 1)
                IO.inspect (valueEntered)
                case valueEntered do

                    "1" ->
                        IO.inspect ("handleMakeDepositChoice")
                        handleMakeDepositChoice(conn, mobile_number, cmd, text, checkMenu)
                    "2" ->
                        IO.inspect ("handleWithdrawal")
                        handleWithdrawal(conn, mobile_number, cmd, text, checkMenu)
                    "3" ->
                        IO.inspect ("handleDivest")
                        handleDivest(conn, mobile_number, cmd, text, checkMenu)
                    "4" ->
                        IO.inspect ("handleGetSavingsBalance")
                        handleGetSavingsBalance(conn, mobile_number, cmd, text, checkMenu)
                    "5" ->
                        IO.inspect ("handleGetSMSStatement")
                        handleGetSMSStatement(conn, mobile_number, cmd, text, checkMenu)
                    "6" ->
                        IO.inspect ("handleTC")
                        handleTC(conn, mobile_number, cmd, text, checkMenu)

                    response = text
                    send_response(conn, response)

                _ ->
                    IO.inspect ("handleInvalidNumber")
                    text = "Invaid number entered\n\nPress \nb. Back \n0. Log Out"

                    response = text
                    send_response(conn, response)


                end
            end

        else
            handle_new_account(conn, mobile_number, cmd, text, users)
        end
    end

    def handleGoodBye(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGoodBye")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(cmd)
        IO.inspect(text)
        if valueEntered == "b" do
                #response = %{
                #    Message: "BA3",
                #    ClientState: 1,
                #    Type: "Response",
                #    key: "BA3"
                #}
            response = "BA3"
            send_response(conn, response)
        else
            case checkMenuLength do
                4 ->
                    response = "Are You sure you want to log out? \n\n1. Logout\nb. Back"
                    send_response(conn, response)
                5 ->
                    response = "Successfully Logged out! Thank you and good bye."
                    send_response_with_header(conn, response)
            end
        end
    end

    def end_session(ussdRequests, conn, response) do
        query_params = conn.query_params
                mobile_number = query_params["MOBILE_NUMBER"]

        query = from au in Savings.Accounts.User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUser = Repo.one(query)

        logUssdRequest(appUser.id, "SESSION END", nil, "SUCCESS", mobile_number, "Session Ended By Client")
        attrs = %{session_ended: 1}
        if(Enum.count(ussdRequests)>0) do
            ussdRequest = Enum.at(ussdRequests, 0)

            ussdRequest
            |> UssdRequest.changesetForUpdate(attrs)
            |> Repo.update()
        end

        # send_response(conn, response)
        send_response_with_header(conn, response)
    end

    def loginOrRecover(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage) do
        IO.inspect text
        orginal_short_code = cmd

        activeStatus = "ACTIVE"
        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number and au.status == ^activeStatus, select: au
        companyStaff = Repo.one(query)

        if(!is_nil(companyStaff)) do
            checkMenu = String.split(text, "\*")
            checkMenuLength = Enum.count(checkMenu)

            IO.inspect("loginOrRecover [[[[[[]]]]]]")
            IO.inspect(checkMenuLength)

            if checkMenuLength == 2 do

                    checkMenuLength = Enum.count(checkMenu)
                    valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
                    IO.inspect("back button")
                    IO.inspect(checkMenuLength)
                    IO.inspect(valueEntered)
                    IO.inspect(text)
                if valueEntered == "b" do
                    #response = %{
                    #    Message: "BA3",
                    #    ClientState: 1,
                    #    Type: "Response",
                    #    key: "BA3"
                    #}

                    response = "BA3"
                    send_response(conn, response)
                else
                    response = passwordRequestMessage
                    send_response(conn, response)
                end
            else
                #if checkMenuLength==4 do
                    #valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                    valueEntered = Enum.at(checkMenu, 1)
                    firstvalueEntered = Enum.at(checkMenu, 1)
                    IO.inspect ("valueEntered")
                    IO.inspect  (valueEntered)
                    valueEntered = elem Integer.parse(valueEntered), 0

                    if firstvalueEntered == "b" do
                        #response = %{
                        #    Message: "BA3",
                        #    ClientState: 1,
                        #    Type: "Response",
                        #    key: "BA3"
                        #}

                        response = "BA3"
                        send_response(conn, response)
                    else

                        if (valueEntered==1) do
                            request_user_password(conn, mobile_number, cmd, text, ussdRequests, "Welcome to MFZ Zipake Savings\n\nPlease enter your 4 digit Pin")
                        else
                            if (valueEntered==2) do
                                if checkMenuLength==3 do
                                    handleRecoverPin(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage)
                                else
                                    handleReadSecurityQuestionResponse(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage, checkMenu, companyStaff)
                                end
                            else
                                checkMenuSize = Enum.count(checkMenu) - 2
                                checkMenuUpd = Enum.slice(checkMenu, 0..checkMenuSize)
                                IO.inspect checkMenuUpd
                                IO.inspect checkMenuSize

                                text = Enum.join(checkMenuUpd, "*")
                                IO.inspect text
                                text = "*"
                                IO.inspect text
                                attrs = %{request_data: text}
                                IO.inspect attrs

                                ussdRequest = Enum.at(ussdRequests, 0)

                                query = from au in UssdRequest, where: au.id == ^ussdRequest.id, select: au
                                    ussdRequest = Repo.one(query)
                                IO.inspect ussdRequest
                                ussdRequest
                                |> UssdRequest.changesetForUpdate(attrs)
                                |> Repo.update()

                                response = "Please select an option.\n\nPress\n1. Login\n2. I Forgot My Pin\nb. Back \n0. End"
                                send_response(conn, response)
                            end
                        end
                    end
            end

        else

            response = "Invalid profile. An active profile mapped to this number could not be found. \nContact MFZ staff to assist you with reactivating your profile"
            send_response(conn, response)
        end
    end

    def request_user_password(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage) do
        IO.inspect text
        orginal_short_code = cmd


        activeStatus = "ACTIVE"
        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number and au.status == ^activeStatus, select: au
        companyStaff = Repo.one(query)

        if(!is_nil(companyStaff)) do
            checkMenu = String.split(text, "\*")
            checkMenuLength = Enum.count(checkMenu)
            IO.inspect checkMenu

            IO.inspect("request_user_password [[[[[[]]]]]]")
            IO.inspect(checkMenuLength)

            if checkMenuLength==3 do
                response = passwordRequestMessage
                send_response(conn, response)
            end
            if checkMenuLength>3 do
                valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                IO.inspect (valueEntered)
                handle_validate_password(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered)
            end

        else
            response = "Invalid profile. An active profile mapped to this number could not be found. \nContact MFZ staff to assist you with reactivating your profile"
            send_response(conn, response)
        end
    end

    def handleRecoverPin(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage) do
        IO.inspect text
        orginal_short_code = cmd


        activeStatus = "ACTIVE"
        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number and au.status == ^activeStatus, select: au
        companyStaff = Repo.one(query)

        if(!is_nil(companyStaff)) do

            query = from au in Savings.Accounts.SecurityQuestions, where: au.id == ^companyStaff.securityQuestionId, select: au
                securityQuestion = Repo.one(query)

            response = "Provide the answer to your security question:\n#{securityQuestion.question}"
            send_response(conn, response)

        else
            response = "You can not recover your password as your profile is not currently active.\nContact MFZ staff to assist you with reactivating your profile"
            send_response(conn, response)
        end
    end

    def handleReadSecurityQuestionResponse(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage, checkMenu, user) do
        IO.inspect checkMenu
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
        securityQuestionId = Enum.at(checkMenu, (checkMenuLength-3))
        IO.inspect("handleReadSecurityQuestionResponse")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)

        query = from au in Savings.Client.UserBioData, where: au.userId == ^user.id, select: au
            userBioData = Repo.one(query)

        pin = Enum.random(1_000..9_999)
        pin = "#{pin}"
        IO.inspect "========>>>>>>"
        IO.inspect "New Pin"
        IO.inspect pin
        pinEnc = Savings.Accounts.User.encrypt_password(pin)
        pinEnc = String.trim_trailing(pinEnc, " ")

        if(user.securityQuestionAnswer==String.downcase(valueEntered)) do
            IO.inspect "Update Pin"

            attrs = %{pin: pinEnc, security_question_fail_count: 0}

            user
            |> User.changeset(attrs)
            |> Repo.update()

            # mobile_number = "260967307151"
            naive_datetime = Timex.now
            firstName = userBioData.firstName

            sms = %{
                mobile: mobile_number,
                msg: "Dear #{firstName}, Your new ZIPAKE account pin is #{pin}. Please log in and change your pin for the security of your ZIPAKE account",
                status: "READY",
                type: "SMS",
                msg_count: "1",
                date_sent: naive_datetime
            }
            Sms.changeset(%Sms{}, sms)
            |> Repo.insert()

            text = "A new ZIPAKE account pin has been generated for you and sent in an SMS message to your mobile number. Please login using the pin sent and change your pin."
            response = text
            send_response(conn, response)
        else
            IO.inspect "Invalid match"
            attrs = if(!is_nil(user.security_question_fail_count) && user.security_question_fail_count==2) do
                attrs = %{security_question_fail_count: (user.security_question_fail_count + 1), status: "BLOCKED"}
                attrs
            else
                attrs = if(is_nil(user.security_question_fail_count)) do
                    attrs = %{security_question_fail_count: 1}
                    attrs
                else
                    attrs = %{security_question_fail_count: (user.security_question_fail_count + 1)}
                    attrs
                end
            end

            user
            |> User.changeset(attrs)
            |> Repo.update()

            text = "Invalid answer provided to your security question. Press \n\nb. Back \n0. End"
            response = text
            send_response(conn, response)
        end
    end

    def handle_validate_password(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered) do

        activeStatus = "ACTIVE"
        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number, select: au
        loggedInUser = Repo.one(query)

        if(!is_nil(loggedInUser)) do

            if(loggedInUser.status != activeStatus) do
                response = "Your account is no longer active. Please contact Microfinance Zambia to reactivate your account. "
                end_session(ussdRequests, conn, response)
            else
                passwordChecker = Base.encode16(:crypto.hash(:sha512, valueEntered))
                pwsdpin = String.trim_trailing(loggedInUser.pin, " ")
                passwordChecker1 = String.trim_trailing(pwsdpin, " ")
                IO.inspect "passwordChecker..."
                IO.inspect passwordChecker
                IO.inspect loggedInUser.pin
                IO.inspect passwordChecker1

                case String.equivalent?(passwordChecker, passwordChecker1) do
                    false ->
                        IO.inspect "loggedInUser.password_fail_count.."
                        IO.inspect loggedInUser.password_fail_count

                        if( is_nil(loggedInUser.password_fail_count)) do

                            attrs = %{password_fail_count: 1}

                            loggedInUser
                            |> User.changeset(attrs)
                            |> Repo.update()

                            attrs = %{request_data: "*778#*"}
                            ussdRequest = Enum.at(ussdRequests, 0)
                            session_id = ussdRequest.session_id

                            ussdRequest
                            |> UssdRequest.changeset(attrs)
                            |> Repo.update()

                            text = "\*778#\*"
                            #request_user_password(conn, mobile_number, cmd, text, ussdRequests, "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times\nb. Back \n0. End")
                            response = "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times\n\nb. Back \n0. End"

                            send_response(conn, response)

                        else
                            if((loggedInUser.password_fail_count>1)) do
                                attrs = %{password_fail_count: (loggedInUser.password_fail_count + 1), status: "BLOCKED"}

                                loggedInUser
                                |> User.changeset(attrs)
                                |> Repo.update()

                                attrs = %{request_data: "*778#*"}
                                ussdRequest = Enum.at(ussdRequests, 0)
                                session_id = ussdRequest.session_id

                                ussdRequest
                                |> UssdRequest.changeset(attrs)
                                |> Repo.update()

                                text = "\*778#\*"
                                #request_user_password(conn, mobile_number, cmd, text, ussdRequests, "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times\nb. Back \n0. End")
                                response = "Invalid credentials. Please log in again. Your account has been locked. Contact our customer support team for more assistance on this"

                                send_response(conn, response)

                            else
                                attrs = %{password_fail_count: (loggedInUser.password_fail_count + 1)}

                                loggedInUser
                                |> User.changeset(attrs)
                                |> Repo.update()

                                attrs = %{request_data: "*778#*"}
                                ussdRequest = Enum.at(ussdRequests, 0)
                                session_id = ussdRequest.session_id

                                ussdRequest
                                |> UssdRequest.changeset(attrs)
                                |> Repo.update()

                                text = "\*778#\*"
                                #request_user_password(conn, mobile_number, cmd, text, ussdRequests, "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times\nb. Back \n0. End")
                                response = "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times\n\nb. Back \n0. End"
                                send_response(conn, response)
                            end
                        end

                    true ->
                        ussdRequest = Enum.at(ussdRequests, 0)
                        session_id = ussdRequest.session_id

                        attrs = %{password_fail_count: 0, status: "ACTIVE"}

                            loggedInUser
                            |> User.changeset(attrs)
                            |> Repo.update()

                        IO.inspect (ussdRequest.id)

                        {1, [ussdRequest]} =
                            from(p in UssdRequest, where: p.id == ^ussdRequest.id, select: p)
                            |> Repo.update_all(set: [request_data: "*778#*", is_logged_in: 1])


                        text = "*778#*"
                        query = from au in UssdRequest, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                        ussdRequests = Repo.all(query)
                        welcome_menu(conn, mobile_number, cmd, text)
                end
            end

        else

            response = "Invalid credentials."
            end_session(ussdRequests, conn, response)
        end

    end

    def handle_new_account(conn, mobile_number, cmd, text, users) do
        IO.inspect("===================")
        IO.inspect(cmd)
        IO.inspect(mobile_number)


        IO.inspect("short_code...")
        IO.inspect(cmd)
        IO.inspect("text...")
        IO.inspect(text)
        clientId = 1
        appUser = Enum.at(users, 0)
        userId = appUser.id
        clientName = "MFZ"


        if text do
            checkMenu = String.split(text, "\*")
            checkMenuLength = Enum.count(checkMenu)
            IO.inspect(checkMenuLength)


            status = "ACTIVE"
            roleType = "INDIVIDUAL"
            otp = Enum.random(1_000..9_999)
            otp = Integer.to_string(otp)
            appUserRole = %Savings.Accounts.UserRole{roleType: roleType, status: status, userId: userId, clientId: clientId, otp: otp}
            case Repo.insert(appUserRole) do
                {:ok, appUserRole} ->
                    accountNo = mobile_number
                    accountType = "SAVINGS"
                    accountVersion = 1.0
                    clientId = 1
                    currencyDecimals = 2
                    currencyId = 1
                    currencyName = "ZMW"
                    status = "ACTIVE"
                    totalCharges = 0.00
                    totalDeposits = 0.00
                    totalInterestEarned = 0.00
                    totalInterestPosted = 0.00
                    totalPenalties = 0.00
                    totalTax = 0.00
                    totalWithdrawals = 0.00
                    userId = appUser.id
                    userRoleId = appUserRole.id

                    account = %Savings.Accounts.Account{
                        accountNo: accountNo,
                        accountType: accountType,
                        accountVersion: accountVersion,
                        clientId: clientId,
                        currencyDecimals: currencyDecimals,
                        currencyId: currencyId,
                        currencyName: currencyName,
                        status: status,
                        totalCharges: totalCharges,
                        totalDeposits: totalDeposits,
                        totalInterestEarned: totalInterestEarned,
                        totalInterestPosted: totalInterestPosted,
                        totalPenalties: totalPenalties,
                        totalTax: totalTax,
                        totalWithdrawals: totalWithdrawals,
                        userId: userId,
                        userRoleId: userRoleId,
                    }
                    case Repo.insert(account) do
                        {:ok, account} ->

                            response = "Your new MFZ account has been setup for you. Press\n\nb. Back\n0. Log Out"
                            send_response(conn, response)

                        {:error, changeset} ->
                            IO.inspect("Fail")

                            response = "Your new MFZ account could not be setup for you. Press\n\nb. Back\n0. Log Out"
                            send_response(conn, response)
                    end

                {:error, changeset} ->
                    IO.inspect("Fail")
                    response = "Your new MFZ account could not be setup for you. Press\n\nb. Back\n0. Log Out"
                    send_response(conn, response)
            end
        else

            response = "Invalid input provided"
            send_response(conn, response)
        end

    end

    def handleMakeDepositChoice(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-3))
        IO.inspect("handleMakeDepositChoice")
        IO.inspect(checkMenuLength)
        IO.inspect"-------------------------------Get"
        IO.inspect(valueEntered)
        IO.inspect(text)
        if valueEntered == "b" do

            response = "BA3"
            send_response(conn, response)
        else
        case checkMenuLength do
                3 ->
                    query = from au in Savings.Products.Product,
                        where: au.status == "ACTIVE",
                        order_by: fragment("? ASC", au.inserted_at),
                        select: au
                    savingsProducts = Repo.all(query)

                    query = from au in Savings.Products.ProductsPeriod,
                        where: au.status == "ACTIVE" and au.productID == 1,
                        order_by: fragment("? ASC", au.defaultPeriod),
                        select: au
                    productsDays = Repo.all(query)

                    if Enum.count(savingsProducts) == 0 do

                        query = from au in Savings.Products.Product,
                            where: (au.status == "ACTIVE"),
                            order_by: fragment("? ASC", au.inserted_at),
                            select: au
                        savingsProducts = Repo.all(query)
                        IO.inspect "(savings-----------------------------------------Products)"
                        IO.inspect (savingsProducts)

                        if Enum.count(savingsProducts)>0 do
                            minSavingsProduct = Enum.at(savingsProducts, 0)
                            maxSavingsProduct = Enum.at(savingsProducts, (Enum.count(savingsProducts)-1))
                            IO.inspect (minSavingsProduct)
                            IO.inspect (maxSavingsProduct)
                            minSavingsProductMin = minSavingsProduct.minimumPrincipal
                            minSavingsProductMin = :erlang.float_to_binary((minSavingsProductMin), [{:decimals, 2}])
                            maxSavingsProductMin = maxSavingsProduct.maximumPrincipal
                            maxSavingsProductMin = :erlang.float_to_binary((maxSavingsProductMin), [{:decimals, 2}])
                            IO.inspect (minSavingsProductMin)
                            IO.inspect (maxSavingsProductMin)

                            # response = %{
                            #     Message: "CON We do not have a fixed deposit package for the amount provided. You can only deposit between K" <> minSavingsProductMin <> " and K" <> maxSavingsProductMin <> "\n\nb. Back\n0. Exit",
                            #     ClientState: 1,
                            #     Type: "Response",
                            #     key: "CON"
                            #  }
                            response = "We do not have a fixed deposit package for the amount provided. You can only deposit between K" <> minSavingsProductMin <> " and K" <> maxSavingsProductMin <> "\n\nb. Back\n0. Exit"
                            send_response(conn, response)
                        else
                            # response = %{
                            #     Message: "CON We do not have a fixed deposit package for the amount provided\n\nb. Back",
                            #     ClientState: 1,
                            #     Type: "Response",
                            #     key: "CON"
                            #  }
                            response = "We do not have a fixed deposit package for the amount provided\n\nb. Back"
                            send_response(conn, response)
                        end


                    else

                        dayOptions = []
                        dayOptions = for {k, v} <- Enum.with_index(productsDays) do
                            totalRepayAmount = 0.00
                            if Enum.member?(dayOptions, k.defaultPeriod) do

                            else
                                default_rate = k.interest
                                default_period = k.defaultPeriod
                                annual_period = k.yearLengthInDays
                                # amt = elem Integer.parse(amount), 0


                                # totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
                                IO.inspect "Test"
                                IO.inspect "Testing"
                                # IO.inspect ((totalRepayments))
                                currencyDecimals = 2

                                # totalRepayments = totalRepayments + amt

                                # totalRepayAmount = Float.ceil(totalRepayments, currencyDecimals)
                                # totalRepayAmount = :erlang.float_to_binary((totalRepayments), [{:decimals, currencyDecimals}])
                                # IO.inspect "#{totalRepayAmount}"
                                default_period = :erlang.integer_to_binary(default_period)
                                repay_entry = "#{v+1}. " <> default_period <> " " <> k.periodType <> " @ #{default_rate}% Interest"<> "  "
                                # IO.inspect "#{totalRepayAmount}"
                                dayOptions = dayOptions ++ [repay_entry]
                                IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&0000000000&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                dayOptions
                            end
                        end


                        if (Enum.count(dayOptions)>0) do
                            optionsList = ""
                            optionsList = Enum.join(dayOptions, "\n")

                            IO.inspect optionsList
                            msg = "Select Savings Period. \n\n" <> optionsList <> "\nb. Back"

                            # response = %{
                            #    Message: msg,
                            #    ClientState: 2,
                            #    Type: "Response",
                            #    key: "CON"
                            # }
                            response = msg
                            send_response(conn, response)
                        else
                            # response = %{
                            #    Message: "CON Deposit Period\n\n1. Choose One\nb. Back",
                            #    ClientState: 2,
                            #    Type: "Response",
                            #    key: "CON"
                            # }
                            response = "Deposit Period\n\n1. Choose One\nb. Back"
                            send_response(conn, response)

                        end
                    end

                4 ->

                    IO.inspect "ooooooooooooooooooooooooooooo"
                    IO.inspect checkMenu
                    selectedIndex = Enum.at(checkMenu, 2)
                    IO.inspect selectedIndex

                    if (checkIfInteger(selectedIndex)===false) do
                        msg = "Invalid Selected Option.\n\nb. Back"
                        # response = %{
                        #     Message: msg,
                        #     ClientState: 2,
                        #     Type: "Response",
                        #     key: "CON"
                        #  }
                        response = msg
                        send_response(conn, response)
                    else
                        selectedIndex = elem Integer.parse(selectedIndex), 0
                        IO.inspect selectedIndex
                        IO.inspect "<<<<<<"
                        IO.inspect selectedIndex
                        # amount = Enum.at(checkMenu, 3)
                        # IO.inspect amount

                        # query = from au in Savings.Products.Product,
                        #     where: (au.minimumPrincipal <= type(^amount, :float) and au.status == "ACTIVE" and au.maximumPrincipal >= type(^amount, :float)),
                        #     order_by: fragment("? ASC", au.inserted_at),
                        #     select: au

                        query = from au in Savings.Products.ProductsPeriod,
                            where: au.status == "ACTIVE" and au.productID == 1,
                            order_by: fragment("? ASC", au.defaultPeriod),
                            select: au
                        savingsProducts = Repo.all(query)

                        IO.inspect "savingsProducts"
                        IO.inspect Enum.count(savingsProducts)

                        if (Enum.count(savingsProducts)==0 || selectedIndex>Enum.count(savingsProducts)) do
                            response = "Invalid entry selected.\n\nb. Back"
                            send_response(conn, response)
                        else

                            savingsProduct = Enum.at(savingsProducts, (selectedIndex - 1))

                            default_rate = savingsProduct.interest
                            default_period = savingsProduct.defaultPeriod
                            annual_period = savingsProduct.yearLengthInDays
                            # amt = elem Integer.parse(amount), 0
                            currencyDecimals = 2

                            # totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
                            IO.inspect "Test"
                            # IO.inspect ((totalRepayments))

                            # totalRepayments = totalRepayments + amt

                            # totalRepayAmount = Float.ceil(totalRepayments, currencyDecimals)
                            # totalRepayAmount = :erlang.float_to_binary((totalRepayments), [{:decimals, currencyDecimals}])
                            # IO.inspect "#{totalRepayAmount}"
                            default_period = :erlang.integer_to_binary(default_period)
                            repay_entry = default_period <> " " <> savingsProduct.periodType
                            # IO.inspect "#{totalRepayAmount}"
                            dayOptions = []
                            dayOptions = dayOptions ++ [repay_entry]
                            IO.inspect "&&&&&&&&&&&&&&&&&&&&&55555555555555555555555&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

                            if (Enum.count(dayOptions)>0) do
                                optionsList = ""
                                optionsList = Enum.join(dayOptions, "\n")

                                IO.inspect optionsList
                                msg = "You have selected a " <> optionsList <> " Savings Plan\n\n Enter Amount "

                                response = msg
                                send_response(conn, response)
                            else

                                response = "Deposit Period\n\n1. Choose One\nb. Back"
                                send_response(conn, response)

                            end
                        end
                    end

                5 ->
                    IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                    selectedIndex = Enum.at(checkMenu, 2)
                    IO.inspect "selectedIndex..."
                    IO.inspect selectedIndex
                    selectedIndex = elem Integer.parse(selectedIndex), 0
                    IO.inspect selectedIndex
                    confirmChoice = "1"
                    IO.inspect confirmChoice
                    currencyDecimals = 2
                    currencyName = "ZMW"

                    if (checkIfInteger(confirmChoice)===false) do
                        response = "Invalid entry. Please enter valid choice.\n\nb. Back"
                        send_response(conn, response)
                    else
                        confirmChoice = elem Integer.parse(confirmChoice), 0
                        IO.inspect confirmChoice
                        amount = Enum.at(checkMenu, 3)
                        IO.inspect amount
                        amount = elem Float.parse(amount), 0
                        IO.inspect amount

                        query = from au in Savings.Products.Product,
                            where: (au.minimumPrincipal <= type(^amount, :float) and au.status == "ACTIVE" and au.maximumPrincipal >= type(^amount, :float)) ,
                            order_by: fragment("? ASC", au.inserted_at),
                            select: au
                        getAmount = Repo.all(query)

                        if Enum.count(getAmount) == 0 do
                                query = from au in Savings.Products.Product,
                                    where: (au.status == "ACTIVE"),
                                    order_by: fragment("? ASC", au.inserted_at),
                                select: au
                                savingsProducts = Repo.all(query)

                                IO.inspect "(savings-----------------------------------------Products)"
                                IO.inspect (savingsProducts)

                                if Enum.count(savingsProducts)>0 do
                                    minSavingsProduct = Enum.at(savingsProducts, 0)
                                    maxSavingsProduct = Enum.at(savingsProducts, (Enum.count(savingsProducts)-1))
                                    IO.inspect (minSavingsProduct)
                                    IO.inspect (maxSavingsProduct)
                                    minSavingsProductMin = minSavingsProduct.minimumPrincipal
                                    minSavingsProductMin = :erlang.float_to_binary((minSavingsProductMin), [{:decimals, 2}])
                                    maxSavingsProductMin = maxSavingsProduct.maximumPrincipal
                                    maxSavingsProductMin = :erlang.float_to_binary((maxSavingsProductMin), [{:decimals, 2}])
                                    IO.inspect (minSavingsProductMin)
                                    IO.inspect (maxSavingsProductMin)

                                    # response = %{
                                    #     Message: "CON We do not have a fixed deposit package for the amount provided. You can only deposit between K" <> minSavingsProductMin <> " and K" <> maxSavingsProductMin <> "\n\nb. Back\n0. Exit",
                                    #     ClientState: 1,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    #  }
                                    response = "We do not have a fixed deposit package for the amount provided. You can only deposit between K" <> minSavingsProductMin <> " and K" <> maxSavingsProductMin <> "\n\nb. Back\n0. Exit"
                                    send_response(conn, response)
                                else
                                    # response = %{
                                    #     Message: "CON We do not have a fixed deposit package for the amount provided\n\nb. Back",
                                    #     ClientState: 1,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    #  }
                                    response = "We do not have a fixed deposit package for the amount provided\n\nb. Back"
                                    send_response(conn, response)
                                end
                            else
                                query = from au in Savings.Products.ProductsPeriod,
                                    where: au.status == "ACTIVE" and au.productID == 1,
                                    order_by: fragment("? ASC", au.defaultPeriod),
                                    select: au
                                savingsProducts = Repo.all(query)

                                if (confirmChoice != 0 && confirmChoice==1) do

                                    random_int3 = UUID.uuid4()
                                    mobileNumberTruncated = String.slice(mobile_number, 3..11)


                                    #------------------------------------------------------ Where to return code --------------------------------------------#


                                    savingsProduct = Enum.at(savingsProducts, (selectedIndex-1))
                                    default_rate = savingsProduct.interest
                                    default_period = savingsProduct.defaultPeriod
                                    # annual_period = savingsProduct.yearLengthInDays
                                    amt = amount
                                    totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
                                    IO.inspect ((totalRepayments))
                                    totalRepayAmount = Float.ceil(totalRepayments, currencyDecimals)
                                    totalRepayAmount = :erlang.float_to_binary((totalRepayments), [{:decimals, currencyDecimals}])
                                    IO.inspect "#{totalRepayAmount}"

                                    # default_period = :erlang.integer_to_binary(default_period)
                                    # repay_entry = default_period <> " " <> savingsProduct.periodType <> " gives you ZMW" <> totalRepayAmount <> "  "
                                    IO.inspect "#{totalRepayAmount}"
                                    IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                    getinterest = elem Float.parse(totalRepayAmount), 0
                                    IO.inspect "This is the interest ================================= "
                                    IO.inspect getinterest

                                    query = from au in Savings.Accounts.User,
                                        where: (au.username == type(^mobile_number, :string)),
                                        select: au
                                    appUsers = Repo.all(query)
                                    appUser = Enum.at(appUsers, 0)

                                    individualRoleType = "INDIVIDUAL"

                                    query = from au in Savings.Accounts.UserRole,
                                        where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                        select: au
                                    appUserRoles = Repo.all(query)
                                    appUserRole = Enum.at(appUserRoles, 0)

                                    IO.inspect "Twst ........"
                                    IO.inspect savingsProduct.id
                                    IO.inspect "{confirmChoice}"
                                    # totalCharges = 0.00

                                    query = from au in Savings.Accounts.Account,
                                        where: (au.userRoleId == type(^appUserRole.id, :integer)),
                                        select: au
                                    accounts = Repo.all(query)
                                    account = Enum.at(accounts, 0)
                                    accountId = account.id

                                    accruedInterest= 0.00
                                    clientId = 1
                                    currency = "ZMW"
                                    currencyId= 1

                                    IO.inspect "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
                                    IO.inspect savingsProduct.defaultPeriod

                                    endDate = case savingsProduct.periodType do
                                        "Days" ->
                                            endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod), :second) |> DateTime.truncate(:second)
                                            endDate

                                        "Months" ->
                                            endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod*30), :second) |> DateTime.truncate(:second)
                                            endDate

                                        "Years" ->
                                            endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod*savingsProduct.yearLengthInDays), :second) |> DateTime.truncate(:second)
                                            endDate

                                    end


                                    # comfirmrequest =  custPush.request.body
                                    # comfirmresponse =  custPush.body

                                    # expectedInterest= Float.ceil((totalRepayments), currencyDecimals)
                                    expectedInterest = getinterest
                                    fixedPeriod= savingsProduct.defaultPeriod
                                    fixedPeriodType= savingsProduct.periodType
                                    interestRate= savingsProduct.interest
                                    interestRateType= savingsProduct.interestType
                                    productInterestMode= "FLAT"
                                    isDivested= false
                                    isMatured= false
                                    principalAmount= amount
                                    productId= savingsProduct.id
                                    startDate= DateTime.utc_now |> DateTime.truncate(:second)
                                    totalAmountPaidOut= 0.00
                                    totalDepositCharge= 0.0
                                    totalPenalties= 0.00
                                    totalWithdrawalCharge= 0.00
                                    userId = appUser.id
                                    userRoleId= appUserRole.id
                                    yearLengthInDays= savingsProduct.yearLengthInDays
                                    fixedDepositStatus = "PENDING"
                                    userId= appUser.id

                                    query = from au in Savings.Client.UserBioData,
                                        where: (au.userId == type(^userId, :integer)),
                                        select: au
                                    userBioData = Repo.one(query)

                                    carriedOutByUserId= userId
                                    carriedOutByUserRoleId= userRoleId
                                    isReversed= false
                                    orderRef= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                    orderRef = "ZIPAKE#{orderRef}"
                                    productId= 1
                                    productType= "SAVINGS"
                                    requestData= nil
                                    responseData= nil
                                    status= "PENDING"
                                    totalAmount= amount
                                    transactionType= "CR"
                                    productCurrency= currencyName
                                    # currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
                                    currentBalance = totalAmount
                                    transactionDetail = "Deposit Payment for Fixed Deposit"

                                    transaction = %Savings.Transactions.Transaction{
                                        accountId: accountId,
                                        carriedOutByUserId: carriedOutByUserId,
                                        carriedOutByUserRoleId: carriedOutByUserRoleId,
                                        isReversed: isReversed,
                                        orderRef: orderRef,
                                        productId: productId,
                                        productType: productType,
                                        referenceNo: random_int3,
                                        requestData: requestData,
                                        responseData: responseData,
                                        status: status,
                                        totalAmount: totalAmount,
                                        transactionType: transactionType,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        transactionDetail: transactionDetail,
                                        transactionTypeEnum: "DEPOSIT",
                                        newTotalBalance: currentBalance,
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                        currencyDecimals: currencyDecimals,
                                        currency: currencyName
                                    }
                                    transaction = Repo.insert!(transaction)

                                    fixedDeposit = %Savings.FixedDeposit.FixedDeposits{
                                        accountId: accountId,
                                        accruedInterest: accruedInterest,
                                        clientId: clientId,
                                        currency: currency,
                                        currencyDecimals: currencyDecimals,
                                        currencyId: currencyDecimals,
                                        endDate: endDate,
                                        expectedInterest: expectedInterest,
                                        fixedPeriod: fixedPeriod,
                                        fixedPeriodType: fixedPeriodType,
                                        interestRate: interestRate,
                                        interestRateType: interestRateType,
                                        isDivested: isDivested,
                                        isMatured: isMatured,
                                        principalAmount: principalAmount,
                                        productId: productId,
                                        startDate: startDate,
                                        totalAmountPaidOut: totalAmountPaidOut,
                                        totalDepositCharge: totalDepositCharge,
                                        totalPenalties: totalPenalties,
                                        totalWithdrawalCharge: totalWithdrawalCharge,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        yearLengthInDays: yearLengthInDays,
                                        productInterestMode: productInterestMode,
                                        fixedDepositStatus: fixedDepositStatus,
                                        autoCreditOnMaturityDone: false,
                                        autoCreditOnMaturity: false,
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}"

                                    }

                                    fixedDeposit = Repo.insert!(fixedDeposit)

                                    fixedDepositTransaction = %Savings.FixedDeposit.FixedDepositTransaction{
                                        clientId: 1,
                                        fixedDepositId: fixedDeposit.id,
                                        amountDeposited: principalAmount,
                                        transactionId: transaction.id,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        status: "PENDING"
                                    }
                                    fixedDepositTransaction = Repo.insert!(fixedDepositTransaction)


                                    tempTotalAmount = Float.ceil(totalAmount, currencyDecimals)
                                    tempTotalAmount = :erlang.float_to_binary((tempTotalAmount), [{:decimals, currencyDecimals}])
                                    #tempTotalAmount = Float.to_string(tempTotalAmount)
                                    exInt = Float.ceil(fixedDeposit.expectedInterest, currencyDecimals)
                                    exInt = :erlang.float_to_binary((exInt), [{:decimals, currencyDecimals}])
                                    firstName = userBioData.firstName
                                    logUssdRequest(userBioData.userId, "FIXED DEPOSIT", nil, "SUCCESS", mobile_number, "Fixed deposit saved prior to confirmation")

                                    response = "Your fixed deposit was initiated. You will get a pin prompt shortly."
                                    send_response_with_header(conn, response)
                                    #------------------------------------------------------------------------------------------------------------------------#

                                    params = %{
                                        airtel_mobile: mobileNumberTruncated,
                                        enterdAmount: amount,
                                        random_int3: random_int3
                                    }
                                    custPush = Savings.Service.Momo.AirtelServices.customer_push(params)
                                    statusCode = custPush.status_code

                                    IO.inspect "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
                                    IO.inspect custPush
                                    case statusCode do
                                    #------------------------------------------------------ Where to we have put it code --------------------------------------------#
                                        200 ->
                                            IO.inspect "Request Has been sent"

                                        #------------------------------------------------------------------------------------------------------------------------#
                                        _->

                                            IO.inspect "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                            # IO.inspect status
                                            response = "Your payment to ZIPAKE was not successful. Please try again"
                                            send_response(conn, response)

                                    end

                            else

                                IO.inspect("Fail")
                                response = "Invalid selection.. Press\n\nb. Back"
                                send_response(conn, response)

                            end
                        end

                    end
                _ ->
                    response = "Invalid entry.. Press\n\nb. Back"
                    send_response(conn, response)
                        end
                end
            end

    def handleGetSavingsBalance(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(cmd)
        IO.inspect(text)
        if valueEntered == "b" do
                #response = %{
                #    Message: "BA3",
                #    ClientState: 1,
                #    Type: "Response",
                #    key: "BA3"
                #}
            response = "BA3"
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->
                    query = from au in User,
                        where: (au.username == type(^mobile_number, :string)),
                        select: au
                    appUsers = Repo.all(query)
                    appUser = Enum.at(appUsers, 0)

                    isDivested = false
                    isWithdrawn = false
                    query = from au in Savings.FixedDeposit.FixedDeposits,
                        where: (au.userId == type(^appUser.id, :integer) and au.isDivested == type(^isDivested, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.fixedDepositStatus == "ACTIVE"),
                        select: au
                    fixedDeposits = Repo.all(query)

                    IO.inspect "=========="
                    IO.inspect Enum.count(fixedDeposits)

                    if Enum.count(fixedDeposits)>0 do

                        totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                            fixedDeposit = Enum.at(fixedDeposits, x)

                            ntotals = fixedDeposit.principalAmount + fixedDeposit.accruedInterest
                            IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                            IO.inspect ntotals
                            ntotals
                        end


                        IO.inspect Enum.count(totals)
                        IO.inspect "=========="
                        totalBalance = Decimal.round(Decimal.from_float(Enum.sum(totals)), 2)
                        text = "Total Balance as at today is ZMW#{totalBalance}\n\nb. Back"
                        # response = %{
                        #    Message: text,
                        #    ClientState: 1,
                        #    Type: "Response",
                        #    key: "CON"
                        # }

                        response = text
                        send_response(conn, response)
                    else
                        text = "Total Balance as at today is ZMW0.00\n\nb. Back"
                        # response = %{
                        #     Message: text,
                        #     ClientState: 1,
                        #     Type: "Response",
                        #     key: "CON"
                        #  }
                        response = text
                        send_response(conn, response)
                    end
                _->
                    text = "Invalid entry\n\nb. Back"
                    response = text
                    send_response(conn, response)
            end
        end

    end

    def handleGetSMSStatement(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect (checkMenu)
        IO.inspect(valueEntered)
        IO.inspect(text)
        defaultCurrencyDecimals = 2
        if valueEntered == "b" do

            response = "BA3"
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->

                    response = "Choose your preferred option to receive your statement:\n\n1. View on ZIPAKE USSD\n2. Send to my email\n\nb. Back"
                    send_response(conn, response)

                4 ->
                    selectedIndex = Enum.at(checkMenu, 2)
                    if(checkIfInteger(selectedIndex)===false) do
                        response = "Invalid entry. Press\n\nb. Back"
                        send_response(conn, response)
                    else
                        selectedIndex = elem Integer.parse(selectedIndex), 0

                        if(selectedIndex==1) do
                            handleReceiveStatement(conn, mobile_number, cmd, text, checkMenu, selectedIndex)
                        else
                            if(selectedIndex==2) do
                                response = "Enter your email address:\n\nb. Back"
                                send_response(conn, response)
                            else
                                response = "Invalid entry\n\nPress\nb. Back"
                                send_response(conn, response)
                            end
                        end
                    end

                5 ->
                    selectedIndex = Enum.at(checkMenu, 2)
                    if(selectedIndex !== "1") do
                        selectedIndex = elem Integer.parse(selectedIndex), 0
                        IO.inspect "CONTAINSSSSSSS"
                        IO.inspect selectedIndex

                        emailAddress = Enum.at(checkMenu, 3)

                        emailAddress = String.replace(emailAddress, "-", "@")

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
                                        html = html <> "<div style=\"width: 100% !important\">"
                                            html = html <> "<div style=\"width: 100% !important\">"
                                                html = html <> "<img src=\"http://localhost:5000/images/Microfinance-logo2.jpg\" style=\"text-align: center; height: 20px; width: 50px; !important\">"
                                            html = html <> "<div>"
                                            html = html <> "<div style=\"width: 100% !important\">"
                                                html = html <> "<h3 style=\"text-align: center !important\">ZIPAKE</h3>"
                                                html = html <> "<h5 style=\"text-align: center !important\">Customer Statement Of Account</h5>"
                                            html = html <> "<div>"
                                            html = html <> "<div style=\"width: 100% !important\">"
                                                html = html <> "<div style=\"width: 30% float: left !important \">"
                                                    html = html <> "<strong>Customer Name:</strong> #{userBioData.firstName} #{userBioData.lastName}"
                                                html = html <> "</div>"
                                                html = html <> "<div style=\"width: 30% float: left !important \">"
                                                    html = html <> "<strong>Mobile Number:</strong> #{appUser.username}"
                                                html = html <> "</div>"
                                                html = html <> "<div style=\"width: 30% float: left !important \">"
                                                    html = html <> "<strong>Account Type:</strong> Savings"
                                                html = html <> "</div>"
                                                html = html <> "<div style=\"width: 30% float: left !important \">"
                                                    html = html <> "<strong>Statement Date:</strong> #{Date.utc_today}"
                                                html = html <> "</div>"
                                            html = html <> "<div>"
                                        html = html <> "</div>"


                                        html = html <> "<div style=\"width: 100% !important\">"


                                            html = html <> "<table style=\"width: 100% !important\">"
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
                                                    where: (au.userId == type(^appUser.id, :integer)) and au.status == "SUCCESS",
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
                                html = html <> "</html>"
                                showfilename = "Statement of Account for #{userBioData.firstName}  #{userBioData.lastName}"
                                {:ok, filename} = PdfGenerator.generate(html, page_size: "A5", filename: showfilename)
                                IO.inspect "filename"
                                IO.inspect filename
                                Email.send_statement_of_account(emailAddress, userBioData, "ZIPAKE", filename)
                                #handleReceiveStatement(conn, mobile_number, cmd, text, checkMenu, selectedIndex)
                                response = "Your statement of account has been sent to the email address (#{emailAddress})\n\nPress \nb. Back"
                                # send_response_mail(conn, response)
                                send_response(conn, response)
                        # end
                    else

                        response = "Invalid entry\n\nPress \nb. Back"
                        send_response(conn, response)
                    end
                _ ->
                    response = "Invalid entry.\n\nPress \nb. Back"
                    send_response(conn, response)
            end
        end
    end

    def send_response_mail(conn, response) do
        IO.inspect  "WITH MAIL!"
        IO.inspect  Jason.encode!(response)
        send_resp(conn, :ok, response)
        # send_resp(conn, :ok, Jason.encode!(response))
    end

    def handleReceiveStatement(conn, mobile_number, cmd, text, checkMenu, selectedIndex) do
        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)



        individualRoleType = "INDIVIDUAL"
        query = from au in Savings.Accounts.UserRole,
            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
            select: au
        userRoles = Repo.all(query)
        userRole = Enum.at(userRoles, 0)


        status = "Disbursed"
        matureStatus = "MATURED"
        activeStatus = "ACTIVE"
        isMatured = false
        isDivested = false
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.userId == type(^appUser.id, :integer) and au.fixedDepositStatus == ^activeStatus or au.fixedDepositStatus == ^matureStatus),
            #au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and
            select: au
        fixedDeposits = Repo.all(query)
        totalBalance = 0.00

            IO.inspect "=========="
            IO.inspect Enum.count(fixedDeposits)

        if Enum.count(fixedDeposits)>0 do

            totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                #totalBalance = Enum.each(fixedDeposits, fn(fixedDeposit) ->
                fixedDeposit = Enum.at(fixedDeposits, x)


                query = from au in Savings.Products.Product,
                    where: (au.id == ^fixedDeposit.productId),
                    select: au
                products = Repo.all(query)
                product = Enum.at(products, 0)

                period = 0
                days = Date.diff(Date.utc_today, fixedDeposit.startDate)
                daysValue = Date.diff(fixedDeposit.endDate, fixedDeposit.startDate)


                #ntotals = calculate_maturity_repayments(fixedDeposit.principalAmount, days,
                #   fixedDeposit.interestRate, fixedDeposit.yearLengthInDays, product.interestMode,
                #   product.interestType, fixedDeposit.fixedPeriodType)

                ntotals = fixedDeposit.principalAmount + fixedDeposit.accruedInterest

                ntotalsAtDueDate = fixedDeposit.principalAmount + fixedDeposit.expectedInterest
                fullValue = Float.ceil(ntotalsAtDueDate, fixedDeposit.currencyDecimals)

                IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                IO.inspect ntotals
                endDate = case fixedDeposit.fixedPeriodType do
                    "Days" ->
                        endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod)
                        endDate
                    "Months" ->
                        endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod*30)
                        endDate
                    "Years" ->
                        endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod*fixedDeposit.yearLengthInDays)
                        endDate
                end
                #currentValue = Float.ceil(ntotals, fixedDeposit.currencyDecimals)

                currentValue = ntotals
                currentValue = :erlang.float_to_binary((currentValue), [{:decimals, fixedDeposit.currencyDecimals}])

                #fixedAmount = Float.ceil(fixedDeposit.principalAmount, fixedDeposit.currencyDecimals)
                fixedAmount = Float.ceil(fixedDeposit.principalAmount, fixedDeposit.currencyDecimals)
                fixedAmount = :erlang.float_to_binary((fixedDeposit.principalAmount), [{:decimals, fixedDeposit.currencyDecimals}])

                currentStatus =
                if(fixedDeposit.fixedDepositStatus=="ACTIVE") do
                    currentStatus =
                    if(!is_nil(fixedDeposit.isMatured) && fixedDeposit.isMatured==true) do
                        currentStatus =
                        if(!is_nil(fixedDeposit.isWithdrawn) && fixedDeposit.isWithdrawn==true) do
                            currentStatus = "Matured & Withdrawn"
                            currentStatus
                        else
                            currentStatus = "Matured"
                            currentStatus
                        end
                    else
                        currentStatus =
                        if(!is_nil(fixedDeposit.isDivested) && fixedDeposit.isDivested==true) do
                            currentStatus = "Divested"
                            currentStatus
                        else
                            currentStatus = "Active"
                            currentStatus
                        end
                    end

                else
                    currentStatus = String.capitalize(fixedDeposit.fixedDepositStatus)
                    currentStatus
                end


                "Fixed Deposit: " <> fixedDeposit.currency <> "#{fixedAmount}\nCurrent Value: " <> fixedDeposit.currency <> "#{currentValue}\nDeposit Date: #{fixedDeposit.startDate}\nValue At Maturity: " <> fixedDeposit.currency <> "#{fullValue}\nValue Date: #{fixedDeposit.endDate}\nStatus: #{currentStatus}\n"
            end


            IO.inspect Enum.count(totals)
            IO.inspect "=========="
            acctStatement = (Enum.join(totals, "\n"))
            text = "Total Balance as at today:\n\n" <> acctStatement <> "\n\nPress \nb. Back"

            response = text
            send_response(conn, response)
        else
            text = "You do not have any fixed deposits at the moment\n\nPress \nb. Back"
            response = text
            send_response(conn, response)
        end
    end



    def handleDivest(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        if valueEntered == "b" do
                #response = %{
                #    Message: "BA3",
                #    ClientState: 1,
                #    Type: "Response",
                #    key: "BA3"
                #}

            response = "BA3"
            send_response(conn, response)
        else
            case checkMenuLength do
                3 ->
                    response = "Choose your preferred early withdrawal option:\n\n1. Partial Early Withdrawal\n2. Full Early Withdrawal"
                        # response = %{
                        #    Message: response,
                        #    ClientState: 1,
                        #    Type: "Response",
                        #    key: "BA3"
                        # }
                    send_response(conn, response)

                4 ->
                    if(valueEntered=="1" || valueEntered=="2") do

                        query = from au in User,
                            where: (au.username == type(^mobile_number, :string)),
                            select: au
                        appUsers = Repo.all(query)
                        appUser = Enum.at(appUsers, 0)

                        individualRoleType = "INDIVIDUAL"
                        query = from au in Savings.Accounts.UserRole,
                            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                            select: au
                        userRoles = Repo.all(query)
                        userRole = Enum.at(userRoles, 0)

                        isMatured = false
                        isDivested = false
                        fixedDepositStatus = "ACTIVE"
                        query = from au in Savings.FixedDeposit.FixedDeposits,
                            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.fixedDepositStatus == type(^fixedDepositStatus, :string) and au.userId == type(^appUser.id, :integer)),
                            order_by: [desc: :id],
                            select: au
                        fixedDeposits = Repo.all(query)
                        totalBalance = 0.00

                        IO.inspect "=========="
                        IO.inspect Enum.count(fixedDeposits)

                        if Enum.count(fixedDeposits)>0 do

                            totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                                fixedDeposit = Enum.at(fixedDeposits, x)

                                query = from au in Savings.Products.Product,
                                    where: (au.id == ^fixedDeposit.productId),
                                    select: au
                                products = Repo.all(query)
                                product = Enum.at(products, 0)

                                period = 0

                                days = Date.diff(Date.utc_today, fixedDeposit.startDate)


                                query = from au in Savings.Divestments.DivestmentPackage,
                                    where: (au.status == "ACTIVE" and au.productId == ^product.id and au.startPeriodDays <= type(^days, :integer) and au.endPeriodDays >= type(^days, :integer)),
                                    select: au
                                divestmentOption = Repo.one(query)

                                if is_nil(divestmentOption) do

                                else

                                    #ntotals = calculate_maturity_repayments(fixedDeposit.principalAmount, days,
                                    #   divestmentOption.divestmentValuation, fixedDeposit.yearLengthInDays, product.interestMode,
                                    #   product.interestType, fixedDeposit.fixedPeriodType)

                                    ntotals = fixedDeposit.principalAmount + fixedDeposit.accruedInterest
                                    ntotalsAtDueDate = fixedDeposit.principalAmount + fixedDeposit.expectedInterest
                                    fullValue = Float.ceil(ntotalsAtDueDate, fixedDeposit.currencyDecimals)

                                    IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                    IO.inspect ntotals
                                    endDate = case fixedDeposit.fixedPeriodType do
                                        "Days" ->
                                            endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod)
                                            endDate
                                        "Months" ->
                                            endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod*30)
                                            endDate
                                        "Years" ->
                                            endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod*fixedDeposit.yearLengthInDays)
                                            endDate
                                    end
                                    #currentValue = Float.ceil(ntotals, fixedDeposit.currencyDecimals)
                                    currentValue = Decimal.round(Decimal.from_float(ntotals), fixedDeposit.currencyDecimals)
                                    #currentValue = :erlang.float_to_binary((currentValue), [{:decimals, fixedDeposit.currencyDecimals}])

                                    fixedAmount = Float.ceil(fixedDeposit.principalAmount, fixedDeposit.currencyDecimals)
                                    fixedAmount = :erlang.float_to_binary((fixedAmount), [{:decimals, fixedDeposit.currencyDecimals}])
                                    id = "#{fixedDeposit.id}"
                                    idLen = String.length(id)

                                    fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
                                    "#{(x+1)}. Ref ##{fixedDepositNumber}\nFixed Deposit: " <> fixedDeposit.currency <> fixedAmount <> "\nCurrent Value: " <> fixedDeposit.currency <> "#{currentValue}" <> "\nValue At Maturity: " <> fixedDeposit.currency <> "#{fullValue}\nValue Date: #{endDate}\n"
                                    #\nDeposit Date: #{fixedDeposit.startDate}
                                end

                            end


                            IO.inspect Enum.count(totals)
                            IO.inspect "==========>>>>>>>"
                            acctStatement = (Enum.join(totals, "\n"))
                            IO.inspect String.length(acctStatement)
                            text = "Select a fixed deposit to divest \n\n" <> acctStatement <> "\n\nb. Back"
                            # response = %{
                            #    Message: text,
                            #    ClientState: 1,
                            #    Type: "Response",
                            #    key: "CON"
                            # }

                            response = text
                            send_response(conn, response)
                        else
                            text = "You do not have any fixed Deposits to divest\n\nb. Back"
                            response = text
                            # response = %{
                            #     Message: response,
                            #     ClientState: 1,
                            #     Type: "Response",
                            #     key: "BA3"
                            #  }
                            send_response(conn, response)
                        end
                    else
                        text = "Invalid option selected\n\nb. Back"
                        response = text
                        # response = %{
                        #     Message: response,
                        #     ClientState: 1,
                        #     Type: "Response",
                        #     key: "BA3"
                        #  }
                        send_response(conn, response)
                    end
                5 ->

                    IO.inspect "<<<<==========>>>>"
                    selectedIndex = Enum.at(checkMenu, 3)
                    IO.inspect selectedIndex

                    if(checkIfInteger(selectedIndex)==false) do
                        text = "Invalid option selected\n\nb. Back"
                        response = text
                        send_response(conn, response)
                    else
                        selectedIndex = elem Integer.parse(selectedIndex), 0
                        query = from au in User,
                            where: (au.username == type(^mobile_number, :string)),
                            select: au
                        appUsers = Repo.all(query)
                        appUser = Enum.at(appUsers, 0)

                        individualRoleType = "INDIVIDUAL"
                        query = from au in Savings.Accounts.UserRole,
                            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                            select: au
                        userRoles = Repo.all(query)
                        userRole = Enum.at(userRoles, 0)

                        isMatured = false
                        isDivested = false
                        fixedDepositStatus = "ACTIVE"
                        query = from au in Savings.FixedDeposit.FixedDeposits,
                            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.fixedDepositStatus == type(^fixedDepositStatus, :string) and au.userId == type(^appUser.id, :integer)),
                            order_by: [desc: :id],
                            select: au
                        fixedDeposits = Repo.all(query)
                        totalBalance = 0.00

                            IO.inspect "=========="
                            IO.inspect Enum.count(fixedDeposits)

                        if (Enum.count(fixedDeposits)>0 && Enum.count(fixedDeposits)>=selectedIndex) do
                            fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))

                            query = from au in Savings.Products.Product,
                                where: (au.id == ^fixedDeposit.productId),
                                select: au
                            products = Repo.all(query)
                            product = Enum.at(products, 0)

                            period = 0
                            days = Date.diff(Date.utc_today, fixedDeposit.startDate)


                            ntotals = calculate_maturity_repayments(fixedDeposit.principalAmount, days, fixedDeposit.interestRate)

                            accruedtotals = fixedDeposit.principalAmount + fixedDeposit.accruedInterest


                            daysAtEnd = Date.diff(Date.utc_today, fixedDeposit.startDate)
                            ntotalsAtDueDate = fixedDeposit.principalAmount + fixedDeposit.expectedInterest

                            IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                            IO.inspect ntotals
                            endDate = case fixedDeposit.fixedPeriodType do
                                "Days" ->
                                    endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod)
                                    endDate
                                "Months" ->
                                    endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod*30)
                                    endDate
                                "Years" ->
                                    endDate = Date.add(Date.utc_today, fixedDeposit.fixedPeriod*fixedDeposit.yearLengthInDays)
                                    endDate
                            end

                                # fullValue = Float.ceil(ntotalsAtDueDate, fixedDeposit.currencyDecimals)
                                #currentValue = Float.ceil(ntotals, fixedDeposit.currencyDecimals)
                                # currentValue = Decimal.round(Decimal.from_float(ntotals), fixedDeposit.currencyDecimals)
                                # accruedtotals = Decimal.round(Decimal.from_float(accruedtotals), fixedDeposit.currencyDecimals)
                                fixedAmount = Float.ceil(fixedDeposit.principalAmount, fixedDeposit.currencyDecimals)
                                # acctStatement = "Txn Date: #{fixedDeposit.startDate}\nValue Date:#{endDate}\nFixed Deposit:" <> fixedDeposit.currency <> "#{fixedAmount}\n"

                                id = "#{fixedDeposit.id}"
                                idLen = String.length(id)

                                fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
                                fixedAmount = :erlang.float_to_binary((fixedAmount), [{:decimals, fixedDeposit.currencyDecimals}])
                                #currentValue = :erlang.float_to_binary((currentValue), [{:decimals, fixedDeposit.currencyDecimals}])
                                acctStatement = "Ref ##{fixedDepositNumber}\nFixed Deposit: " <> fixedDeposit.currency <> fixedAmount
                                #<> "\nCurrent Value: " <> fixedDeposit.currency <> "#{accruedtotals}" <> "\nValue At Maturity: " <> fixedDeposit.currency <> "#{fullValue}\nValue Date: #{endDate}\nDeposit Date: #{fixedDeposit.startDate}\n"

                                currentDays = Date.diff(Date.utc_today, fixedDeposit.startDate)
                                query = from au in Savings.Divestments.DivestmentPackage,
                                    where: (au.productId == ^fixedDeposit.productId and au.startPeriodDays <= type(^currentDays, :integer) and au.endPeriodDays >= type(^currentDays, :integer)),
                                    select: au
                                divestmentPackages = Repo.all(query)

                                if Enum.count(divestmentPackages) == 0 do
                                    # response = %{
                                    #    Message: "CON You can not divest this fixed product. Contact our customer support team for more assistance on this",
                                    #    ClientState: 1,
                                    #    Type: "Response"
                                    # }

                                    response = "You can not divest this fixed product. Contact our customer support team for more assistance on this"
                                    send_response(conn, response)
                                else

                                    IO.inspect "=========="
                                    text = "Your selected fixed deposit:\n\n" <> acctStatement <> "\n1. Confirm\nb. Back"
                                    # response = %{
                                    #    Message: text,
                                    #    ClientState: 1,
                                    #    Type: "Response",
                                    #    key: "CON"
                                    # }
                                    response = text
                                    send_response(conn, response)
                                end
                                else
                                    text = "Invalid selection. Select a valid fixed deposit to divest\nb. Back"
                                    response = text
                                    send_response(conn, response)
                                end
                            end

                        6 ->


                            IO.inspect "88888888888888888888888888888888"
                            IO.inspect checkMenu
                            selectedIndex = Enum.at(checkMenu, 2)
                            selectedIndex = elem Integer.parse(selectedIndex), 0
                            valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu) - 2))

                            if (selectedIndex==1) do
                                #Partial Divestment
                                if(valueEntered=="1") do
                                    response = "Enter how much you are withdrawing today."
                                    #  response = %{
                                    #     Message: response,
                                    #     ClientState: 1,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    # }
                                    send_response(conn, response)
                                else
                                    text = "Invalid selection.\nb. Back"
                                    response = text
                                    send_response(conn, response)
                                end
                            else
                                if (selectedIndex==2) do
                                    #Full Divestment
                                    if(valueEntered=="1") do
                                        selectedIndex = Enum.at(checkMenu, 3)
                                        selectedIndex = elem Integer.parse(selectedIndex), 0
                                        query = from au in User,
                                            where: (au.username == type(^mobile_number, :string)),
                                            select: au
                                        appUsers = Repo.all(query)
                                        appUser = Enum.at(appUsers, 0)

                                        isMatured = false
                                        isDivested = false
                                        fixedDepositStatus = "ACTIVE"
                                        query = from au in Savings.FixedDeposit.FixedDeposits,
                                            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.fixedDepositStatus == type(^fixedDepositStatus, :string) and au.userId == type(^appUser.id, :integer)),
                                            order_by: [desc: :id],
                                            select: au
                                        fixedDeposits = Repo.all(query)
                                        fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))

                                        productId = 1
                                        query = from au in Savings.Products.Product,
                                            where: (au.id == type(^productId, :integer)) ,
                                            select: au
                                        savingsProducts = Repo.all(query)
                                        savingsProduct = Enum.at(savingsProducts, 0)


                                        amount = fixedDeposit.principalAmount
                                        IO.inspect "<<<<<<"
                                        IO.inspect amount

                                        currentDays = Date.diff(Date.utc_today, fixedDeposit.startDate)
                                        query = from au in Savings.Divestments.DivestmentPackage,
                                            where: (au.productId == ^fixedDeposit.productId and au.startPeriodDays <= type(^currentDays, :integer) and au.endPeriodDays >= type(^currentDays, :integer)),
                                            select: au
                                        divestmentPackages = Repo.all(query)
                                        divestmentPackage = Enum.at(divestmentPackages, 0)


                                        newValuation = calculate_maturity_repayments(amount, currentDays, divestmentPackage.divestmentValuation)
                                        newValuation = Float.ceil(newValuation, 2)
                                        totalRepayAmount = Float.ceil(newValuation, fixedDeposit.currencyDecimals)
                                        newValuation = :erlang.float_to_binary((newValuation), [{:decimals, fixedDeposit.currencyDecimals}])

                                        totalRepayAmount = Float.to_string(totalRepayAmount)
                                        IO.inspect "#{totalRepayAmount}"
                                        IO.inspect "new valuation... #{totalRepayAmount}"


                                        msg = "If you withdraw today you will receive an interest of #{fixedDeposit.currency}#{newValuation}. Please press"
                                        msg = msg <> "\n\n1. Confirm\nb. Back"
                                        # response = %{
                                        #     Message: msg,
                                        #     ClientState: 1,
                                        #     Type: "Response",
                                        #     key: "CON"
                                        #  }
                                        response = msg
                                        send_response(conn, response)
                                    else

                                        msg = "Invalid selection. Press"
                                        msg = msg <> "\n\nb. Back"
                                        response = msg
                                        send_response(conn, response)
                                    end
                                end
                            end

                        7 ->
                            selectedIndex = Enum.at(checkMenu, 2)
                            selectedIndex = elem Integer.parse(selectedIndex), 0
                            # valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu) - 1))
                            valueEntered = Enum.at(checkMenu, 5)
                            # Enum.at(checkMenu, 4)

                            if (selectedIndex==2) do
                                #Full Divestment

                                keyEntered = "1"
                                response = handleDivestFundAction(conn, mobile_number, cmd, text, checkMenu, keyEntered, 2)
                                #FULL DIVESTMENT
                                send_response(conn, response)
                            else
                                if (selectedIndex==1 && checkIfFloat(valueEntered)!==false) do
                                    #Partial Divestment
                                    selectedIndex = Enum.at(checkMenu, 3)
                                    selectedIndex = elem Integer.parse(selectedIndex), 0
                                    query = from au in User,
                                        where: (au.username == type(^mobile_number, :string)),
                                        select: au
                                    appUsers = Repo.all(query)
                                    appUser = Enum.at(appUsers, 0)

                                    individualRoleType = "INDIVIDUAL"
                                    query = from au in Savings.Accounts.UserRole,
                                        where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                        select: au
                                    userRoles = Repo.all(query)
                                    userRole = Enum.at(userRoles, 0)


                                    isMatured = false
                                    isDivested = false
                                    fixedDepositStatus = "ACTIVE"
                                    query = from au in Savings.FixedDeposit.FixedDeposits,
                                        where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.fixedDepositStatus == type(^fixedDepositStatus, :string) and au.userId == type(^appUser.id, :integer)),
                                        order_by: [desc: :id],
                                        select: au
                                    fixedDeposits = Repo.all(query)
                                    fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))
                                    totalBalance = 0.00


                                    productId = fixedDeposit.productId
                                    query = from au in Savings.Products.Product,
                                        where: (au.id == type(^productId, :integer)) ,
                                        select: au
                                    savingsProducts = Repo.all(query)
                                    savingsProduct = Enum.at(savingsProducts, 0)


                                    amount = Enum.at(checkMenu, 5)
                                    amount = elem Float.parse(amount), 0
                                    IO.inspect "<<<<<<"
                                    IO.inspect amount

                                    currentDays = Date.diff(Date.utc_today, fixedDeposit.startDate)
                                    if(currentDays >= fixedDeposit.fixedPeriod) do
                                        msg = "You can not divest this fixed deposit. The selected fixed deposit is due for maturity. Please use the Withdraw option to withdraw your matured funds. Press\n\nb. Back"
                                        response = msg
                                        send_response(conn, response)
                                    else
                                        query = from au in Savings.Divestments.DivestmentPackage,
                                            where: (au.productId == ^fixedDeposit.productId and au.startPeriodDays <= type(^currentDays, :integer) and au.endPeriodDays >= type(^currentDays, :integer)),
                                            select: au
                                        divestmentPackages = Repo.all(query)
                                        divestmentPackage = Enum.at(divestmentPackages, 0)


                                        newValuation = calculate_maturity_repayments(amount, currentDays, divestmentPackage.divestmentValuation)

                                        totalwithdraw = amount + newValuation
                                        totalwithdraw = :erlang.float_to_binary((totalwithdraw), [{:decimals, 2}])

                                        newValuation = Float.ceil(newValuation, 2)
                                        totalRepayAmount = Float.ceil(newValuation, fixedDeposit.currencyDecimals)
                                        newValuation = :erlang.float_to_binary((newValuation), [{:decimals, 2}])

                                        totalRepayAmount = Float.to_string(totalRepayAmount)
                                        IO.inspect "#{totalRepayAmount}"
                                        IO.inspect "new valuation... #{totalRepayAmount}"


                                        reinvestPeriod = fixedDeposit.fixedPeriod
                                        balance = (fixedDeposit.principalAmount - amount)
                                        reinvestCurrency = savingsProduct.currencyId

                                        IO.inspect "new Balance... #{balance}"
                                        IO.inspect fixedDeposit.principalAmount

                                        if amount > fixedDeposit.principalAmount do
                                            msg = "You can not divest more than your fixed deposit amount. Press\n\nb. Back"

                                            # response = %{
                                            #    Message: msg,
                                            #    ClientState: 2,
                                            #    Type: "Response",
                                            #    key: "BA3"
                                            # }

                                            response = msg
                                            send_response(conn, response)
                                        else

                                            if balance>0 do
                                                query = from au in Savings.Products.ProductsPeriod,
                                                    where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod),
                                                    select: au
                                                reinvestSavingsProducts = Repo.all(query)
                                                # reinvestSavingsProducts = Enum.at(reinvestSavingsProducts, 0)

                                                # if reinvestSavingsProducts.minimumPrincipal < balance do
                                                #     msg = "CON You can not divest the sum of the amount. The remaining minimum should be greater than ZMW 10. Press\n\nb. Back"

                                                #     response = %{
                                                #        Message: msg,
                                                #        ClientState: 2,
                                                #        Type: "Response",
                                                #        key: "BA3"
                                                #     }

                                                #     # response = msg
                                                #     send_response(conn, response)
                                                # else
                                                    reinvestSavingsProduct = Enum.at(reinvestSavingsProducts, 0)
                                                    IO.inspect Enum.count(reinvestSavingsProducts)
                                                    reinvestValuationCurrency = "ZMW"
                                                    reinvestPeriod = reinvestSavingsProduct.defaultPeriod
                                                    reinvestPeriodType = reinvestSavingsProduct.periodType

                                                    reinvestValuation = calculate_maturity_repayments(balance, reinvestPeriod, reinvestSavingsProduct.interest)
                                                    reinvestValuation = Float.ceil(reinvestValuation, 2)
                                                    reinvestValuation = :erlang.float_to_binary((reinvestValuation), [{:decimals, 2}])

                                                    msg = "If you withdraw ZMW#{valueEntered} today you will receive Interest #{fixedDeposit.currency}" <> newValuation <> ". \nThe balance will be reinvested to give you #{reinvestValuationCurrency}#{reinvestValuation} on #{DateTime.to_date(fixedDeposit.endDate)} \n\n1. Confirm\nb. Back"

                                                    # response = %{
                                                    # Message: msg,
                                                    # ClientState: 2,
                                                    # Type: "Response",
                                                    # key: "CON"
                                                    # }

                                                    response = msg
                                                    send_response(conn, response)
                                                # end
                                            else
                                                msg = "If you withdraw ZMW#{valueEntered} today you will receive Interest #{fixedDeposit.currency}#{newValuation}. Total ZMW#{totalwithdraw}"
                                                msg = msg <> "\n\n1. Confirm\nb. Back"

                                                # response = %{
                                                # Message: msg,
                                                # ClientState: 2,
                                                # Type: "Response",
                                                # key: "CON"
                                                # }

                                                response = msg
                                                send_response(conn, response)
                                            end
                                        end
                                    end
                                else
                                    text = "Invalid amount entered.\n\nb. Back"
                                    response = text
                                    send_response(conn, response)
                                end
                            end

                        8 ->
                            keyEntered = Enum.at(checkMenu, 6)
                            response = handleDivestFundAction(conn, mobile_number, cmd, text, checkMenu, keyEntered, 1)
                            #For Partial Divestment
                            send_response(conn, response)
                end
        end
    end

    def handleDivestFundAction(conn, mobile_number, cmd, text, checkMenu, keyEntered, type) do
        clientid = 1

        response = if keyEntered=="1" do
            selectedIndex = Enum.at(checkMenu, 3)
            selectedIndex = elem Integer.parse(selectedIndex), 0

            query = from au in User,
                where: (au.username == type(^mobile_number, :string)),
                select: au
            appUsers = Repo.all(query)
            appUser = Enum.at(appUsers, 0)

            individualRoleType = "INDIVIDUAL"
            query = from au in Savings.Accounts.UserRole,
                where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                select: au
            userRoles = Repo.all(query)
            userRole = Enum.at(userRoles, 0)
            userRoleId = userRole.id

            query = from au in Savings.Client.UserBioData,
                where: (au.userId == type(^appUser.id, :integer)),
                select: au
            userBioData = Repo.one(query)

            isMatured = false
            isDivested = false
            fixedDepositStatus = "ACTIVE"
            query = from au in Savings.FixedDeposit.FixedDeposits,
                where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.fixedDepositStatus == type(^fixedDepositStatus, :string) and au.userId == type(^appUser.id, :integer)),
                order_by: [desc: :id],
                select: au
            fixedDeposits = Repo.all(query)
            fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))

            productId = 1
            query = from au in Savings.Products.Product,
                where: (au.id == type(^productId, :integer)) ,
                select: au
            savingsProducts = Repo.all(query)
            savingsProduct = Enum.at(savingsProducts, 0)

            amount = if (type==1) do
                amount = Enum.at(checkMenu, 5)
                amount = elem Float.parse(amount), 0
                amount
            else
                amount = if (type==2) do
                    amount = fixedDeposit.principalAmount
                    amount
                end
                amount
            end

            IO.inspect "<<<<<<"
            IO.inspect amount

            currentDays = Date.diff(Date.utc_today, fixedDeposit.startDate)

            query = from au in Savings.Divestments.DivestmentPackage,
                where: (au.productId == ^fixedDeposit.productId and au.startPeriodDays <= type(^currentDays, :integer) and au.endPeriodDays >= type(^currentDays, :integer)),
                select: au
            divestmentPackages = Repo.all(query)
            divestmentPackage = Enum.at(divestmentPackages, 0)

            newValuation = calculate_maturity_repayments(amount, currentDays, divestmentPackage.divestmentValuation)
            accruedInterest = newValuation

            newValuation = Float.ceil(newValuation, 2)
            accruedInterest = Float.ceil(accruedInterest, 2)
            totalRepayAmount = Float.ceil(newValuation, fixedDeposit.currencyDecimals)
            totalRepayAmount = Float.to_string(totalRepayAmount)

            IO.inspect "#{totalRepayAmount}"
            IO.inspect "new valuation... #{totalRepayAmount}"

            reinvestPeriod = fixedDeposit.fixedPeriod
            balance = (fixedDeposit.principalAmount - amount)
            reinvestCurrency = savingsProduct.currencyId

            query = from au in Savings.Accounts.Account,
                where: (au.userRoleId == type(^userRole.id, :integer)),
                select: au
            accounts = Repo.all(query)
            account = Enum.at(accounts, 0)
            accountId = account.id
            userId = appUser.id



            carriedOutByUserId= userId
            carriedOutByUserRoleId= userRoleId
            isReversed= false
            orderRef= Integer.to_string(Enum.random(1_000000000..9_999999999))
            orderRef = "ZIPAKE#{orderRef}"
            divestOrderRef = "ZIPAKE#{orderRef}"
            productId= savingsProduct.id
            productType= "SAVINGS"
            referenceNo = UUID.uuid4()
            requestData= nil
            responseData= nil
            status= "SUCCESS"
            totalAmount= amount
            transactionType= "DR"
            productCurrency= "ZMW"
            currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
            transactionDetail = "Withdrawal before Fixed Deposit Maturity"

            divestmentType = if (type==1) do
                divestmentType = "Partial Divestment"
                divestmentType
            else
                divestmentType = if (type==2) do
                    divestmentType = "Full Divestment"
                    divestmentType
                end
                divestmentType

            end

            amtWithdrawnAndSentToAirtel = Decimal.round(Decimal.from_float(amount + newValuation), fixedDeposit.currencyDecimals)
            idLen1 = String.length("#{fixedDeposit.id}")
            fixedDepositNumber1 = String.pad_leading("#{fixedDeposit.id}", (6 - idLen1), "0")
            logUssdRequest(appUser.id, "DIVEST FIXED DEPOSIT", nil, "SUCCESS", mobile_number, "Divested fixed deposit - ##{fixedDepositNumber1} | #{fixedDeposit.currency}#{amtWithdrawnAndSentToAirtel}")
            referenceNo = orderRef
            mobileNumberTruncated = String.slice(mobile_number, 3..11)

            params = %{
                airtel_mobile: mobileNumberTruncated,
                enterdAmount: amtWithdrawnAndSentToAirtel,
                referenceNo: referenceNo,
                orderRef: orderRef
            }

            custPush = Savings.Service.Momo.AirtelServices.customer_disbursment(params)
            statusCode = custPush.status_code

            IO.inspect "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
            IO.inspect amtWithdrawnAndSentToAirtel
            IO.inspect amount
            IO.inspect custPush
            case statusCode do

                200 ->

                    body =  Jason.decode!(custPush.body)
                    airtelCode = body["status"]["code"]
                    airtelAtatus = body["status"]["success"]

                    case airtelCode do

                        "200" ->

                            case airtelAtatus do

                                true ->

                                    transaction = %Savings.Transactions.Transaction{
                                        accountId: accountId,
                                        carriedOutByUserId: carriedOutByUserId,
                                        carriedOutByUserRoleId: carriedOutByUserRoleId,
                                        isReversed: isReversed,
                                        orderRef: orderRef,
                                        productId: productId,
                                        productType: productType,
                                        referenceNo: referenceNo,
                                        requestData: requestData,
                                        responseData: responseData,
                                        status: status,
                                        totalAmount: totalAmount,
                                        transactionType: transactionType,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        transactionDetail: transactionDetail,
                                        transactionTypeEnum: "DIVESTMENT",
                                        newTotalBalance: (fixedDeposit.principalAmount - totalAmount),
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                        currencyDecimals: fixedDeposit.currencyDecimals,
                                        currency: fixedDeposit.currency,
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}"

                                    }
                                    transaction = Repo.insert!(transaction)

                                    acct = Savings.Accounts.Account.changesetForUpdate(account,
									%{
										totalWithdrawals: (account.totalDeposits + totalAmount)
									})

									Repo.update!(acct)

                                    divestment = %Savings.Divestments.Divestment{
                                        clientId: clientid,
                                        divestAmount: amount,
                                        divestmentDate: Date.utc_today,
                                        divestmentDayCount: currentDays,
                                        divestmentValuation: divestmentPackage.divestmentValuation,
                                        fixedDepositId: fixedDeposit.id,
                                        fixedPeriod: fixedDeposit.fixedPeriod,
                                        interestRate: fixedDeposit.interestRate,
                                        interestRateType: fixedDeposit.interestRateType,
                                        principalAmount: fixedDeposit.principalAmount,
                                        interestAccrued: accruedInterest,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                        divestmentType: divestmentType,
                                        currencyDecimals: fixedDeposit.currencyDecimals,
                                        currency: fixedDeposit.currency
                                    }

                                    divestment = Repo.insert!(divestment)

                                    divestmentTransaction = %Savings.Divestments.DivestmentTransaction{
                                        clientId: clientid,
                                        amountDivested: amount,
                                        divestmentId: divestment.id,
                                        interestAccrued: accruedInterest,
                                        transactionId: transaction.id,
                                        userId: userId,
                                        userRoleId: userRoleId
                                    }

                                    divestmentTransaction = Repo.insert!(divestmentTransaction)

                                    fd = Repo.get!(Savings.FixedDeposit.FixedDeposits, fixedDeposit.id)
                                    cs = Savings.FixedDeposit.FixedDeposits.changeset(fd,

                                        %{
                                            accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
                                            interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: fd.accruedInterest,
                                            isMatured: fd.isMatured, isDivested: true, divestmentPackageId: divestmentPackage.id, currencyId: fd.currencyId,
                                            currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
                                            totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
                                            totalAmountPaidOut: totalAmount, startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId, divestmentId: divestment.id,
                                            productInterestMode: fd.productInterestMode, branchId: fd.branchId,
                                            divestedInterestRate: divestmentPackage.divestmentValuation, divestedInterestRateType: fixedDeposit.fixedPeriodType,
                                            amountDivested: amount, divestedInterestAmount: accruedInterest, divestedPeriod: currentDays, fixedDepositStatus: "DIVESTED"
                                        })

                                    Repo.update!(cs)

                                    #########################################################333#########################################################
                                    customerPayout = %Savings.CustomerPayouts.CustomerPayout{
                                        amount: totalAmount + newValuation,
                                        fixedDepositId: fixedDeposit.id,
                                        orderRef: orderRef,
                                        payoutRequest: nil,
                                        payoutResponse: nil,
                                        payoutType: "DIVESTMENT",
                                        status: "SUCCESS",
                                        transactionDate: Date.utc_today,
                                        transactionId: transaction.id,
                                        userId: appUser.id
                                    }
                                    customerPayout = Repo.insert!(customerPayout)

                                    #########################################################333#########################################################

                                    response = if balance>0 do

                                        # query = from au in Savings.Products.Product,
                                        #     where: (au.minimumPrincipal <= type(^balance, :float) and au.status == "ACTIVE" and au.maximumPrincipal >= type(^balance, :float) and au.defaultPeriod == type(^reinvestPeriod, :integer) and au.currencyId == type(^reinvestCurrency, :integer)) ,
                                        #     select: au
                                        # reinvestSavingsProducts = Repo.all(query)

                                        query = from au in Savings.Products.ProductsPeriod,
                                            where: au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod,
                                            select: au
                                        reinvestSavingsProducts = Repo.all(query)

                                        reinvestSavingsProduct = Enum.at(reinvestSavingsProducts, 0)

                                        reinvestValuationCurrency = "ZMW"
                                        reinvestPeriod = reinvestSavingsProduct.defaultPeriod
                                        reinvestPeriodType = reinvestSavingsProduct.periodType

                                        reinvestValuation = calculate_maturity_repayments(balance, reinvestPeriod, reinvestSavingsProduct.interest)
                                        IO.inspect "============================oooooooooooooooooooooooooooooooo"
                                        IO.inspect reinvestValuation

                                        reinvestValuation = Float.ceil(reinvestValuation, 2)
                                        carriedOutByUserId = userId
                                        carriedOutByUserRoleId = userRoleId
                                        isReversed = false
                                        orderRef = Integer.to_string(Enum.random(1_000000000..9_999999999))
                                        orderRef = "ZIPAKE#{orderRef}"
                                        productId = 1
                                        productType = "SAVINGS"
                                        referenceNo = String.slice(mobile_number, 3..11)
                                        requestData = nil
                                        responseData = nil
                                        status = "SUCCESS"
                                        totalAmount = amount
                                        transactionType = "CR"
                                        productCurrency = reinvestValuationCurrency
                                        # expectedInterest = Float.ceil((reinvestValuation - balance), 2)
                                        expectedInterest = reinvestValuation
                                        fixedPeriod = reinvestPeriod
                                        fixedPeriodType = reinvestSavingsProduct.periodType
                                        interestRate = reinvestSavingsProduct.interest
                                        interestRateType = reinvestSavingsProduct.interestType
                                        isDivested = false
                                        isMatured = false
                                        principalAmount = balance
                                        productId = 1
                                        startDate = fd.startDate
                                        totalAmountPaidOut = 0.00
                                        totalDepositCharge = 0.00
                                        totalPenalties = 0.00
                                        totalWithdrawalCharge = 0.00
                                        yearLengthInDays = reinvestSavingsProduct.yearLengthInDays
                                        accruedInterest = 0.00
                                        currencyId = 1
                                        currencyDecimals = 2
                                        currency = reinvestValuationCurrency
                                        endDate = fd.endDate
                                        fixedDepositStatus = "ACTIVE"
                                        productInterestMode= "FLAT"

                                        fixedDeposit = %Savings.FixedDeposit.FixedDeposits{
                                            accountId: accountId,
                                            accruedInterest: accruedInterest,
                                            clientId: clientid,
                                            currency: currency,
                                            currencyDecimals: currencyDecimals,
                                            currencyId: currencyId,
                                            endDate: endDate,
                                            expectedInterest: expectedInterest,
                                            fixedPeriod: fixedPeriod,
                                            fixedPeriodType: fixedPeriodType,
                                            interestRate: interestRate,
                                            interestRateType: interestRateType,
                                            isDivested: isDivested,
                                            isMatured: isMatured,
                                            principalAmount: principalAmount,
                                            productId: productId,
                                            startDate: startDate,
                                            totalAmountPaidOut: totalAmountPaidOut,
                                            totalDepositCharge: totalDepositCharge,
                                            totalPenalties: totalPenalties,
                                            totalWithdrawalCharge: totalWithdrawalCharge,
                                            userId: userId,
                                            userRoleId: userRoleId,
                                            yearLengthInDays: yearLengthInDays,
                                            fixedDepositStatus: fixedDepositStatus,
                                            productInterestMode: productInterestMode,
                                            customerName: "#{userBioData.firstName} #{userBioData.lastName}"
                                        }

                                        fixedDeposit = Repo.insert!(fixedDeposit)

                                        # currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
                                        currentBalance = principalAmount
                                        transactionDetail = "Fixed Deposit on Balance"

                                        transaction = %Savings.Transactions.Transaction{
                                            accountId: accountId,
                                            carriedOutByUserId: carriedOutByUserId,
                                            carriedOutByUserRoleId: carriedOutByUserRoleId,
                                            isReversed: isReversed,
                                            orderRef: orderRef,
                                            productId: productId,
                                            productType: productType,
                                            referenceNo: referenceNo,
                                            requestData: requestData,
                                            responseData: responseData,
                                            status: status,
                                            totalAmount: balance,
                                            transactionType: transactionType,
                                            userId: userId,
                                            userRoleId: userRoleId,
                                            transactionDetail: transactionDetail,
                                            transactionTypeEnum: "DEPOSIT",
                                            newTotalBalance: (currentBalance),
                                            customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                            currencyDecimals: currencyDecimals,
                                            currency: currency
                                        }

                                        transaction = Repo.insert!(transaction)

                                        fixedDepositTransaction = %Savings.FixedDeposit.FixedDepositTransaction{
                                            clientId: clientid,
                                            fixedDepositId: fixedDeposit.id,
                                            amountDeposited: principalAmount,
                                            transactionId: transaction.id,
                                            userId: userId,
                                            userRoleId: userRoleId,
                                            status: "SUCCESS"
                                        }

                                        fixedDepositTransaction = Repo.insert!(fixedDepositTransaction)

                                        sumAmount = amount + newValuation
                                        newValuation = :erlang.float_to_binary((newValuation), [{:decimals, 2}])
                                        balance = :erlang.float_to_binary((balance), [{:decimals, 2}])

                                        msg = "The sum of #{fixedDeposit.currency}#{sumAmount} has been paid into your Airtel mobile money account.\n\nThe balance of #{reinvestValuationCurrency}#{balance} has also been fixed for #{reinvestPeriod}  #{reinvestPeriodType} to yield you #{reinvestValuationCurrency}#{reinvestValuation}\n\nb. Back"

                                        query = from au in Savings.Client.UserBioData,
                                            where: (au.userId == type(^userId, :integer)),
                                            select: au
                                        userBioData = Repo.one(query)
                                        firstName = userBioData.firstName

                                        idLen1 = String.length("#{fixedDeposit.id}")
                                        fixedDepositNumber1 = String.pad_leading("#{fixedDeposit.id}", (6 - idLen1), "0")
                                        idLen2 = String.length("#{fd.id}")

                                        fixedDepositNumber2 = String.pad_leading("#{fd.id}", (6 - idLen2), "0")

                                        logUssdRequest(appUser.id, "FIXED DEPOSIT", nil, "SUCCESS", mobile_number, "Fixed deposit - #{userBioData.firstName} #{userBioData.lastName} | ##{fixedDepositNumber1} | #{fixedDeposit.currency}#{balance} | Reinvestment From ##{fixedDepositNumber2}")

                                        naive_datetime = Timex.now

                                        sms = %{
                                            mobile: appUser.username,
                                            msg: "Dear #{firstName},\nYour withdrawal of #{fixedDeposit.currency}" <> "#{sumAmount}" <> " was been queued for payment into your Airtel mobile money account.\nOrder Ref: #{divestOrderRef}",
                                            status: "READY",
                                            type: "SMS",
                                            msg_count: "1",
                                            date_sent: naive_datetime
                                        }
                                        Sms.changeset(%Sms{}, sms)
                                        |> Repo.insert()

                                        sms = %{
                                            mobile: appUser.username,
                                            msg: "Dear #{firstName}, The balance of #{reinvestValuationCurrency}#{balance} has been fixed for #{reinvestPeriod}  #{reinvestPeriodType} to yield you #{reinvestValuationCurrency}#{reinvestValuation}\nOrder Ref: #{orderRef}",
                                            status: "READY",
                                            type: "SMS",
                                            msg_count: "1",
                                            date_sent: naive_datetime
                                        }
                                        Sms.changeset(%Sms{}, sms)
                                        |> Repo.insert()

                                        # response = %{
                                        #    Message: msg,
                                        #    ClientState: 2,
                                        #    Type: "Response",
                                        #    key: "CON"
                                        # }

                                        response = msg
                                        response

                                    else

                                        newValuation = :erlang.float_to_binary((newValuation), [{:decimals, 2}])
                                        sumAmount = amount + newValuation
                                        msg = "The sum of #{fixedDeposit.currency}#{sumAmount} has been queued for payment into your mobile money account. Thanks\n\n\nb. Back"


                                        query = from au in Savings.Client.UserBioData,
                                            where: (au.userId == type(^userId, :integer)),
                                            select: au
                                        userBioData = Repo.one(query)

                                        firstName = userBioData.firstName


                                        naive_datetime = Timex.now
                                        sms = %{
                                            mobile: appUser.username,
                                            msg: "Dear #{firstName}, Your withdrawal of #{fixedDeposit.currency}" <> "#{sumAmount}" <> " has been queued for payment into your Airtel mobile money account.\nOrder Ref: #{divestOrderRef}",
                                            status: "READY",
                                            type: "SMS",
                                            msg_count: "1",
                                            date_sent: naive_datetime
                                        }
                                        Sms.changeset(%Sms{}, sms)
                                        |> Repo.insert()

                                        response = msg
                                        # response = %{
                                        #    Message: msg,
                                        #    ClientState: 2,
                                        #    Type: "Response",
                                        #    key: "CON"
                                        # }

                                        response

                                    end

                                    response
                            _->

                                status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                IO.inspect status
                                response = "Your early withdraw was not successful. Please try again"
                                send_response(conn, response)
                        end
                        _->

                            status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                            IO.inspect status
                            response = "Your early withdraw was not successful. Please try again"
                            send_response(conn, response)
                    end
                _->

                    status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                    IO.inspect status
                    response = "Your early withdraw was not successful. Please try again"
                    send_response(conn, response)


            end
        else

            #response = %{
            #    Message: "Invalid selection.. Press\n\nb. Back",
            #    ClientState: 1,
            #    Type: "Response",
            #    key: "BA3"
            #}

            response = "Invalid selection.. Press\n\nb. Back"
            response

        end

        response

    end


    def handleWithdrawal(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        defaultCurrency = 1
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)

        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)

            if valueEntered == "b" do

                response = "BA3"
                send_response(conn, response)
            else
                case checkMenuLength do
                    3 ->

                        individualRoleType = "INDIVIDUAL"
                        query = from au in Savings.Accounts.UserRole,
                                where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                select: au
                        userRoles = Repo.all(query)
                        userRole = Enum.at(userRoles, 0)

                        isMatured = true
                        isWithdrawn = false
                        query = from au in Savings.FixedDeposit.FixedDeposits,
                            where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                            order_by: [desc: :id],
                            select: au
                        fixedDeposits = Repo.all(query)

                        IO.inspect "=========="
                        IO.inspect Enum.count(fixedDeposits)

                        if Enum.count(fixedDeposits)>0 do

                                #acc = Enum.reduce(fixedDeposits, fn x,
                                #    acc -> x.id * acc
                                #end)

                                totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                                        #totalBalance = Enum.each(fixedDeposits, fn(fixedDeposit) ->
                                        fixedDeposit = Enum.at(fixedDeposits, x)

                                        currentValue = Float.ceil((fixedDeposit.principalAmount + fixedDeposit.accruedInterest - fixedDeposit.totalAmountPaidOut), fixedDeposit.currencyDecimals)
                                        currentValue = :erlang.float_to_binary((currentValue), [{:decimals, fixedDeposit.currencyDecimals}])

                                        #fixedAmount = Float.ceil(fixedDeposit.principalAmount, fixedDeposit.currencyDecimals)
                                        #fixedAmount = :erlang.float_to_binary((fixedAmount), [{:decimals, fixedDeposit.currencyDecimals}])
                                        fixedAmount = Decimal.round(Decimal.from_float((fixedDeposit.principalAmount)), fixedDeposit.currencyDecimals)
                                        id = "#{fixedDeposit.id}"
                                        idLen = String.length(id)

                                        fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
                                        retStr = "#{(x+1)}. Ref ##{fixedDepositNumber}\nFixed Deposit: #{fixedDeposit.currency}#{fixedAmount}\nCurrent Balance: #{fixedDeposit.currency}#{currentValue}\n"
                                        retStr
                                end


                                IO.inspect Enum.count(totals)
                                IO.inspect "=========="
                                acctStatement = (Enum.join(totals, "\n"))
                                text = "Select a fixed deposit to withdraw \n\n" <> acctStatement <> "\nb. Back"
                                # response = %{
                                #    Message: text,
                                #    ClientState: 1,
                                #    Type: "Response",
                                #    key: "CON"
                                # }

                                response = text
                                send_response(conn, response)
                        else
                            text = "You do not have any matured fixed Deposits to withdraw\n\nb. Back"
                            # response = %{
                            #     Message: text,
                            #     ClientState: 1,
                            #     Type: "Response",
                            #     key: "CON"
                            #  }
                            response = text
                            send_response(conn, response)
                        end

                    4 ->

                        IO.inspect "<<<<==========>>>>"
                        IO.inspect checkMenu
                        selectedIndex = Enum.at(checkMenu, 2)
                        IO.inspect selectedIndex
                        selectedIndex = elem Integer.parse(selectedIndex), 0
                        query = from au in User,
                            where: (au.username == type(^mobile_number, :string)),
                            select: au
                        appUsers = Repo.all(query)
                        appUser = Enum.at(appUsers, 0)



                        individualRoleType = "INDIVIDUAL"
                        query = from au in Savings.Accounts.UserRole,
                            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                            select: au
                        userRoles = Repo.all(query)
                        userRole = Enum.at(userRoles, 0)


                        status = "Disbursed"
                        isMatured = true
                        isWithdrawn = false
                        query = from au in Savings.FixedDeposit.FixedDeposits,
                            where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                            order_by: [desc: :id],
                            select: au
                        fixedDeposits = Repo.all(query)
                        totalBalance = 0.00

                                IO.inspect "=========="
                                IO.inspect Enum.count(fixedDeposits)

                        if (Enum.count(fixedDeposits)>0 && (selectedIndex <= Enum.count(fixedDeposits)) && selectedIndex>0) do


                            #totalBalance = Enum.each(fixedDeposits, fn(fixedDeposit) ->
                            fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))



                            #fullValue = Float.ceil((fixedDeposit.principalAmount + fixedDeposit.accruedInterest), fixedDeposit.currencyDecimals)
                            currentValue = Float.ceil((fixedDeposit.principalAmount + fixedDeposit.accruedInterest), fixedDeposit.currencyDecimals)
                            #currentValue = :erlang.float_to_binary((currentValue), [{:decimals, fixedDeposit.currencyDecimals}])
                            currentValue = Decimal.round(Decimal.from_float((fixedDeposit.principalAmount + fixedDeposit.accruedInterest)), fixedDeposit.currencyDecimals)
                            fixedAmount = Float.ceil(fixedDeposit.principalAmount, fixedDeposit.currencyDecimals)
                            fixedAmount = :erlang.float_to_binary((fixedAmount), [{:decimals, fixedDeposit.currencyDecimals}])
                            id = "#{fixedDeposit.id}"
                            idLen = String.length(id)

                            fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")

                            balance = fixedDeposit.principalAmount + fixedDeposit.accruedInterest - fixedDeposit.totalAmountPaidOut
                            balance = :erlang.float_to_binary((balance), [{:decimals, fixedDeposit.currencyDecimals}])
                            acctStatement = "Ref ##{fixedDepositNumber}\nFixed Deposit: #{fixedDeposit.currency} #{fixedAmount}\nValue Amount: #{fixedDeposit.currency}#{currentValue}\nCurrent Balance: #{fixedDeposit.currency}#{balance}\n"

                            IO.inspect "=========="
                            text = "Your selected fixed deposit:\n\n" <> acctStatement <> "\n1.Full Withdraw \n2.Partial Withdraw \n3.Partial Reinvest \n4.Full Reinvest \nb. Back"
                            # response = %{
                            #     Message: text,
                            #     ClientState: 1,
                            #     Type: "Response",
                            #     key: "CON"
                            #  }
                            response = text
                            send_response(conn, response)
                        else
                            text = "Invalid selection.\n\nb. Back"
                            # response = %{
                            #     Message: text,
                            #     ClientState: 1,
                            #     Type: "Response",
                            #     key: "CON"
                            #  }
                            response = text
                            send_response(conn, response)
                        end

                    5 ->

                        query = from au in User,
                            where: (au.username == type(^mobile_number, :string)),
                            select: au
                        appUsers = Repo.all(query)

                        appUser = Enum.at(appUsers, 0)

                        IO.inspect "<<<<==========>>>>"
                        selectedFdIndex = Enum.at(checkMenu, 2)
                        IO.inspect selectedFdIndex
                        selectedFdIndex = elem Integer.parse(selectedFdIndex), 0





                        selectedIndex1 = Enum.at(checkMenu, 3)

                        case selectedIndex1 do

                            "1" ->

                                isMatured = true
                                isWithdrawn = false
                                query = from au in Savings.FixedDeposit.FixedDeposits,
                                    where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                                    order_by: [desc: :id],
                                    select: au
                                fixedDeposits = Repo.all(query)

                                selectedIndex = Enum.at(checkMenu, 3)
                                IO.inspect selectedIndex
                                selectedIndex = elem Integer.parse(selectedIndex), 0

                                fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))

                                totalBalance = 0.00
                                IO.inspect "=========="
                                IO.inspect Enum.count(fixedDeposits)

                                if (Enum.count(fixedDeposits)>0) do

                                    IO.inspect selectedIndex1
                                    fixedDeposit = Enum.at(fixedDeposits, (selectedFdIndex-1))

                                    # amtWithdrawnAndSentToAirtel = Decimal.round(Decimal.from_float(totalAmount), fixedDeposit.currencyDecimals)


                                    carriedOutByUserId= appUser.id
                                    isReversed= false
                                    orderRef= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                    orderRef = "ZIPAKE#{orderRef}"
                                    productType= "SAVINGS"
                                    carriedOutByUserRoleId= fixedDeposit.userRoleId
                                    productId= fixedDeposit.productId
                                    requestData= nil
                                    responseData= nil
                                    status= "SUCCESS"
                                    totalAmount = fixedDeposit.principalAmount + fixedDeposit.expectedInterest - fixedDeposit.totalAmountPaidOut
                                    transactionType= "CR"
                                    productCurrency = "ZMW"
                                    referenceNo = UUID.uuid4()
                                    mobileNumberTruncated = String.slice(mobile_number, 3..11)

                                    amtWithdrawnAndSentToAirtel = totalAmount
                                    idLen1 = String.length("#{fixedDeposit.id}")

                                    fixedDepositNumber1 = String.pad_leading("#{fixedDeposit.id}", (6 - idLen1), "0")

                                    logUssdRequest(appUser.id, "FIXED DEPOSIT WITHDRAWAL", nil, "SUCCESS", mobile_number, "Full Withdrawal On Maturity - ##{fixedDepositNumber1} | #{fixedDeposit.currency}#{amtWithdrawnAndSentToAirtel}")
                                    IO.inspect "CHECKER 2"

                                    params = %{
                                        airtel_mobile: mobileNumberTruncated,
                                        enterdAmount: amtWithdrawnAndSentToAirtel,
                                        referenceNo: referenceNo,
                                        orderRef: orderRef
                                    }

                                    custPush = Savings.Service.Momo.AirtelServices.customer_disbursment(params)
                                    statusCode = custPush.status_code

                                    IO.inspect "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
                                    IO.inspect amtWithdrawnAndSentToAirtel
                                    IO.inspect custPush
                                    case statusCode do

                                        200 ->

                                            body =  Jason.decode!(custPush.body)
                                            airtelCode = body["status"]["code"]
                                            airtelAtatus = body["status"]["success"]

                                            case airtelCode do

                                                "200" ->

                                                    case airtelAtatus do

                                                        true ->

                                                            fd = Repo.get!(Savings.FixedDeposit.FixedDeposits, fixedDeposit.id)
                                                            cs = Savings.FixedDeposit.FixedDeposits.changeset(fd,

                                                                %{
                                                                    accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
                                                                    interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: fd.accruedInterest,
                                                                    isMatured: fd.isMatured, isDivested: fd.isDivested, currencyId: fd.currencyId,
                                                                    currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
                                                                    totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
                                                                    totalAmountPaidOut: (fd.accruedInterest + fd.principalAmount), startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId,
                                                                    productInterestMode: fd.productInterestMode, branchId: fd.branchId,
                                                                    isWithdrawn: true
                                                                })
                                                            Repo.update!(cs)


                                                            query = from au in Savings.Client.UserBioData,
                                                                where: (au.userId == type(^appUser.id, :integer)),
                                                                select: au
                                                            userBioData = Repo.one(query)

                                                            transactionDetail = "Fixed Deposit on Balance"
                                                            # currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
                                                            # currentBalance = fd.principalAmount
                                                            transaction = %Savings.Transactions.Transaction{
                                                                accountId: fd.accountId,
                                                                carriedOutByUserId: carriedOutByUserId,
                                                                carriedOutByUserRoleId: carriedOutByUserRoleId,
                                                                isReversed: isReversed,
                                                                orderRef: orderRef,
                                                                productId: productId,
                                                                productType: productType,
                                                                referenceNo: referenceNo,
                                                                requestData: requestData,
                                                                responseData: responseData,
                                                                status: status,
                                                                totalAmount: fd.accruedInterest + fd.principalAmount,
                                                                transactionType: transactionType,
                                                                userId: fd.userId,
                                                                userRoleId: fd.userRoleId,
                                                                transactionDetail: transactionDetail,
                                                                newTotalBalance: fd.accruedInterest + fd.principalAmount,
                                                                transactionTypeEnum: "Withdrawal",
                                                                customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                                                currencyDecimals: fd.currencyDecimals,
                                                                currency: fd.currency
                                                            }
                                                            transaction = Repo.insert!(transaction)

                                                            ###################################################################################################
                                                            status = String.downcase(status, :default)

                                                            customerPayout = %Savings.CustomerPayouts.CustomerPayout{

                                                                amount: amtWithdrawnAndSentToAirtel,
                                                                fixedDepositId: fixedDeposit.id,
                                                                orderRef: orderRef,
                                                                payoutRequest: nil,
                                                                payoutResponse: nil,
                                                                payoutType: "WITHDRAWAL",
                                                                status: status,
                                                                transactionDate: Date.utc_today,
                                                                transactionId: transaction.id,
                                                                userId: appUser.id
                                                            }
                                                            customerPayout = Repo.insert!(customerPayout)

                                                            naive_datetime = Timex.now
                                                            sms = %{
                                                                mobile: mobile_number,
                                                                msg: "Hello,\nYour withdrawal of #{fd.currency}#{(fd.accruedInterest + fd.principalAmount)} has been paid into your Airtel mobile money account.",
                                                                status: "READY",
                                                                type: "SMS",
                                                                msg_count: "1",
                                                                date_sent: naive_datetime
                                                            }
                                                            Sms.changeset(%Sms{}, sms)
                                                            |> Repo.insert()

                                                            IO.inspect "=========="
                                                            text = "Your Airtel mobile money account will be credited with the sum of #{fd.currency}#{(fd.accruedInterest + fd.principalAmount)}.\nThank you for your patronage.\n\nb. Back"
                                                            response = text
                                                            # response = %{
                                                            #     Message: text,
                                                            #     ClientState: 1,
                                                            #     Type: "Response",
                                                            #     key: "CON"
                                                            # }
                                                            send_response(conn, response)

                                                            ###################################################################################################
                                                            logUssdRequest(appUser.id, "TRANSFER TO CUSTOMER", nil, "SUCCESS", mobile_number, "Transfer Divestment Sent - #{userBioData.firstName} #{userBioData.lastName} | ##{fixedDepositNumber1} | #{fixedDeposit.currency}#{(amtWithdrawnAndSentToAirtel)}")

                                                    _->

                                                        status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                                        IO.inspect status
                                                        response = "Your withdraw was not successful. Please try again"
                                                        send_response(conn, response)
                                                end
                                                _->

                                                    status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                                    IO.inspect status
                                                    response = "Your withdraw was not successful. Please try again"
                                                    send_response(conn, response)
                                            end
                                        _->

                                            status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                            IO.inspect status
                                            response = "Your withdraw was not successful. Please try again"
                                            send_response(conn, response)


                                    end
                                else

                                    text = "Invalid selection.Press \n\nb. Back"
                                    # response = %{
                                    #     Message: text,
                                    #     ClientState: 1,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    #  }
                                    response = text
                                    send_response(conn, response)

                                end

                            "2" ->

                                response = "Enter how much you are withdrawing today?"
                                # text = "Enter how much you are withdrawing today?"
                                # response = %{
                                #     Message: text,
                                #     ClientState: 1,
                                #     Type: "Response",
                                #     key: "CON"
                                #  }
                                send_response(conn, response)

                            "3" ->

                                handleReinvestSomeMaturedFunds(conn, mobile_number, cmd, text, checkMenu, appUser)

                            "4" ->

                                handleReinvestAllMaturedFunds(conn, mobile_number, cmd, text, checkMenu, appUser)

                            _ ->

                                response = "Invalid selection. Press \n\nb. Back"
                                # response = %{
                                #     Message: "CON Invalid selection. Press \n\nb. Back",
                                #     ClientState: 1,
                                #     Type: "Response",
                                #     key: "CON"
                                #  }
                                send_response(conn, response)

                        end


                    6 ->
                        IO.inspect "########################"
                        IO.inspect checkMenu
                        parentIndex = Enum.at(checkMenu, 3)
                        case parentIndex do
                            "2" ->
                                #For Partial Withdrawal
                                selectedIndex = Enum.at(checkMenu, 2)
                                selectedIndex = elem Integer.parse(selectedIndex), 0

                                individualRoleType = "INDIVIDUAL"
                                query = from au in Savings.Accounts.UserRole,
                                    where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                    select: au
                                userRoles = Repo.all(query)
                                userRole = Enum.at(userRoles, 0)


                                status = "Disbursed"
                                isMatured = true
                                isWithdrawn = false
                                query = from au in Savings.FixedDeposit.FixedDeposits,
                                    where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                                    order_by: [desc: :id],
                                    select: au
                                fixedDeposits = Repo.all(query)
                                fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))
                                totalBalance = 0.00


                                productId = fixedDeposit.productId
                                query = from au in Savings.Products.Product,
                                    where: (au.id == type(^productId, :integer)) ,
                                    select: au
                                savingsProducts = Repo.all(query)
                                savingsProduct = Enum.at(savingsProducts, 0)

                                amount = Enum.at(checkMenu, 4)


                                if(checkIfFloat(amount)!==false && checkIfFloat(amount)>0) do
                                    amount = elem Float.parse(amount), 0
                                    IO.inspect "<<<<<<"
                                    IO.inspect amount

                                    newValuation = :erlang.float_to_binary((fixedDeposit.principalAmount + fixedDeposit.accruedInterest), [{:decimals, 2}])
                                    amountStr = :erlang.float_to_binary((amount), [{:decimals, 2}])

                                    IO.inspect "#{newValuation}"
                                    IO.inspect "new valuation... #{newValuation}"


                                    reinvestPeriod = fixedDeposit.fixedPeriod
                                    balance = (fixedDeposit.principalAmount + fixedDeposit.accruedInterest - amount)
                                    reinvestCurrency = savingsProduct.currencyId
                                    reinvestCurrencyName = savingsProduct.currencyName

                                    remaingbalance = fixedDeposit.principalAmount + fixedDeposit.accruedInterest - fixedDeposit.totalAmountPaidOut
                                    checkRemaingbalance = :erlang.float_to_binary((remaingbalance), [{:decimals, fixedDeposit.currencyDecimals}])

                                    if remaingbalance < amount do
                                        msg = "You can not withdraw that amount. Your current balance on this fixed deposit is #{checkRemaingbalance}. Press\n\nb. Back"
                                        response = msg
                                        send_response(conn, response)
                                    else
                                        if balance>0 do
                                            # query = from au in Savings.Products.Product,
                                            #     where: (au.minimumPrincipal <= type(^balance, :float) and au.status == "ACTIVE" and au.maximumPrincipal >= type(^balance, :float) and au.defaultPeriod == type(^reinvestPeriod, :integer) and au.currencyId == type(^reinvestCurrency, :integer)) ,
                                            #     select: au
                                            query = from au in Savings.Products.ProductsPeriod,
                                                where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod),
                                                select: au
                                            reinvestSavingsProducts = Repo.all(query)

                                            if Enum.count(reinvestSavingsProducts)== 0 do
                                                msg = "You can not withdraw the amount. You can only divest the full amount your have deposited. Press\n\nb. Back"

                                                # response = %{
                                                #    Message: msg,
                                                #    ClientState: 2,
                                                #    Type: "Response",
                                                #    key: "BA3"
                                                # }

                                                response = msg
                                                send_response(conn, response)
                                            else
                                                IO.inspect Enum.count(reinvestSavingsProducts)
                                                reinvestSavingsProduct = Enum.at(reinvestSavingsProducts, 0)
                                                reinvestValuationCurrency = "ZMW"
                                                reinvestPeriod = reinvestSavingsProduct.defaultPeriod
                                                reinvestPeriodType = reinvestSavingsProduct.periodType
                                                reinvestEndDate = case reinvestSavingsProduct.periodType do
                                                    "Days" ->
                                                        endDate = DateTime.add(DateTime.utc_now, (24*60*60*reinvestSavingsProduct.defaultPeriod), :second) |> DateTime.truncate(:second)
                                                        endDate
                                                    "Months" ->
                                                        endDate = DateTime.add(DateTime.utc_now, (24*60*60*reinvestSavingsProduct.defaultPeriod*30), :second) |> DateTime.truncate(:second)
                                                        endDate
                                                    "Years" ->
                                                        endDate = DateTime.add(DateTime.utc_now, (24*60*60*reinvestSavingsProduct.defaultPeriod*reinvestSavingsProduct.yearLengthInDays), :second) |> DateTime.truncate(:second)
                                                        endDate
                                                end

                                                reinvestValuation = calculate_maturity_repayments(balance, reinvestPeriod, reinvestSavingsProduct.interest)
                                                reinvestValuation = Float.ceil(reinvestValuation, 2)
                                                reinvestValuation = :erlang.float_to_binary((reinvestValuation), [{:decimals, 2}])

                                                msg = "You are about to withdraw #{reinvestCurrencyName}#{amountStr}. \n\n1. Confirm\nb. Back"

                                                # response = %{
                                                #    Message: msg,
                                                #    ClientState: 2,
                                                #    Type: "Response",
                                                #    key: "CON"
                                                # }

                                                response = msg
                                                send_response(conn, response)
                                            end
                                        else
                                            if balance<0 do
                                                msg = "Invalid amount. Please try again"
                                                msg = msg <> "\n\n1. Confirm\nb. Back"

                                                # response = %{
                                                #    Message: msg,
                                                #    ClientState: 2,
                                                #    Type: "Response",
                                                #    key: "CON"
                                                # }

                                                response = msg
                                                send_response(conn, response)
                                            else
                                                msg = "If you withdraw today you will receive #{fixedDeposit.currency}#{amountStr}"
                                                msg = msg <> "\n\n1. Confirm\nb. Back"

                                                # response = %{
                                                #    Message: msg,
                                                #    ClientState: 2,
                                                #    Type: "Response",
                                                #    key: "CON"
                                                # }

                                                response = msg
                                                send_response(conn, response)
                                            end
                                        end
                                    end
                                else
                                    text = "Invalid amount entered.Press \n\nb. Back"
                                    # response = %{
                                    #     Message: text,
                                    #     ClientState: 2,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    #  }
                                    response = text
                                    send_response(conn, response)
                                end
                            "3" ->
                                isMatured = true
                                isWithdrawn = false
                                query = from au in Savings.FixedDeposit.FixedDeposits,
                                    where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                                    order_by: [desc: :id],
                                    select: au
                                fixedDeposits = Repo.all(query)
                                totalBalance = 0.00

                                    IO.inspect "=========="
                                    IO.inspect Enum.count(fixedDeposits)

                                if (Enum.count(fixedDeposits)>0) do

                                    selectedFdIndex = Enum.at(checkMenu, 2)
                                    IO.inspect selectedFdIndex
                                    selectedFdIndex = elem Integer.parse(selectedFdIndex), 0


                                    fixedDeposit = Enum.at(fixedDeposits, (selectedFdIndex-1))


                                    fd = Repo.get!(Savings.FixedDeposit.FixedDeposits, fixedDeposit.id)
                                    totalDueAtMaturity = fd.principalAmount + fd.accruedInterest - fd.totalAmountPaidOut
                                    amount = Enum.at(checkMenu, 4)
                                    amount = elem Float.parse(amount), 0
                                    if(amount > 0 && amount < totalDueAtMaturity) do

                                        IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                        selectedIndex = Enum.at(checkMenu, 3)
                                        IO.inspect "selectedIndex..."
                                        IO.inspect selectedIndex
                                        selectedIndex = elem Integer.parse(selectedIndex), 0
                                        IO.inspect selectedIndex
                                        query = from au in Savings.Products.ProductsPeriod,
                                            where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod) ,
                                            select: au
                                        savingsProduct = Repo.one(query)

                                        default_rate = savingsProduct.interest
                                        default_period = savingsProduct.defaultPeriod
                                        annual_period = savingsProduct.yearLengthInDays
                                        #amt = elem Integer.parse(amount), 0
                                        amt = amount


                                        totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
                                        IO.inspect "Test"
                                        IO.inspect ((totalRepayments))

                                        #totalRepayAmount = :erlang.float_to_binary((totalRepayments), [decimals= 2])
                                        totalRepayAmount = Float.ceil(totalRepayments, 2)
                                        #totalRepayAmount = :erlang.float_to_binary((totalRepayments), [{decimals, 2}])
                                        totalRepayAmount = Float.to_string(totalRepayAmount)
                                        IO.inspect "#{totalRepayAmount}"
                                        default_period = :erlang.integer_to_binary(default_period)
                                        repay_entry = default_period <> " " <> savingsProduct.periodType <> " will give you ZMW" <> totalRepayAmount <> ".\nPress \n\n1. Confirm Deposit\nb. Back"

                                        response = repay_entry
                                        send_response(conn, response)

                                    else
                                        text = "The amount you provided to reinvest is more than what you currently have. Please enter a valid amount. Press \n\nb. Back"
                                        # response = %{
                                        #     Message: text,
                                        #     ClientState: 2,
                                        #     Type: "Response",
                                        #     key: "CON"
                                        #  }
                                        response = text
                                        send_response(conn, response)
                                    end



                                else
                                    text = "Invalid selection.Press \n\nb. Back"
                                    response = text
                                    send_response(conn, response)
                                end
                            "4" ->
                                isMatured = true
                                isWithdrawn = false
                                query = from au in Savings.FixedDeposit.FixedDeposits,
                                    where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                                    order_by: [desc: :id],
                                    select: au
                                fixedDeposits = Repo.all(query)
                                totalBalance = 0.00

                                    IO.inspect "=========="
                                    IO.inspect Enum.count(fixedDeposits)

                                if (Enum.count(fixedDeposits)>0) do

                                    selectedFdIndex = Enum.at(checkMenu, 2)
                                    IO.inspect selectedFdIndex
                                    selectedFdIndex = elem Integer.parse(selectedFdIndex), 0

                                    fixedDeposit = Enum.at(fixedDeposits, (selectedFdIndex-1))

                                    fd = Repo.get!(Savings.FixedDeposit.FixedDeposits, fixedDeposit.id)
                                    totalDueAtMaturity = fd.principalAmount + fd.accruedInterest - fd.totalAmountPaidOut
                                    amount = totalDueAtMaturity
                                    if(amount>0 && amount<=totalDueAtMaturity) do

                                        IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                        selectedIndex = Enum.at(checkMenu, 3)
                                        IO.inspect "selectedIndex..."
                                        IO.inspect selectedIndex
                                        selectedIndex = elem Integer.parse(selectedIndex), 0
                                        IO.inspect selectedIndex
                                        query = from au in Savings.Products.ProductsPeriod,
                                            where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod) ,
                                            select: au
                                        savingsProduct = Repo.one(query)

                                        default_rate = savingsProduct.interest
                                        default_period = savingsProduct.defaultPeriod
                                        annual_period = savingsProduct.yearLengthInDays
                                        #amt = elem Integer.parse(amount), 0
                                        amt = amount


                                        totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
                                        IO.inspect "Test"
                                        IO.inspect ((totalRepayments))

                                        #totalRepayAmount = :erlang.float_to_binary((totalRepayments), [decimals= 2])
                                        totalRepayAmount = Float.ceil(totalRepayments, 2)
                                        #totalRepayAmount = :erlang.float_to_binary((totalRepayments), [{decimals, 2}])
                                        totalRepayAmount = Float.to_string(totalRepayAmount)
                                        IO.inspect "#{totalRepayAmount}"
                                        default_period = :erlang.integer_to_binary(default_period)
                                        repay_entry = default_period <> " " <> savingsProduct.periodType <> " gives you ZMW" <> totalRepayAmount <> "  "
                                        IO.inspect "#{totalRepayAmount}"
                                        IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"


                                        individualRoleType = "INDIVIDUAL"
                                        query = from au in Savings.Accounts.UserRole,
                                            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                            select: au
                                        appUserRoles = Repo.all(query)
                                        appUserRole = Enum.at(appUserRoles, 0)

                                        IO.inspect "Twst ........"
                                        IO.inspect savingsProduct.id
                                        totalCharges = 0.00

                                        totalCharge = 0.00


                                        query = from au in Savings.Accounts.Account,
                                            where: (au.userRoleId == type(^appUserRole.id, :integer)),
                                            select: au
                                        accounts = Repo.all(query)
                                        account = Enum.at(accounts, 0)
                                        accountId = account.id

                                        accruedInterest= 0.00
                                        clientId = 1
                                        currency= "ZMW"
                                        currencyDecimals = 2
                                        currencyId= 1

                                                IO.inspect "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
                                                IO.inspect savingsProduct.defaultPeriod

                                        endDate = case savingsProduct.periodType do
                                            "Days" ->
                                                endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod), :second) |> DateTime.truncate(:second)
                                                endDate
                                            "Months" ->
                                                endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod*30), :second) |> DateTime.truncate(:second)
                                                endDate
                                            "Years" ->
                                                endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod*savingsProduct.yearLengthInDays), :second) |> DateTime.truncate(:second)
                                                endDate
                                        end


                                        expectedInterest= Float.ceil((totalRepayments), 2)
                                        fixedPeriod= savingsProduct.defaultPeriod
                                        fixedPeriodType= savingsProduct.periodType
                                        interestRate= savingsProduct.interest
                                        interestRateType= savingsProduct.interestType
                                        productInterestMode= "FLAT"
                                        isDivested= false
                                        isMatured= false
                                        principalAmount= amount
                                        productId= 1
                                        startDate= DateTime.utc_now |> DateTime.truncate(:second)
                                        totalAmountPaidOut= 0.00
                                        totalDepositCharge= totalCharge
                                        totalPenalties= 0.00
                                        totalWithdrawalCharge= 0.00
                                        userId= appUser.id
                                        userRoleId= appUserRole.id
                                        yearLengthInDays= savingsProduct.yearLengthInDays
                                        fixedDepositStatus = "ACTIVE"
                                        userId= appUser.id
                                        query = from au in Savings.Client.UserBioData,
                                            where: (au.userId == type(^userId, :integer)),
                                            select: au
                                        userBioData = Repo.one(query)

                                        fixedDeposit = %Savings.FixedDeposit.FixedDeposits{
                                            accountId: accountId,
                                            accruedInterest: accruedInterest,
                                            clientId: clientId,
                                            currency: currency,
                                            currencyDecimals: currencyDecimals,
                                            currencyId: currencyDecimals,
                                            endDate: endDate,
                                            expectedInterest: expectedInterest,
                                            fixedPeriod: fixedPeriod,
                                            fixedPeriodType: fixedPeriodType,
                                            interestRate: interestRate,
                                            interestRateType: interestRateType,
                                            isDivested: isDivested,
                                            isMatured: isMatured,
                                            principalAmount: Float.ceil((principalAmount), 2),
                                            productId: productId,
                                            startDate: startDate,
                                            totalAmountPaidOut: totalAmountPaidOut,
                                            totalDepositCharge: totalDepositCharge,
                                            totalPenalties: totalPenalties,
                                            totalWithdrawalCharge: totalWithdrawalCharge,
                                            userId: userId,
                                            userRoleId: userRoleId,
                                            yearLengthInDays: yearLengthInDays,
                                            productInterestMode: productInterestMode,
                                            fixedDepositStatus: fixedDepositStatus,
                                            customerName: "#{userBioData.firstName} #{userBioData.lastName}"
                                        }
                                        fixedDeposit = Repo.insert!(fixedDeposit)


                                        carriedOutByUserId= userId
                                        carriedOutByUserRoleId= userRoleId
                                        isReversed= false
                                        orderRef= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                        orderRef = "ZIPAKE#{orderRef}"
                                        productId= savingsProduct.id
                                        productType= "SAVINGS"
                                        referenceNo= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                        requestData= nil
                                        responseData= nil
                                        status= "SUCCESS"
                                        totalAmount= amount
                                        transactionType= "CR"
                                        productCurrency= "ZMW"


                                        currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
                                        transactionDetail = "Deposit Payment for Fixed Deposit"
                                        transaction = %Savings.Transactions.Transaction{
                                            accountId: accountId,
                                            carriedOutByUserId: carriedOutByUserId,
                                            carriedOutByUserRoleId: carriedOutByUserRoleId,
                                            isReversed: isReversed,
                                            orderRef: orderRef,
                                            productId: productId,
                                            productType: productType,
                                            referenceNo: referenceNo,
                                            requestData: requestData,
                                            responseData: responseData,
                                            status: status,
                                            totalAmount: totalAmount,
                                            transactionType: transactionType,
                                            userId: userId,
                                            userRoleId: userRoleId,
                                            transactionDetail: transactionDetail,
                                            newTotalBalance: (currentBalance),
                                            transactionTypeEnum: "DEPOSIT",
                                            customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                            currencyDecimals: 2,
                                            currency: "ZMW"
                                        }
                                        transaction = Repo.insert!(transaction)



                                        fixedDepositTransaction = %Savings.FixedDeposit.FixedDepositTransaction{
                                            clientId: 1,
                                            fixedDepositId: fixedDeposit.id,
                                            amountDeposited: principalAmount,
                                            transactionId: transaction.id,
                                            userId: userId,
                                            userRoleId: userRoleId,
                                            status: "SUCCESS"
                                        }
                                        fixedDepositTransaction = Repo.insert!(fixedDepositTransaction)


                                        query = from au in Savings.Accounts.Account,
                                            where: (au.userId == type(^userId, :integer) and au.userRoleId == type(^userRoleId, :integer)),
                                            select: au
                                        userAccounts = Repo.all(query)
                                        acc = Enum.at(userAccounts, 0)
                                        #acc = Repo.get!(Savings.Accounts.Account, fixedDeposit.id)

                                        acct = Savings.Accounts.Account.changesetForUpdate(acc,
                                        %{
                                            accountNo: acc.accountNo,
                                            accountType: acc.accountType,
                                            accountVersion: acc.accountVersion,
                                            clientId: acc.clientId,
                                            currencyDecimals: acc.currencyDecimals,
                                            currencyId: acc.currencyId,
                                            currencyName: acc.currencyName,
                                            status: acc.status,
                                            totalCharges: acc.totalCharges,
                                            totalDeposits: (acc.totalDeposits + principalAmount),
                                            totalInterestEarned: acc.totalInterestEarned,
                                            totalInterestPosted: acc.totalInterestPosted,
                                            totalPenalties: acc.totalPenalties,
                                            totalTax: acc.totalTax,
                                            totalWithdrawals: (acc.totalWithdrawals - principalAmount),
                                            userId: acc.userId,
                                            userRoleId: acc.userRoleId,
                                            DateClosed: nil,
                                            accountOfficerUserId: acc.accountOfficerId,
                                            blockedByUserId: acc.blockedByUserId,
                                            blockedReason: acc.blockedReason,
                                            deactivatedReason: acc.deactivatedReason,
                                            derivedAccountBalance: acc.derivedAccountBalance,
                                            externalId: acc.externalId
                                        })

                                        Repo.update!(acct)



                                        isWithdrawn =
                                        if ((fd.principalAmount + fd.accruedInterest - (fd.totalAmountPaidOut + principalAmount))>0) do
                                            isWithdrawn = false
                                        else
                                            isWithdrawn = true
                                        end


                                        cs = Savings.FixedDeposit.FixedDeposits.changeset(fd,
                                            %{
                                                accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
                                                interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: fd.accruedInterest,
                                                isMatured: fd.isMatured, isDivested: fd.isDivested, divestmentPackageId: fd.divestmentPackageId, currencyId: fd.currencyId,
                                                currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
                                                totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
                                                totalAmountPaidOut: (fd.totalAmountPaidOut + principalAmount), startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId, divestmentId: fd.divestmentId,
                                                productInterestMode: fd.productInterestMode, branchId: fd.branchId,
                                                divestedInterestRate: fd.divestedInterestRate, divestedInterestRateType: fd.fixedPeriodType,
                                                amountDivested: fd.amountDivested, divestedInterestAmount: fd.divestedInterestAmount, divestedPeriod: fd.divestedPeriod,
                                                fixedDepositStatus: fd.fixedDepositStatus, lastEndOfDayDate: fd.lastEndOfDayDate, isWithdrawn: isWithdrawn
                                            })
                                        Repo.update!(cs)


                                        tempTotalAmount = Float.ceil(totalAmount, 2)
                                        tempTotalAmount = :erlang.float_to_binary((tempTotalAmount), [{:decimals, 2}])
                                        #tempTotalAmount = Float.to_string(tempTotalAmount)


                                        exInt = Float.ceil(fixedDeposit.expectedInterest, 2)
                                        exInt = :erlang.float_to_binary((exInt), [{:decimals, 2}])



                                        firstName = userBioData.firstName


                                        naive_datetime = Timex.now
                                        sms = %{
                                            mobile: appUser.username,
                                            msg: "Dear #{firstName},\nYour deposit of #{productCurrency}" <> tempTotalAmount <> " has been recorded successfully. Your deposit will been fixed for a period of #{fixedDeposit.fixedPeriod} #{fixedDeposit.fixedPeriodType} yielding you an interest of #{productCurrency}" <> exInt <> "\nOrder Ref: #{orderRef}",
                                            status: "READY",
                                            type: "SMS",
                                            msg_count: "1",
                                            date_sent: naive_datetime
                                        }
                                        Sms.changeset(%Sms{}, sms)
                                        |> Repo.insert()


                                        text = "Your deposit of #{productCurrency}" <> tempTotalAmount <> " has been posted. Your deposit has been fixed for a period of #{fixedDeposit.fixedPeriod} #{fixedDeposit.fixedPeriodType} yielding you an interest of #{productCurrency}" <> exInt <> "\nOrder Ref: #{orderRef}.\nPress \n\nb. Back \n0. End"
                                        #  response = %{
                                        #        Message: text,
                                        #        ClientState: 2,
                                        #        Type: "Response",
                                        #        key: "CON"
                                        #     }
                                        response = text
                                        send_response(conn, response)

                                    else
                                        text = "The amount you provided to reinvest is more than what you currently have. Please enter a valid amount. Press \n\nb. Back"
                                        # response = %{
                                        #     Message: text,
                                        #     ClientState: 2,
                                        #     Type: "Response",
                                        #     key: "CON"
                                        #  }
                                        response = text
                                        send_response(conn, response)
                                    end



                                else
                                    text = "Invalid selection.Press \n\nb. Back"
                                    response = text
                                    send_response(conn, response)
                                end
                            _ ->
                                response = "Invalid selection. Press \n\nb. Back"
                                send_response(conn, response)
                        end

                    7 ->

                        IO.inspect "########################"
                        IO.inspect checkMenu
                        parentIndex = Enum.at(checkMenu, 3)
                        case parentIndex do

                        "2" ->

                            #For Partial Withdrawal
                            keyEntered = Enum.at(checkMenu, 5)
                            if keyEntered=="1" do

                                selectedIndex = Enum.at(checkMenu, 2)
                                selectedIndex = elem Integer.parse(selectedIndex), 0
                                query = from au in User,
                                    where: (au.username == type(^mobile_number, :string)),
                                    select: au
                                appUsers = Repo.all(query)
                                appUser = Enum.at(appUsers, 0)

                                individualRoleType = "INDIVIDUAL"

                                query = from au in Savings.Accounts.UserRole,
                                    where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                    select: au
                                userRoles = Repo.all(query)
                                userRole = Enum.at(userRoles, 0)
                                userRoleId = userRole.id

                                status = "Disbursed"
                                isMatured = true
                                isWithdrawn = false
                                query = from au in Savings.FixedDeposit.FixedDeposits,
                                    where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                                    order_by: [desc: :id],
                                    select: au
                                fixedDeposits = Repo.all(query)
                                fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))

                                productId = fixedDeposit.productId
                                query = from au in Savings.Products.Product,
                                    where: (au.id == type(^productId, :integer)) ,
                                    select: au
                                savingsProducts = Repo.all(query)
                                savingsProduct = Enum.at(savingsProducts, 0)

                                amount = Enum.at(checkMenu, 4)
                                amount = elem Float.parse(amount), 0
                                IO.inspect "<<<<<<"
                                IO.inspect amount

                                totalRepayAmount = Float.ceil((fixedDeposit.principalAmount + fixedDeposit.accruedInterest), fixedDeposit.currencyDecimals)
                                totalRepayAmount = :erlang.float_to_binary((totalRepayAmount), [{:decimals, fixedDeposit.currencyDecimals}])
                                IO.inspect "#{totalRepayAmount}"
                                IO.inspect "new valuation... #{totalRepayAmount}"

                                reinvestPeriod = fixedDeposit.fixedPeriod
                                balance = ((fixedDeposit.principalAmount + fixedDeposit.accruedInterest) - amount)
                                reinvestCurrency = savingsProduct.currencyId

                                query = from au in Savings.Accounts.Account,
                                    where: (au.userRoleId == type(^userRole.id, :integer)),
                                    select: au
                                accounts = Repo.all(query)
                                account = Enum.at(accounts, 0)
                                accountId = account.id

                                userId = appUser.id


                                carriedOutByUserId = userId
                                carriedOutByUserRoleId = userRoleId
                                isReversed = false
                                orderRef = Integer.to_string(Enum.random(1_000000000..9_999999999))
                                orderRef = "ZIPAKE#{orderRef}"
                                withdrawalRef = orderRef
                                productId = savingsProduct.id
                                productType = "SAVINGS"
                                requestData = nil
                                responseData = nil
                                status = "SUCCESS"
                                totalAmount = amount
                                transactionType = "DR"
                                productCurrency = savingsProduct.currencyName

                                query = from au in Savings.Client.UserBioData,
                                    where: (au.userId == type(^appUser.id, :integer)),
                                    select: au
                                userBioData = Repo.one(query)



                                amtWithdrawnAndSentToAirtel = Decimal.round(Decimal.from_float(totalAmount), fixedDeposit.currencyDecimals)

                                IO.inspect "CHECKER 1"
                                idLen1 = String.length("#{fixedDeposit.id}")
                                fixedDepositNumber1 = String.pad_leading("#{fixedDeposit.id}", (6 - idLen1), "0")

                                referenceNo = orderRef
                                mobileNumberTruncated = String.slice(mobile_number, 3..11)
                                logUssdRequest(appUser.id, "DIVEST FIXED DEPOSIT", nil, "SUCCESS", mobile_number, "Divested fixed deposit - ##{fixedDepositNumber1} | #{fixedDeposit.currency}#{amtWithdrawnAndSentToAirtel}")

                                params = %{
                                    airtel_mobile: mobileNumberTruncated,
                                    enterdAmount: amtWithdrawnAndSentToAirtel,
                                    referenceNo: referenceNo,
                                    orderRef: orderRef
                                }

                                custPush = Savings.Service.Momo.AirtelServices.customer_disbursment(params)
                                statusCode = custPush.status_code

                                IO.inspect "uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu"
                                IO.inspect amtWithdrawnAndSentToAirtel
                                IO.inspect custPush
                                case statusCode do

                                    200 ->

                                        body =  Jason.decode!(custPush.body)
                                        airtelCode = body["status"]["code"]
                                        airtelAtatus = body["status"]["success"]

                                        case airtelCode do

                                            "200" ->

                                                case airtelAtatus do

                                                    true ->

                                                        currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
                                                        transactionDetail = "Withdrawal on Fixed Deposit Maturity"

                                                        transaction = %Savings.Transactions.Transaction{
                                                            accountId: accountId,
                                                            carriedOutByUserId: carriedOutByUserId,
                                                            carriedOutByUserRoleId: carriedOutByUserRoleId,
                                                            isReversed: isReversed,
                                                            orderRef: orderRef,
                                                            productId: productId,
                                                            productType: productType,
                                                            referenceNo: referenceNo,
                                                            requestData: requestData,
                                                            responseData: responseData,
                                                            status: status,
                                                            totalAmount: totalAmount,
                                                            transactionType: transactionType,
                                                            userId: userId,
                                                            userRoleId: userRoleId,
                                                            transactionDetail: transactionDetail,
                                                            transactionTypeEnum: "Withdrawal",
                                                            newTotalBalance: (totalAmount - currentBalance),
                                                            customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                                            currency: productCurrency,
                                                            currencyDecimals: 2
                                                        }
                                                        transaction = Repo.insert!(transaction)

                                                        maturedWithdrawals = %Savings.Withdrawals.MaturedWithdrawal{
                                                            clientId: 1,
                                                            amount: amount,
                                                            fixedDepositId: fixedDeposit.id,
                                                            fixedPeriod: fixedDeposit.fixedPeriod,
                                                            interestRate: fixedDeposit.interestRate,
                                                            interestRateType: fixedDeposit.interestRateType,
                                                            principalAmount: fixedDeposit.principalAmount,
                                                            interestAccrued: fixedDeposit.accruedInterest,
                                                            userId: userId,
                                                            userRoleId: userRoleId,
                                                            transactionId: transaction.id
                                                        }
                                                        maturedWithdrawals = Repo.insert!(maturedWithdrawals)

                                                        fd = Repo.get!(Savings.FixedDeposit.FixedDeposits, fixedDeposit.id)
                                                        cs = Savings.FixedDeposit.FixedDeposits.changeset(fd,

                                                            %{
                                                                accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
                                                                interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: fd.accruedInterest,
                                                                isMatured: fd.isMatured, isDivested: fd.isDivested, divestmentPackageId: fd.divestmentPackageId, currencyId: fd.currencyId,
                                                                currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
                                                                totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
                                                                totalAmountPaidOut: fixedDeposit.totalAmountPaidOut + amount, startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId, divestmentId: fd.divestmentId,
                                                                productInterestMode: fd.productInterestMode, branchId: fd.branchId,
                                                                divestedInterestRate: fd.divestedInterestRate, divestedInterestRateType: fd.divestedInterestRateType,
                                                                amountDivested: fd.amountDivested, divestedInterestAmount: fd.divestedInterestAmount, divestedPeriod: fd.divestedPeriod, isWithdrawn: false
                                                            })
                                                        Repo.update!(cs)

                                                        ############################################################################################################################
                                                        status = String.downcase(status, :default)

                                                        customerPayout = %Savings.CustomerPayouts.CustomerPayout{
                                                            amount: totalAmount,
                                                            fixedDepositId: fixedDeposit.id,
                                                            orderRef: orderRef,
                                                            payoutRequest: nil,
                                                            payoutResponse: nil,
                                                            payoutType: "WITHDRAWAL",
                                                            status: status,
                                                            transactionDate: Date.utc_today,
                                                            transactionId: transaction.id,
                                                            userId: appUser.id
                                                        }
                                                        customerPayout = Repo.insert!(customerPayout)
                                                        logUssdRequest(appUser.id, "TRANSFER TO CUSTOMER", nil, "SUCCESS", mobile_number, "Transfer Divestment Sent - #{userBioData.firstName} #{userBioData.lastName} | ##{fixedDepositNumber1} | #{fixedDeposit.currency}#{(amtWithdrawnAndSentToAirtel)}")
                                                        ############################################################################################################################


                                                        # if balance>0 do

                                                        #     # query = from au in Savings.Products.Product,
                                                        #     #     where: (au.minimumPrincipal <= type(^balance, :float) and au.status == "ACTIVE" and au.maximumPrincipal >= type(^balance, :float) and au.defaultPeriod == type(^reinvestPeriod, :integer) and au.currencyId == type(^reinvestCurrency, :integer)) ,
                                                        #     #     select: au

                                                        #     query = from au in Savings.Products.ProductsPeriod,
                                                        #         where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod),
                                                        #         select: au
                                                        #     reinvestSavingsProducts = Repo.all(query)

                                                        #     reinvestSavingsProducts = Repo.all(query)
                                                        #     reinvestSavingsProduct = Enum.at(reinvestSavingsProducts, 0)

                                                        #     reinvestValuationCurrency = "ZMW"
                                                        #     reinvestPeriod = reinvestSavingsProduct.defaultPeriod
                                                        #     reinvestPeriodType = reinvestSavingsProduct.periodType

                                                        #     reinvestValuation = calculate_maturity_repayments(balance, reinvestPeriod, reinvestSavingsProduct.interest)
                                                        #     reinvestValuation = Float.ceil(reinvestValuation, 2)


                                                        #     carriedOutByUserId= userId
                                                        #     carriedOutByUserRoleId= userRoleId
                                                        #     isReversed= false
                                                        #     orderRef= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                                        #     orderRef = "ZIPAKE#{orderRef}"
                                                        #     productId= reinvestSavingsProduct.id
                                                        #     productType= "SAVINGS"
                                                        #     referenceNo = Integer.to_string(Enum.random(1_000000000..9_999999999))
                                                        #     requestData= nil
                                                        #     responseData= nil
                                                        #     status= "SUCCESS"
                                                        #     totalAmount= balance
                                                        #     transactionType= "CR"
                                                        #     productCurrency= "ZMW"

                                                        #     transactionDetail = "Fixed Deposit on Balance"
                                                        #     currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)

                                                        #     transaction = %Savings.Transactions.Transaction{
                                                        #         accountId: accountId,
                                                        #         carriedOutByUserId: carriedOutByUserId,
                                                        #         carriedOutByUserRoleId: carriedOutByUserRoleId,
                                                        #         isReversed: isReversed,
                                                        #         orderRef: orderRef,
                                                        #         productId: productId,
                                                        #         productType: productType,
                                                        #         referenceNo: referenceNo,
                                                        #         requestData: requestData,
                                                        #         responseData: responseData,
                                                        #         status: status,
                                                        #         totalAmount: totalAmount,
                                                        #         transactionType: transactionType,
                                                        #         userId: userId,
                                                        #         userRoleId: userRoleId,
                                                        #         transactionDetail: transactionDetail,
                                                        #         newTotalBalance: (currentBalance + totalAmount),
                                                        #         transactionTypeEnum: "Deposit",
                                                        #         customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                                        #         currencyDecimals: 2,
                                                        #         currency: "ZMW"
                                                        #     }
                                                        #     transaction = Repo.insert!(transaction)


                                                        #     expectedInterest= Float.ceil((reinvestValuation), 2)
                                                        #     fixedPeriod= reinvestSavingsProduct.defaultPeriod
                                                        #     fixedPeriodType= reinvestSavingsProduct.periodType
                                                        #     interestRate= reinvestSavingsProduct.interest
                                                        #     interestRateType= reinvestSavingsProduct.interestType
                                                        #     isDivested= false
                                                        #     isMatured= false
                                                        #     isWithdrawn = false
                                                        #     principalAmount = balance
                                                        #     productId = 1
                                                        #     startDate = fd.startDate
                                                        #     totalAmountPaidOut= 0.00
                                                        #     totalDepositCharge= 0.00
                                                        #     totalPenalties= 0.00
                                                        #     totalWithdrawalCharge= 0.00
                                                        #     yearLengthInDays= reinvestSavingsProduct.yearLengthInDays
                                                        #     accruedInterest = 0.00
                                                        #     currencyId = 1
                                                        #     currencyDecimals = 2
                                                        #     currency = "ZMW"
                                                        #     endDate = fd.endDate
                                                        #     fixedDepositStatus = "ACTIVE"


                                                        #     fixedDeposit = %Savings.FixedDeposit.FixedDeposits{
                                                        #         accountId: accountId,
                                                        #         accruedInterest: accruedInterest,
                                                        #         clientId: 1,
                                                        #         currency: currency,
                                                        #         currencyDecimals: currencyDecimals,
                                                        #         currencyId: currencyDecimals,
                                                        #         endDate: endDate,
                                                        #         expectedInterest: expectedInterest,
                                                        #         fixedPeriod: fixedPeriod,
                                                        #         fixedPeriodType: fixedPeriodType,
                                                        #         interestRate: interestRate,
                                                        #         interestRateType: interestRateType,
                                                        #         isDivested: isDivested,
                                                        #         isMatured: isMatured,
                                                        #         isWithdrawn: isWithdrawn,
                                                        #         principalAmount: Float.ceil((principalAmount), 2),
                                                        #         productId: productId,
                                                        #         startDate: startDate,
                                                        #         totalAmountPaidOut: totalAmountPaidOut,
                                                        #         totalDepositCharge: totalDepositCharge,
                                                        #         totalPenalties: totalPenalties,
                                                        #         totalWithdrawalCharge: totalWithdrawalCharge,
                                                        #         userId: userId,
                                                        #         userRoleId: userRoleId,
                                                        #         yearLengthInDays: yearLengthInDays,
                                                        #         fixedDepositStatus: fixedDepositStatus,
                                                        #         customerName: "#{userBioData.firstName} #{userBioData.lastName}"
                                                        #     }
                                                        #     fixedDeposit = Repo.insert!(fixedDeposit)

                                                        #     fixedDepositTransaction = %Savings.FixedDeposit.FixedDepositTransaction{
                                                        #         clientId: 1,
                                                        #         fixedDepositId: fixedDeposit.id,
                                                        #         amountDeposited: principalAmount,
                                                        #         transactionId: transaction.id,
                                                        #         userId: userId,
                                                        #         userRoleId: userRoleId,
                                                        #         status: "SUCCESS"
                                                        #     }
                                                        #     fixedDepositTransaction = Repo.insert!(fixedDepositTransaction)

                                                        #     amountStr = :erlang.float_to_binary((amount), [{:decimals, 2}])
                                                        #     balance = :erlang.float_to_binary((balance), [{:decimals, 2}])
                                                        #     msg = "The sum of #{fixedDeposit.currency}#{amountStr} has been paid into your Airtel mobile money account.\n\nThe balance of #{reinvestValuationCurrency}#{balance} has also been fixed for #{reinvestPeriod}  #{reinvestPeriodType} to yield you #{reinvestValuationCurrency}#{reinvestValuation}\n\nb. Back"

                                                        #     query = from au in Savings.Client.UserBioData,
                                                        #         where: (au.userId == type(^userId, :integer)),
                                                        #         select: au
                                                        #     userBioData = Repo.one(query)
                                                        #     firstName = userBioData.firstName

                                                        #     naive_datetime = Timex.now
                                                        #     sms = %{
                                                        #         mobile: appUser.username,
                                                        #         msg: "Dear #{firstName},\nYour withdrawal of ZMW#{amountStr} was paid into your Airtel mobile money account.\nOrder Ref: #{withdrawalRef}",
                                                        #         status: "READY",
                                                        #         type: "SMS",
                                                        #         msg_count: "1",
                                                        #         date_sent: naive_datetime
                                                        #     }
                                                        #     Sms.changeset(%Sms{}, sms)
                                                        #     |> Repo.insert()

                                                        #     naive_datetime = Timex.now
                                                        #     sms = %{
                                                        #         mobile: appUser.username,
                                                        #         msg: "Dear #{firstName},\nThe balance of #{reinvestValuationCurrency}#{balance} has been fixed for #{reinvestPeriod}  #{reinvestPeriodType} to yield you #{reinvestValuationCurrency}#{reinvestValuation}.\nOrder Ref: #{orderRef}",
                                                        #         status: "READY",
                                                        #         type: "SMS",
                                                        #         msg_count: "1",
                                                        #         date_sent: naive_datetime
                                                        #     }
                                                        #     Sms.changeset(%Sms{}, sms)
                                                        #     |> Repo.insert()

                                                        #     # response = %{
                                                        #     #    Message: msg,
                                                        #     #    ClientState: 2,
                                                        #     #    Type: "Response",
                                                        #     #    key: "CON"
                                                        #     # }
                                                        #     response = msg
                                                        #     send_response(conn, response)

                                                        # else

                                                            newValuation = :erlang.float_to_binary((amount), [{:decimals, 2}])
                                                            msg = "The sum of ZMW#{newValuation} has been paid into your mobile money account. Thanks\n\n\nb. Back"
                                                            #response = %{
                                                            #    Message: msg,
                                                            #    ClientState: 2,
                                                            #    Type: "Response",
                                                            #    key: "CON"
                                                            #}

                                                            query = from au in Savings.Client.UserBioData,
                                                                where: (au.userId == type(^userId, :integer)),
                                                                select: au
                                                            userBioData = Repo.one(query)
                                                            firstName = userBioData.firstName

                                                            naive_datetime = Timex.now
                                                            sms = %{
                                                                mobile: appUser.username,
                                                                msg: "Dear #{firstName}, Your withdrawal of ZMW#{newValuation} was paid into your Airtel mobile money account.\nOrder Ref: #{withdrawalRef}",
                                                                status: "READY",
                                                                type: "SMS",
                                                                msg_count: "1",
                                                                date_sent: naive_datetime
                                                            }
                                                            Sms.changeset(%Sms{}, sms)
                                                            |> Repo.insert()

                                                            response = msg
                                                            send_response(conn, response)

                                                        # end

                                                    _->

                                                        status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                                        IO.inspect status
                                                        response = "Your withdraw was not successful. Please try again"
                                                        send_response(conn, response)
                                                end
                                            _->

                                                status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                                IO.inspect status
                                                response = "Your withdraw was not successful. Please try again"
                                                send_response(conn, response)
                                        end
                                    _->

                                        status = "KILLEERSSSSSSSSSS++++++++++++++++++++++++++++++++++++++++++++++++++SSSSSSSSSSSSSSSSSSSSS"
                                        IO.inspect status
                                        response = "Your withdraw was not successful. Please try again"
                                        send_response(conn, response)
                                end
                            else

                                #response = %{
                                #    Message: "Invalid selection.. Press\n\nb. Back",
                                #    ClientState: 1,
                                #    Type: "Response",
                                #    key: "BA3"
                                #}

                                response = "Invalid selection.. Press\n\nb. Back"
                                send_response(conn, response)

                            end

                        "3" ->

                            isMatured = true
                            isWithdrawn = false

                            query = from au in Savings.FixedDeposit.FixedDeposits,
                                where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
                                order_by: [desc: :id],
                                select: au
                            fixedDeposits = Repo.all(query)

                            totalBalance = 0.00

                                IO.inspect "=========="
                                IO.inspect Enum.count(fixedDeposits)

                           if (Enum.count(fixedDeposits)>0) do

                                selectedFdIndex = Enum.at(checkMenu, 2)
                                IO.inspect selectedFdIndex
                                selectedFdIndex = elem Integer.parse(selectedFdIndex), 0

                                fixedDeposit = Enum.at(fixedDeposits, (selectedFdIndex-1))

                                fd = Repo.get!(Savings.FixedDeposit.FixedDeposits, fixedDeposit.id)
                                totalDueAtMaturity = fd.principalAmount + fd.accruedInterest - fd.totalAmountPaidOut
                                amount = Enum.at(checkMenu, 4)
                                amount = elem Float.parse(amount), 0

                                if(amount > 0 && amount < totalDueAtMaturity) do

                                    IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                    selectedIndex = Enum.at(checkMenu, 3)
                                    IO.inspect "selectedIndex..."
                                    IO.inspect selectedIndex

                                    selectedIndex = elem Integer.parse(selectedIndex), 0
                                    IO.inspect selectedIndex

                                    query = from au in Savings.Products.ProductsPeriod,
                                        where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod) ,
                                        select: au
                                    savingsProduct = Repo.one(query)

                                    default_rate = savingsProduct.interest
                                    default_period = savingsProduct.defaultPeriod
                                    annual_period = savingsProduct.yearLengthInDays
                                    #amt = elem Integer.parse(amount), 0
                                    amt = amount

                                    totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
                                    IO.inspect "Test"
                                    IO.inspect ((totalRepayments))



                                    #totalRepayAmount = :erlang.float_to_binary((totalRepayments), [decimals= 2])
                                    totalRepayAmount = Float.ceil(totalRepayments, 2)
                                    #totalRepayAmount = :erlang.float_to_binary((totalRepayments), [{decimals, 2}])

                                    totalRepayAmount = Float.to_string(totalRepayAmount)
                                    IO.inspect "#{totalRepayAmount}"
                                    default_period = :erlang.integer_to_binary(default_period)

                                    repay_entry = default_period <> " " <> savingsProduct.periodType <> " gives you ZMW" <> totalRepayAmount <> "  "
                                    IO.inspect "#{totalRepayAmount}"
                                    IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"

                                    query = from au in Savings.Accounts.User,
                                        where: (au.username == type(^mobile_number, :string)),
                                        select: au
                                    appUsers = Repo.all(query)
                                    appUser = Enum.at(appUsers, 0)

                                    individualRoleType = "INDIVIDUAL"

                                    query = from au in Savings.Accounts.UserRole,
                                        where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
                                        select: au
                                    appUserRoles = Repo.all(query)
                                    appUserRole = Enum.at(appUserRoles, 0)

                                    IO.inspect "Twst ........"
                                    IO.inspect savingsProduct.id
                                    totalCharges = 0.00
                                    totalCharge = 0.00

                                    query = from au in Savings.Accounts.Account,
                                        where: (au.userRoleId == type(^appUserRole.id, :integer)),
                                        select: au
                                    accounts = Repo.all(query)
                                    account = Enum.at(accounts, 0)

                                    accountId = account.id

                                    accruedInterest= 0.00
                                    clientId = 1
                                    currency= "ZMW"
                                    currencyDecimals= 2
                                    currencyId= 1

                                    IO.inspect "%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
                                    IO.inspect savingsProduct.defaultPeriod



                                    endDate = case savingsProduct.periodType do

                                        "Days" ->
                                            endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod), :second) |> DateTime.truncate(:second)
                                            endDate

                                        "Months" ->
                                            endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod*30), :second) |> DateTime.truncate(:second)
                                            endDate

                                        "Years" ->
                                            endDate = DateTime.add(DateTime.utc_now, (24*60*60*savingsProduct.defaultPeriod*savingsProduct.yearLengthInDays), :second) |> DateTime.truncate(:second)
                                            endDate
                                    end


                                    expectedInterest= Float.ceil((totalRepayments), 2)
                                    fixedPeriod= savingsProduct.defaultPeriod
                                    fixedPeriodType= savingsProduct.periodType
                                    interestRate= savingsProduct.interest
                                    interestRateType= savingsProduct.interestType
                                    productInterestMode= "FLAT"
                                    isDivested= false
                                    isMatured= false
                                    principalAmount= amount
                                    productId= 1
                                    startDate= DateTime.utc_now |> DateTime.truncate(:second)
                                    totalAmountPaidOut= 0.00
                                    totalDepositCharge= totalCharge
                                    totalPenalties= 0.00
                                    totalWithdrawalCharge= 0.00
                                    userRoleId= appUserRole.id
                                    yearLengthInDays= savingsProduct.yearLengthInDays
                                    fixedDepositStatus = "ACTIVE"
                                    userId= appUser.id

                                    query = from au in Savings.Client.UserBioData,
                                        where: (au.userId == type(^userId, :integer)),
                                        select: au
                                    userBioData = Repo.one(query)

                                    fixedDeposit = %Savings.FixedDeposit.FixedDeposits{
                                        accountId: accountId,
                                        accruedInterest: accruedInterest,
                                        clientId: clientId,
                                        currency: currency,
                                        currencyDecimals: currencyDecimals,
                                        currencyId: currencyDecimals,
                                        endDate: endDate,
                                        expectedInterest: expectedInterest,
                                        fixedPeriod: fixedPeriod,
                                        fixedPeriodType: fixedPeriodType,
                                        interestRate: interestRate,
                                        interestRateType: interestRateType,
                                        isDivested: isDivested,
                                        isMatured: isMatured,
                                        principalAmount: principalAmount,
                                        productId: productId,
                                        startDate: startDate,
                                        totalAmountPaidOut: totalAmountPaidOut,
                                        totalDepositCharge: totalDepositCharge,
                                        totalPenalties: totalPenalties,
                                        totalWithdrawalCharge: totalWithdrawalCharge,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        yearLengthInDays: yearLengthInDays,
                                        productInterestMode: productInterestMode,
                                        fixedDepositStatus: fixedDepositStatus,
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}"
                                    }
                                    fixedDeposit = Repo.insert!(fixedDeposit)

                                    carriedOutByUserId= userId
                                    carriedOutByUserRoleId= userRoleId
                                    isReversed= false
                                    orderRef= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                    orderRef = "ZIPAKE#{orderRef}"
                                    productId= savingsProduct.id
                                    productType= "SAVINGS"
                                    referenceNo= Integer.to_string(Enum.random(1_000000000..9_999999999))
                                    requestData= nil
                                    responseData= nil
                                    status= "SUCCESS"
                                    totalAmount= amount
                                    transactionType= "CR"
                                    productCurrency= "ZMW"
                                    transactionTypeEnum = ""

                                    currentBalance = calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu)
                                    transactionDetail = "Deposit Payment for Fixed Deposit"

                                    transaction = %Savings.Transactions.Transaction{
                                        accountId: accountId,
                                        carriedOutByUserId: carriedOutByUserId,
                                        carriedOutByUserRoleId: carriedOutByUserRoleId,
                                        isReversed: isReversed,
                                        orderRef: orderRef,
                                        productId: productId,
                                        productType: productType,
                                        referenceNo: referenceNo,
                                        requestData: requestData,
                                        responseData: responseData,
                                        status: status,
                                        totalAmount: totalAmount,
                                        transactionType: transactionType,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        transactionDetail: transactionDetail,
                                        transactionTypeEnum: "DEPOSIT",
                                        newTotalBalance: (currentBalance),
                                        customerName: "#{userBioData.firstName} #{userBioData.lastName}",
                                        currencyDecimals: 2,
                                        currency: "ZMW"
                                    }
                                    transaction = Repo.insert!(transaction)

                                    fixedDepositTransaction = %Savings.FixedDeposit.FixedDepositTransaction{
                                        clientId: 1,
                                        fixedDepositId: fixedDeposit.id,
                                        amountDeposited: principalAmount,
                                        transactionId: transaction.id,
                                        userId: userId,
                                        userRoleId: userRoleId,
                                        status: "SUCCESS"
                                    }
                                    fixedDepositTransaction = Repo.insert!(fixedDepositTransaction)

                                    query = from au in Savings.Accounts.Account,
                                        where: (au.userId == type(^userId, :integer) and au.userRoleId == type(^userRoleId, :integer)),
                                        select: au
                                    userAccounts = Repo.all(query)

                                    acc = Enum.at(userAccounts, 0)
                                    #acc = Repo.get!(Savings.Accounts.Account, fixedDeposit.id)

                                    acct = Savings.Accounts.Account.changesetForUpdate(acc,
                                    %{
                                        accountNo: acc.accountNo,
                                        accountType: acc.accountType,
                                        accountVersion: acc.accountVersion,
                                        clientId: acc.clientId,
                                        currencyDecimals: acc.currencyDecimals,
                                        currencyId: acc.currencyId,
                                        currencyName: acc.currencyName,
                                        status: acc.status,
                                        totalCharges: acc.totalCharges,
                                        totalDeposits: (acc.totalDeposits + principalAmount),
                                        totalInterestEarned: acc.totalInterestEarned,
                                        totalInterestPosted: acc.totalInterestPosted,
                                        totalPenalties: acc.totalPenalties,
                                        totalTax: acc.totalTax,
                                        totalWithdrawals: (acc.totalWithdrawals - principalAmount),
                                        userId: acc.userId,
                                        userRoleId: acc.userRoleId,
                                        DateClosed: nil,
                                        accountOfficerUserId: acc.accountOfficerId,
                                        blockedByUserId: acc.blockedByUserId,
                                        blockedReason: acc.blockedReason,
                                        deactivatedReason: acc.deactivatedReason,
                                        derivedAccountBalance: acc.derivedAccountBalance,
                                        externalId: acc.externalId
                                    })
                                   Repo.update!(acct)

                                    isWithdrawn =
                                    if ((fd.principalAmount + fd.accruedInterest - (fd.totalAmountPaidOut + principalAmount))>0) do
                                        isWithdrawn = false
                                    else
                                        isWithdrawn = true
                                    end

                                    fdId = fd.id

                                    cs = Savings.FixedDeposit.FixedDeposits.changeset(fd,
                                        %{
                                            accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
                                            interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: fd.accruedInterest,
                                            isMatured: fd.isMatured, isDivested: fd.isDivested, divestmentPackageId: fd.divestmentPackageId, currencyId: fd.currencyId,
                                            currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
                                            totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
                                            totalAmountPaidOut: (fd.totalAmountPaidOut + principalAmount), startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId, divestmentId: fd.divestmentId,
                                            productInterestMode: fd.productInterestMode, branchId: fd.branchId,
                                            divestedInterestRate: fd.divestedInterestRate, divestedInterestRateType: fd.fixedPeriodType,
                                            amountDivested: fd.amountDivested, divestedInterestAmount: fd.divestedInterestAmount, divestedPeriod: fd.divestedPeriod,
                                            fixedDepositStatus: fd.fixedDepositStatus, lastEndOfDayDate: fd.lastEndOfDayDate, isWithdrawn: isWithdrawn
                                        })
                                    Repo.update!(cs)

                                    tempTotalAmount = Float.ceil(totalAmount, 2)
                                    tempTotalAmount = :erlang.float_to_binary((tempTotalAmount), [{:decimals, 2}])
                                    #tempTotalAmount = Float.to_string(tempTotalAmount)

                                    exInt = Float.ceil(fixedDeposit.expectedInterest, 2)
                                    exInt = :erlang.float_to_binary((exInt), [{:decimals, 2}])

                                    firstName = userBioData.firstName

                                    naive_datetime = Timex.now
                                    sms = %{
                                        mobile: appUser.username,
                                        msg: "Dear #{firstName},\nYour deposit of #{productCurrency}" <> tempTotalAmount <> " has been recorded successfully. On confirmation, your deposit will been fixed for a period of #{fixedDeposit.fixedPeriod} #{fixedDeposit.fixedPeriodType} yielding you an interest of #{productCurrency}" <> exInt <> "\nOrder Ref: #{orderRef}",
                                        status: "READY",
                                        type: "SMS",
                                        msg_count: "1",
                                        date_sent: naive_datetime
                                    }
                                    Sms.changeset(%Sms{}, sms)
                                    |> Repo.insert()

                                    text = "Your deposit of #{productCurrency}" <> tempTotalAmount <> " has been posted. Your deposit has been fixed for a period of #{fixedDeposit.fixedPeriod} #{fixedDeposit.fixedPeriodType} yielding you an interest of #{productCurrency}" <> totalRepayAmount <> "\nOrder Ref: #{orderRef}.\nPress \n\nb. Back"
                                    # response = %{
                                    #     Message: text,
                                    #     ClientState: 2,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    # }
                                    response = text
                                    send_response(conn, response)

                               else
                                    text = "The amount you provided to reinvest is more than what you currently have. Please enter a valid amount. Press \n\nb. Back"

                                    # response = %{
                                    #     Message: text,
                                    #     ClientState: 2,
                                    #     Type: "Response",
                                    #     key: "CON"
                                    # }
                                    response = text
                                    send_response(conn, response)
                                end

                            else

                                text = "Invalid selection.Press \n\nb. Back"
                                response = text
                                send_response(conn, response)

                            end

                    end
                end
        end
    end

    def handleReinvestSomeMaturedFunds(conn, mobile_number, cmd, text, checkMenu, appUser) do
        checkMenuLength = Enum.count(checkMenu)
        defaultCurrency = 1
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        if valueEntered == "b" do
            #response = %{
            #    Message: "BA3",
            #    ClientState: 1,
            #    Type: "Response",
            #    key: "BA3"
            #}

            response = "BA3"
            send_response(conn, response)
        else
            case checkMenuLength do
                5 ->
                    # response = %{
                    #     Message: "Enter how much you are reinvesting?",
                    #     ClientState: 2,
                    #     Type: "Response",
                    #     key: "CON"
                    # }
                    response = "Enter how much you are reinvesting?"
                    send_response(conn, response)
            end
        end
    end




    def handleReinvestAllMaturedFunds(conn, mobile_number, cmd, text, checkMenu, appUser) do
        selectedIndex = Enum.at(checkMenu, 2)
        selectedIndex = elem Integer.parse(selectedIndex), 0
        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)

        individualRoleType = "INDIVIDUAL"
        query = from au in Savings.Accounts.UserRole,
            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
            select: au
        userRoles = Repo.all(query)
        userRole = Enum.at(userRoles, 0)


        status = "Disbursed"
        isMatured = true
        isWithdrawn = false
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isWithdrawn == type(^isWithdrawn, :boolean) and au.userId == type(^appUser.id, :integer)),
            order_by: [desc: :id],
            select: au
        fixedDeposits = Repo.all(query)
        fixedDeposit = Enum.at(fixedDeposits, (selectedIndex-1))

        productId = fixedDeposit.productId

        query = from au in Savings.Products.ProductsPeriod,
            where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod) ,
            select: au
        savingsProducts = Repo.all(query)
        savingsProduct = Enum.at(savingsProducts, 0)


        amount = fixedDeposit.principalAmount + fixedDeposit.accruedInterest - fixedDeposit.totalAmountPaidOut
        IO.inspect "<<<<<<"
        IO.inspect amount



        newValuation = :erlang.float_to_binary((fixedDeposit.principalAmount + fixedDeposit.accruedInterest), [{:decimals, 2}])
        amountStr = :erlang.float_to_binary((amount), [{:decimals, 2}])

        IO.inspect "#{newValuation}"
        IO.inspect "new valuation... #{newValuation}"


        reinvestPeriod = fixedDeposit.fixedPeriod
        balance = amount
        reinvestCurrency = 1
        reinvestCurrencyName = "ZMW"

        if balance>0 do
            query = from au in Savings.Products.ProductsPeriod,
                where: (au.status == "ACTIVE" and au.defaultPeriod == ^fixedDeposit.fixedPeriod) ,
                select: au
            reinvestSavingsProduct = Repo.one(query)

            reinvestValuationCurrency = "ZMW"
            reinvestPeriod = reinvestSavingsProduct.defaultPeriod
            reinvestPeriodType = reinvestSavingsProduct.periodType
            reinvestEndDate = case reinvestSavingsProduct.periodType do
                "Days" ->
                    endDate = DateTime.add(DateTime.utc_now, (24*60*60*reinvestSavingsProduct.defaultPeriod), :second) |> DateTime.truncate(:second)
                    endDate
                "Months" ->
                    endDate = DateTime.add(DateTime.utc_now, (24*60*60*reinvestSavingsProduct.defaultPeriod*30), :second) |> DateTime.truncate(:second)
                    endDate
                "Years" ->
                    endDate = DateTime.add(DateTime.utc_now, (24*60*60*reinvestSavingsProduct.defaultPeriod*reinvestSavingsProduct.yearLengthInDays), :second) |> DateTime.truncate(:second)
                    endDate
            end

            reinvestValuation = calculate_maturity_repayments(balance, reinvestPeriod, reinvestSavingsProduct.interest)
            reinvestValuation = Float.ceil(reinvestValuation, 2)
            reinvestValuation = :erlang.float_to_binary((reinvestValuation), [{:decimals, 2}])

            reinvestEndDate = String.slice("#{reinvestEndDate}", 0, 10)
            msg = "If you reinvest #{reinvestCurrencyName}#{amountStr}, we will give you #{reinvestValuationCurrency}#{reinvestValuation} on #{reinvestEndDate} \n\n1. Confirm\nb. Back"

            # response = %{
            #    Message: msg,
            #    ClientState: 2,
            #    Type: "Response",
            #    key: "CON"
            # }

            response = msg
            send_response(conn, response)
        else
            if balance<0 do
                msg = "Invalid amount. Please try again"
                msg = msg <> "\n\n1. Confirm\nb. Back"

                # response = %{
                #    Message: msg,
                #    ClientState: 2,
                #    Type: "Response",
                #    key: "CON"
                # }

                response = msg
                send_response(conn, response)
            else
                msg = "If you reinvest today you will receive #{fixedDeposit.currency}#{amountStr}"
                msg = msg <> "\n\n1. Confirm\nb. Back"

                # response = %{
                #    Message: msg,
                #    ClientState: 2,
                #    Type: "Response",
                #    key: "CON"
                # }

                response = msg
                send_response(conn, response)
            end
        end
    end

    def handleAutoRollovers(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        IO.inspect checkMenu

        if valueEntered == "b" do
            response = "BA3"
            send_response(conn, response)
        else
            case checkMenuLength do

                3 ->

                    text = "Select Option:\n\n1. View Auto Rollovers\n2. Set an Automatic Rollover\nb. Back"
                    # response = %{
                    #     Message: text,
                    #     ClientState: 2,
                    #     Type: "Response",
                    #     key: "BA3"
                    # }
                    response = text
                    send_response(conn, response)
                4 ->

                    valueEntered = Enum.at(checkMenu, (2))
                    IO.inspect (valueEntered)

                    case valueEntered do

                        "1" ->
                            IO.inspect ("displayAutoRollovers")
                            displayAutoRollovers(conn, mobile_number, cmd, text, checkMenu)
                        "2" ->
                            IO.inspect ("createNew")
                            createNewAutoRollover(conn, mobile_number, cmd, text, checkMenu)

                    end

                5 ->

                    valueEntered = Enum.at(checkMenu, (2))
                    IO.inspect (valueEntered)

                    case valueEntered do

                        "1" ->
                            IO.inspect ("deleteAutoRollover")
                            deleteAutoRollover(conn, mobile_number, cmd, text, checkMenu)

                        "2" ->
                            IO.inspect ("enterRolloverAmount")
                            enterRolloverAmount(conn, mobile_number, cmd, text, checkMenu)

                    end
                6 ->
                    valueEntered = Enum.at(checkMenu, (2))
                    IO.inspect (valueEntered)

                    case valueEntered do
                        "2" ->
                            IO.inspect ("enterRolloverAmount")
                            applyRolloverAmount(conn, mobile_number, cmd, text, checkMenu)

                    end
                end
        end
    end

    def displayAutoRollovers(conn, mobile_number, cmd, text, checkMenu) do
        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)


        isMatured = false
        isDivested = false
        status = "ACTIVE"
        autoCreditOnMaturityDone = false
        autoCreditOnMaturity = true
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.autoCreditOnMaturity == type(^autoCreditOnMaturity, :boolean)
                and au.autoCreditOnMaturityDone == type(^autoCreditOnMaturityDone, :boolean) and au.fixedDepositStatus == type(^status, :string) and au.userId == type(^appUser.id, :integer)),
            select: au
        fixedDeposits = Repo.all(query)

            IO.inspect "=========="
            IO.inspect Enum.count(fixedDeposits)

        if Enum.count(fixedDeposits)>0 do

            #acc = Enum.reduce(fixedDeposits, fn x,
            #    acc -> x.id * acc
            #end)

            if Enum.count(fixedDeposits)>0 do

                #acc = Enum.reduce(fixedDeposits, fn x,
                #    acc -> x.id * acc
                #end)

                totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                    fixedDeposit = Enum.at(fixedDeposits, x)

                    fullValue = Decimal.round(Decimal.from_float(fixedDeposit.principalAmount + fixedDeposit.expectedInterest), fixedDeposit.currencyDecimals)
                    fixedAmount = Decimal.round(Decimal.from_float(fixedDeposit.principalAmount), fixedDeposit.currencyDecimals)
                    id = "#{fixedDeposit.id}"
                    idLen = String.length(id)

                    fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
                    autoRollOverAmount = Decimal.round(Decimal.from_float(fixedDeposit.autoRollOverAmount), fixedDeposit.currencyDecimals)
                    endDate = DateTime.to_date(fixedDeposit.endDate)
                    totals = "#{(x+1)}. Ref ##{fixedDepositNumber}\nFixed Deposit: #{fixedDeposit.currency}#{fixedAmount}\nValue At Maturity: #{fixedDeposit.currency}#{fullValue}\nValue Date: #{endDate}\nRollover Amount: #{fixedDeposit.currency}#{autoRollOverAmount}\n\n"

                end


                IO.inspect Enum.count(totals)
                IO.inspect "==========>>>>>>>"
                acctStatement = (Enum.join(totals, "\n"))
                IO.inspect String.length(acctStatement)
                text = "Select a fixed deposit to remove its automatic rollover on maturity\n\n" <> acctStatement <> "\n\nb. Back"
                # response = %{
                #     Message: text,
                #     ClientState: 2,
                #     Type: "Response",
                #     key: "BA3"
                # }
                response = text
                send_response(conn, response)
            else
                text = "You do not have any automatic rollovers on fixed deposits\n\nb. Back"
                # response = %{
                #     Message: text,
                #     ClientState: 2,
                #     Type: "Response",
                #     key: "BA3"
                # }
                response = text
                send_response(conn, response)
            end

            response = text
            # response = %{
            #     Message: text,
            #     ClientState: 2,
            #     Type: "Response",
            #     key: "BA3"
            # }
            send_response(conn, response)
        else
            text = "You do not have any automatic rollovers on fixed deposits\n\nb. Back"
            # response = %{
            #     Message: text,
            #     ClientState: 2,
            #     Type: "Response",
            #     key: "BA3"
            # }
            response = text
            send_response(conn, response)
        end
    end

    def createNewAutoRollover(conn, mobile_number, cmd, text, checkMenu) do
        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)


        isMatured = false
        isDivested = false
        status = "ACTIVE"
        autoCreditOnMaturityDone = false
        autoCreditOnMaturity = false
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.autoCreditOnMaturity == type(^autoCreditOnMaturity, :boolean)
                and au.autoCreditOnMaturityDone == type(^autoCreditOnMaturityDone, :boolean) and au.fixedDepositStatus == type(^status, :string) and au.userId == type(^appUser.id, :integer)),
            select: au
        fixedDeposits = Repo.all(query)

            IO.inspect "=========="
            IO.inspect Enum.count(fixedDeposits)

        if Enum.count(fixedDeposits)>0 do

            totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                fixedDeposit = Enum.at(fixedDeposits, x)
                IO.inspect fixedDeposit

                fullValue = Decimal.round(Decimal.from_float(fixedDeposit.principalAmount + fixedDeposit.expectedInterest), fixedDeposit.currencyDecimals)
                fixedAmount = Decimal.round(Decimal.from_float(fixedDeposit.principalAmount), fixedDeposit.currencyDecimals)
                id = "#{fixedDeposit.id}"
                idLen = String.length(id)

                fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
                autoRollOverAmount = if(!is_nil(fixedDeposit.autoRollOverAmount)) do
                    autoRollOverAmount = Decimal.round(Decimal.from_float(fixedDeposit.autoRollOverAmount), fixedDeposit.currencyDecimals)
                else
                    0.00
                end
                endDate = DateTime.to_date(fixedDeposit.endDate)
                totals = "#{(x+1)}. Ref ##{fixedDepositNumber}\nFixed Deposit: #{fixedDeposit.currency}#{fixedAmount }\nValue At Maturity: #{fixedDeposit.currency}#{fullValue}\nValue Date: #{endDate}\nRollover Amount: #{fixedDeposit.currency }#{autoRollOverAmount}\n\n"

            end


            IO.inspect Enum.count(totals)
            IO.inspect "==========>>>>>>>"
            acctStatement = (Enum.join(totals, "\n"))
            IO.inspect String.length(acctStatement)
            text = "Select a fixed deposit to add an automatic rollover on maturity\n\n" <> acctStatement <> "\n\nb. Back"

            response = text
            send_response(conn, response)
        else
            text = "There are no fixed deposits to fix an automatic rollover on\n\nb. Back"
            response = text
            send_response(conn, response)
        end

    end

    def deleteAutoRollover(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        IO.inspect checkMenu

        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)


        isMatured = false
        isDivested = false
        status = "ACTIVE"
        autoCreditOnMaturityDone = false
        autoCreditOnMaturity = true
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.autoCreditOnMaturity == type(^autoCreditOnMaturity, :boolean)
                and au.autoCreditOnMaturityDone == type(^autoCreditOnMaturityDone, :boolean) and au.fixedDepositStatus == type(^status, :string) and au.userId == type(^appUser.id, :integer)),
            select: au
        fixedDeposits = Repo.all(query)

            IO.inspect "=========="
            IO.inspect Enum.count(fixedDeposits)

        if Enum.count(fixedDeposits)>0 do

            valueEntered = elem Integer.parse(valueEntered), 0
            fixedDeposit = Enum.at(fixedDeposits, (valueEntered-1))

            IO.inspect fixedDeposit
            attrs = %{autoCreditOnMaturityDone: false, autoCreditOnMaturity: false, autoRollOverAmount: 0.00}

            fixedDeposit
            |> Savings.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
            |> Repo.update()

            idLen = String.length("#{fixedDeposit.id}")
            fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
            text = "Automatic rollover has been removed for your fixed deposit ##{fixedDepositNumber}\n\nb. Back"

            response = text
            send_response(conn, response)
        else
            text = "You do not have any automatic rollovers on fixed deposits\n\nb. Back"
            response = text
            send_response(conn, response)
        end
    end

    def enterRolloverAmount(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        IO.inspect checkMenu

        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)


        isMatured = false
        isDivested = false
        status = "ACTIVE"
        autoCreditOnMaturityDone = false
        autoCreditOnMaturity = false
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.autoCreditOnMaturity == type(^autoCreditOnMaturity, :boolean)
                and au.autoCreditOnMaturityDone == type(^autoCreditOnMaturityDone, :boolean) and au.fixedDepositStatus == type(^status, :string) and au.userId == type(^appUser.id, :integer)),
            select: au
        fixedDeposits = Repo.all(query)

            IO.inspect ">>=========="
            IO.inspect Enum.count(fixedDeposits)

        if Enum.count(fixedDeposits)>0 do

            valueEntered = elem Integer.parse(valueEntered), 0
            fixedDeposit = Enum.at(fixedDeposits, (valueEntered - 1))

            IO.inspect fixedDeposit

            idLen = String.length("#{fixedDeposit.id}")
            fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
            currency = fixedDeposit.currency
            maturityValue = fixedDeposit.principalAmount + fixedDeposit.expectedInterest
            maturityValue = Decimal.round(Decimal.from_float(maturityValue), fixedDeposit.currencyDecimals)
            text = "Enter Amount to automatically rollover.\nHow much do you want to reinvest? Maximum allowed is #{currency}#{maturityValue} \n\nb. Back"
            # response = %{
            #     Message: text,
            #     ClientState: 2,
            #     Type: "Response",
            #     key: "BA3"
            # }
            response = text
            send_response(conn, response)
        else
            text = "You do not have any fixed deposits to add an automatic rollover on\n\nb. Back"
            # response = %{
            #     Message: text,
            #     ClientState: 2,
            #     Type: "Response",
            #     key: "BA3"
            # }
            response = text
            send_response(conn, response)
        end
    end

    def applyRolloverAmount(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        fdSelected = Enum.at(checkMenu, (checkMenuLength-2))
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        IO.inspect checkMenu
        valueEntered = elem Float.parse(valueEntered), 0

        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)


        isMatured = false
        isDivested = false
        status = "ACTIVE"
        autoCreditOnMaturityDone = false
        autoCreditOnMaturity = false
        query = from au in Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.autoCreditOnMaturity == type(^autoCreditOnMaturity, :boolean)
                and au.autoCreditOnMaturityDone == type(^autoCreditOnMaturityDone, :boolean) and au.fixedDepositStatus == type(^status, :string) and au.userId == type(^appUser.id, :integer)),
            select: au
        fixedDeposits = Repo.all(query)

            IO.inspect ">>=========="
            IO.inspect Enum.count(fixedDeposits)

        if Enum.count(fixedDeposits)>0 do

            fdSelected = elem Integer.parse(fdSelected), 0
            fixedDeposit = Enum.at(fixedDeposits, (fdSelected - 1))

            IO.inspect fixedDeposit
            attrs = %{autoCreditOnMaturityDone: false, autoCreditOnMaturity: true, autoRollOverAmount: valueEntered}

            fixedDeposit
            |> Savings.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
            |> Repo.update()

            idLen = String.length("#{fixedDeposit.id}")
            fixedDepositNumber = String.pad_leading("#{fixedDeposit.id}", (6 - idLen), "0")
            ntotals = calculate_maturity_repayments(valueEntered, fixedDeposit.fixedPeriod, fixedDeposit.interestRate)
            ntotals = Decimal.round(Decimal.from_float(ntotals),fixedDeposit.currencyDecimals)


            text = "Automatic rollover has been added for your fixed deposit ##{fixedDepositNumber} for a period of #{fixedDeposit.fixedPeriod} #{fixedDeposit.fixedPeriodType} yielding you an interest of #{fixedDeposit.currency}#{ntotals}. This instruction will be effected at the point of maturity\n\nb. Back"
            # response = %{
            #     Message: text,
            #     ClientState: 2,
            #     Type: "Response",
            #     key: "BA3"
            # }
            response = text
            send_response(conn, response)
        else
            text = "You do not have any fixed deposits to add an automatic rollover on\n\nb. Back"
            # response = %{
            #     Message: text,
            #     ClientState: 2,
            #     Type: "Response",
            #     key: "BA3"
            # }
            response = text
            send_response(conn, response)
        end
    end

    def handleChangePin(conn, mobile_number, cmd, text, checkMenu, passwordRequestMessage) do
        checkMenuLength = Enum.count(checkMenu)
        defaultCurrency = 1
        valueEntered = Enum.at(checkMenu, (checkMenuLength-4))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)

        query_params = conn.query_params
        session_id = query_params["SESSION_ID"]
        query = from au in UssdRequest, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
        ussdRequests = Repo.all(query)
        ussdRequest = Enum.at(ussdRequests, 0)
        IO.inspect (Enum.count(ussdRequests))
        #handle_validate_password_for_pin_change(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered)

        IO.inspect text
        orginal_short_code = cmd


        activeStatus = "ACTIVE"
            query = from au in Savings.Accounts.User, where: au.username == ^mobile_number and au.status == ^activeStatus, select: au
            companyStaff = Repo.one(query)

        if(!is_nil(companyStaff)) do
            checkMenu = String.split(text, "\*")
            checkMenuLength = Enum.count(checkMenu)

            IO.inspect("[[[[[[]]]]]]")
            IO.inspect(checkMenuLength)
            IO.inspect(checkMenu)

            case checkMenuLength do
                4 ->
                    response = passwordRequestMessage
                    send_response(conn, response)
                5 ->
                    valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                    IO.inspect (valueEntered)
                    handle_validate_password_for_pin_change(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered)
                6 ->
                    pin = Enum.at(checkMenu, 4)
                    IO.inspect "pin..." <> pin
                    checkDigits = Regex.match?(~r/^([0-9]{4})+$/, pin)
                    case checkDigits do

                        true ->

                            response = "Retype the 4-Digit security pin again\n\nb. Cancel"
                            send_response(conn, response)

                        false ->

                            IO.inspect "checkMenu"
                            IO.inspect checkMenu
                            checkMenuSize = Enum.count(checkMenu) - 2
                            checkMenuUpd = Enum.slice(checkMenu, 0..checkMenuSize)
                            IO.inspect checkMenuUpd
                            IO.inspect checkMenuSize
                            #IO.inspect Enum.join(checkMenuUpd, "*")

                            text = Enum.join(checkMenuUpd, "*")
                            IO.inspect text
                            text = text <> "*"
                            IO.inspect text
                            attrs = %{request_data: text}
                            IO.inspect attrs

                            ussdRequest = Enum.at(ussdRequests, 0)

                            query = from au in UssdRequest, where: au.id == ^ussdRequest.id, select: au
                                    ussdRequest = Repo.one(query)
                            IO.inspect ussdRequest

                            ussdRequest
                            |> UssdRequest.changesetForUpdate(attrs)
                            |> Repo.update()

                            response = "Incorrect values provided. Please enter your valid 4-digit security pin\nb. Cancel"
                            send_response(conn, response)

                        end
                7 ->
                    #password = Enum.at(checkMenu, 4)
                    #cpassword = Enum.at(checkMenu, 5)

                    pin = Enum.at(checkMenu, 4)
                    rpin = Enum.at(checkMenu, 5)
                    IO.inspect "pin..." <> pin
                    IO.inspect "rpin..." <> rpin
                    checkDigits = Regex.match?(~r/^([0-9]{4})+$/, pin)

                    case checkDigits do
                        false ->

                            IO.inspect "checkMenu"
                            IO.inspect checkMenu
                            checkMenuSize = Enum.count(checkMenu) - 2
                            checkMenuUpd = Enum.slice(checkMenu, 0..checkMenuSize)
                            IO.inspect checkMenuUpd
                            IO.inspect checkMenuSize
                            #IO.inspect Enum.join(checkMenuUpd, "*")

                            text = Enum.join(checkMenuUpd, "*")
                            IO.inspect text
                            text = text <> "*"
                            IO.inspect text
                            attrs = %{request_data: text}
                            IO.inspect attrs

                            ussdRequest = Enum.at(ussdRequests, 0)

                            query = from au in UssdRequest, where: au.id == ^ussdRequest.id, select: au
                                    ussdRequest = Repo.one(query)
                            IO.inspect ussdRequest
                            ussdRequest
                            |> UssdRequest.changesetForUpdate(attrs)
                            |> Repo.update()

                            response = "Invalid pin provided. Retype the 4-Digit security pin again\nb. Cancel"
                            send_response(conn, response)

                        true ->
                            case String.equivalent?(pin, rpin) do
                                false ->

                                    logUssdRequest(companyStaff.id, "PASSWORD CHANGE", nil, "FAILED", mobile_number, "Pin Change Failed. Pin mismatch comparing pin with confirmation pin")

                                    response = "Pin mismatch! The pins you have provided did not match. Enter a valid 4-digit security pin\nb. Back"
                                    send_response(conn, response)

                                true ->
                                    pinEnc = Savings.Accounts.User.encrypt_password(pin)
                                    pinEnc = String.trim_trailing(pinEnc, " ")

                                    attrs = %{pin: pinEnc}
                                    companyStaff
                                    |> Savings.Accounts.User.changesetforupdate(attrs)
                                    |> Repo.update()

                                    logUssdRequest(companyStaff.id, "PASSWORD CHANGE", nil, "SUCCESS", mobile_number, "Pin Change Successful")

                                        response = "Pin change was successful\n\nb. Back"
                                        send_response(conn, response)

                            end
                    end
                end

        else
            response = "Invalid profile. An active profile mapped to this number could not be found. \nContact MFZ staff to assist you with reactivating your profile"
            send_response(conn, response)
        end

    end

    def handle_validate_password_for_pin_change(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered) do

        activeStatus = "ACTIVE"
        query = from au in Savings.Accounts.User, where: au.username == ^mobile_number, select: au
        loggedInUser = Repo.one(query)


        if(!is_nil(loggedInUser)) do

            if(loggedInUser.status != activeStatus) do

                logUssdRequest(loggedInUser.id, "PASSWORD CHANGE", nil, "FAILED", mobile_number, "Validate OTP sent for Password Change Failed. Account is #{loggedInUser.status}")
                response = "Your account is no longer active. Please contact Microfinance Zambia to reactivate your account. "
                end_session(ussdRequests, conn, response)
            else
                passwordChecker = Base.encode16(:crypto.hash(:sha512, valueEntered))
                pwsdpin = String.trim_trailing(loggedInUser.pin, " ")
                passwordChecker1 = String.trim_trailing(pwsdpin, " ")
                IO.inspect "passwordChecker..."
                IO.inspect passwordChecker
                IO.inspect loggedInUser.pin
                IO.inspect passwordChecker1

                case String.equivalent?(passwordChecker, passwordChecker1) do
                    false ->
                        logUssdRequest(loggedInUser.id, "PASSWORD CHANGE", nil, "FAILED", mobile_number, "Validate OTP sent for Password Change Failed. User failed to provide correct password")
                        if(loggedInUser.password_fail_count>2) do

                            logUssdRequest(loggedInUser.id, "PASSWORD CHANGE", nil, "FAILED", mobile_number, "Account blocked due to failure to provide correct password")
                            attrs = %{password_fail_count: 3, status: "BLOCKED"}

                            loggedInUser
                            |> User.changeset(attrs)
                            |> Repo.update()
                        else

                            attrs = %{password_fail_count: (loggedInUser.password_fail_count + 1)}

                            loggedInUser
                            |> User.changeset(attrs)
                            |> Repo.update()
                        end


                        IO.inspect "checkMenu"
                        IO.inspect checkMenu
                        checkMenuSize = Enum.count(checkMenu) - 5
                        checkMenuUpd = Enum.slice(checkMenu, 0..checkMenuSize)
                        IO.inspect checkMenuUpd
                        IO.inspect checkMenuSize
                        #IO.inspect Enum.join(checkMenuUpd, "*")

                        text = Enum.join(checkMenuUpd, "*")
                        IO.inspect text
                        text = text <> "*"
                        IO.inspect text
                        attrs = %{request_data: text}
                        IO.inspect attrs

                        ussdRequest = Enum.at(ussdRequests, 0)

                        query = from au in UssdRequest, where: au.id == ^ussdRequest.id, select: au
                                ussdRequest = Repo.one(query)
                        IO.inspect ussdRequest
                        ussdRequest
                        |> UssdRequest.changesetForUpdate(attrs)
                        |> Repo.update()
                        session_id = ussdRequest.session_id

                        send_response(conn, "Invalid pin entered. Enter your current pin")
                        #handleChangePin(conn, mobile_number, cmd, text, checkMenu, "Invalid Pin. Please provide your valid pin. Your account will be locked if you fail to provide a valid pin after 3 times\nb. Back")
                        #handleChangePin(conn, mobile_number, cmd, text, ussdRequests, "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times\nb. Back")

                    true ->

                        attrs = %{password_fail_count: 0, status: "ACTIVE"}

                        loggedInUser
                        |> User.changeset(attrs)
                        |> Repo.update()

                        ussdRequest = Enum.at(ussdRequests, 0)
                        session_id = ussdRequest.session_id

                        IO.inspect (ussdRequest.id)
                        logUssdRequest(loggedInUser.id, "PASSWORD CHANGE", nil, "SUCCESS", mobile_number, "Validate OTP sent for Password Change")

                        query = from au in UssdRequest, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                        ussdRequests = Repo.all(query)
                        response = "Enter New 4-digit Pin\n\nb. Cancel"
                        send_response(conn, response)
                end
            end

        else

            response = "Invalid credentials."
            end_session(ussdRequests, conn, response)
        end

    end

    def handleTC(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(valueEntered)
        IO.inspect(text)
        if valueEntered == "b" do
            tempText = text <> "*"
            tempCheckMenu = String.split(tempText, "*b*")
            tempCheckMenuFirst = Enum.at(tempCheckMenu, 0)
            IO.inspect(tempCheckMenuFirst)
            tempCheckMenuLength = Enum.count(tempCheckMenu)
            tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1)

            nText = tempCheckMenuLast
            response = nText
            send_response(conn, response)
        else

            naive_datetime = Timex.now
            sms = %{
                mobile: mobile_number,
                msg: "Age 18+, min deposit K50, interest rates based on deposit tenure, no 3rd party deposits, no withdrawals during term, visit mfz.co.zm for detailed ts&cs, ",
                status: "READY",
                type: "SMS",
                msg_count: "1",
                date_sent: naive_datetime
            }
            Sms.changeset(%Sms{}, sms)
            |> Repo.insert()

            tc = "Ts & Cs\n\n
            Zipake Terms: Min. age 18 with active Airtel mobile money account. Min. deposit K50. Interest rates vary based on tenure. No third-party deposits. No withdrawals during deposit term, except interim withdrawals with changed interest. Partial withdrawal treated as full withdrawal. Deposit and interest paid to Airtel Money Account at maturity. Liability excluded unless prohibited by law. Dormant Airtel numbers deactivate, funds sent to Bank of Zambia. In the event of death, funds paid to appointed administrator. By depositing, you agree to these terms \n\nb. Back"
            response = tc
            send_response(conn, response)
        end
    end


    def calculateCurrentBalance(conn, mobile_number, cmd, text, checkMenu) do
        IO.inspect(checkMenu)
        IO.inspect(cmd)
        IO.inspect(text)
        IO.inspect(conn)
        query = from au in User,
            where: (au.username == type(^mobile_number, :string)),
            select: au
        appUsers = Repo.all(query)
        appUser = Enum.at(appUsers, 0)

        individualRoleType = "INDIVIDUAL"
        query = from au in  Savings.Accounts.UserRole,
            where: (au.userId == type(^appUser.id, :integer) and au.roleType == type(^individualRoleType, :string)),
            select: au
        userRoles = Repo.all(query)
        userRole = Enum.at(userRoles, 0)

        IO.inspect(userRole)

        # status = "Disbursed"
        isMatured = false
        isDivested = false
        query = from au in  Savings.FixedDeposit.FixedDeposits,
            where: (au.isMatured == type(^isMatured, :boolean) and au.isDivested == type(^isDivested, :boolean) and au.userId == type(^appUser.id, :integer)),
            select: au
        fixedDeposits = Repo.all(query)
        # totalBalance = 0.00

        IO.inspect "=========="
        IO.inspect Enum.count(fixedDeposits)

            totalBalance = if Enum.count(fixedDeposits)>0 do
                totals = for x <- 0..(Enum.count(fixedDeposits)-1) do
                    fixedDeposit = Enum.at(fixedDeposits, x)
                    days = Date.diff(Date.utc_today, fixedDeposit.startDate)
                    ntotals = calculate_maturity_repayments(fixedDeposit.principalAmount, days, fixedDeposit.interestRate)
                    IO.inspect "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                    IO.inspect ntotals
                    ntotals
                end

                IO.inspect Enum.count(totals)
                IO.inspect "=========="
                totalBalance = Float.ceil(Enum.sum(totals), 2)
                totalBalance
            else
                totalBalance = 0.00
                totalBalance
            end
        totalBalance
    end

    def calculate_maturity_repayments(amount, period, rate) do
        incurredInterest = amount * rate * period/364 / 100
        IO.inspect incurredInterest
    end

    def checkIfFloat(v) do
        v = case Float.parse(v) do
            {v, u} ->
                IO.inspect "v...#{v}"
                IO.inspect v
                IO.inspect u
                v
            error ->

            IO.inspect error
            v = case Integer.parse(v) do
                {v, u} ->
                    IO.inspect "v1..."
                    IO.inspect v
                    IO.inspect u
                    v
                error ->
                    IO.inspect "error..."
                    IO.inspect error
                    false
            end
            IO.inspect v
        end
        v
    end

    def checkIfInteger(v) do
        v = case Integer.parse(v) do
            {v, u} ->
                IO.inspect u
                v
            error ->
                IO.inspect error
                false
        end
        v
    end

    def logUssdRequest(userId, action, parentRoute, status, mobileNo, details) do

        ussd_log = %UssdLog{
            userId: userId,
            action: action,
            parentRoute: parentRoute,
            status: status,
            details: details,
            mobileNo: mobileNo
        }

        IO.inspect ("ussd_log")
        IO.inspect (ussd_log)

        case Repo.insert(ussd_log) do
            {:ok, ussd_log} ->
                IO.inspect ussd_log
                nil
            {:error, changeset} ->
                IO.inspect changeset
                nil
        end
    end

    def send_response(conn, response) do
        IO.inspect  "Test!"
        IO.inspect  Jason.encode!(response)
        conn
        |> put_status(:ok)
        |> put_resp_header("Freeflow", "FC")
        |> send_resp(:ok, response)
    end



    def send_response_with_header(conn, response) do
        IO.inspect  "Test!"
        IO.inspect  Jason.encode!(response)
        conn
        |> put_status(:ok)
        |> put_resp_header("Freeflow", "FB")
        |> send_resp(:ok, response)
    end

    def pending_transactions() do
        case Savings.Transactions.pending_transactions_update() do
          [] ->
                    IO.puts("\n <<<<<<<  NO PENDING TRANSACTIONS WERE FOUND >>>>>>> \n")
            []
          transactions ->
            transactions
        end
      end

    #   SavingsWeb.UssdController.update_expected_interest
    @spec update_expected_interest :: :ok
    def update_expected_interest do

        Enum.each(pending_transactions(), fn txn ->

            txnid = txn.id
            query = from au in Savings.FixedDeposit.FixedDepositTransaction,
                where: (au.transactionId == type(^txnid, :integer)),
                select: au
            fixedDepositTransaction = Repo.one(query)

            query = from au in Savings.FixedDeposit.FixedDeposits,
                where: (au.id == type(^fixedDepositTransaction.fixedDepositId, :integer)),
                select: au
            fixedDeposit = Repo.one(query)

            fixedDepositIdd = fixedDeposit.id
            IO.inspect "-------------"
            IO.inspect fixedDepositIdd

            amt = fixedDeposit.principalAmount
            default_period = fixedDeposit.fixedPeriod
            default_rate = fixedDeposit.interestRate

            totalRepayments = calculate_maturity_repayments(amt, default_period, default_rate)
            IO.inspect "***********************************************"
            getinterest = Float.ceil(totalRepayments, 2)
            IO.inspect getinterest

            # attrs = %{expectedInterest: getinterest}
            # fixedDeposit
            # |> Savings.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
            # |> Repo.update()

        end)

    end

end
