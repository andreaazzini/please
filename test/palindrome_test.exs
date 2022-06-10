defmodule PalindromeTest do
  use ExUnit.Case

  import Please.Palindrome

  test "handles actual palindromes" do
    assert my_function("radar")
    assert my_function("eve")
  end

  test "rejects invalid strings" do
    refute my_function("abc")
    refute my_function("apple")
  end
end
