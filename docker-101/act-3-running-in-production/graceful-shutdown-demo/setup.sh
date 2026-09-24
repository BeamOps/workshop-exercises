#!/usr/bin/env bash
# Wires Oban + the SlowJob worker into the starter app for the graceful-shutdown demo.
# Idempotent — safe to re-run. Run it from anywhere:
#   ./setup.sh
set -euo pipefail

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="$(cd "$DEMO_DIR/../../starter-app/starter_app" 2>/dev/null && pwd || true)"

if [ -z "${APP:-}" ] || [ ! -f "$APP/mix.exs" ]; then
  echo "✗ starter app not found at docker-101/starter-app/starter_app — generate it (00-setup) first."
  exit 1
fi

echo "==> Wiring Oban into $APP"
cd "$APP"

# 1a. dependency
if grep -q ':oban' mix.exs; then
  echo "  • dep: oban already present"
else
  perl -0777 -pi -e 's/(defp deps do\n\s*\[\n)/$1      {:oban, "~> 2.24"},\n/' mix.exs
  grep -q ':oban' mix.exs || { echo "✗ could not add oban to mix.exs deps — add {:oban, \"~> 2.24\"} by hand"; exit 1; }
  echo "  • dep: added {:oban, \"~> 2.24\"}"
fi
mix deps.get >/dev/null

# 1b. migration
if ls priv/repo/migrations/*_add_oban.exs >/dev/null 2>&1; then
  echo "  • migration: already present"
else
  cp "$DEMO_DIR/files/add_oban.exs" "priv/repo/migrations/$(date +%Y%m%d%H%M%S)_add_oban.exs"
  echo "  • migration: installed"
fi

# 1c. worker
mkdir -p lib/starter_app/workers
cp "$DEMO_DIR/files/slow_job.ex" lib/starter_app/workers/slow_job.ex
echo "  • worker: SlowJob installed"

# 1d. config
if grep -q 'config :starter_app, Oban' config/config.exs; then
  echo "  • config.exs: Oban already configured"
else
  perl -0777 -pi -e 's/^(import_config)/config :starter_app, Oban, repo: StarterApp.Repo, queues: [default: 10]\n\n$1/m' config/config.exs
  echo "  • config.exs: added Oban config"
fi

if grep -q 'shutdown_grace_period' config/runtime.exs; then
  echo "  • runtime.exs: OBAN_GRACE already configured"
else
  cat >> config/runtime.exs <<'EOF'

# graceful-shutdown demo: tune Oban's grace period via OBAN_GRACE (milliseconds)
config :starter_app, Oban,
  shutdown_grace_period: String.to_integer(System.get_env("OBAN_GRACE") || "15000")
EOF
  echo "  • runtime.exs: added OBAN_GRACE"
fi

# 1e. supervisor
if grep -q '{Oban,' lib/starter_app/application.ex; then
  echo "  • application.ex: Oban already in the supervision tree"
else
  perl -0777 -pi -e 's/^(\s*)(StarterApp\.Repo,\n)/$1$2$1\{Oban, Application.fetch_env!(:starter_app, Oban)\},\n/m' lib/starter_app/application.ex
  grep -q '{Oban,' lib/starter_app/application.ex || { echo "✗ could not add Oban to application.ex — add {Oban, Application.fetch_env!(:starter_app, Oban)} to children by hand"; exit 1; }
  echo "  • application.ex: added Oban to the supervision tree"
fi

echo "==> Compiling..."
mix compile

echo ""
echo "✅ Done. Now rebuild the image and run the demo (from the graceful-shutdown-demo folder):"
echo "   docker build -f ../01-multi-stage-build/solution/Dockerfile -t starter-app:3.0 ../../starter-app/starter_app"
echo "   docker compose up -d"
