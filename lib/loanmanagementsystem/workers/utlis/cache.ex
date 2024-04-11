defmodule Loanmanagementsystem.Workers.Utlis.Cache do

  # ================= PUT FUNCTIONS ================

    def put(data, :search) do
      Cachex.put(:store, :search_data, data)
    end

    def put(data, :uploads) do
      Cachex.put(:store, :uploads, data)
    end

    def put(data, :role) do
      Cachex.put(:store, :role_id, data)
    end


    def put(data, :login) do
      Cachex.put(:store, :params, data)
    end

    def put(data, :assigns) do
      Cachex.put(:store, :assigns, data)
    end



     # ================= GET FUNCTIONS ================

    def get(:search) do
      { :ok, value} = Cachex.get(:store, :search_data)
      value
    end

    def get(:uploads) do
      { :ok, value} = Cachex.get(:store, :uploads)
      value
    end

    def get(:role) do
      { :ok, value} = Cachex.get(:store, :role_id)
      value
    end

    # Loanmanagementsystem.Workers.Utlis.Cache.get(:role)
    def get(:login) do
      { :ok, value} = Cachex.get(:store, :params)
      value
    end

    def get(:assigns) do
      { :ok, value} = Cachex.get(:store, :assigns)
      value
    end


    # ================= DELETE FUNCTIONS ================

    def delete(:search) do
      Cachex.del(:store, :search_data)
    end

    def delete(:uploads) do
      Cachex.del(:store, :uploads)
    end

    def delete(:role) do
      Cachex.del(:store, :role_id)
    end

    def delete(:login) do
      Cachex.del(:store, :params)
    end


    def delete(:assigns) do
      Cachex.del(:store, :assigns)
    end


end
