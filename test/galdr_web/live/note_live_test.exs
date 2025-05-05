defmodule GaldrWeb.NoteLiveTest do
  use GaldrWeb.ConnCase

  import Phoenix.LiveViewTest
  import Galdr.KnowledgeFixtures

  @create_attrs %{position: 42, status: "some status", title: "some title", content: "some content", last_accessed: "2025-05-04T02:35:00Z"}
  @update_attrs %{position: 43, status: "some updated status", title: "some updated title", content: "some updated content", last_accessed: "2025-05-05T02:35:00Z"}
  @invalid_attrs %{position: nil, status: nil, title: nil, content: nil, last_accessed: nil}
  defp create_note(_) do
    note = note_fixture()

    %{note: note}
  end

  describe "Index" do
    setup [:create_note]

    test "lists all notes", %{conn: conn, note: note} do
      {:ok, _index_live, html} = live(conn, ~p"/notes")

      assert html =~ "Listing Notes"
      assert html =~ note.title
    end

    test "saves new note", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Note")
               |> render_click()
               |> follow_redirect(conn, ~p"/notes/new")

      assert render(form_live) =~ "New Note"

      assert form_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#note-form", note: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notes")

      html = render(index_live)
      assert html =~ "Note created successfully"
      assert html =~ "some title"
    end

    test "updates note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#notes-#{note.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notes/#{note}/edit")

      assert render(form_live) =~ "Edit Note"

      assert form_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#note-form", note: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notes")

      html = render(index_live)
      assert html =~ "Note updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes note in listing", %{conn: conn, note: note} do
      {:ok, index_live, _html} = live(conn, ~p"/notes")

      assert index_live |> element("#notes-#{note.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#notes-#{note.id}")
    end
  end

  describe "Show" do
    setup [:create_note]

    test "displays note", %{conn: conn, note: note} do
      {:ok, _show_live, html} = live(conn, ~p"/notes/#{note}")

      assert html =~ "Show Note"
      assert html =~ note.title
    end

    test "updates note and returns to show", %{conn: conn, note: note} do
      {:ok, show_live, _html} = live(conn, ~p"/notes/#{note}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/notes/#{note}/edit?return_to=show")

      assert render(form_live) =~ "Edit Note"

      assert form_live
             |> form("#note-form", note: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#note-form", note: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/notes/#{note}")

      html = render(show_live)
      assert html =~ "Note updated successfully"
      assert html =~ "some updated title"
    end
  end
end
