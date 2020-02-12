defmodule AccessLogParser.Parsec do
  @moduledoc false

  import NimbleParsec

  dash_or_string = choice([string("-"), repeat(ascii_string([not: 32], min: 1))])

  date = repeat(ascii_string([?a..?z, ?A..?Z, ?0..?9, ?:, ?/], 20))
  ip = repeat(ascii_string([?a..?f, ?A..?F, ?0..?9, ?:, ?.], min: 7))
  length = repeat(integer(min: 1))

  method =
    choice([
      string("CONNECT"),
      string("DELETE"),
      string("GET"),
      string("HEAD"),
      string("OPTIONS"),
      string("PATCH"),
      string("POST"),
      string("PUT"),
      string("TRACE")
    ])

  path = repeat(ascii_string([not: 32], min: 1))

  protocol =
    choice([
      string("HTTP/0.9"),
      string("HTTP/1.0"),
      string("HTTP/1.1"),
      string("HTTP/2"),
      string("HTTP/3")
    ])

  referrer = repeat(ascii_string([not: ?"], min: 1))
  status = repeat(integer(3))
  timezone = repeat(ascii_string([?0..?9, ?+, ?-], 5))
  user_agent = repeat(ascii_string([not: ?"], min: 1))
  userid = dash_or_string
  vhost = repeat(ascii_string([not: 32], min: 1))

  common =
    ip
    |> ignore(string(" "))
    |> ignore(dash_or_string)
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
    |> ignore(string(" "))
    |> concat(protocol)
    |> ignore(string(~s(" )))
    |> concat(status)
    |> ignore(string(" "))
    |> concat(length)

  common_complete =
    vhost
    |> ignore(string(" "))
    |> concat(common)
    |> ignore(string(~s( ")))
    |> concat(referrer)
    |> ignore(string(~s(" ")))
    |> concat(user_agent)

  common_vhost =
    vhost
    |> ignore(string(" "))
    |> concat(common)

  extended =
    common
    |> ignore(string(~s( ")))
    |> concat(referrer)
    |> ignore(string(~s(" ")))
    |> concat(user_agent)

  defparsec :common, common, inline: true
  defparsec :common_complete, common_complete, inline: true
  defparsec :common_vhost, common_vhost, inline: true
  defparsec :extended, extended, inline: true
end
