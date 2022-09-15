defmodule FooTest do
  use ExUnit.Case
  doctest Foo

  test "greets the world" do
    inputs = [
      "*==foobar",
      "*!=foobar",
      "event:goal==foo",
      "some==foo",
      "abc!=xyz",
      "some==foo|bar",
      "some!=foo|bar",
      "event:goal!=foo",
      "abc==foo",
      "some==a|b|c",
      "omg==a|b\\|c",
      "some==a\\|b",
      "some!=a\\|b"
    ]

    for i <- inputs do
      Foo.Parser.filter(i) |> IO.inspect(label: "#{i}\t\t\t")
    end
  end
end
