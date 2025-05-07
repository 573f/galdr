# lib/galdr_web/live/note_live/form_component.ex
defmodule GaldrWeb.NoteLive.FormComponent do
  use GaldrWeb, :live_component

  alias Galdr.Knowledge

  @impl true
  def update(%{note: note} = assigns, socket) do
    changeset = Knowledge.change_note(note)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      socket.assigns.note
      |> Knowledge.change_note(note_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Knowledge.update_note(socket.assigns.note, note_params) do
      {:ok, _note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Knowledge rune updated")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_note(socket, :new, note_params) do
    IO.inspect(socket.assigns)

    case Knowledge.create_note(note_params) do
      {:ok, note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Knowledge rune created")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
