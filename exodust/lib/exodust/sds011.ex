defmodule Exodust.SDS011 do
  alias Exodust.Probe
  defmodule UnsupportedMessageError, do: defexception [:message]

  @header <<0xAA, 0xC0>>
  @trailer 0xAB

  # {:nerves_uart, "ttyUSB0", <<170, 192, 251, 1, 87, 4, 13, 70, 170, 171>>}
  def decode({:nerves_uart, _interface, message}) do
    decode_sds011!(message)
  end

  def decode_sds011!(<<@header::binary, d1, d2, d3, d4, d5, d6, checksum, @trailer>>)
      when rem(d1 + d2 + d3 + d4 + d5 + d6, 256) == checksum do
    %Probe{
      pm25: (d2 * 256 + d1) / 10,
      pm10: (d4 * 256 + d3) / 10
    }
  end

  def decode_sds011!(<<@header::binary, _::size(48), checksum, @trailer>>) do
    raise UnsupportedMessageError, "Wrong checksum: #{inspect(checksum)}"
  end

  def decode_sds011!(message) do
    raise UnsupportedMessageError, "Unrecognized message: #{inspect(message)}"
  end
end
