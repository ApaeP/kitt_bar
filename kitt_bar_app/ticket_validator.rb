#!/usr/bin/env ruby

`curl -X PUT -H 'Accept: application/json, text/plain, */*' -H 'User-Agent: KittBar/1.0'  --cookie \"#{ARGV[0]}\" #{ARGV[1]}`
