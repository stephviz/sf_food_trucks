defmodule SFFoodTrucks.Vendors do
  @moduledoc """
  The Vendors context.
  """

  import Ecto.Query, warn: false
  alias SFFoodTrucks.Repo

  alias SFFoodTrucks.Vendors.Vendor

  @doc """
  Returns the list of vendors.

  ## Examples

      iex> list()
      [%Vendor{}, ...]

  """
  def list do
    Repo.all(Vendor)
  end

  @doc """
  Returns a single vendor.

  ## Examples

      iex> get(123)
      {:ok, %Vendor{}}

      iex> get(0)
      {:error, :not_found}

  """
  def get(id) do
    Repo.get(Vendor, id)
    |> case do
      nil -> {:error, :not_found}
      v -> {:ok, v}
    end
  end

  @doc """
  Gets a single vendor.

  Raises `Ecto.NoResultsError` if the Vendor does not exist.

  ## Examples

      iex> get!(123)
      %Vendor{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Vendor, id)

  @doc """
  Creates a vendor.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Vendor{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Vendor{}
    |> Vendor.changeset(attrs)
    |> Repo.insert(
      on_conflict: :replace_all,
      conflict_target: :location_id,
      returning: true
    )
  end

  @doc """
  Updates a vendor.

  ## Examples

      iex> update(vendor, %{field: new_value})
      {:ok, %Vendor{}}

      iex> update(vendor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Vendor{} = vendor, attrs) do
    changeset = Vendor.changeset(vendor, attrs)

    if changeset.valid? and changeset.changes == %{} do
      {:error, :no_valid_changes}
    else
      Repo.update(changeset)
    end
  end

  @doc """
  Deletes a vendor.

  ## Examples

      iex> delete(vendor)
      {:ok, %Vendor{}}

      iex> delete(vendor)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Vendor{} = vendor) do
    Repo.delete(vendor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vendor changes.

  ## Examples

      iex> change(vendor)
      %Ecto.Changeset{data: %Vendor{}}

  """
  def change(%Vendor{} = vendor, attrs \\ %{}) do
    Vendor.changeset(vendor, attrs)
  end
end
