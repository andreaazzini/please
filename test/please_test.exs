defmodule PleaseTest do
  use ExUnit.Case
  doctest Please

  test "greets the world" do
    assert Please.hello() == :world
  end
end
