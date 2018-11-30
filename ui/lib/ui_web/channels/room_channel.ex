defmodule UiWeb.RoomChannel do
 use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    send(self, :post_join)
    {:ok, socket}
  end

  def handle_info(:post_join, socket) do
    push(socket, "new_msg", %{body: "Hello from socket"})
    {:noreply, socket}
  end

  def handle_info({:nerves_uart, _, _} = message, socket) do
    probe = Exodust.SDS011.decode(message)
    push(socket, "new_probe", %{body: probe})
    {:noreply, socket}
  end

  def handle_in("uart_run", %{"tty" => tty}, socket) do
    case Nerves.UART.open(:exodust_uart, tty, speed: 9600, active: true) do
      :ok ->
        push(socket, "new_msg", %{body: "Connected via UART"})
      {:error, :enoent} ->
        push(socket, "new_msg", %{body: "Is the sensor connected via UART?"})
    end
    {:noreply, socket}
  end
end
