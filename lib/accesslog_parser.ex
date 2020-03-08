# credo:disable-for-this-file Credo.Check.Readability.MaxLineLength
defmodule AccessLogParser do
  @moduledoc """
  Parses access log lines matching a given (known) format.

  ## Usage

  You simply call the parse method with your log line and the format it adheres to:

      iex> AccessLogParser.parse(~s(1.2.3.4 - - [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765), :common)
      %{
        date: "22/Apr/2017:15:17:39",
        ip: "1.2.3.4",
        length: 765,
        method: "GET",
        path: "/",
        protocol: "HTTP/1.0",
        status: 200,
        timezone: "+0200",
        userid: "-"
      }

  ## Formats

  ### Common Log Format (CLF)

  - `:common`
  - Apache configuration: `%h %l %u %t \\"%r\\" %>s %b`

  ### CLF with Virtual Host and Client

  - `:common_complete`
  - Apache configuration: `%v %h %l %u %t \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-agent}i\\"`

  ### CLF with Virtual Host

  - `:common_vhost`
  - Apache configuration: `%v %h %l %u %t \\"%r\\" %>s %b`

  ### NCSA extended/combined log format

  - `:combined` or `:extended`
  - Apache configuration: `%h %l %u %t \\"%r\\" %>s %b \\"%{Referer}i\\" \\"%{User-agent}i\\"`
  """

  alias AccessLogParser.Parsec

  @type log_format :: :combined | :common | :common_complete | :common_vhost | :extended

  @doc """
  Converts a given line into a map matching the defined format.
  """
  @spec parse(String.t(), log_format) :: map
  def parse(line, :combined), do: parse(line, :extended)

  def parse(line, :common) do
    case Parsec.common(line) do
      {:ok, [ip, userid, date, timezone, method, path, protocol, status, length], _, _, _, _} ->
        %{
          date: date,
          ip: ip,
          length: length,
          method: method,
          path: path,
          protocol: protocol,
          status: status,
          timezone: timezone,
          userid: userid
        }

      _ ->
        nil
    end
  end

  def parse(line, :common_complete) do
    case Parsec.common_complete(line) do
      {:ok,
       [
         vhost,
         ip,
         userid,
         date,
         timezone,
         method,
         path,
         protocol,
         status,
         length,
         referrer,
         user_agent
       ], _, _, _, _} ->
        %{
          date: date,
          ip: ip,
          length: length,
          method: method,
          path: path,
          protocol: protocol,
          referrer: referrer,
          status: status,
          timezone: timezone,
          user_agent: user_agent,
          userid: userid,
          vhost: vhost
        }

      _ ->
        nil
    end
  end

  def parse(line, :common_vhost) do
    case Parsec.common_vhost(line) do
      {:ok, [vhost, ip, userid, date, timezone, method, path, protocol, status, length], _, _, _,
       _} ->
        %{
          date: date,
          ip: ip,
          length: length,
          method: method,
          path: path,
          protocol: protocol,
          status: status,
          timezone: timezone,
          userid: userid,
          vhost: vhost
        }

      _ ->
        nil
    end
  end

  def parse(line, :extended) do
    case Parsec.extended(line) do
      {:ok,
       [
         ip,
         userid,
         date,
         timezone,
         method,
         path,
         protocol,
         status,
         length,
         referrer,
         user_agent
       ], _, _, _, _} ->
        %{
          date: date,
          ip: ip,
          length: length,
          method: method,
          path: path,
          protocol: protocol,
          referrer: referrer,
          status: status,
          timezone: timezone,
          user_agent: user_agent,
          userid: userid
        }

      _ ->
        nil
    end
  end
end
