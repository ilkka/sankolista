defmodule Sankolista.List.ListItem do
  @moduledoc """
  List item in bucket list.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("list_items")
    repo(Sankolista.Repo)
  end

  code_interface do
    define_for(Sankolista.List)
    define(:create, action: :create)
    define(:read_all, action: :read)
    define(:update, action: :update)
    define(:destroy, action: :destroy)
    define(:get_by_id, args: [:id], action: :by_id)
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    read :by_id do
      argument(:id, :uuid, allow_nil?: false)
      get?(true)
      filter(expr(id == ^arg(:id)))
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :title, :string do
      allow_nil?(false)
    end

    attribute :status, :atom do
      constraints(one_of: [:waiting, :started, :done])
      default(:waiting)
      allow_nil?(false)
    end

    create_timestamp(:created_at)
    update_timestamp(:updated_at)
  end
end
