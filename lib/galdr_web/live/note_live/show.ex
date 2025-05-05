defmodule GaldrWeb.NoteLive.Show do
  alias Galdr.Knowledge.Note
  use GaldrWeb, :live_view

  alias Galdr.Knowledge

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        Note {@note.id}
        <:subtitle>This is a note record from your database.</:subtitle>
        <:actions>
          <.link navigate={~p"/notes/#{@note}/edit?return_to=show"}>
            Edit Note
          </.link>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@note.title}</:item>
        <:item title="Content">{@note.content}</:item>
        <:item title="Status">{@note.status}</:item>
        <:item title="Position">{@note.position}</:item>
        <:item title="Last accessed">{@note.last_accessed}</:item>
      </.list>

      <.back navigate={~p"/notes"}> =Back to notes</.back>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Note")
     |> assign(:note, Knowledge.get_note!(id))}
  end
end
