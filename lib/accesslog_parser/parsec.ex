defmodule AccessLogParser.Parsec do
  @moduledoc false

  import NimbleParsec

  date = repeat(ascii_string([?a..?z, ?A..?Z, ?0..?9, ?:, ?/], 20))
  ip = repeat(ascii_string([?a..?f, ?A..?F, ?0..?9, ?:, ?.], min: 7))
  length = repeat(integer(min: 1))

  method =
    choice([
      string("DELETE"),
      string("GET"),
      string("PATCH"),
      string("POST"),
      string("PUT")
    ])

  path = repeat(ascii_string([not: 32], min: 1))
  status = repeat(integer(min: 1))
  timezone = repeat(ascii_string([?0..?9, ?+, ?-], 5))
  userid = repeat(ascii_string([not: 32], min: 1))
  vhost = repeat(ascii_string([not: 32], min: 1))

  common =
    ip
    |> ignore(string(" "))
    |> ignore(repeat(ascii_string([not: 32], min: 1)))
    |> ignore(string(" "))
    |> concat(userid)
    |> ignore(string(" ["))
    |> concat(date)
    |> ignore(string(" "))
    |> concat(timezone)
    |> ignore(string(~s(] ")))
    |> concat(method)
    |> ignore(string(" "))
    |> concat(path)
    |> ignore(repeat(ascii_string([not: ?"], min: 1)))
    |> ignore(string(~s(" )))
    |> concat(status)
    |> ignore(string(" "))
    |> concat(length)

  common_vhost =
    vhost
    |> ignore(string(" "))
    |> concat(common)

  defparsec :common, common, inline: true
  defparsec :common_vhost, common_vhost, inline: true
end
