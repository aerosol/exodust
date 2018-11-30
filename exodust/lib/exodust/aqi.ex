defmodule Exodust.AQI do
  # The Common Air Quality Index (CAQI)

  def rate(pm25, pm10) when pm10 > 180 or pm25 > 110, do: 5
  def rate(pm25, pm10) when pm10 > 90 or pm25 > 55, do: 4
  def rate(pm25, pm10) when pm10 > 50 or pm25 > 30, do: 3
  def rate(pm25, pm10) when pm10 > 25 or pm25 > 15, do: 2
  def rate(pm25, pm10) when pm10 <= 25 or pm25 <= 15, do: 1
end
