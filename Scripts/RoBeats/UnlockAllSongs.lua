--// variables 

local songs = {};
local stored_songs = {};

local song_database;
local monday_night_monsters_key;

--// get dependencies

for index, value in next, getgc(true) do -- cant use getloadedmodules cuz of some stuff (this is kinda unoptimized also but doesnt matter since only runs once)
    if type(value) == "table" then
        if rawget(value, "playerblob_has_vip_for_current_day") then
            value.playerblob_has_vip_for_current_day = function()
                return true; 
            end;
        elseif rawget(value, "AudioFilename") then 
            stored_songs[value.AudioFilename] = value;
        elseif rawget(value, "key_has_combineinfo") then
            song_database = value;
            
            monday_night_monsters_key = value:name_to_key("MondayNightMonsters1");
        elseif rawget(value, "new") and islclosure(value.new) then 
            if table.find(getconstants(value.new), "on_songkey_pressed") then 
                songs[value] = true;
            end;
        end;
    end;
end;

--// functions 

local function apply_song(song)
    local old_song_new = song.new;
    song.new = function(...)
        local song_data = old_song_new(...);
        
        local old_on_songkey_pressed = song_data.on_songkey_pressed;
        song_data.on_songkey_pressed = function(self, song_id)
            local stored_song = stored_songs[song_database:get_title_for_key(tonumber(song_id))];
            
            local all_songs = getupvalue(song_database.add_key_to_data, 1);
            
            all_songs:add(monday_night_monsters_key, stored_song);
            stored_song.__key = monday_night_monsters_key;
            
            setupvalue(song_database.add_key_to_data, 1, all_songs);
                
            return old_on_songkey_pressed(self, monday_night_monsters_key);
        end;
        
        return song_data;
    end;
end;

--// apply songs 

for song, placeholder in next, songs do
    apply_song(song);
end;
