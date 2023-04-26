defmodule Foo do
  defmodule Parser do
    import NimbleParsec

    key =
      choice([
        string("source") |> replace(:source),
        string("referrer") |> replace(:referrer),
        string("utm_medium") |> replace(:utm_medium),
        string("utm_source") |> replace(:utm_source),
        string("utm_campaign") |> replace(:utm_campaign),
        string("utm_content") |> replace(:utm_content),
        string("utm_term") |> replace(:utm_term),
        string("screen") |> replace(:screen),
        string("device") |> replace(:device),
        string("browser") |> replace(:browser),
        string("browser_version") |> replace(:browser_version),
        string("os") |> replace(:os),
        string("os_version") |> replace(:os_version),
        string("country") |> replace(:country),
        string("region") |> replace(:region),
        string("city") |> replace(:city),
        string("entry_page") |> replace(:entry_page),
        string("exit_page") |> replace(:exit_page),
        string("event") |> replace(:event),
        string("page") |> replace(:page),
        string("goal") |> replace(:goal)
      ])

    operator =
      choice([
        string("!=") |> replace(:is_not),
        string("==") |> replace(:is)
      ])

    literal_value =
      empty()
      |> concat(optional(ascii_string([?*], min: 1, max: 2) |> unwrap_and_tag(:wildcard)))
      |> concat(ascii_string([?a..?z, ?A..?Z, ?0..9, ?/, {:not, ?*}], min: 1))
      |> concat(optional(ascii_string([?*], min: 1, max: 2) |> unwrap_and_tag(:wildcard)))
      |> concat(optional(string("\\|") |> replace("|")))
      |> concat(optional(ascii_string([?a..?z, ?A..?Z, ?0..9], min: 1)))
      |> reduce({:join, []})

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

    defparsec(:filter, key |> concat(operator) |> concat(expression))

    defp join(args) do
      Enum.reduce(args, %{value: "", wildcard?: false}, fn
        thing, acc when is_binary(thing) ->
          %{acc | value: acc.value <> thing}

        {:wildcard, thing}, acc when is_binary(thing) ->
          %{acc | value: acc.value <> thing, wildcard?: true}
      end)
    end

    defp parse_alternative(args) do
      Enum.reject(args, &(&1 == :or))
    end
  end
end
