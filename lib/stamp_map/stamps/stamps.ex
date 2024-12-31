defmodule StampMap.Stamps do
  import Ecto.Query

  alias StampMap.Repo

  alias StampMap.Stamps.Schemas.Stamps

  def get_stamps_by_user_id(user_id) do
    from(
      stamp in Stamps,
      where: stamp.user_id == ^user_id,
      where: stamp.active,
      preload: [:images]
    )
    |> Repo.all()
  end

  def insert_stamp(stamp) do
    %Stamps{}
    |> Stamps.changeset(stamp)
    |> Repo.insert()
  end
end
