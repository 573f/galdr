defmodule GaldrWeb.NoteLive.Index do
  use GaldrWeb, :live_view

  alias Galdr.Knowledge
  alias Galdr.Knowledge.Note

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:notes, Knowledge.list_notes())
     |> assign(:selected_note, nil)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Galdr - Your Knowledge")
    |> assign(:note, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Rune")
    |> assign(:note, %Note{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    note = Knowledge.get_note!(id)
    Knowledge.update_last_accessed(note)

    socket
    |> assign(:page_title, "Edit #{note.title}")
    |> assign(:note, note)
    |> assign(:selected_note, note)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Knowledge.get_note!(id)
    {:ok, _} = Knowledge.delete_note(note)

    notes = Knowledge.list_notes()

    selected_note =
      if socket.assigns.selected_note && socket.assigns.selected_note.id == note.id do
        nil
      else
        socket.assigns.selected_note
      end

    {:noreply, assign(socket, notes: notes, selected_note: selected_note)}
  end
end
