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

def self.get_db_conn()

    begin
        hostaddr = Resolv.getaddress $db_host
    rescue
        # catch the error but just continue
    end

    begin
        conn = PG::Connection.open(
            :host     => $db_host,
            :port     => $db_port,
            :dbname   => $db_name,
            :user     => $db_user,
            :password => $db_pwd,
            # :hostaddr => hostaddr,
            # :sslmode  => true
        )

        return conn
    rescue PG::Error => e
        pp e
        return false
    end


end

# ------------------------------------------------------------

http = "https://www.cityoftulsa.org/apps/opendata/tfd_dispatch.jsn"

$db_host = ENV['RAILS_SERVER']
$db_name = ENV['RAILS_DB']
$db_port = ENV['RAILS_PORT']
$db_user = ENV['RAILS_USER']
$db_pwd  = ENV['RAILS_PASSWORD']

# pp server
# pp database
# pp port
# pp user
# pp password


while true
    
    content = open(http).read
    json = JSON.parse(content)

    conn = get_db_conn()
    pp conn



    json['Incidents']['Incident'].each do |child|

        response_insert = conn.query("replace into tfd_incidents values($1, $2, $3, $4, $5, $6, $7)", [pp child['IncidentNumber'], 
                      child['Problem'], child['Address'], child['ResponseDate'], child['Latitude'], child['Longitude'], child['Vehicles']])

    end

    conn.close

    sleep 60
    puts "---------------"
end

    #     pp child['IncidentNumber']
    #     pp child['Problem']
    #     pp child['Address']
    #     pp child['ResponseDate']
    #     pp child['Latitude']
    #     pp child['Longitude']
    #     pp child['Vehicles']
    #     puts "---------------"
    
# create table tfd_incidents(
#     IncidentNumber text primary key not null,
#     Problem text not null,
#     Address text not null,
#     ResponseDate text not null,
#     Latitude text not null,
#     Longitude text not null,
#     Vehicles json not null
# )

