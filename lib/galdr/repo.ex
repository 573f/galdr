defmodule Galdr.Repo do
  use Ecto.Repo,
    otp_app: :galdr,
    adapter: Ecto.Adapters.Postgres
end
