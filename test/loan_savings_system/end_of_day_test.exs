defmodule LoanSavingsSystem.EndOfDayTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.EndOfDay

  describe "tbl_end_of_day" do
    alias LoanSavingsSystem.EndOfDay.EndOfDayRun

    @valid_attrs %{currencyId: 42, currencyName: "some currencyName", date_ran: ~N[2010-04-17 14:00:00], end_date: ~N[2010-04-17 14:00:00], end_of_day_type: "some end_of_day_type", penalties_incurred: 120.5, start_date: ~N[2010-04-17 14:00:00], status: "some status", total_interest_accrued: 120.5}
    @update_attrs %{currencyId: 43, currencyName: "some updated currencyName", date_ran: ~N[2011-05-18 15:01:01], end_date: ~N[2011-05-18 15:01:01], end_of_day_type: "some updated end_of_day_type", penalties_incurred: 456.7, start_date: ~N[2011-05-18 15:01:01], status: "some updated status", total_interest_accrued: 456.7}
    @invalid_attrs %{currencyId: nil, currencyName: nil, date_ran: nil, end_date: nil, end_of_day_type: nil, penalties_incurred: nil, start_date: nil, status: nil, total_interest_accrued: nil}

    def end_of_day_run_fixture(attrs \\ %{}) do
      {:ok, end_of_day_run} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_end_of_day_run()

      end_of_day_run
    end

    test "list_tbl_end_of_day/0 returns all tbl_end_of_day" do
      end_of_day_run = end_of_day_run_fixture()
      assert EndOfDay.list_tbl_end_of_day() == [end_of_day_run]
    end

    test "get_end_of_day_run!/1 returns the end_of_day_run with given id" do
      end_of_day_run = end_of_day_run_fixture()
      assert EndOfDay.get_end_of_day_run!(end_of_day_run.id) == end_of_day_run
    end

    test "create_end_of_day_run/1 with valid data creates a end_of_day_run" do
      assert {:ok, %EndOfDayRun{} = end_of_day_run} = EndOfDay.create_end_of_day_run(@valid_attrs)
      assert end_of_day_run.currencyId == 42
      assert end_of_day_run.currencyName == "some currencyName"
      assert end_of_day_run.date_ran == ~N[2010-04-17 14:00:00]
      assert end_of_day_run.end_date == ~N[2010-04-17 14:00:00]
      assert end_of_day_run.end_of_day_type == "some end_of_day_type"
      assert end_of_day_run.penalties_incurred == 120.5
      assert end_of_day_run.start_date == ~N[2010-04-17 14:00:00]
      assert end_of_day_run.status == "some status"
      assert end_of_day_run.total_interest_accrued == 120.5
    end

    test "create_end_of_day_run/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_end_of_day_run(@invalid_attrs)
    end

    test "update_end_of_day_run/2 with valid data updates the end_of_day_run" do
      end_of_day_run = end_of_day_run_fixture()
      assert {:ok, %EndOfDayRun{} = end_of_day_run} = EndOfDay.update_end_of_day_run(end_of_day_run, @update_attrs)
      assert end_of_day_run.currencyId == 43
      assert end_of_day_run.currencyName == "some updated currencyName"
      assert end_of_day_run.date_ran == ~N[2011-05-18 15:01:01]
      assert end_of_day_run.end_date == ~N[2011-05-18 15:01:01]
      assert end_of_day_run.end_of_day_type == "some updated end_of_day_type"
      assert end_of_day_run.penalties_incurred == 456.7
      assert end_of_day_run.start_date == ~N[2011-05-18 15:01:01]
      assert end_of_day_run.status == "some updated status"
      assert end_of_day_run.total_interest_accrued == 456.7
    end

    test "update_end_of_day_run/2 with invalid data returns error changeset" do
      end_of_day_run = end_of_day_run_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_end_of_day_run(end_of_day_run, @invalid_attrs)
      assert end_of_day_run == EndOfDay.get_end_of_day_run!(end_of_day_run.id)
    end

    test "delete_end_of_day_run/1 deletes the end_of_day_run" do
      end_of_day_run = end_of_day_run_fixture()
      assert {:ok, %EndOfDayRun{}} = EndOfDay.delete_end_of_day_run(end_of_day_run)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_end_of_day_run!(end_of_day_run.id) end
    end

    test "change_end_of_day_run/1 returns a end_of_day_run changeset" do
      end_of_day_run = end_of_day_run_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_end_of_day_run(end_of_day_run)
    end
  end

  describe "tbl_end_of_day_entries" do
    alias LoanSavingsSystem.EndOfDay.EndOfDayEntry

    @valid_attrs %{currencyId: 42, currencyName: "some currencyName", end_of_day_date: ~N[2010-04-17 14:00:00], end_of_day_id: 42, interest_accrued: 120.5, penalties_incurred: 120.5, status: "some status"}
    @update_attrs %{currencyId: 43, currencyName: "some updated currencyName", end_of_day_date: ~N[2011-05-18 15:01:01], end_of_day_id: 43, interest_accrued: 456.7, penalties_incurred: 456.7, status: "some updated status"}
    @invalid_attrs %{currencyId: nil, currencyName: nil, end_of_day_date: nil, end_of_day_id: nil, interest_accrued: nil, penalties_incurred: nil, status: nil}

    def end_of_day_entry_fixture(attrs \\ %{}) do
      {:ok, end_of_day_entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_end_of_day_entry()

      end_of_day_entry
    end

    test "list_tbl_end_of_day_entries/0 returns all tbl_end_of_day_entries" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert EndOfDay.list_tbl_end_of_day_entries() == [end_of_day_entry]
    end

    test "get_end_of_day_entry!/1 returns the end_of_day_entry with given id" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert EndOfDay.get_end_of_day_entry!(end_of_day_entry.id) == end_of_day_entry
    end

    test "create_end_of_day_entry/1 with valid data creates a end_of_day_entry" do
      assert {:ok, %EndOfDayEntry{} = end_of_day_entry} = EndOfDay.create_end_of_day_entry(@valid_attrs)
      assert end_of_day_entry.currencyId == 42
      assert end_of_day_entry.currencyName == "some currencyName"
      assert end_of_day_entry.end_of_day_date == ~N[2010-04-17 14:00:00]
      assert end_of_day_entry.end_of_day_id == 42
      assert end_of_day_entry.interest_accrued == 120.5
      assert end_of_day_entry.penalties_incurred == 120.5
      assert end_of_day_entry.status == "some status"
    end

    test "create_end_of_day_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_end_of_day_entry(@invalid_attrs)
    end

    test "update_end_of_day_entry/2 with valid data updates the end_of_day_entry" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert {:ok, %EndOfDayEntry{} = end_of_day_entry} = EndOfDay.update_end_of_day_entry(end_of_day_entry, @update_attrs)
      assert end_of_day_entry.currencyId == 43
      assert end_of_day_entry.currencyName == "some updated currencyName"
      assert end_of_day_entry.end_of_day_date == ~N[2011-05-18 15:01:01]
      assert end_of_day_entry.end_of_day_id == 43
      assert end_of_day_entry.interest_accrued == 456.7
      assert end_of_day_entry.penalties_incurred == 456.7
      assert end_of_day_entry.status == "some updated status"
    end

    test "update_end_of_day_entry/2 with invalid data returns error changeset" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_end_of_day_entry(end_of_day_entry, @invalid_attrs)
      assert end_of_day_entry == EndOfDay.get_end_of_day_entry!(end_of_day_entry.id)
    end

    test "delete_end_of_day_entry/1 deletes the end_of_day_entry" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert {:ok, %EndOfDayEntry{}} = EndOfDay.delete_end_of_day_entry(end_of_day_entry)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_end_of_day_entry!(end_of_day_entry.id) end
    end

    test "change_end_of_day_entry/1 returns a end_of_day_entry changeset" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_end_of_day_entry(end_of_day_entry)
    end
  end

  describe "fcube_general_ledger" do
    alias LoanSavingsSystem.EndOfDay.FcubeGeneralLedger

    @valid_attrs %{account_name: "some account_name", gl_account_no: "some gl_account_no"}
    @update_attrs %{account_name: "some updated account_name", gl_account_no: "some updated gl_account_no"}
    @invalid_attrs %{account_name: nil, gl_account_no: nil}

    def fcube_general_ledger_fixture(attrs \\ %{}) do
      {:ok, fcube_general_ledger} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_fcube_general_ledger()

      fcube_general_ledger
    end

    test "list_fcube_general_ledger/0 returns all fcube_general_ledger" do
      fcube_general_ledger = fcube_general_ledger_fixture()
      assert EndOfDay.list_fcube_general_ledger() == [fcube_general_ledger]
    end

    test "get_fcube_general_ledger!/1 returns the fcube_general_ledger with given id" do
      fcube_general_ledger = fcube_general_ledger_fixture()
      assert EndOfDay.get_fcube_general_ledger!(fcube_general_ledger.id) == fcube_general_ledger
    end

    test "create_fcube_general_ledger/1 with valid data creates a fcube_general_ledger" do
      assert {:ok, %FcubeGeneralLedger{} = fcube_general_ledger} = EndOfDay.create_fcube_general_ledger(@valid_attrs)
      assert fcube_general_ledger.account_name == "some account_name"
      assert fcube_general_ledger.gl_account_no == "some gl_account_no"
    end

    test "create_fcube_general_ledger/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_fcube_general_ledger(@invalid_attrs)
    end

    test "update_fcube_general_ledger/2 with valid data updates the fcube_general_ledger" do
      fcube_general_ledger = fcube_general_ledger_fixture()
      assert {:ok, %FcubeGeneralLedger{} = fcube_general_ledger} = EndOfDay.update_fcube_general_ledger(fcube_general_ledger, @update_attrs)
      assert fcube_general_ledger.account_name == "some updated account_name"
      assert fcube_general_ledger.gl_account_no == "some updated gl_account_no"
    end

    test "update_fcube_general_ledger/2 with invalid data returns error changeset" do
      fcube_general_ledger = fcube_general_ledger_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_fcube_general_ledger(fcube_general_ledger, @invalid_attrs)
      assert fcube_general_ledger == EndOfDay.get_fcube_general_ledger!(fcube_general_ledger.id)
    end

    test "delete_fcube_general_ledger/1 deletes the fcube_general_ledger" do
      fcube_general_ledger = fcube_general_ledger_fixture()
      assert {:ok, %FcubeGeneralLedger{}} = EndOfDay.delete_fcube_general_ledger(fcube_general_ledger)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_fcube_general_ledger!(fcube_general_ledger.id) end
    end

    test "change_fcube_general_ledger/1 returns a fcube_general_ledger changeset" do
      fcube_general_ledger = fcube_general_ledger_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_fcube_general_ledger(fcube_general_ledger)
    end
  end

  describe "fcube_request_responses" do
    alias LoanSavingsSystem.EndOfDay.FcubeReqRes

    @valid_attrs %{request_data: "some request_data", response_data: "some response_data"}
    @update_attrs %{request_data: "some updated request_data", response_data: "some updated response_data"}
    @invalid_attrs %{request_data: nil, response_data: nil}

    def fcube_req_res_fixture(attrs \\ %{}) do
      {:ok, fcube_req_res} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_fcube_req_res()

      fcube_req_res
    end

    test "list_fcube_request_responses/0 returns all fcube_request_responses" do
      fcube_req_res = fcube_req_res_fixture()
      assert EndOfDay.list_fcube_request_responses() == [fcube_req_res]
    end

    test "get_fcube_req_res!/1 returns the fcube_req_res with given id" do
      fcube_req_res = fcube_req_res_fixture()
      assert EndOfDay.get_fcube_req_res!(fcube_req_res.id) == fcube_req_res
    end

    test "create_fcube_req_res/1 with valid data creates a fcube_req_res" do
      assert {:ok, %FcubeReqRes{} = fcube_req_res} = EndOfDay.create_fcube_req_res(@valid_attrs)
      assert fcube_req_res.request_data == "some request_data"
      assert fcube_req_res.response_data == "some response_data"
    end

    test "create_fcube_req_res/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_fcube_req_res(@invalid_attrs)
    end

    test "update_fcube_req_res/2 with valid data updates the fcube_req_res" do
      fcube_req_res = fcube_req_res_fixture()
      assert {:ok, %FcubeReqRes{} = fcube_req_res} = EndOfDay.update_fcube_req_res(fcube_req_res, @update_attrs)
      assert fcube_req_res.request_data == "some updated request_data"
      assert fcube_req_res.response_data == "some updated response_data"
    end

    test "update_fcube_req_res/2 with invalid data returns error changeset" do
      fcube_req_res = fcube_req_res_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_fcube_req_res(fcube_req_res, @invalid_attrs)
      assert fcube_req_res == EndOfDay.get_fcube_req_res!(fcube_req_res.id)
    end

    test "delete_fcube_req_res/1 deletes the fcube_req_res" do
      fcube_req_res = fcube_req_res_fixture()
      assert {:ok, %FcubeReqRes{}} = EndOfDay.delete_fcube_req_res(fcube_req_res)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_fcube_req_res!(fcube_req_res.id) end
    end

    test "change_fcube_req_res/1 returns a fcube_req_res changeset" do
      fcube_req_res = fcube_req_res_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_fcube_req_res(fcube_req_res)
    end
  end

  describe "flexcubeconfigs" do
    alias LoanSavingsSystem.EndOfDay.FlexCubeConfig

    @valid_attrs %{action_type: "some action_type", dr_cr: "some dr_cr", flex_cube_gl_code: "some flex_cube_gl_code", flex_cube_gl_id: 42, flex_cube_gl_name: "some flex_cube_gl_name"}
    @update_attrs %{action_type: "some updated action_type", dr_cr: "some updated dr_cr", flex_cube_gl_code: "some updated flex_cube_gl_code", flex_cube_gl_id: 43, flex_cube_gl_name: "some updated flex_cube_gl_name"}
    @invalid_attrs %{action_type: nil, dr_cr: nil, flex_cube_gl_code: nil, flex_cube_gl_id: nil, flex_cube_gl_name: nil}

    def flex_cube_config_fixture(attrs \\ %{}) do
      {:ok, flex_cube_config} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_flex_cube_config()

      flex_cube_config
    end

    test "list_flexcubeconfigs/0 returns all flexcubeconfigs" do
      flex_cube_config = flex_cube_config_fixture()
      assert EndOfDay.list_flexcubeconfigs() == [flex_cube_config]
    end

    test "get_flex_cube_config!/1 returns the flex_cube_config with given id" do
      flex_cube_config = flex_cube_config_fixture()
      assert EndOfDay.get_flex_cube_config!(flex_cube_config.id) == flex_cube_config
    end

    test "create_flex_cube_config/1 with valid data creates a flex_cube_config" do
      assert {:ok, %FlexCubeConfig{} = flex_cube_config} = EndOfDay.create_flex_cube_config(@valid_attrs)
      assert flex_cube_config.action_type == "some action_type"
      assert flex_cube_config.dr_cr == "some dr_cr"
      assert flex_cube_config.flex_cube_gl_code == "some flex_cube_gl_code"
      assert flex_cube_config.flex_cube_gl_id == 42
      assert flex_cube_config.flex_cube_gl_name == "some flex_cube_gl_name"
    end

    test "create_flex_cube_config/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_flex_cube_config(@invalid_attrs)
    end

    test "update_flex_cube_config/2 with valid data updates the flex_cube_config" do
      flex_cube_config = flex_cube_config_fixture()
      assert {:ok, %FlexCubeConfig{} = flex_cube_config} = EndOfDay.update_flex_cube_config(flex_cube_config, @update_attrs)
      assert flex_cube_config.action_type == "some updated action_type"
      assert flex_cube_config.dr_cr == "some updated dr_cr"
      assert flex_cube_config.flex_cube_gl_code == "some updated flex_cube_gl_code"
      assert flex_cube_config.flex_cube_gl_id == 43
      assert flex_cube_config.flex_cube_gl_name == "some updated flex_cube_gl_name"
    end

    test "update_flex_cube_config/2 with invalid data returns error changeset" do
      flex_cube_config = flex_cube_config_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_flex_cube_config(flex_cube_config, @invalid_attrs)
      assert flex_cube_config == EndOfDay.get_flex_cube_config!(flex_cube_config.id)
    end

    test "delete_flex_cube_config/1 deletes the flex_cube_config" do
      flex_cube_config = flex_cube_config_fixture()
      assert {:ok, %FlexCubeConfig{}} = EndOfDay.delete_flex_cube_config(flex_cube_config)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_flex_cube_config!(flex_cube_config.id) end
    end

    test "change_flex_cube_config/1 returns a flex_cube_config changeset" do
      flex_cube_config = flex_cube_config_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_flex_cube_config(flex_cube_config)
    end
  end

  describe "calendars" do
    alias LoanSavingsSystem.EndOfDay.Calendar

    @valid_attrs %{createdby_id: 42, end_date: ~D[2010-04-17], name: "some name", start_date: ~D[2010-04-17]}
    @update_attrs %{createdby_id: 43, end_date: ~D[2011-05-18], name: "some updated name", start_date: ~D[2011-05-18]}
    @invalid_attrs %{createdby_id: nil, end_date: nil, name: nil, start_date: nil}

    def calendar_fixture(attrs \\ %{}) do
      {:ok, calendar} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_calendar()

      calendar
    end

    test "list_calendars/0 returns all calendars" do
      calendar = calendar_fixture()
      assert EndOfDay.list_calendars() == [calendar]
    end

    test "get_calendar!/1 returns the calendar with given id" do
      calendar = calendar_fixture()
      assert EndOfDay.get_calendar!(calendar.id) == calendar
    end

    test "create_calendar/1 with valid data creates a calendar" do
      assert {:ok, %Calendar{} = calendar} = EndOfDay.create_calendar(@valid_attrs)
      assert calendar.createdby_id == 42
      assert calendar.end_date == ~D[2010-04-17]
      assert calendar.name == "some name"
      assert calendar.start_date == ~D[2010-04-17]
    end

    test "create_calendar/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_calendar(@invalid_attrs)
    end

    test "update_calendar/2 with valid data updates the calendar" do
      calendar = calendar_fixture()
      assert {:ok, %Calendar{} = calendar} = EndOfDay.update_calendar(calendar, @update_attrs)
      assert calendar.createdby_id == 43
      assert calendar.end_date == ~D[2011-05-18]
      assert calendar.name == "some updated name"
      assert calendar.start_date == ~D[2011-05-18]
    end

    test "update_calendar/2 with invalid data returns error changeset" do
      calendar = calendar_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_calendar(calendar, @invalid_attrs)
      assert calendar == EndOfDay.get_calendar!(calendar.id)
    end

    test "delete_calendar/1 deletes the calendar" do
      calendar = calendar_fixture()
      assert {:ok, %Calendar{}} = EndOfDay.delete_calendar(calendar)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_calendar!(calendar.id) end
    end

    test "change_calendar/1 returns a calendar changeset" do
      calendar = calendar_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_calendar(calendar)
    end
  end

  describe "holidays" do
    alias LoanSavingsSystem.EndOfDay.Holiday

    @valid_attrs %{calendar_id: 42, from_date: ~D[2010-04-17], maturity_payments_rescheduled_to: ~D[2010-04-17], name: "some name", status: "some status", to_date: ~D[2010-04-17]}
    @update_attrs %{calendar_id: 43, from_date: ~D[2011-05-18], maturity_payments_rescheduled_to: ~D[2011-05-18], name: "some updated name", status: "some updated status", to_date: ~D[2011-05-18]}
    @invalid_attrs %{calendar_id: nil, from_date: nil, maturity_payments_rescheduled_to: nil, name: nil, status: nil, to_date: nil}

    def holiday_fixture(attrs \\ %{}) do
      {:ok, holiday} =
        attrs
        |> Enum.into(@valid_attrs)
        |> EndOfDay.create_holiday()

      holiday
    end

    test "list_holidays/0 returns all holidays" do
      holiday = holiday_fixture()
      assert EndOfDay.list_holidays() == [holiday]
    end

    test "get_holiday!/1 returns the holiday with given id" do
      holiday = holiday_fixture()
      assert EndOfDay.get_holiday!(holiday.id) == holiday
    end

    test "create_holiday/1 with valid data creates a holiday" do
      assert {:ok, %Holiday{} = holiday} = EndOfDay.create_holiday(@valid_attrs)
      assert holiday.calendar_id == 42
      assert holiday.from_date == ~D[2010-04-17]
      assert holiday.maturity_payments_rescheduled_to == ~D[2010-04-17]
      assert holiday.name == "some name"
      assert holiday.status == "some status"
      assert holiday.to_date == ~D[2010-04-17]
    end

    test "create_holiday/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EndOfDay.create_holiday(@invalid_attrs)
    end

    test "update_holiday/2 with valid data updates the holiday" do
      holiday = holiday_fixture()
      assert {:ok, %Holiday{} = holiday} = EndOfDay.update_holiday(holiday, @update_attrs)
      assert holiday.calendar_id == 43
      assert holiday.from_date == ~D[2011-05-18]
      assert holiday.maturity_payments_rescheduled_to == ~D[2011-05-18]
      assert holiday.name == "some updated name"
      assert holiday.status == "some updated status"
      assert holiday.to_date == ~D[2011-05-18]
    end

    test "update_holiday/2 with invalid data returns error changeset" do
      holiday = holiday_fixture()
      assert {:error, %Ecto.Changeset{}} = EndOfDay.update_holiday(holiday, @invalid_attrs)
      assert holiday == EndOfDay.get_holiday!(holiday.id)
    end

    test "delete_holiday/1 deletes the holiday" do
      holiday = holiday_fixture()
      assert {:ok, %Holiday{}} = EndOfDay.delete_holiday(holiday)
      assert_raise Ecto.NoResultsError, fn -> EndOfDay.get_holiday!(holiday.id) end
    end

    test "change_holiday/1 returns a holiday changeset" do
      holiday = holiday_fixture()
      assert %Ecto.Changeset{} = EndOfDay.change_holiday(holiday)
    end
  end
end
