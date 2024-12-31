defmodule StampMapWeb.UserLoginLive do
  use StampMapWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Logg inn
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Brukernavn" required />
        <.input field={@form[:password]} type="password" label="Passord" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Hold meg innlogget" />
        </:actions>
        <:actions>
          <.button phx-disable-with="Logger inn..." class="w-full">
            Logg inn <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
