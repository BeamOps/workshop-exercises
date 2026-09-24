# Copy this into priv/repo/migrations/ with a timestamp prefix, e.g.:
#   priv/repo/migrations/20260101000000_add_oban.exs
# (or run `mix ecto.gen.migration add_oban` and paste the up/down bodies).
defmodule StarterApp.Repo.Migrations.AddOban do
  use Ecto.Migration

  def up, do: Oban.Migration.up()
  def down, do: Oban.Migration.down(version: 1)
end
