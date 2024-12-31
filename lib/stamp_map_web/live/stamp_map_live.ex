defmodule StampMapWeb.StampMapLive do
  use StampMapWeb, :live_view

  alias StampMap.Stamps

  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    # JS.dispatch()
    current_user =
      if Map.has_key?(socket.assigns, :current_user) do
        stamps = Stamps.get_stamps_by_user_id(socket.assigns.current_user.id)

        Map.merge(socket.assigns.current_user, %{stamps: stamps})
      end

    {:ok, assign(socket, current_user: current_user)}
  end
end
