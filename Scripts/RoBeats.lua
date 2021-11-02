--// Localizations

local getupvalue = getupvalue or debug.getupvalue
local setupvalue = setupvalue or debug.setupvalue
local getconstants = getconstants or debug.getconstants 
local getinfo = getinfo or debug.getinfo 
local getloadedmodules = getloadedmodules or get_loaded_modules
local islclosure = islclosure or is_l_closure

local delay = delay
local wait = wait
local type = type 
local tostring = tostring
local tonumber = tonumber 
local rawget = rawget
local unpack = unpack
local require = require

local m_abs = math.abs 
local m_floor = math.floor
local m_random = math.random
local t_find = table.find 
local t_insert = table.insert
local c_fromrgb = Color3.fromRGB

local Player = game:GetService("Players").LocalPlayer

--// UI Init

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Introvert1337/Releases/master/Utilities/Epic_Thing_Library.lua"))()

local Window = Library:Window("RoBeats")

local Autoplayer = Window:Tab("Autoplayer")
local Misc = Window:Tab("Misc")

--// Variables 

local HitPercentages = {
    Perfect = 100;
    Great = 0;
    Okay = 0;
    Miss = 0;
    Combined = 0;
}

local HeldNotes = {}

local Bounds = {
    Perfect = -20;
    Great = -50;
    Okay = -100;
    Miss = -500;
}

local RELEASE_TRACK = "release_track_index"
local PRESS_TRACK = "press_track_index"
local TEST_HIT = "get_delta_time_from_hit_time"
local TEST_RELEASE = "get_delta_time_from_release_time"

local determine_key = {
    [RELEASE_TRACK] = "release",
    [PRESS_TRACK] = "press",
    [TEST_HIT] = TEST_HIT,
    [TEST_RELEASE] = TEST_RELEASE,
    ["ya_mum"] = "set_game_noteskin_colors"
}

local colors = {
    [1] = c_fromrgb(255, 0, 0);
    [2] = c_fromrgb(255, 0, 0);
    [3] = c_fromrgb(255, 0, 0);
    [4] = c_fromrgb(255, 0, 0);
}

local SongSpeedValue = 1000
local SongVolume = 1

local Database
local AllSongs
local Applying = {}
local StoredSongs = {}

--// scope shit

local TrackSystem
local get_local_elements_folder
local vip
local WebNPCManager
local SPRemoteEvent
local GameUtilities
local MenuManager
local Client
local visit_webnpc

--// Functions 

local function GetHitPercentage(a) 
    return HitPercentages[a] 
end

local function Calculate(a, b, c, d)
    local Total = a + b + c + d
    return a / Total * 100, b / Total * 100, c / Total * 100, d / Total * 100
end

local Utilities

