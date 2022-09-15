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
      |> concat(optional(string("\\|") |> replace("|")))
      |> concat(optional(ascii_string([?a..?z, ?A..?Z, ?0..9], min: 1)))
      |> reduce({Enum, :join, [""]})

    alternative_separator =
      string("|")
      |> replace(:or)

    alternative_of_values =
      literal_value
      |> concat(times(concat(alternative_separator, literal_value), min: 1))
      |> reduce({:parse_alternative, []})

    expression =
      choice([
        alternative_of_values,
        literal_value
      ])

    defparsec(:filter, key |> concat(operator) |> concat(expression), debug: true)

    defp parse_alternative(args) do
      Enum.reject(args, &(&1 == :or))
    end
  end
end
