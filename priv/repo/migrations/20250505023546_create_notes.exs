defmodule Galdr.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :content, :text
      add :status, :string
      add :position, :integer
      add :last_accessed, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
