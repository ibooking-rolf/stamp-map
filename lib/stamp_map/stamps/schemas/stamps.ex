defmodule StampMap.Stamps.Schemas.Stamps do
  use Ecto.Schema

  import Ecto.Changeset

  alias StampMap.Accounts.User
  alias StampMap.Stamps.Schemas.StampImages

  alias __MODULE__

  schema "stamps" do
    belongs_to :user, User
    field :title, :string
    field :description, :string
    field :url, :string
    field :longitude, :float
    field :latitude, :float
    field :active, :boolean, default: true

    timestamps(type: :utc_datetime)

    has_many(:images, StampImages, foreign_key: :stamp_id)
  end

  def changeset(%Stamps{} = stamps, attrs) do
    stamps
    |> cast(attrs, [
      :user_id,
      :title,
      :description,
      :url,
      :longitude,
      :latitude,
      :active
    ])
  end
end
