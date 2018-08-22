# coding utf-

require 'open-uri'
require 'json'
require 'pg'
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

    json['Incidents']['Incident'].each do |child|
        pp child['IncidentNumber']
        pp child['Problem']
        pp child['Address']
        pp child['ResponseDate']
        pp child['Latitude']
        pp child['Longitude']
        pp child['Vehicles'].
        puts "---------------"
    end

    sleep 60
    puts "---------------"
end

# create table tfd_incidents(
#     IncidentNumber text primary key not null,
#     Problem text not null,
#     Address text not null,
#     ResponseDate text not null,
#     Latitude text not null,
#     Longitude text not null,
#     Vehicles json not null
# )