Utilities = {
    get_target_delay_from_noteresult = function(noteresult)
        return Bounds[noteresult]
    end;
    
    get_noteresult = function()
        local P, G, O, M = Calculate(GetHitPercentage("Perfect"), GetHitPercentage("Great"), GetHitPercentage("Okay"), GetHitPercentage("Miss"))
        local Target = P + G + O + M
        local Total = 0
        local Number = m_random(0, m_floor(Target))
        
        local ChanceTBL = {}
        local Chance = {"Miss", "Okay", "Great", "Perfect"}

        for Index, Value in next, {M, O, G, P} do 
            if Value > 0 then 
                ChanceTBL[Chance[Index]] = Value
            end
        end

        local Entries = {}

        for Index, Value in next, ChanceTBL do
            Entries[Index] = {Min = Total, Max = Total + Value}
            Total = Total + Value
        end

        for Index, Value in next, Entries do
            if Value.Min <= Number and Value.Max >= Number then
                return Index
            end
        end
    end;

    updatehitpct = function()
        local P, G, O, M = GetHitPercentage("Perfect"), GetHitPercentage("Great"), GetHitPercentage("Okay"), GetHitPercentage("Miss")
        HitPercentages.Combined = P + G + O + M
    end;

    determine = function(key, constants)
        local finding = determine_key[key]
    
        if finding == nil then return false end
    
        if t_find(constants, finding) then
            return true
        end
        
        return false 
    end;
    
    get_notes = function(tracksystem)
        for Index, Value in next, tracksystem do 
            if type(Value) == "function" then 
                local Constants = getconstants(Value)

                if t_find(Constants, "do_remove") and t_find(Constants, "clear") then
                    return getupvalue(Value, 1)
                end 
            end 
        end
    end;
    
    get_tracksystems = function(_game)
        for Index, Value in next, _game do
            if type(Value) == "function" then
                local obj = getupvalue(Value, 1)

                if type(obj) == "table" and rawget(obj, "_table") and rawget(obj, "count") then
                    if obj:count() <= 4 then
                        return obj
                    end
                end
            end
        end
    end;
    
    get_func = function(parent, func)
        for Index, Value in next, parent do
            local Constants = type(Value) == "function" and getconstants(Value) or {}

            if type(Value) == "function" and Utilities.determine(func, Constants) then
                return Value
            end
        end
    end;
};

local function Apply(as,db)
    local MNM = db:name_to_key("MondayNightMonsters1")

    local OldNew = as.new
    
    as.new = function(...)
        local NewAs = OldNew(...)
        local OldSkp = NewAs.on_songkey_pressed

        NewAs.on_songkey_pressed = function(self, song)
            local actual = tonumber(song)
            
            if Library.flags["Unlock All Songs (locks score)"] then
                song = MNM
            end
            
            local song_name = db:key_to_name(song)
            local actual_name = db:key_to_name(actual)
            local title = db:get_title_for_key(actual)
            local data = StoredSongs[title]
            
            if not data then
                for Index, Module in next, getloadedmodules() do
                    local req = require(Module)

                    if type(req) == "table" and rawget(req, "HitObjects") then
                        StoredSongs[rawget(req, "AudioFilename")] = req

                        if rawget(req, "AudioFilename") == title then
                            data = req
                            break
                        end
                    end
                end
            end
            
            local all = getupvalue(db.add_key_to_data, 1)

            all:add(song, data)
            data.__key = song
            
            setupvalue(db.add_key_to_data, 1, all)
             
            return OldSkp(self, song)
        end
        
        return NewAs
    end
end

-- Fetch Game Utilities (very ugly)

