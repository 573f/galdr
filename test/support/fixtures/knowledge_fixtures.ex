defmodule Galdr.KnowledgeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Galdr.Knowledge` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        content: "some content",
        last_accessed: ~U[2025-05-04 02:35:00Z],
        position: 42,
        status: "some status",
        title: "some title"
      })
      |> Galdr.Knowledge.create_note()

    note
  end
end
