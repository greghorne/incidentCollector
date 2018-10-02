# encoding utf-8

require 'open-uri'
require 'json'
require 'pg'
require 'pp'

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

while true

  begin
    content = open(http).read
    json = JSON.parse(content)

    conn = get_db_conn()

    counter = 0
    json['Incidents']['Incident'].each do |child|

        response_query = conn.query("select * from tfd_incidents where IncidentNumber = '" + child['IncidentNumber'] + "'")
        if response_query.cmd_tuples === 0
            strJSON =  child['Vehicles'].to_json
            str = "insert into tfd_incidents values('" + child['IncidentNumber'].to_s + "','" + child['Problem'].to_s + "','" + child['Address'].to_s + "','" + child['ResponseDate'].to_s + "','" + child['Latitude'].to_s + "','" + child['Longitude'].to_s + "','" + strJSON + "')"
            response_insert = conn.query(str)
            counter = counter + 1
        end
    end

    response_query = conn.query("select count(*) from tfd_incidents")
    numRows = response_query[0]['count']

    conn.close

    puts
    puts "------------------------------"
    puts Time.now
    puts "Records Inserted: " + counter.to_s
    puts "Number Records:   " + numRows
    puts "------------------------------"
    
  rescue
  end

    sleep 1800
    
end
