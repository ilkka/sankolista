defmodule Sankolista.List.ListItem do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "list_items"
    repo Sankolista.Repo
  end

  code_interface do
    define_for Sankolista.List
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
    end

    attribute :status, :atom do
      constraints one_of: [:waiting, :started, :done]
      default :waiting
      allow_nil? false
    end
  end
end
