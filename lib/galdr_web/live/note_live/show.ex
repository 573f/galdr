defmodule GaldrWeb.NoteLive.Show do
  use GaldrWeb, :live_view

  alias Galdr.Knowledge

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Note")
     |> assign(:note, Knowledge.get_note!(id))
     |> assign(:notes, Knowledge.list_notes())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    note = Knowledge.get_note!(id)
    Knowledge.update_last_accessed(note)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, note))
     |> assign(:note, note)}
  end

  defp page_title(:show, note), do: note.title
  defp page_title(:edit, note), do: "Edit #{note.title}"
end
