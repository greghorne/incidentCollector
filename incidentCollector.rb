# coding utf-

require 'open-uri'
require 'json'
require 'pp'

def getJSON()

end


def getConnect()

end


def processJSON()

end

# ------------------------------------------------------------

http = "https://www.cityoftulsa.org/apps/opendata/tfd_dispatch.jsn"

while true
    
    content = open(http).read
    json = JSON.parse(content)

    pp json

    sleep 10
    puts "---------------"
end

