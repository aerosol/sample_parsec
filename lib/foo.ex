defmodule Foo do
  defmodule Parser do
    import NimbleParsec

    key =
      choice([
        string("event:goal") |> replace(:goal),
        string("*") |> replace(:wildcard),
        ascii_string([?a..?z, ?A..?Z, ?0..9, ?:, {:not, ?!}, {:not, ?=}], min: 1)
      ])

    operator =
      choice([
        string("!=") |> replace(:is_not),
        string("==") |> replace(:is)
      ])

    literal_value =
      ascii_string([?a..?z, ?A..?Z, ?0..9], min: 1)
      |> optional(string("\\|") |> replace("|"))
      |> optional(ascii_string([?a..?z, ?A..?Z, ?0..9], min: 1))
      |> reduce({Enum, :join, [""]})

    list_of_literals =
      choice([
        ascii_string([?a..?z, ?A..?Z, ?0..9], min: 1),
        string("|") |> replace(:or)
      ])

    value =
      choice([
        literal_value,
        list_of_literals
      ])

    defparsec(:filter, key |> concat(operator) |> concat(repeat(value)), debug: true)
  end
end
