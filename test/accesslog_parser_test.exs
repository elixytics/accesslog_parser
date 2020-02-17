defmodule AccessLogParserTest do
  use ExUnit.Case, async: true

  describe "with a valid log entry" do
    # credo:disable-for-lines:6 Credo.Check.Readability.MaxLineLength
    @log_common ~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765)
    @log_common_complete ~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/535.11 \(KHTML, like Gecko\) Chrome/17.0.963.56 Safari/535.11")
    @log_common_vhost ~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765)
    @log_extended ~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/535.11 \(KHTML, like Gecko\) Chrome/17.0.963.56 Safari/535.11")

    @result_user_agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.11 (KHTML, like Gecko) Chrome/17.0.963.56 Safari/535.11"

    test ":common" do
      assert AccessLogParser.parse(@log_common, :common) ==
               %{
                 date: "22/Apr/2017:15:17:39",
                 ip: "1.2.3.4",
                 length: 765,
                 method: "GET",
                 path: "/",
                 protocol: "HTTP/1.0",
                 status: 200,
                 timezone: "+0200",
                 userid: "someuser"
               }
    end

    test ":common_complete" do
      assert AccessLogParser.parse(@log_common_complete, :common_complete) ==
               %{
                 date: "22/Apr/2017:15:17:39",
                 ip: "1.2.3.4",
                 length: 765,
                 method: "GET",
                 path: "/",
                 protocol: "HTTP/1.0",
                 referrer: "-",
                 status: 200,
                 timezone: "+0200",
                 user_agent: @result_user_agent,
                 userid: "someuser",
                 vhost: "www.example.com"
               }
    end

    test ":common_vhost" do
      assert AccessLogParser.parse(@log_common_vhost, :common_vhost) ==
               %{
                 date: "22/Apr/2017:15:17:39",
                 ip: "1.2.3.4",
                 length: 765,
                 method: "GET",
                 path: "/",
                 protocol: "HTTP/1.0",
                 status: 200,
                 timezone: "+0200",
                 userid: "someuser",
                 vhost: "www.example.com"
               }
    end

    test ":extended" do
      assert AccessLogParser.parse(@log_extended, :extended) ==
               %{
                 date: "22/Apr/2017:15:17:39",
                 ip: "1.2.3.4",
                 length: 765,
                 method: "GET",
                 path: "/",
                 protocol: "HTTP/1.0",
                 referrer: "-",
                 status: 200,
                 timezone: "+0200",
                 user_agent: @result_user_agent,
                 userid: "someuser"
               }
    end
  end
end
