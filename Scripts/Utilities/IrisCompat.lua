-- made by iris

if rawget(getgenv(), "syn") then
	for FuncName, Function in next, syn do
		getgenv()[FuncName] = getgenv()["syn"][FuncName]
	end
else
	getgenv()["syn"] = {};
end

local Functions = {
	--// Meta Table Functions \\--
	["getrawmetatable"] = get_raw_metatable or getrawmetatable or "getrawmetatable was not found in exploit environment",
	["setrawmetatable"] = set_raw_metatable or setrawmetatable or "setrawmetatable was not found in exploit environment",
	["setreadonly"] = setreadonly or make_readonly or makereadonly or "setreadonly was not found in exploit environment",
	["iswriteable"] = iswriteable or writeable or is_writeable or "iswriteable was not found in exploit environment",

	--// Mouse Inputs \\--
	["mouse1release"] = mouse1release or syn_mouse1release or m1release or m1rel or mouse1up or "mouse1release was not found in exploit environment",
	["mouse1press"] = mouse1press or mouse1press or m1press or mouse1click or "mouse1press was not found in exploit environment",
	["mouse2release"] = mouse2release or syn_mouse2release or m2release or m1rel or mouse2up or "mouse2release was not found in exploit environment",
	["mouse2press"] = mouse2press or mouse2press or m2press or mouse2click or "mouse2press was not found in exploit environment",

	--// IO Functions \\--
	["isfolder"] = isfolder or syn_isfolder or is_folder or "isfolder was not found in exploit environment",
	["isfile"] = isfile or syn_isfile or is_file or "isfile was not found in exploit environment",
	["delfolder"] = delfolder or syn_delsfolder or del_folder or "delfolder was not found in exploit environment",
	["delfile"] = delfile or syn_delfile or del_file or "delfile was not found in exploit environment",
	["appendfile"] = appendfile or syn_io_append or append_file or "appendfile was not found in exploit environment",

	--// Environment Manipulation Functions \\--
	["hookfunction"] = hookfunction or hookfunc or detour_function or "hookfunction was not found in exploit environment",
	["islclosure"] = islclosure or is_lclosure or isluaclosure or "islclosure was not found in exploit environment",
	["iscclosure"] = iscclosure or is_cclosure or "iscclosure was not found in exploit environment",
	["newcclosure"] = newcclosure or new_cclosure or "newcclosure was not found in exploit environment",
	["cloneref"] = clonereference or cloneref or "cloneref was not found in exploit environment",
	["getconnections"] = getconnections or get_connections or get_signal_cons or "getconnections was not found in exploit environment",
	["getnamecallmethod"] = getnamecallmethod or get_namecall_method or "getconnections was not found in exploit environment",

	--// Protection Functions \\--

	--// Instance Functions \\--
	["getnilinstances"] = getnilinstances or get_nil_instances or "getnilinstances was not found in exploit environment",
	["getproperties"] = getproperties or get_properties or "getproperties was not found in exploit environment",
	["fireclickdetector"] = fireclickdetector or fire_click_detector or "fireclickdetector was not found in exploit environment",
	["gethiddenproperties"] = gethiddenproperties or get_hidden_properties or gethiddenprop or get_hidden_prop or "gethiddenproperties was not found in exploit environment",
	["sethiddenproperties"] = sethiddenproperties or set_hidden_properties or sethiddenprop or set_hidden_prop or "sethiddenproperties was not found in exploit environment",

	--// Network Functions \\--
	["setsimulationradius"] = setsimradius or set_simulation_radius or setsimulationradius or "setsimulationradius was not found in exploit environment",
	["getsimulationradius"] = getsimradius or get_simulation_radius or getsimulationradius or "getsimulationradius was not found in exploit environment",
	["isnetworkowner"] = isnetowner or isnetworkowner or is_network_owner or "isnetworkowner was not found in exploit environment",

	--// Misc Functions \\--
	["http_request"] = http_request or request or httprequest or "http_request was not found in exploit environment",
	["isluau"] = function() return true end,
	["isrbxactive"] = isrbxactive or "isrbxactive was not found in exploit environment", 
	["writeclipboard"] = write_clipboard or writeclipboard or setclipboard or set_clipboard or "writeclipboard was not found in exploit environment",
	["queue_on_teleport"] = queue_on_teleport or queueonteleport or "queue_on_teleport was not found in exploit environment",
	["is_exploit_function"] = is_synapse_function or isourclosure or isexecutorclosure or is_sirhurt_closure or issentinelclosure or is_protosmasher_closure or "is_exploit_function was not found in exploit environment",
	["getthreadcontext"] = getthreadcontext or get_thread_context or "getthreadcontext was not found in exploit environment",
	["setthreadcontext"] = setthreadcontext or set_thread_context or "setthreadcontext was not found in exploit environment",
	["getcallingscript"] = getcallingscript or get_calling_script or "getcallingscript was not found in exploit environment",

}


for FuncName, Function in next, Functions do
	getgenv()[FuncName] = Function;
end

if rawget(getgenv(), "crypt") then
	if not getgenv()["crypt"]["custom"] then
		getgenv()["crypt"]["custom"] = {};
	end
	for FuncName, Function in next, getgenv()["crypt"] do
		getgenv()["crypt"]["custom"][FuncName] = Function;
	end
end

if not (type(Functions["setreadonly"]) == "string" and type(Functions["setrawmetatable"]) == "string") then 
	Functions["setreadonly"](getgenv().syn, false)

	Functions["setrawmetatable"](getgenv().syn, {
		__index = function(OriginalEnv, Element)
			return getgenv()[Element];
		end,
	})
	Functions["setreadonly"](getgenv().syn, true)
end

getgenv()["Iris"] = {}

getgenv()["Iris"].GetMissingFunctions = function()
	local MissingFuncs = {};
	for FuncName, Function in next, Functions do
		if type(Function) == "string" then
			table.insert(MissingFuncs, FuncName);
		end
	end
	return MissingFuncs;
end

getgenv()["Iris"].HasFunction = function(FuncToFind)
	
	for FuncName, FuncData in next, Functions do
		if FuncName:match(FuncToFind) then
			return true;
		end
	end

	for FuncName, FuncData in next, getgenv() do
		if FuncName:match(FuncToFind) then
			return true;
		end
	end

	return false;
end

getgenv()["Iris"].TestCompat = function()
	warn("Items in Syn Table:", #syn)
	table.foreach(syn.request({
		Url = "http://httpbin.org/post",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json" 
		},
		Body = game:GetService("HttpService"):JSONEncode({hello = "world"})
	}), warn)
end

for FuncName, Function in next, getgenv()["Iris"] do
	getgenv()[FuncName] = Function;
end
