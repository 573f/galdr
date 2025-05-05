defmodule GaldrWeb.NoteLive.Index do
  use GaldrWeb, :live_view

  alias Galdr.Knowledge

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        Listing Notes
        <:actions>
          <.link navigate={~p"/notes/new"}>
            <.icon name="hero-plus" /> New Note
          </.link>
        </:actions>
      </.header>

      <.table
        id="notes"
        rows={@streams.notes}
        row_click={fn {_id, note} -> JS.navigate(~p"/notes/#{note}") end}
      >
        <:col :let={{_id, note}} label="Title">{note.title}</:col>
        <:col :let={{_id, note}} label="Content">{note.content}</:col>
        <:col :let={{_id, note}} label="Status">{note.status}</:col>
        <:col :let={{_id, note}} label="Position">{note.position}</:col>
        <:col :let={{_id, note}} label="Last accessed">{note.last_accessed}</:col>
        <:action :let={{_id, note}}>
          <div class="sr-only">
            <.link navigate={~p"/notes/#{note}"}>Show</.link>
          </div>
          <.link navigate={~p"/notes/#{note}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, note}}>
          <.link
            phx-click={JS.push("delete", value: %{id: note.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Notes")
     |> stream(:notes, Knowledge.list_notes())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Knowledge.get_note!(id)
    {:ok, _} = Knowledge.delete_note(note)

    {:noreply, stream_delete(socket, :notes, note)}
  end
end
