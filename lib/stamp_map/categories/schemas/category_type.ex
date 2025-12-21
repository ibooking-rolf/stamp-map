defmodule StampMap.Categories.Schemas.CategoryType do
  use Ecto.Schema

  import Ecto.Changeset

  alias StampMap.Categories.Schemas.Category

  alias __MODULE__

  schema "category_type" do
    field(:type_name, :string)

    has_many(:categories, Category)
  end

  def changeset(%CategoryType{} = category_type, attrs \\ %{}) do
    category_type
    |> cast(attrs, [:type_name])
    |> validate_required([:type_name])
  end
end
