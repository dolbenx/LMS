defmodule Loanmanagementsystem.Bot do
  @bot :loanmanagementsystem

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.Account
  import Ecto.Query, warn: false

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")

  use Tesla
  # plug Tesla.Middleware.BaseUrl, "http://localhost:4000/"
  # middleware(ExGram.Middleware.IgnoreUsername)
  # middleware(ExGram.Middleware.Contact)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    # chats = ExGram.get_chat_member_count!(context.update.message.chat.id)
    # gets = ExGram.Model.Update.message
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    first_name = context.update.message.chat.first_name
    # last_name = context.update.message.chat.last_name
    telegram_id = context.update.message.chat.id

    query =
      from au in Loanmanagementsystem.Accounts.Account,
        where: au.telegram_id == ^"#{telegram_id}",
        select: au

    appusers = Repo.all(query)

    # if Enum.count(appusers) > 0 do

    Nadia.send_message(context.update.message.chat.id, "Hi #{first_name} 👋🏽,
Welome to PBS Loans, You can quickly and easily apply for loans and get the money instantly, Click on an option",

    reply_markup: %{
      inline_keyboard:
        [
          [%{text: "1. Request Loan 💰", callback_data: "getloan",  request_contact: true}],
          [%{text: "2. Repay Loan 💵", callback_data: "repay"}],
          [%{text: "3. Check Loan Balance ⚖️", callback_data: "balance"}],
          [%{text: "4. Check Eligible Loan Amount 📱", callback_data: "eligible"}],
          [%{text: "5. Check Loan Requirements 🆔", callback_data: "requirments"}],
          [%{text: "6. Help ❓", callback_data: "help"}]

        ]
      })

    # else

    #  teledata = %Account{telegram_id: "#{context.update.message.chat.id}"}

    #  case Repo.insert(teledata) do

    #     {:ok, teledata} ->

    #       Nadia.send_message(context.update.message.chat.id, "You do not have an account with us yet. Please click the button below and you account will be ready shortly.",
    #       reply_markup: %{
    #         inline_keyboard:
    #           [
    #             [
    #               %{text: "Sign Online", url: "http://45.63.115.210:4000/Register"}
    #             ]
    #           ]
    #         })

    #     {:error, changeset} ->

    #       answer(context, "You need to try again")
    #   end

    # end
  end
  def handle({:callback_query, %{data: "start"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    first_name = context.update.callback_query.message.chat.first_name
    last_name = context.update.callback_query.message.chat.last_name
    Nadia.send_message(context.update.callback_query.message.chat.id, "Hi #{first_name} #{last_name} 👋🏽,
    Welome to PBS Loans, You can quickly and easily apply for loans and get the money instantly, Click on an option",

        reply_markup: %{
          inline_keyboard:
            [
              [%{text: "1. Request Loan 💰", callback_data: "getloan"}],
              [%{text: "2. Repay Loan 💵", callback_data: "repay"}],
              [%{text: "3. Check Loan Balance ⚖️", callback_data: "balance"}],
              [%{text: "4. Check Eligible Loan Amount 📱", callback_data: "eligible"}],
              [%{text: "5. Check Loan Requirements 🆔", callback_data: "requirments"}],
              [%{text: "6. Help ❓", callback_data: "help"}]

            ]
          })
  end

  def handle({:command, :getloan, _msg}, context) do
    # answer(context, "Enter Amount")
    Nadia.send_message(context.update.message.chat.id, "Hey Boss", reply_markup: %{inline_keyboard: [[%{text: "one", callback_data: "one"}]]})
  end

  def handle({:callback_query, %{data: "getloan"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "Select Amount You Would Like Apply For:",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "100 ZMW", callback_data: "amount"},
            %{text: "200 ZMW", callback_data: "amount"},
            %{text: "300 ZMW", callback_data: "start"},
            %{text: "400 ZMW", callback_data: "start"},
          ],
          [
            %{text: "500 ZMW", callback_data: "start"},
            %{text: "600 ZMW", callback_data: "start"},
            %{text: "700 ZMW", callback_data: "start"},
            %{text: "800 ZMW", callback_data: "start"},
          ],
          [
            %{text: "900 ZMW", callback_data: "start"},
            %{text: "1,000 ZMW", callback_data: "start"},
            %{text: "1,500 ZMW", callback_data: "start"},
            %{text: "2,000 ZMW", callback_data: "start"},
          ],
          [
            %{text: "Enter Your Own Amount 💰", callback_data: "repay_amount"}
          ],
          [
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "amount"}}, context) do
    IO.inspect("888888888888888888888888888888888888888888888888")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "You have request for a loan for ZMW 100, Your Interest ZMW 10, total repayment ZMW 110, Due 2022-09-19",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Comfirm", callback_data: "comfirm_loan"}
          ],
          [
            %{text: "Previous Menu ↩️", callback_data: "getloan"},
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "comfirm_loan"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "You have successfully requested for a loan for ZMW 100, Due 2022-09-19. You will be credited with ZMW 100 into mobile money account.",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "repay"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "Select An Option Below.",

    reply_markup: %{
      inline_keyboard:
        [
          [
          %{text: "2,200 ZMW", callback_data: "start"},
          %{text: "1,980 ZMW", callback_data: "start"}
          ],
          [
            %{text: "Enter Own Amount", callback_data: "repay_amount"}
          ],
          [
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "repay_amount"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "Enter Amount To Repay")
  end

  def get_balance() do
    get("/Customer/Bot/Balance")
  end

  def handle({:callback_query, %{data: "balance"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    {:ok, response} = get_balance()
    IO.inspect(response.body)
    Nadia.send_message(context.update.callback_query.message.chat.id, response.body,

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "eligible"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "Hi You are currently eligiable to get upto ZMW2,500.",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "requirments"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "LOAN REQUIREMENTS
    1. NRC
    2. Latest Payslip
    3. Latest Bank Statement
    4. Letter of Introduction from Employer",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Back to main menu ↩️", callback_data: "start"}
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "location"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_venue(1128140103, -15.400337211139245, 28.296661241728515, "PROBASE head office", "probase", [])
    Nadia.send_message(context.update.callback_query.message.chat.id, "Click On the map above to get directions to our offices.",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Back to main menu ↩️", callback_data: "start"},
          ]
        ]
      })
  end

  def handle({:callback_query, %{data: "help"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "Hi there! Do you have any questions about our services? Please get in touch with us through the following channels:

    Call Us: +260977548025
    Email Us: info@qfin.co.zm
    WhatsApp Us: +260977548025
    Visit Our Website: www.qfinloans.com",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Back to main menu ↩️", callback_data: "start"},
            %{text: "View Head Office Location 📍", callback_data: "location"}
          ]
        ]
      })
  end


  def handle({:callback_query, %{data: "contact"}}, context) do
    IO.inspect("{{{{{{{{{{{{{{{{{{{{{{{}}}}}}}}}}}}}}}}}}}}}}}")
    IO.inspect(context)
    Nadia.answer_callback_query(context.update.callback_query.id)
    # Nadia.delete_message(context.update.callback_query.message.chat.id, context.update.callback_query.message.message_id)
    Nadia.send_message(context.update.callback_query.message.chat.id, "Send Contact",

    reply_markup: %{
      inline_keyboard:
        [
          [
            %{text: "Contact", callback_data: "start"},
          ]
        ]
      })
  end


  # Loanmanagementsystem.Bot.tests
  def tests() do
    # Nadia.get_chat(5327164656)5159706082,,,,,,,,,,1128140103...........5327164656
    # Nadia.get_webhook_info()
    # Nadia.inline_keyboard(5159706082)
    # keyboard:
    # [
    #   [%{text: "Get Contactss 💰", request_contact: true, callback_data: "help"}]
    # ],
    # Nadia.send_message(1128140103, "Hey Boss", reply_markup: %{keyboard: [[%{text: "one", callback_data: "contact", remove_keyboard: true, request_contact: true}]]})
    # ExGram.logOut
    # Nadia.send_venue(1128140103, -15.400337211139245, 28.296661241728515, "PROBASE head office", "probase", [])


  end
end
