Benchee.run(
  %{
    ":common" => fn ->
      AccessLogParser.parse(
        ~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765),
        :common
      )
    end,
    ":common_complete" => fn ->
      AccessLogParser.parse(
        ~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/535.11 \(KHTML, like Gecko\) Chrome/17.0.963.56 Safari/535.11"),
        :common_complete
      )
    end,
    ":common_vhost" => fn ->
      AccessLogParser.parse(
        ~s(www.example.com 1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765),
        :common_vhost
      )
    end,
    ":extended" => fn ->
      AccessLogParser.parse(
        ~s(1.2.3.4 - someuser [22/Apr/2017:15:17:39 +0200] "GET / HTTP/1.0" 200 765 "-" "Mozilla/5.0 \(X11; Linux x86_64\) AppleWebKit/535.11 \(KHTML, like Gecko\) Chrome/17.0.963.56 Safari/535.11"),
        :extended
      )
    end
  },
  formatters: [{Benchee.Formatters.Console, comparison: false}],
  warmup: 2,
  time: 10
)
