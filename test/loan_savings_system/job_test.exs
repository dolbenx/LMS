defmodule LoanSavingsSystem.JobTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Job

  describe "tbl_jobs" do
    alias LoanSavingsSystem.Job.Jobs

    @valid_attrs %{client_id: "some client_id", cron_expression: "some cron_expression", first_run_datetime: "some first_run_datetime", is_completed: "some is_completed", is_running: "some is_running", job_id: "some job_id", job_name: "some job_name", next_run_datetime: "some next_run_datetime", priority: "some priority", status: "some status"}
    @update_attrs %{client_id: "some updated client_id", cron_expression: "some updated cron_expression", first_run_datetime: "some updated first_run_datetime", is_completed: "some updated is_completed", is_running: "some updated is_running", job_id: "some updated job_id", job_name: "some updated job_name", next_run_datetime: "some updated next_run_datetime", priority: "some updated priority", status: "some updated status"}
    @invalid_attrs %{client_id: nil, cron_expression: nil, first_run_datetime: nil, is_completed: nil, is_running: nil, job_id: nil, job_name: nil, next_run_datetime: nil, priority: nil, status: nil}

    def jobs_fixture(attrs \\ %{}) do
      {:ok, jobs} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Job.create_jobs()

      jobs
    end

    test "list_tbl_jobs/0 returns all tbl_jobs" do
      jobs = jobs_fixture()
      assert Job.list_tbl_jobs() == [jobs]
    end

    test "get_jobs!/1 returns the jobs with given id" do
      jobs = jobs_fixture()
      assert Job.get_jobs!(jobs.id) == jobs
    end

    test "create_jobs/1 with valid data creates a jobs" do
      assert {:ok, %Jobs{} = jobs} = Job.create_jobs(@valid_attrs)
      assert jobs.client_id == "some client_id"
      assert jobs.cron_expression == "some cron_expression"
      assert jobs.first_run_datetime == "some first_run_datetime"
      assert jobs.is_completed == "some is_completed"
      assert jobs.is_running == "some is_running"
      assert jobs.job_id == "some job_id"
      assert jobs.job_name == "some job_name"
      assert jobs.next_run_datetime == "some next_run_datetime"
      assert jobs.priority == "some priority"
      assert jobs.status == "some status"
    end

    test "create_jobs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Job.create_jobs(@invalid_attrs)
    end

    test "update_jobs/2 with valid data updates the jobs" do
      jobs = jobs_fixture()
      assert {:ok, %Jobs{} = jobs} = Job.update_jobs(jobs, @update_attrs)
      assert jobs.client_id == "some updated client_id"
      assert jobs.cron_expression == "some updated cron_expression"
      assert jobs.first_run_datetime == "some updated first_run_datetime"
      assert jobs.is_completed == "some updated is_completed"
      assert jobs.is_running == "some updated is_running"
      assert jobs.job_id == "some updated job_id"
      assert jobs.job_name == "some updated job_name"
      assert jobs.next_run_datetime == "some updated next_run_datetime"
      assert jobs.priority == "some updated priority"
      assert jobs.status == "some updated status"
    end

    test "update_jobs/2 with invalid data returns error changeset" do
      jobs = jobs_fixture()
      assert {:error, %Ecto.Changeset{}} = Job.update_jobs(jobs, @invalid_attrs)
      assert jobs == Job.get_jobs!(jobs.id)
    end

    test "delete_jobs/1 deletes the jobs" do
      jobs = jobs_fixture()
      assert {:ok, %Jobs{}} = Job.delete_jobs(jobs)
      assert_raise Ecto.NoResultsError, fn -> Job.get_jobs!(jobs.id) end
    end

    test "change_jobs/1 returns a jobs changeset" do
      jobs = jobs_fixture()
      assert %Ecto.Changeset{} = Job.change_jobs(jobs)
    end
  end

  describe "tbl_job_history" do
    alias LoanSavingsSystem.Job.Job_history

    @valid_attrs %{client_id: "some client_id", end_datetime: "some end_datetime", error_log: "some error_log", is_system_ran: "some is_system_ran", job_id: "some job_id", start_datetime: "some start_datetime", status: "some status"}
    @update_attrs %{client_id: "some updated client_id", end_datetime: "some updated end_datetime", error_log: "some updated error_log", is_system_ran: "some updated is_system_ran", job_id: "some updated job_id", start_datetime: "some updated start_datetime", status: "some updated status"}
    @invalid_attrs %{client_id: nil, end_datetime: nil, error_log: nil, is_system_ran: nil, job_id: nil, start_datetime: nil, status: nil}

    def job_history_fixture(attrs \\ %{}) do
      {:ok, job_history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Job.create_job_history()

      job_history
    end

    test "list_tbl_job_history/0 returns all tbl_job_history" do
      job_history = job_history_fixture()
      assert Job.list_tbl_job_history() == [job_history]
    end

    test "get_job_history!/1 returns the job_history with given id" do
      job_history = job_history_fixture()
      assert Job.get_job_history!(job_history.id) == job_history
    end

    test "create_job_history/1 with valid data creates a job_history" do
      assert {:ok, %Job_history{} = job_history} = Job.create_job_history(@valid_attrs)
      assert job_history.client_id == "some client_id"
      assert job_history.end_datetime == "some end_datetime"
      assert job_history.error_log == "some error_log"
      assert job_history.is_system_ran == "some is_system_ran"
      assert job_history.job_id == "some job_id"
      assert job_history.start_datetime == "some start_datetime"
      assert job_history.status == "some status"
    end

    test "create_job_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Job.create_job_history(@invalid_attrs)
    end

    test "update_job_history/2 with valid data updates the job_history" do
      job_history = job_history_fixture()
      assert {:ok, %Job_history{} = job_history} = Job.update_job_history(job_history, @update_attrs)
      assert job_history.client_id == "some updated client_id"
      assert job_history.end_datetime == "some updated end_datetime"
      assert job_history.error_log == "some updated error_log"
      assert job_history.is_system_ran == "some updated is_system_ran"
      assert job_history.job_id == "some updated job_id"
      assert job_history.start_datetime == "some updated start_datetime"
      assert job_history.status == "some updated status"
    end

    test "update_job_history/2 with invalid data returns error changeset" do
      job_history = job_history_fixture()
      assert {:error, %Ecto.Changeset{}} = Job.update_job_history(job_history, @invalid_attrs)
      assert job_history == Job.get_job_history!(job_history.id)
    end

    test "delete_job_history/1 deletes the job_history" do
      job_history = job_history_fixture()
      assert {:ok, %Job_history{}} = Job.delete_job_history(job_history)
      assert_raise Ecto.NoResultsError, fn -> Job.get_job_history!(job_history.id) end
    end

    test "change_job_history/1 returns a job_history changeset" do
      job_history = job_history_fixture()
      assert %Ecto.Changeset{} = Job.change_job_history(job_history)
    end
  end
end
