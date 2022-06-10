defmodule Cel2FahrTest do
  use ExUnit.Case

  import Please.Cel2Fahr

  test "can convert from celsius to fahrenheit" do
    assert convert(0) == 32
    assert convert(100) == 212
  end
end
