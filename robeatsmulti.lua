local function count(tbl)
    local index = 0 
    for i,v in next, tbl do 
        index = index + 1 
    end 
    return index 
end

return function(multiplier)
    for i,v in next, getloadedmodules() do
        if v.Parent == nil then
            local req = require(v)
            if type(req) == "table" and rawget(req, "new") and type(rawget(req, "new")) == "function" and count(debug.getconstants(req.new)) == 69 then
                for k,x in next, getupvalues(req.new) do
                    if type(x) == "table" then 
                        for a,b in next, x do 
                            if a == "get_powerbar_multiplier" then 
                                rawset(x, a, function() return multiplier end)
                            elseif a == "get_powerbar_base_decay_time_seconds" then 
                                rawset(x, a, function() return math.huge end)
                            elseif a == "get_fever_fill_base" then 
                                rawset(x, a, function() return 0.0001 end)
                            elseif a == "get_powerbar_noteresult_fill" then 
                                rawset(x, a, function() return 1 end)
                            elseif a == "get_powerbar_noteresult_drain" then 
                                rawset(x, a, function() return 0 end)
                            end
                        end
                    end
                end
            end
        end
    end
end
