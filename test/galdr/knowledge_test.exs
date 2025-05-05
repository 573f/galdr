defmodule Galdr.KnowledgeTest do
  use Galdr.DataCase

  alias Galdr.Knowledge

  describe "notes" do
    alias Galdr.Knowledge.Note

    import Galdr.KnowledgeFixtures

    @invalid_attrs %{position: nil, status: nil, title: nil, content: nil, last_accessed: nil}

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Knowledge.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Knowledge.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      valid_attrs = %{position: 42, status: "some status", title: "some title", content: "some content", last_accessed: ~U[2025-05-04 02:35:00Z]}

      assert {:ok, %Note{} = note} = Knowledge.create_note(valid_attrs)
      assert note.position == 42
      assert note.status == "some status"
      assert note.title == "some title"
      assert note.content == "some content"
      assert note.last_accessed == ~U[2025-05-04 02:35:00Z]
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Knowledge.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      update_attrs = %{position: 43, status: "some updated status", title: "some updated title", content: "some updated content", last_accessed: ~U[2025-05-05 02:35:00Z]}

      assert {:ok, %Note{} = note} = Knowledge.update_note(note, update_attrs)
      assert note.position == 43
      assert note.status == "some updated status"
      assert note.title == "some updated title"
      assert note.content == "some updated content"
      assert note.last_accessed == ~U[2025-05-05 02:35:00Z]
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Knowledge.update_note(note, @invalid_attrs)
      assert note == Knowledge.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Knowledge.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Knowledge.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Knowledge.change_note(note)
    end
  end
end
