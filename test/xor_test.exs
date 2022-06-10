defmodule XorTest do
  use ExUnit.Case

  import Please.Xor

  test "equal inputs are always false" do
    refute xor(true, true)
    refute xor(false, false)
  end

  test "unequal inputs evaluates to true" do
    assert xor(true, false)
    assert xor(false, true)
  end
end
