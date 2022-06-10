defmodule EnmTest do
  use ExUnit.Case

  import Please.Enm

  test "at/2" do
    assert at([2, 4, 6], 0) == 2
    assert at([2, 4, 6], 2) == 6
    assert at([2, 4, 6], 4) == nil
    assert at([2, 4, 6], -2) == 4
    assert at([2, 4, 6], -4) == nil
  end
end
