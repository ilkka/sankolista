defmodule Sankolista.List.ListItemTest do
  use Sankolista.DataCase, async: false

  alias Sankolista.List.ListItem

  @moduletag :capture_log

  doctest ListItem

  test "cannot create item without title" do
    assert {:error, _} = ListItem.create(%{})
  end


  test "can create items when providing a title" do
    assert {:ok, _} = ListItem.create(%{title: "Morjesta pöytään"})
  end
end
