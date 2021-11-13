loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/RobloxReleases/master/Scripts/Rogue_Lineage_Key_Fetcher.lua"))()

local apply_fall_damage_remote = get_remote("ApplyFallDamage");

local remote_event_hook;
remote_event_hook = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(remote, ...)
    if remote == apply_fall_damage_remote then 
        return;
    end;

    return remote_event_hook(remote, ...);
end));
