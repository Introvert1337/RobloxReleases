--// get network keys

local network_keys = {}

local function scan_network_keys(table)
    for index, value in next, table do
        if islclosure(value) and not is_synapse_function(value) then
            for index, constant in next, getconstants(value) do
                if type(constant) == "string" then
                    local cleansed_string, pattern_matched = constant:gsub("%W+", "")
                    
                    if pattern_matched > 0 then
                        network_keys[cleansed_string] = constant
                    end
                end
            end
            
            scan_network_keys(getprotos(value))
        end
    end
end

scan_network_keys(getgc())

--// get network module

local network_module

for index, module in next, getloadedmodules() do
    if module.Name == "network" then
        network_module = require(module)
        
        break
    end
end

--// function to send normally

local function bypassed_send(name, ...)
    return network_module:send(network_keys[name], ...)
end

--bypassed_send("falldamage", 100)
