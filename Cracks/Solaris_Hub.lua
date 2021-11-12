-- cracked 11/11/2021 due to linkvertise use (which is stupid)
-- this isn't a crack of the premium version since the premium version doesn't use linkvertise, this is a key system bypass for the free version
-- solaris_games folder at https://anonfiles.com/94qbw3Uaud/solaris_games_zip
-- extract the solaris_games.zip file into your synapse workspace folder

-- this could be done in one line but i think this version is more precise
-- replaceclosure(syn.request, function() return {Body = ("0"):rep(64)}; end);

local script_paths = {
    placeid = ("solaris_games/%s.lua"):format(game.PlaceId);
    gameid = ("solaris_games/%s.lua"):format(game.GameId);
    universal = "solaris_games/universal.lua";
};

replaceclosure(syn.request, function(data)
    if data.Url == "https://solarishub.dev/keysystem/HWID.php" or data.Url == "https://solarishub.dev/keysystem/Verify.php" then
        return {Body = ("0"):rep(64)}; -- return "valid" response
    end;
        
    warn("unknown url");
    return coroutine.yield();
end);

return loadfile(isfile(script_paths.placeid) and script_paths.placeid or isfile(script_paths.gameid) and script_paths.placeid or script_paths.universal)();
