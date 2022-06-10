defmodule RpsTest do
  use ExUnit.Case

  import Please.Rps

  test "rock beats scissors" do
    assert wins(:rock, :scissors)
  end

  test "scissors beats paper" do
    assert wins(:scissors, :paper)
  end

  test "paper beats rock" do
    assert wins(:paper, :rock)
  end

  test "can not win over oneself" do
    for move <- [:rock, :paper, :scissors] do
      refute wins(move, move)
    end
  end
end