for Index, Value in next, getgc(true) do
    if type(Value) == "table" then
        if rawget(Value, "key_has_combineinfo") then
            Database = Value
        end

        if rawget(Value, "input_began") then 
            local input_began = Value.input_began
            local input_ended = Value.input_ended

            Value.input_began = function(self, input) 
                if type(input) ~= "number" and input ~= Enum.KeyCode.Backspace and Library.flags["Block Input"] then 
                    return
                end 

                return input_began(self, input)
            end
            
            Value.input_ended = function(self, input) 
                if type(input) ~= "number" and input ~= Enum.KeyCode.Backspace and Library.flags["Block Input"] then 
                    return
                end 

                return input_ended(self, input)
            end
        end

        if rawget(Value, "visit_webnpc") then
            visit_webnpc = Value.visit_webnpc
        end 

        if rawget(Value, "webnpcid_should_trigger_reward") then
            WebNPCManager = Value
        end

        if rawget(Value, "EVT_WebNPC_ServerAcknowledgeClientVisitNPC") then
            SPRemoteEvent = Value
        end
        
        if rawget(Value, "fire_event_to_server") then
            GameUtilities = Value
        end
        
        if rawget(Value, "visit_webnpc") then
            MenuManager = Value
        end

        if rawget(Value, "_player_blob_manager") and typeof(Value._player_blob_manager) == "table" then
            Client = Value
        end

        if rawget(Value, "playerblob_has_vip_for_current_day") then
            vip = Value
        end

        if type(rawget(Value, "new")) == "function" and islclosure(Value.new) then
            local OldNew = Value.new
            local Finding = {"get_default_base_color_list", "get_default_fever_color_list"}
            local Found = 0

            for Index, Constant in next, getconstants(OldNew) do
                if Constant == "on_songkey_pressed" then
                    t_insert(Applying, #Applying + 1, Value)
                end

                if t_find(Finding, Constant) then
                    Found = Found + 1
                end
            end

            if Found >= #Finding and not TrackSystem then
                TrackSystem = Value
            end
        end	

        if rawget(Value, "TimescaleToDeltaTime") then 
            local OldTTDT = Value.TimescaleToDeltaTime

            Value.TimescaleToDeltaTime = function(...)
                local Arguments = {...}
                Arguments[2] = Arguments[2] * (SongSpeedValue / 1000)

                return OldTTDT(unpack(Arguments))
            end
        end

        if rawget(Value, "color3_for_slot") then 
            local old = Value.color3_for_slot

            Value.color3_for_slot = function(self, ...)
                local orig = old(self, ...)

                if not Library.flags["Note Colors"] then 
                    return orig 
                end

                return colors[self:get_track_index()] or orig
            end
        end

        if rawget(Value, "get_local_elements_folder") then 
            get_local_elements_folder = Value.get_local_elements_folder 
        end
    end
end

--// Unlock All Songs Stuff

for _, AllSongs in next, Applying do
    Apply(AllSongs, Database)
end

local playerblob_has_vip_for_current_day = vip.playerblob_has_vip_for_current_day

--// Main Autoplayer Function

local function update_autoplayer(_game, target_delay)
    local localSlot = getupvalue(_game.set_local_game_slot, 1)
    local trackSystem = Utilities.get_tracksystems(_game)._table[localSlot]
    local Notes = Utilities.get_notes(trackSystem)
    local Target = -m_abs(target_delay)
    local current_song = get_local_elements_folder():FindFirstChildWhichIsA("Sound")

    if current_song then 
        current_song.PlaybackSpeed = SongSpeedValue / 1000

        if current_song.Volume > 0 then
            current_song.Volume = SongVolume
        end
    end

    for Index = 1, Notes:count() do
        local Note = Notes:get(Index)

        if Note then
            local TEST_RELEASE_FUNC
            local TEST_HIT_FUNC
            local NoteTrack = Note:get_track_index(Index)

            for Index, Value in next, Note do 
		if type(Value) == "function" then 
		    for Index, Constant in next, getconstants(Value) do 
			if Constant == "get_delta_time_from_release_time" then 
			    TEST_RELEASE_FUNC = Value
                            break
                        elseif Constant  == "get_delta_time_from_hit_time" then
			    TEST_HIT_FUNC = Value
                            break
		 	end 
		    end
		end 
	    end

            if HeldNotes[NoteTrack] and TEST_RELEASE_FUNC then
                local Released, Result, Delay = TEST_RELEASE_FUNC(Note, _game, 0)

                if Released and Delay >= Target then
                    HeldNotes[NoteTrack] = nil

                    local release_track = Utilities.get_func(trackSystem, RELEASE_TRACK)
                    local release_time = m_random(1, 5) / 100

                    delay(release_time, function()
                        release_track(trackSystem, _game, NoteTrack)
                    end)

                    Utilities.get_func(trackSystem, RELEASE_TRACK)(trackSystem, _game, NoteTrack)

                    return true
                end
            elseif Library.flags["Autoplayer"] and TEST_HIT_FUNC then
                local hit, result, hitdelay = TEST_HIT_FUNC(Note, _game, 0)

                if hit and hitdelay >= Target then
                    Utilities.get_func(trackSystem, PRESS_TRACK)(trackSystem, _game, NoteTrack)
                    _game:debug_any_press()

                    if Note.get_time_to_end == nil then
                        HeldNotes[NoteTrack] = true
                    else
                        local release_track = Utilities.get_func(trackSystem, RELEASE_TRACK)
                        local release_time = m_random(1, 18) / 100

                        delay(release_time, function()
                            release_track(trackSystem, _game, NoteTrack)
                        end)
                    end
                end
            end
        end
    end
end

--// Autoplay Hook

local TracksystemNew = TrackSystem.new

TrackSystem.new = function(...)
    local NewTrackSystem = TracksystemNew(...)
    local OldUpdate
    local Arguments = {...}

    if Arguments[2]._players._slots:get(Arguments[3])._name == Player.Name then
        for Index, Value in next, NewTrackSystem do 
            if type(Value) == "function" then 
                local Constants = getconstants(Value)

                if t_find(Constants, "do_remove") and t_find(Constants, "remove_at") then 
                    OldUpdate = Value

                    rawset(NewTrackSystem, getinfo(Value).name, function(shit, slot, _game)
                        if Library.flags["Autoplayer"] then
                            local delay = Utilities.get_target_delay_from_noteresult(Utilities.get_noteresult()) or 25
                            coroutine.wrap(update_autoplayer)(_game, delay)
                        end

                        return OldUpdate(NewTrackSystem, slot, _game)
                    end)

                    break
                end
            end 
        end
    end

    return NewTrackSystem
end

--// UI Options

local Main = Autoplayer:Section("Main")

Main:Toggle("Block Input")

local Utils = Misc:Section("Utilities")

Utils:Slider("Song Speed", {min = 0, max = 5000, default = 1000}, function(value)
    SongSpeedValue = value
end)

Utils:Slider("Song Volume", {min = 1, max = 100, default = 10}, function(Value)
    SongVolume = Value / 10
end)

local SongId = Utils:Label("Song ID : ")

Main:Toggle("Autoplayer")

local Percentages = Autoplayer:Section("Percentages")

Percentages:Slider("Perfect Percentage", {min = 0, max = 100, default = 100}, function(value)
    HitPercentages.Perfect = value
    Utilities.updatehitpct()
end)

Percentages:Slider("Great Percentage", {min = 0, max = 100, default = 0}, function(value)
    HitPercentages.Great = value
    Utilities.updatehitpct()
end)

Percentages:Slider("Okay Percentage", {min = 0, max = 100, default = 0}, function(value)
    HitPercentages.Okay = value
    Utilities.updatehitpct()
end)

Percentages:Slider("Miss Percentage", {min = 0, max = 100, default = 0}, function(value)
    HitPercentages.Okay = value
    Utilities.updatehitpct()
end)

Utils:Toggle("Unlock All Songs (locks score)", false, function(value)
    vip.playerblob_has_vip_for_current_day = value and function() return true end or playerblob_has_vip_for_current_day
end)

Utils:Button("Collect NPC Rewards", function()
    for Index, Value in next, getupvalue(WebNPCManager.webnpcid_should_trigger_reward, 1)._table do
        MenuManager:visit_webnpc(Index, function() end)
        wait(1)
        
        Client._player_blob_manager:do_sync(function()
            GameUtilities:fire_event_to_server(SPRemoteEvent.EVT_PlayerBlob_ClientRequestSync)
        end)
    end
end)

local NoteColors = Misc:Section("Note Colors")

NoteColors:Toggle("Note Colors")

for Index = 1, 4 do 
    NoteColors:ColorPicker("Note Track " .. tostring(Index), c_fromrgb(255, 0, 0), function(value)
        colors[i] = value
    end)
end

--// Update Song ID Text

while wait(1) do 
    local elements = get_local_elements_folder()
    local sound = elements and elements:FindFirstChildWhichIsA("Sound")

    if sound then
        SongId:Update("Song ID : " .. tostring(sound.SoundId):sub(14))
    end
end
