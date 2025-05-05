defmodule GaldrWeb.NoteLive.Form do
  use GaldrWeb, :live_view

  alias Galdr.Knowledge
  alias Galdr.Knowledge.Note

  @impl true
  def render(assigns) do
    ~H"""
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage note records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="note-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:position]} type="number" label="Position" />
        <.input field={@form[:last_accessed]} type="datetime-local" label="Last accessed" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Note</.button>
          <.button navigate={return_path(@return_to, @note)}>Cancel</.button>
        </footer>
      </.form>

      <.back navigate={return_path(@return_to, @note)}>Back</.back>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    note = Knowledge.get_note!(id)

    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, note)
    |> assign(:form, to_form(Knowledge.change_note(note)))
  end

  defp apply_action(socket, :new, _params) do
    note = %Note{}

    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, note)
    |> assign(:form, to_form(Knowledge.change_note(note)))
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset = Knowledge.change_note(socket.assigns.note, note_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.live_action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Knowledge.update_note(socket.assigns.note, note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, note))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_note(socket, :new, note_params) do
    case Knowledge.create_note(note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, note))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _note), do: ~p"/notes"
  defp return_path("show", note), do: ~p"/notes/#{note}"
end
