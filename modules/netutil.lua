local netutil = {}
    
function netutil.convertStringToOctets(str)
    octets = {}
    i = 1
    for o in string.gmatch(str, "([^.]+)") do
        octet = tonumber(o)
        if octet >= 256 then
            error("8-bit maximum exceeded")
        end
        octets[i] = octet
        i = i + 1
    end
    if i ~= 5 then
        error("Invalid count of octets")
    end
    return octets
end

function netutil.convertOctetsToString(octets)
    return table.concat(octets, ".")
end
    
function netutil.calculateNetworkID(ip, subnetmask)
    netID = {}
    for i = 1, 4 do
        netID[i] = bit.band(ip[i], subnetmask[i])
    end
    return netID 
end
    
function netutil.calculateHostID(ip, subnetmask)
    hostID = {}
    for i = 1, 4 do
        hostID[i] = bit.band(ip[i], bit.band(bit.bnot(subnet[i]), 255))
    end
    return hostID
end

function netutil.targetIPIsInNetwork(ip, target_ip, subnetmask)
    return table.concat(netutil.calculateNetworkID(ip, subnetmask), ".") == table.concat(netutil.calculateNetworkID(target_ip, subnetmask), ".")
end

return netutil