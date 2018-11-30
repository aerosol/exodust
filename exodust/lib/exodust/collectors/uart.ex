defmodule Exodust.Collectors.UART do
  use GenServer

  def start(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    tty = Keyword.get(opts, :tty, "ttyUSB0")
    :ok = Nerves.UART.open(:exodust_uart, tty, speed: 9600, active: true)
    {:ok, :no_state}
  end

  def handle_info({:nerves_uart, _, _} = message, state) do
    probe = Exodust.SDS011.decode(message)
    rating = Exodust.AQI.rate(probe)
    IO.puts "Probe: #{inspect probe} - rating: #{rating}"
    {:noreply, state}
  end
end
