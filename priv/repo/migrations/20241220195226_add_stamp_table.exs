defmodule StampMap.Repo.Migrations.AddStampTable do
  use Ecto.Migration

  def change do
    create table(:stamps) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :title, :string, null: false
      add :description, :string
      add :url, :string
      add :longitude, :float
      add :latitude, :float
      add :active, :boolean, null: false, default: true

      timestamps(type: :utc_datetime)
    end

    create table(:stamp_images) do
      add :stamp_id, references(:stamps, on_delete: :delete_all), null: false
      add :title, :string
      add :url, :string, null: false
      add :thumbnail, :string

      timestamps(type: :utc_datetime)
    end
  end
end
