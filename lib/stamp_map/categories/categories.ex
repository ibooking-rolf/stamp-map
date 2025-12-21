defmodule StampMap.Categories do
  import Ecto.Query

  alias StampMap.Repo

  alias StampMap.Categories.Schemas.Category

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

  def insert_category(category) do
    %Category{}
    |> Category.changeset(category)
    |> Repo.insert()
  end
end
