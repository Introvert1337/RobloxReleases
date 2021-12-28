do
    local hmac_function, uniform_rng_function = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/master/Cracks/Dependencies/HydraHub/HashLibrary.lua"))();
    local server_key = ("a"):rep(15);
    
    replaceclosure(syn.request, newcclosure(function(payload)
        local url = payload.Url;
        
        if url == "https://whitelist.hydrahub.net/api/dSgVkYp2" then 
            return {
                Body = game:GetService("HttpService"):JSONEncode({
                    ["1"] = server_key, 
                    ["2"] = server_key, 
                    ["3"] = server_key
                })
            };
        elseif url == "https://whitelist.hydrahub.net/api/mYq3t6w9" then
            local current_time = tostring(os.time());
            local time_data = uniform_rng_function(current_time:sub(-4, -4), current_time:sub(-3, -3));
            local script_key = getgenv().Key or "";
        
            return {
                Body = hmac_function(server_key, script_key .. tostring(time_data):sub(1, -3))
            };
        end;
        
        error("unhandled syn request");
    end));
    
    local old_httpget;
    old_httpget = replaceclosure(game.HttpGet, newcclosure(function(self, url, ...)
        if url == "https://raw.githubusercontent.com/HydraVirgo/hydrahubv2/main/funloadstring" then 
            return old_httpget(self, "https://raw.githubusercontent.com/Introvert1337/RobloxReleases/master/Cracks/Dependencies/HydraHub/UILibrary.lua", ...);
        end;
        
        error("unhandled http request");
    end));
end;

getgenv().Key = ("a"):rep(16);
loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/master/Cracks/Dependencies/HydraHub/RawScript.lua"))();
