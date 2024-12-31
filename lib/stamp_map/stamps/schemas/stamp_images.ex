defmodule StampMap.Stamps.Schemas.StampImages do
  use Ecto.Schema

  import Ecto.Changeset

  alias StampMap.Stamps.Schemas.Stamps

  alias __MODULE__

  schema "stamp_images" do
    belongs_to :stamp, Stamps
    field :title, :string
    field :url, :string
    field :thumbnail, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(%StampImages{} = stamp_image, attrs) do
    stamp_image
    |> cast(attrs, [
      :stamp_id,
      :title,
      :url,
      :thumbnail
    ])
  end
end
