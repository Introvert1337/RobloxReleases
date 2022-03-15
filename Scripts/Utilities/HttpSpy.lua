--[[
  - works on syn.request, httpget, httpgetasync, httppost, getobjects, httppostasync
  - bypasses every detection method i know of

  - this script is by far the most undetected http spy
  - it doesnt support websockets yet, coming soon
]]

--// prevent any detections by cloning all used functions 

local select = clonefunction(select);
local rawget = clonefunction(rawget);
local type = clonefunction(type);
local setmetatable = clonefunction(setmetatable);
local unpack = clonefunction(unpack);
local assert = clonefunction(assert);
local pcall = clonefunction(pcall);
local next = clonefunction(next);
local appendfile = clonefunction(appendfile);
local rconsoleprint = clonefunction(rconsoleprint);
local getnamecallmethod = clonefunction(getnamecallmethod);

local string_format = clonefunction(string.format);
local string_match = clonefunction(string.match);

local coroutine_resume = clonefunction(coroutine.resume);
local coroutine_yield = clonefunction(coroutine.yield);
local coroutine_running = clonefunction(coroutine.running);
local coroutine_wrap = clonefunction(coroutine.wrap);

--// outputting stuff 

local file_name = syn.crypt.base64.encode(syn.crypt.random(4)):gsub("%p", "") .. "_http_log.txt";

if not isfile(file_name) then 
    writefile(file_name, os.date("%d/%m/%y, %I:%S %p") .. " Http Logs\n\n");
end;

local function output_message(message)
    appendfile(file_name, message);
    rconsoleprint(message);
end;

--// function to convert a table to a string

local table_format = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/main/Scripts/Utilities/TableFormatter.lua"))();

--// syn.request hook

do
    local payload_keys = {"Url", "Method", "Headers", "Cookies", "Body"};
    local valid_methods = {"GET", "POST", "PATCH", "DELETE", "HEAD", "PUT", "OPTIONS"};

    local old_syn_request;
    old_syn_request = replaceclosure(syn.request, function(...) -- credits to wally for a lot of this
        -- bypass for syn.request() error check (syn.request() and syn.request(nil) have different error messages which is why you cant just do if not payload)

        if select("#", ...) == 0 then
            return old_syn_request();
        end;

        local payload = ...;

        -- make sure payload is a table and has a url

        if type(payload) ~= "table" then
            return old_syn_request(payload);
        end;

        -- bypass for setmetatable(payload) checks

        local payload_proxy = setmetatable({}, {__index = payload});
        local payload_clone = {};

        for _, key in next, payload_keys do
            payload_clone[key] = payload_proxy[key];
        end;
        
        -- bypass for any pcall checks

        if type(payload_clone.Url) ~= "string" or not string_match(payload_clone.Url, "https?://.+") or not valid_methods[payload_clone.Method] then
            return old_syn_request(payload_clone);
        end;
        
        if type(payload_clone.Headers) ~= "table" or type(payload_clone.Cookies) ~= "table" then 
            return old_syn_request(payload_clone);
        end; 
        
        for index, value in next, payload_clone.Cookies do 
            if type(index) ~= "string" or type(value) ~= "value" then 
                return old_syn_request(payload_clone);
            end;
        end;
        
        for index, value in next, payload_clone.Headers do 
            if type(index) ~= "string" or type(value) ~= "value" then 
                return old_syn_request(payload_clone);
            end;
        end;

        -- the thread stuff is because without it you cant get the response because of yielding stuff

        local thread = coroutine_running();
            
        coroutine_wrap(function()
            local response = old_syn_request(payload_clone);

            output_message(string_format("\n\nsyn.request(%s)\n\nResponse Payload: %s", table_format(payload_clone), table_format(response)));
            
            assert(coroutine_resume(thread, response)); -- return response to "thread" thread
        end)();
        
        return coroutine_yield(); -- yield thread until resumed
    end);
end; 

--// http functions hooks 

do 
    -- index values cuz called every __namecall so optimizations needed

    local http_methods = {
        HttpGet = true,
        HttpGetAsync = true,
        GetObjects = true,
        HttpPost = true,
        HttpPostAsync = true
    };

    local old_http_functions = {};

    -- hook index variations of functions table

    for http_method in next, http_methods do 
        old_http_functions[http_method] = replaceclosure(game[http_method], function(self, ...)
            local old_http_function = old_http_functions[http_method];
            local arguments = {...};
            
            local thread = coroutine_running();
                
            coroutine_wrap(function()
                local success, response = pcall(old_http_function, self, unpack(arguments));

                if success then
                    output_message(string_format("\n\ngame.%s(%s)\n\nResponse: %s", http_method, table_format(arguments), response));
                    
                    assert(coroutine_resume(thread, response));
                else 
                    assert(coroutine_resume(thread));
                end;
            end)();
            
            local response = coroutine_yield();
            
            if response then 
                return response 
            else 
                return old_http_function(self, ...);
            end;
        end);
    end;
    
    -- hook namecall variations of functions

    local old_namecall;
    old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
        local call_method = getnamecallmethod();
        
        if http_methods[call_method] then
            local arguments = {...};
            
            local thread = coroutine_running();
                
            coroutine_wrap(function()
                local success, response = pcall(old_http_functions[call_method], self, unpack(arguments));

                if success then
                    output_message(string_format("\n\ngame:%s(%s)\n\nResponse: %s", call_method, table_format(arguments), response));
                    
                    assert(coroutine_resume(thread, response));
                else 
                    assert(coroutine_resume(thread));
                end;
            end)();
            
            local response = coroutine_yield();
            
            if response then 
                return response 
            else 
                return old_namecall(self, ...);
            end;
        end;

        return old_namecall(self, ...);
    end);
end;
