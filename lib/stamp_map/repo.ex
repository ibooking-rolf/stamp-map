defmodule StampMap.Repo do
  use Ecto.Repo,
    otp_app: :stamp_map,
    adapter: Ecto.Adapters.Postgres
end
