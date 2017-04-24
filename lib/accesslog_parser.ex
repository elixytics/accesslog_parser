defmodule AccessLogParser do
  @moduledoc """
  Parses access log lines.
  """

  @re_common ~r/(?P<ip>\S+)\s+\S+\s+(?P<userid>\S+)\s+\[(?P<date>.*?)\s+(?P<timezone>.*?)\]\s+"\S+\s+(?P<path>.*?)\s+\S+"\s+(?P<status>\S+)\s+(?P<length>\S+)/

  @doc """
  Converts a given line into a map matching the defined format.

  ## Examples

      iex> parse(~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765), :common)
      %{
        "date"     => "22/Apr/2017:15:17:39",
        "ip"       => "1.2.3.4",
        "length"   => "765",
        "path"     => "/",
        "status"   => "200",
        "timezone" => "+0200",
        "userid"   => "someuser"
      }
  """
  @spec parse(String.t, atom) :: map
  def parse(line, :common), do: Regex.named_captures(@re_common, line)
end
