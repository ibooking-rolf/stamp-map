defmodule StampMapWeb.StampMapLive do
  use StampMapWeb, :live_view

  alias StampMap.Categories
  alias StampMap.Stamps

  @impl true
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
       add_stamp_form: to_form(Stamps.Schemas.Stamps.changeset(%Stamps.Schemas.Stamps{})),
       search_form: to_form(%{"query" => ""})
     )}
  end

  def handle_event("stamp_search", %{"query" => search_query}, socket) do
    IO.inspect(search_query)
    {:noreply, socket}
  end

  def handle_event("add-stamp", _params, socket) do
    categories =
      Categories.get_categories_by_user_id(socket.assigns.current_user.id)
      |> to_select_options(:categories)

    {:noreply,
     assign(socket, add_new_stamp?: true, categories: categories) |> push_event("add-stamp", %{})}
  end

  def handle_event("save-stamp", %{"stamps" => unsigned_params} = param, socket) do
    IO.inspect(param)
    current_user = socket.assigns.current_user

    Map.merge(unsigned_params, %{"user_id" => current_user.id})
    # |> Stamps.insert_stamp()

    stamps = Stamps.get_stamps_by_user_id(socket.assigns.current_user.id)

    current_user = Map.merge(current_user, %{stamps: stamps})

    {:noreply,
     assign(socket,
       current_user: current_user,
       add_new_stamp?: false,
       add_stamp_form: to_form(Stamps.Schemas.Stamps.changeset(%Stamps.Schemas.Stamps{}))
     )}
  end

  def handle_event(
        "new_stamp_validation",
        %{
          "_target" => ["stamps", "category_id"],
          "stamps" => %{"category_id_text_input" => <<"Legg til ", new_category_name::binary>>}
        },
        socket
      ) do
    stamp_category_type = Categories.get_category_type_by_type_name!("STAMP")

    category_attrs = %{
      category_type_id: stamp_category_type.id,
      user_id: socket.assigns.current_user.id,
      name: new_category_name
    }

    {:ok, new_category} = Categories.insert_category(category_attrs)

    form =
      socket.assigns.add_stamp_form.data
      |> Stamps.Schemas.Stamps.changeset(
        Map.merge(socket.assigns.add_stamp_form.params, %{
          "category_id" => {new_category.name, new_category.id}
        })
      )
      |> to_form(action: :validate)

    {:noreply, assign(socket, add_stamp_form: form)}
  end

  def handle_event("new_stamp_validation", %{"_target" => ["reset"]}, socket) do
    {:noreply,
     assign(socket,
       add_new_stamp?: false,
       add_stamp_form: to_form(Stamps.Schemas.Stamps.changeset(%Stamps.Schemas.Stamps{}))
     )
     |> push_event("new_stamp_reset", %{})}
  end

  def handle_event("new_stamp_validation", %{"stamps" => values}, socket) do
    form =
      %Stamps.Schemas.Stamps{}
      |> Stamps.Schemas.Stamps.changeset(values)
      |> to_form(action: :validate)

    {:noreply, assign(socket, add_stamp_form: form)}
  end

  def handle_event(
        "update-stamp-location",
        %{"new_lng_lat" => %{"lat" => lat, "lng" => lng}},
        socket
      ) do
    form =
      socket.assigns.add_stamp_form.data
      |> Stamps.Schemas.Stamps.changeset(
        Map.merge(socket.assigns.add_stamp_form.params, %{"longitude" => lng, "latitude" => lat})
      )
      |> to_form(action: :validate)

    {:noreply, assign(socket, add_stamp_form: form)}
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

  @impl true
  def handle_event("live_select_change", %{"text" => text, "id" => live_select_id}, socket) do
    categories =
      Categories.search_categories_by_name(socket.assigns.current_user.id, text)
      |> to_select_options(:categories)
      |> Kernel.++([{"Legg til #{text}", nil}])

    send_update(LiveSelect.Component, id: live_select_id, options: categories)

    {:noreply, socket}
  end

  defp to_select_options(list, type) when type in [:categories],
    do: Enum.map(list, &{&1.name, &1.id})
end
