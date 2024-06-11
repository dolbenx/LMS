defmodule Loanmanagementsystem.Configs do
  @moduledoc """
  The Configs context.
  """
  @pagination [page_size: 10]
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Configs.Titles

  @doc """
  Returns the list of tbl_titles.

  ## Examples

      iex> list_tbl_titles()
      [%Titles{}, ...]

  """
  def list_tbl_titles do
    Repo.all(Titles)
  end

  @doc """
  Gets a single titles.

  Raises `Ecto.NoResultsError` if the Titles does not exist.

  ## Examples

      iex> get_titles!(123)
      %Titles{}

      iex> get_titles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_titles!(id), do: Repo.get!(Titles, id)

  @doc """
  Creates a titles.

  ## Examples

      iex> create_titles(%{field: value})
      {:ok, %Titles{}}

      iex> create_titles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_titles(attrs \\ %{}) do
    %Titles{}
    |> Titles.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a titles.

  ## Examples

      iex> update_titles(titles, %{field: new_value})
      {:ok, %Titles{}}

      iex> update_titles(titles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_titles(%Titles{} = titles, attrs) do
    titles
    |> Titles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a titles.

  ## Examples

      iex> delete_titles(titles)
      {:ok, %Titles{}}

      iex> delete_titles(titles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_titles(%Titles{} = titles) do
    Repo.delete(titles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking titles changes.

  ## Examples

      iex> change_titles(titles)
      %Ecto.Changeset{data: %Titles{}}

  """
  def change_titles(%Titles{} = titles, attrs \\ %{}) do
    Titles.changeset(titles, attrs)
  end

  def list_titles(search_params) do
    Titles
    |> where([u], u.status != "DELETED")
    |> handle_title_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_title_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_title_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        title_isearch_filter(query, Utils.sanitize_term(value))

      {"title", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("lower(?) LIKE lower(?)", a.name, ^Utils.sanitize_term(value)))

      {"description", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("lower(?) LIKE lower(?)", a.description, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("lower(?) LIKE lower(?)", a.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("CAST(? AS DATE) >= ?", a.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [a], fragment("CAST(? AS DATE) <= ?", a.inserted_at, ^value))



      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp title_isearch_filter(query, search_term) do
    where(
      query,
      [a],
      fragment("lower(?) LIKE lower(?)", a.title, ^search_term) or
      fragment("lower(?) LIKE lower(?)", a.description, ^search_term) or
      fragment("lower(?) LIKE lower(?)", a.status, ^search_term)


    )
  end


  defp compose_title_select(query) do
    query
    |> select(
      [u],
      map(u, [
        :id,
          :title,
          :description,
          :status,
          :inserted_at,
          :updated_at
      ])
    )
  end

end
