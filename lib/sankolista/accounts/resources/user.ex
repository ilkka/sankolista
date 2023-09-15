defmodule Sankolista.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  postgres do
    table "users"
    repo Sankolista.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
  end

  authentication do
    api Sankolista.Accounts

    strategies do
      auth0 do
        client_id(Sankolista.Secrets)
        client_secret(Sankolista.Secrets)
        redirect_uri(Sankolista.Secrets)
        site(Sankolista.Secrets)
      end
    end
  end

  identities do
    identity :email, :email
  end

  actions do
    create :register_with_auth0 do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :email

      change fn changeset, _ ->
        user_info = Ash.Changeset.get_argument(changeset, :user_info)
        Ash.Changeset.change_attributes(changeset, Map.take(user_info, ["email"]))
      end
    end
  end
end
