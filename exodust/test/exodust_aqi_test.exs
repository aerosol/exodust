defmodule ExodustAQITest do
  use ExUnit.Case

  import Exodust.AQI
  alias Exodust.Probe

  test "rating works" do
    assert 1 == rate(%Probe{pm25: 0, pm10: 0})
    assert 2 == rate(%Probe{pm25: 20, pm10: 10})
    assert 3 == rate(%Probe{pm25: 45, pm10: 10})
    assert 3 == rate(%Probe{pm25: 45, pm10: 53})
    assert 5 == rate(%Probe{pm25: 500, pm10: 0})
    assert 5 == rate(%Probe{pm25: 0, pm10: 500})
  end
end

