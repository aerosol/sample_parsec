defmodule FooTest do
  use ExUnit.Case
  doctest Foo

  test "greets the world" do
    inputs = [
      "source==**/hello/**",
      "page==*/hi/*",
      "event==/site/**",
      "goal==/site/**|somethingelse",
      "goal==/foo/**/bar",
      "device==foo",
      "device!=xyz",
      "os==foo|bar",
      "os!=foo|bar",
      "utm_source!=foo",
      "screen==a|b|c",
      "region==a|b\\|c",
      "city==a\\|b",
      "entry_page!=a\\|b",
      "exit_page==/hello/world/**"
    ]

    for i <- inputs do
      {:ok, match, _, _, _, _} = Foo.Parser.filter(i)

      match
      |> IO.inspect(label: IO.ANSI.yellow() <> "#{i}" <> IO.ANSI.reset())
    end
  end
end
