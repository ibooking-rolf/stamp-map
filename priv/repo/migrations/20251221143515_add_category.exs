defmodule StampMap.Repo.Migrations.AddCategory do
  use Ecto.Migration

  def change do
    create table(:category_type) do
      add :type_name, :string, null: false
    end

    create unique_index(:category_type, [:type_name])

    create table(:category) do
      add :category_type_id, references(:category_type, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :name, :string, null: false
      add :color, :string
      add :active, :boolean, null: false, default: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:category, [:category_type_id, :user_id, :name])

    alter table(:stamps) do
      add :category_id, references(:category)
      add :collection_id, references(:category)
      add :series_id, references(:category)

      add :issued, :date
    end
  end
end
