defmodule SankolistaWeb.PostsLive.Index do
  use SankolistaWeb, :live_view
  # import Phoenix.HTML.Form
  alias Sankolista.List.ListItem

  @impl true
  def render(assigns) do
    ~H"""
    <h2>Sankolista</h2>
    <h3>Items</h3>
    <div>
      <%= for item <- @list_items do %>
        <div>
          <h3><%= item.title %></h3>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    list_items = ListItem.read_all!()

    socket =
      assign(socket,
        list_items: list_items,
        item_selector: item_selector(list_items),
        create_form: AshPhoenix.Form.for_create(ListItem, :create) |> to_form(),
        update_form:
          AshPhoenix.Form.for_update(List.first(list_items, %ListItem{}), :update) |> to_form()
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("delete_item", %{"item-id" => item_id}, socket) do
    item_id |> ListItem.get_by_id!() |> ListItem.destroy!()
    items = ListItem.read_all!()

    {:noreply, assign(socket, list_items: items, item_selector: item_selector(items))}
  end

  @impl true
  def handle_event("create_item", %{"form" => %{"title" => title}}, socket) do
    ListItem.create(%{title: title})
    items = ListItem.read_all!()

    {:noreply, assign(socket, list_items: items, item_selector: item_selector(items))}
  end

  @impl true
  def handle_event("update_item", %{"form" => form_params}, socket) do
    %{"item_id" => item_id, "title" => title} = form_params

    item_id |> ListItem.get_by_id!() |> ListItem.update(%{title: title})
    items = ListItem.read_all!()

    {:noreply, assign(socket, list_items: items, item_selector: item_selector(items))}
  end

  defp item_selector(items) do
    for item <- items do
      {item.title, item.id}
    end
  end
end
