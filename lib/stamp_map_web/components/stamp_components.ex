defmodule StampMapWeb.Components do
  use Phoenix.Component

  import StampMapWeb.CoreComponents

  attr :form, :any, required: true
  def add_new_stamp(assigns) do
    ~H"""
    <h1>Nytt frimerke</h1>
    <.simple_form class="mb-6" for={@form} phx-change="new_stamp_validation">
      <.input field={@form[:title]} label="Tittel/navn" placeholder="" />
      <.input field={@form[:description]} label="Beskrivelse" placeholder="" type="textarea" />
      <.input field={@form[:url]} label="URL" placeholder="" />

      <div class="w-full inline-flex flex-row justify-between">
        <.input field={@form[:longitude]} disabled label="Lengdegrad" placeholder="" />
        <.input field={@form[:latitude]} disabled label="Breddegrad" placeholder="" />
      </div>
    </.simple_form>
    """
  end
end
