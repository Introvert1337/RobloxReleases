local get_local_elements_folder

for i,v in next, getgc(true) do
	if type(v) == "table" then
		if rawget(v, "TimescaleToDeltaTime") then 
			local OldTTDT = v.TimescaleToDeltaTime
			v.TimescaleToDeltaTime = function(...)
				local args = {...}
				args[2] = args[2] * shared.SongSpeed
				return OldTTDT(unpack(args))
			end
		end
		if rawget(v, "get_local_elements_folder") then 
		    get_local_elements_folder = v.get_local_elements_folder
		end
	end
end

game:GetService("RunService").Heartbeat:connect(function()
    local local_element_folder = get_local_elements_folder()
    if local_element_folder then 
        local song_track = local_element_folder:FindFirstChildWhichIsA("Sound")
        if song_track then 
            song_track.PlaybackSpeed = shared.SongSpeed
        end
    end
end)
