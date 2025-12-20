defmodule StampMapWeb.StampMapLive do
  use StampMapWeb, :live_view

  alias StampMap.Stamps

  def mount(_params, _session, socket) do
    {current_user, access_token} =
      if Map.has_key?(socket.assigns, :current_user) do
        stamps = Stamps.get_stamps_by_user_id(socket.assigns.current_user.id)

        mapbox_access_token =
          Application.get_env(:stamp_map, :mapbox)
          |> Keyword.get(:access_token)

        {Map.merge(socket.assigns.current_user, %{stamps: stamps}), mapbox_access_token}
      else
        {nil, nil}
      end

    {:ok,
     assign(socket,
       current_user: current_user,
       access_token: access_token,
       add_new_stamp?: false,
       add_stamp_form: to_form(%{}), as: Stamps.Schemas.Stamps,
       search_form: to_form(%{"query" => ""})
     )}
  end

  def handle_event("stamp_search", %{"query" => search_query}, socket) do
    IO.inspect(search_query)
    {:noreply, socket}
  end

  def handle_event("add-stamp", _params, socket) do
    {:noreply, assign(socket, :add_new_stamp?, true)}
  end

  def handle_event("save-stamp", unsigned_params, socket) do
    current_user = socket.assigns.current_user

    Map.merge(unsigned_params, %{"user_id" => current_user.id})
    |> Stamps.insert_stamp()

    stamps = Stamps.get_stamps_by_user_id(socket.assigns.current_user.id)

    current_user = Map.merge(current_user, %{stamps: stamps})

    {:noreply, assign(socket, current_user: current_user, add_new_stamp?: false, add_stamp_form: to_form(%{}), as: Stamps.Schemas.Stamps)}
  end

  def handle_event("new_stamp_validation", %{"_target" => ["reset"]}, socket) do
    {:noreply, assign(socket, add_new_stamp?: false, add_stamp_form: to_form(%{}), as: Stamps.Schemas.Stamps)}
  end

  def handle_event("new_stamp_validation", values, socket) do
    {:noreply, assign(socket, add_stamp_form: to_form(values))}
  end

  def handle_event("select_stamp", %{"stampid" => stamp_id}, socket) do
    selected_stamp = Stamps.get_stamp(stamp_id)

    {:noreply,
     assign(socket, selected_stamp: selected_stamp)
     |> push_event("add-marker", %{
       longitude: selected_stamp.longitude,
       latitude: selected_stamp.latitude
     })}
  end
end
