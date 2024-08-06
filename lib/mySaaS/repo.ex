defmodule MySaaS.Repo do
  use Ecto.Repo,
    otp_app: :mySaaS,
    adapter: Ecto.Adapters.Postgres
end
