defmodule Hftx.Repo do
  use Ecto.Repo,
    otp_app: :hftx,
    adapter: Ecto.Adapters.Postgres
end
