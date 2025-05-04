defmodule Galdr.Knowledge.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :title, :string
    field :content, :string
    field :status, :string, default: "active" # active, archived
    field :position, :integer
    field :last_accessed, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :content, :status, :position, :last_accessed])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
