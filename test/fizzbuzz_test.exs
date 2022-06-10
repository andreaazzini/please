defmodule FizzbuzzTest do
  use ExUnit.Case

  import Please.Fizzbuzz

  test "outputs correctly" do
    assert fizzbuzz(1) == "1"
    assert fizzbuzz(2) == "1 2"
    assert fizzbuzz(3) == "1 2 Fizz"
    assert fizzbuzz(4) == "1 2 Fizz 4"

    assert fizzbuzz(20) ==
             "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz 16 17 Fizz 19 Buzz"
  end
end
