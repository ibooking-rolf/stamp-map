defmodule StampMap.Categories.Schemas.Category do
  use Ecto.Schema

  import Ecto.Changeset

  alias StampMap.Accounts.User
  alias StampMap.Categories.Schemas.CategoryType
  alias StampMap.Stamps.Schemas.Stamps

  alias __MODULE__

  schema "category" do
    belongs_to(:category_type, CategoryType)
    belongs_to(:user, User)
    field(:name, :string)
    field(:color, :string)
    field(:active, :boolean, default: true)

    timestamps(type: :utc_datetime)

    has_many(:category_stamps, Stamps, foreign_key: :category_id)
    has_many(:collection_stamps, Stamps, foreign_key: :collection_id)
    has_many(:series_stamps, Stamps, foreign_key: :series_id)
  end

  def changeset(%Category{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [
      :category_type_id,
      :user_id,
      :name,
      :color,
      :active
    ])
    |> validate_required([
      :category_type_id,
      :name
    ])
  end
end
