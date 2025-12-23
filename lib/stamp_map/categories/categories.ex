defmodule StampMap.Categories do
  import Ecto.Query

  alias StampMap.Repo

  alias StampMap.Categories.Schemas.Category
  alias StampMap.Categories.Schemas.CategoryType

  def get_categories_by_user_id(user_id) do
    from(
      category in Category,
      where: category.user_id == ^user_id,
      or_where: is_nil(category.user_id),
      where: category.active == true,
      preload: [:category_type]
    )
    |> Repo.all()
  end

  def search_categories_by_name(user_id, name) do
    like_string = "%#{name}%"

    from(
      category in Category,
      where: category.user_id == ^user_id,
      or_where: is_nil(category.user_id),
      where: category.active == true,
      where: like(category.name, ^like_string),
      preload: [:category_type]
    )
    |> Repo.all()
  end

  def get_category_type_by_type_name(type_name) do
    from(
      category_type in CategoryType,
      where: category_type.type_name == ^type_name
    )
    |> Repo.one()
  end

  def get_category_type_by_type_name!(type_name) do
    from(
      category_type in CategoryType,
      where: category_type.type_name == ^type_name
    )
    |> Repo.one!()
  end

  def insert_category(category) do
    %Category{}
    |> Category.changeset(category)
    |> Repo.insert()
  end
end
