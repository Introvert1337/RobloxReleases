do -- hooks
    do -- syn.request
       replaceclosure(syn.request, newcclosure(function(payload)
            local url = payload.Url;
            
            if url == "https://whitelist.hydrahub.net/api/dSgVkYp2" then 
                return {Body = '{"1":"tmSgO26scLxO51Y","2":"7WSadFSi7idfvaQ","3":"Gf8wyS8z3pYOqkl"}'}; -- random keys
            elseif url == "https://whitelist.hydrahub.net/api/mYq3t6w9" then
                return {Body = "22cca489bad9cfe5a7a6cb217767e4d895d3a5bd18b9c2d7c57ed8f7dc6ef6c1"}; -- static response with spoofed time and random values
            end;
        end));
    end;
    
    do -- tostring (i have a os.time and math.random hook but this is shorter and avoids the dumb checks)
        local old_tostring; 
        old_tostring = replaceclosure(tostring, newcclosure(function(data)
            if checkcaller() then 
                if data == 1 or data == 2 or data == 3 then -- tostring on math.random(1, 3)
                    return "2";
                elseif data == os.time() then -- tostring on os.time()
                    return "1640302130";
                end;
            end; 

            return old_tostring(data);
        end));
    end;
end;

getgenv().Key = "SO1WxX4QetzX878m"; -- this key is a part of the response
loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RandomStuff/main/hydra.lua"))();
