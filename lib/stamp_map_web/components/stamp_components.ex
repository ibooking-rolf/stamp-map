defmodule StampMapWeb.Components do
  use Phoenix.Component

  import StampMapWeb.CoreComponents

  attr :form, :any, required: true

  def add_new_stamp(assigns) do
    ~H"""
    <h1>Nytt frimerke</h1>
    <.simple_form class="mb-6" for={@form} phx-change="new_stamp_validation" phx-submit="save-stamp">
      <.input field={@form[:title]} label="Tittel/navn" placeholder="" />
      <.input field={@form[:description]} label="Beskrivelse" placeholder="" type="textarea" />
      <.input field={@form[:url]} label="URL" placeholder="" />

      <div class="w-full inline-flex flex-row justify-between">
        <.input field={@form[:longitude]} readonly label="Lengdegrad" placeholder="" />
        <.input field={@form[:latitude]} readonly label="Breddegrad" placeholder="" />
      </div>

      <:actions>
        <div class="flex absolute bottom-0 right-0 justify-between gap-4 w-full rounded-xl">
          <.button class="w-full h-full" type="reset" name="reset">
            Avbryt
          </.button>

          <.button class="w-full h-full">
            Lagre
          </.button>
        </div>
      </:actions>
    </.simple_form>
    """
  end
end
