defmodule Loanmanagementsystem.AuthenticationServices.UserSecurity do
  alias Loanmanagementsystem.{
    Context.SecurityQuestions,
    Notifications.Messages,
    UserContext,
    Utility.Randomizer
  }

  def get_security_questions(_conn, _params) do
    Messages.success_message(
      "Security Question list",
      SecurityQuestions.get_security_questions()
    )
  end

  def set_security_question(conn, %{"question" => question, "answer" => _} = params) do
    SecurityQuestions.get_security_question_by_id(question)
    |> case do
      nil ->
        Messages.error_message("Invalid security_question")

      _quest ->
        SecurityQuestions.insert_or_update_security_questions(
          conn,
          Map.merge(params, %{"question_id" => question})
        )
        |> case do
          {:ok, _} -> Messages.success_message("Successfully added security question", %{})
          {:error, message} -> Messages.error_message(message)
        end
    end
  end

  def reset_pass_user_question(_conn, %{"query" => _} = params) do
    SecurityQuestions.get_user_security_question(params)
    |> case do
      nil -> Messages.error_message("Security Questions not set")
      question -> Messages.success_message("Successfully collected", question)
    end
  end

  def reset_pass_user_question_answer(
        conn,
        %{"question" => question, "answer" => answer} = params
      ) do
    SecurityQuestions.get_question_map(question)
    |> case do
      nil ->
        Messages.error_message("Wrong Answer")

      question ->
        ques = String.downcase(question.answer) |> String.trim()
        answer = String.downcase(answer) |> String.trim()

        if ques == answer do
          UserContext.reset_login_password_with_question(conn, question.user)
          |> case do
            {:error, message} ->
              Messages.error_message(message)

            {:ok, %{user: user}} ->
              key = Randomizer.randomizer(50)

              Cachex.put(:session_key, key, user.id, ttl: :timer.minutes(3))
              |> case do
                {:ok, true} ->
                  Messages.success_message(
                    "A message is sent to your phone, please use it to change your password",
                    %{
                      exp_time: 3,
                      exp_type: "minutes",
                      password_key: key
                    }
                  )

                _ ->
                  Messages.error_message("Something went wrong")
              end
          end
        else
          Messages.error_message("Wrong Answer")
        end
    end
  end

  def reset_pass_change_password(
        conn,
        %{"password_key" => key, "reset_password" => current_password, "new_password" => password} =
          params
      ) do
    Cachex.get(:session_key, key)
    |> case do
      {:ok, nil} ->
        Messages.error_message("Password key is expired")

      {:ok, user_id} ->
        UserContext.get_user_by_id(user_id)
        |> case do
          nil ->
            Messages.error_message("Invalid user")

          user ->
            if Bcrypt.verify_pass(user.username <> current_password, user.hashed_password) do
              UserContext.update_password(conn, user, password, params)
              |> case do
                {:ok, _user} -> Messages.success_message("Successfully changed password", %{})
                {:error, message} -> Messages.error_message(message)
              end
            else
              Messages.error_message("Invalid reset password code")
            end
        end
    end
  end
end
