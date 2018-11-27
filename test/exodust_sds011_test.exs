defmodule ExodustSDS011Test do
  use ExUnit.Case

  alias Exodust.SDS011
  import SDS011

  @samples %{
    when_vaping: <<170, 192, 183, 1, 143, 3, 13, 70, 157, 171>>,
    xiaomi_purifier: :todo,
    blueair_purifier: :todo
  }

  test "Properly decodes a message" do
    probe = decode_sds011!(@samples.when_vaping)
    assert probe.pm10 == 91.1
    assert probe.pm25 == 43.9
  end

  test "Fails nicely on wrong checksum" do
    assert_raise SDS011.UnsupportedMessageError, ~r/^Wrong checksum/, fn ->
      @samples.when_vaping
      |> malform_nth_byte(9)
      |> decode_sds011!
    end
  end

  test "Fails nicely on malformed messages" do
    assert_raise SDS011.UnsupportedMessageError, ~r/^Unrecognized message/, fn ->
      @samples.when_vaping
      |> malform_nth_byte(1)
      |> decode_sds011!
    end

    assert_raise SDS011.UnsupportedMessageError, ~r/^Unrecognized message/, fn ->
      @samples.when_vaping
      |> malform_nth_byte(2)
      |> decode_sds011!
    end

    assert_raise SDS011.UnsupportedMessageError, ~r/^Unrecognized message/, fn ->
      @samples.when_vaping
      |> malform_nth_byte(10)
      |> decode_sds011!
    end

    assert_raise SDS011.UnsupportedMessageError, ~r/^Unrecognized message/, fn ->
      decode_sds011!(<<"completely wrong">>)
    end
  end

  defp malform_nth_byte(binary, n) do
    pos = n - 1
    <<l::binary-size(pos), b, r::binary>> = binary
    <<l::binary-size(pos), b + 1, r::binary>>
  end
end
