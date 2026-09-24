defmodule StarterApp.Workers.SlowJob do
  @moduledoc """
  A deliberately slow Oban worker for the graceful-shutdown demo.

  It sleeps for `seconds` seconds, logging every tick, so you can watch it be
  interrupted (or drain cleanly) when the container receives SIGTERM.
  """
  use Oban.Worker, queue: :default

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{id: id, args: %{"seconds" => seconds}}) do
    Logger.info("▶️  SlowJob ##{id} STARTED — will run for #{seconds}s (SIGTERM me!)")

    Enum.each(1..seconds, fn i ->
      Process.sleep(1000)
      Logger.info("⏳ SlowJob ##{id} working… #{i}/#{seconds}s")
    end)

    # If you see this line, the job drained gracefully → Oban marks it `completed`.
    # If you DON'T see it, the grace period expired first → Oban kills it → `retryable`.
    Logger.info("✅ SlowJob ##{id} COMPLETED — drained gracefully")
    :ok
  end
end
