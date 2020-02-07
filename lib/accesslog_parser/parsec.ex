defmodule AccessLogParser.Parsec do
  @moduledoc false

  import NimbleParsec

  common =
    repeat(ascii_string([?a..?f, ?A..?F, ?0..?9, ?:, ?.], min: 7))
    |> ignore(ascii_char([32]))
    |> ignore(repeat(ascii_string([not: 32], min: 1)))
    |> ignore(ascii_char([32]))
    |> repeat(ascii_string([not: 32], min: 1))
    |> ignore(ascii_char([32]))
    |> ignore(ascii_char([?[]))
    |> repeat(ascii_string([?a..?z, ?A..?Z, ?0..?9, ?:, ?/], 20))
    |> ignore(ascii_char([32]))
    |> repeat(ascii_string([?0..?9, ?+, ?-], 5))
    |> ignore(ascii_char([?]]))
    |> ignore(ascii_char([32]))
    |> ignore(repeat(ascii_string([not: 32], min: 1)))
    |> ignore(ascii_char([32]))
    |> repeat(ascii_string([not: 32], min: 1))
    |> ignore(repeat(ascii_string([not: ?"], min: 1)))
    |> ignore(ascii_char([?"]))
    |> ignore(ascii_char([32]))
    |> repeat(integer(min: 1))
    |> ignore(ascii_char([32]))
    |> repeat(integer(min: 1))

  defparsec :common, common, inline: true
end
