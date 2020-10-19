local exploit = (syn and not is_sirhurt_closure and not pebc_execute and "Synapse") or (secure_load and "Sentinel") or (pebc_execute and "ProtoSmasher") or (KRNL_LOADED and "Krnl") or ("Unsupported") 
local req = (exploit == "Synapse" and syn.request) or ((exploit == "Sentinel" or exploit == "Krnl") and request) or (exploit == "ProtoSmasher" and http_request) 
local HookHttp = true

local urls = {}

httphook = hookfunction(game.HttpGet, function(self, url, ...)
    if HookHttp then
        table.insert(urls, {Url = url, Resp = nil, Type = "http"})
    end
    return httphook(self, url, ...)
end)

if exploit == "Synapse" then 
    setreadonly(syn, false)
    local oldreq = syn.request 
    syn.request = function(data)
        local res = oldreq(data)
        table.insert(urls, {Url = data.Url, Resp = res, Type = "req"})
        return res
    end
    setreadonly(syn, true)
elseif (exploit == "Sentinel" or exploit == "Krnl") then 
    local oldreq = request 
    request = function(data)
        local res = oldreq(data)
        table.insert(urls, {Url = data.Url, Resp = res, Type = "req"})
        return res
    end
elseif exploit == "ProtoSmasher" then 
    local oldreq = http_request 
    http_request = function(data)
        local res = oldreq(data)
        table.insert(urls, {Url = data.Url, Resp = res, Type = "req"})
        return res
    end
end

--// SCRIPT HERE

HookHttp = false 

for i,v in next, urls do 
    if v.Resp == nil and v.Type == "http" then 
        v.Resp = game:HttpGet(v.Url)
    end 
end

local function Format(a)
    if typeof(a) == "string" then 
        a = "'"..a.."'"
    end 
    return tostring(a)
end

local function GenerateOutput()
    local Output = ""
    local http, request, httpbase, reqbase = false, false, nil, nil
    for i,v in next, urls do 
        if v.Type == "http" then 
            http = true
        elseif v.Type == "req" then 
            request = true
        end
    end
    if http then 
        httpbase = "httphook = hookfunction(game.HttpGet, function(self, url, ...)\n"
        for i,v in next, urls do 
            if v.Type == "http" then 
                httpbase = httpbase.."      if string.find(url, '"..string.split(v.Url, "?")[1].."') then\n".. "          return '"..v.Resp.."'\n      end\n\n"
            end
        end
        httpbase = httpbase.."      return httphook(self, url, ...)\nend)"
    end
    if request then 
        reqbase = "reqhook = hookfunction("..((exploit == "Synapse" and "syn.request") or ((exploit == "Sentinel" or exploit == "Krnl") and "request") or (exploit == "ProtoSmasher" and "http_request"))..", function(data)\n".."      local url = data.Url\n".."      local res = reqhook(data)\n" 
        for i,v in next, urls do 
            if v.Type == "req" then 
                reqbase = reqbase.."      if string.find(url, '"..string.split(v.Url, "?")[1].."') then \n"
                for k,x in next, v.Resp do 
                    if k ~= "Headers" and k ~= "Cookies" then 
                        reqbase = reqbase.."          res[".."'"..k.."'] = "..Format(x).."\n"
                    end 
                end
                reqbase = reqbase.."      end\n"
            end
        end
        reqbase = reqbase.."      return res\nend)"
    end
    if httpbase then 
        Output = Output..httpbase
    end 
    if reqbase then 
        Output = Output.."\n\n"..reqbase 
    end
    return Output
end

writefile("crack.txt", GenerateOutput())
