hook = hookfunction(Instance.new("RemoteEvent").FireServer, function(self, ...)
    local args = {...} 
    if #args == 2 and type(args[1]) == "table" and type(args[2]) == "table" and #args[1] == 2 and type(args[1][1]) == "number" and type(args[1][2]) == "number" and self.Parent == workspace.Live[game:GetService("Players").LocalPlayer.Name].CharacterHandler.Remotes then 
        return 
    end
    return hook(self, ...)
end)
