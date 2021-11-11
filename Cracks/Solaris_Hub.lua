-- cracked 11/11/2021 due to linkvertise use (which is stupid)
-- this isn't a crack of the premium version since the premium version doesn't use linkvertise, this is a key system bypass for the free version
-- solaris_games folder at https://anonfiles.com/94qbw3Uaud/solaris_games_zip
-- extract the solaris_games.zip file into your synapse workspace folder

local url_format = {
    hwid_url = "^http[s]?://[w%.]*solarishub%.dev/keysystem/HWID%.php"; -- https://solarishub.dev/keysystem.HWID.php
    verify_url = "^http[s]?://[w%.]*solarishub%.dev/keysystem/Verify%.php"; -- https://solarishub.dev/keysystem.Verify.php
};

local dependencies = {
    fake_key = ("0"):rep(64);  -- length check lmao
    folder_directory = "solaris_games/";
};

local old_request;
old_request = replaceclosure(syn.request, function(data)
    local url = data.Url;

    if url:match(url_format.hwid_url) or url:match(url_format.verify_url) then
        return {Body = dependencies.fake_key};
    end;
    
    return old_request(data);
end);

local placeid_directory, gameid_directory = ("%s/%s.lua"):format(dependencies.folder_directory, game.PlaceId), ("%s/%s.lua"):format(dependencies.folder_directory, game.GameId);

if isfile(placeid_directory) then 
    return loadfile(placeid_directory)();
elseif isfile(gameid_directory) then 
    return loadfile(gameid_directory)();
else 
    return loadfile(("%suniversal.lua"):format(dependencies.folder_directory))();
end;
