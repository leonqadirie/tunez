defmodule Tunez.Music.Calculations.YearsAgo do
  use Ash.Resource.Calculation

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  @impl true
  def calculate(records, _opts, _context) do
    today = Date.utc_today()

    Enum.map(
      records,
      fn record ->
        today.year - record.year_released
      end
    )
  end
end
