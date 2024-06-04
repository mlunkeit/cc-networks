local lan = {}

-- Including netutil library
local netutil = require("netutil")

-- Including the json library by rxi
local json = require("json")

-- Looking for wired modem on any side
local modems = { peripheral.find("modem", function(name, modem)
    return not modem.isWireless()
end) }

local modem = modems[1]

-- Open request channel
modem.open(481)
-- Open response channel
modem.open(482)

local properties = {}

function lan.setProperty(key, value)
    properties[key] = value
end

function lan.getProperty(key)
    return properties[key] or error("No such property:  "..key)
end

function lan.init(ip, subnetmask, gateway)
   lan.setProperty("ip", netutil.convertStringToOctets(ip))
   lan.setProperty("subnet", netutil.convertStringToOctets(subnetmask))
   lan.setProperty("gateway", netutil.convertStringToOctets(gateway))
end

function lan.transmit(target_ip, port, payload)
    target_ip_octets = netutil.convertStringToOctets(target_ip)
    gateway_required = not netutil.targetIPIsInNetwork(lan.getProperty("ip"), target_ip_octets, lan.getProperty("subnet"))

    print("Gateway required: "..tostring(gateway_required))

    if gateway_required then
        error("Gateway stuff not implemented yet")
    else
        local header = {
            origin = lan.getProperty("ip"),
            target = target_ip,
            port = port
        }
    
        modem.transmit(481, 482, json.encode({header = header, payload = payload}))
    end
end

function lan.receive(port)
    local event, side, channel, replyChannel, payload, distance = os.pullEvent("modem_message")
    
end

function lan.getIP()
    return properties["ip"]
end

return lan