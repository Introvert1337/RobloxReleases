-- this was mostly made by sor

local key_handler = game:GetService("ReplicatedStorage").Assets.Modules.KeyHandler;

local patcher = {};

do 
    local tf = table.find;
    local type = type;

    patcher.__index = patcher;

    local psu_struct = {
        next = "sBgaL",
        rC = 639954,
        rBx = "jDWh3",
        rB = -50014,
        rA = "CuAjnb"
    };

    function patcher:new(upvalues)
        return setmetatable({
            upvalues = upvalues,
            instructions = nil,
            stack = nil,
            indexes = {},
            cur_instr = 0;
        }, patcher);
    end;

    function patcher:grab_dependencies()
        for idx, upvalue in ipairs(self.upvalues) do 
            if type(upvalue) == "table" then
                if upvalue[0] then
                    local entry = upvalue[0];

                    if entry and type(entry) == "table" then 
                        if entry[psu_struct.next] then 
                            self.instructions = upvalue;
                        end;
                    end;
                else
                    self.stack = upvalue;
                end;
            end;
        end;

        assert(self.instructions, "unable to find instructions!");
        assert(self.stack, "unable to find stack!");
    end;

    function patcher:patch_instruction(old, new)
        for idx, val in next, new do 
            old[idx] = val;
        end;
    end;

    function patcher:patch_method(method, ...)
        if method == 1 then
            local cur_instr = self.cur_instr;
            local eq_amount = 0;

            while true do
                local instr = self.instructions[cur_instr]; 
                if type(instr[psu_struct.rB]) == "table" then 
                    eq_amount++;
                else
                    eq_amount = 0;
                end;

                if eq_amount == 2 then 
                    local to_patch = self.instructions[cur_instr - 1];
                    local go_to = instr[psu_struct.rB];
                
                    self:patch_instruction(to_patch, go_to);
                    cur_instr = tf(self.instructions, go_to);
                    break;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        elseif method == 2 then 
            local cur_instr = self.cur_instr;
            local to_patch;

            while true do 
                local instr = self.instructions[cur_instr];

                if type(instr[psu_struct.rB]) == "table" then 
                    if self.instructions[cur_instr + 2][psu_struct.rC] == "LocalPlayer" then 
                        local to_patch = instr;
                        local go_to = instr[psu_struct.rB];

                        self:patch_instruction(to_patch, go_to);
                        cur_instr = tf(self.instructions, go_to);
                        break;
                    end;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        elseif method == 3 then
            local cur_instr = self.cur_instr;
            local to_patch;

            while true do 
                local instr = self.instructions[cur_instr];

                if type(instr[psu_struct.rB]) == "table" then 
                    if self.instructions[cur_instr - 3][psu_struct.rC] == "FindFirstChild" then 
                        local to_patch = instr;
                        local go_to = instr[psu_struct.rB];

                        self:patch_instruction(to_patch, go_to);
                        cur_instr = tf(self.instructions, go_to);
                        break;
                    end;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        elseif method == 4 then
            local cur_instr = self.cur_instr;
            local to_patch;

            while true do 
                local instr = self.instructions[cur_instr];

                if type(instr[psu_struct.rB]) == "table" then 
                    if type(self.instructions[cur_instr + 2][psu_struct.rBx]) == "table" and 
                        type(self.instructions[cur_instr + 5][psu_struct.rBx]) == "table" then 
                        local to_patch = instr;
                        local go_to = instr[psu_struct.rB];

                        self:patch_instruction(to_patch, go_to);
                        cur_instr = tf(self.instructions, go_to);
                        break;
                    end;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        elseif method == 5 then
            local cur_instr = self.cur_instr;
            local to_patch;

            local args = {...};

            while true do 
                local instr = self.instructions[cur_instr];

                if type(instr[psu_struct.rB]) == "table" then 
                    if self.instructions[cur_instr + args[1]][psu_struct.rB] == "EEKEWAEJIWAJDOIWAJDIOJAWDIOJAWODJOAIW" then 
                        local to_patch = instr;
                        local go_to = instr[psu_struct.rB];

                        self:patch_instruction(to_patch, go_to);
                        cur_instr = tf(self.instructions, go_to);
                        break;
                    end;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        elseif method == 6 then
            local cur_instr = self.cur_instr;
            local to_patch;

            while true do 
                local instr = self.instructions[cur_instr];

                if type(instr[psu_struct.rB]) == "table" then 
                    if type(self.instructions[cur_instr + 4][psu_struct.rB]) == "table" then 
                        local to_patch = instr;
                        local go_to = self.instructions[cur_instr + 4][psu_struct.rB];

                        self:patch_instruction(to_patch, go_to);
                        cur_instr = tf(self.instructions, go_to);
                        break;
                    end;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        elseif method == 7 then
            local cur_instr = self.cur_instr;
            local to_patch;

            while true do 
                local instr = self.instructions[cur_instr];

                if type(instr[psu_struct.rB]) == "table" then 
                    local success = true;
                    for idx = 1, 5 do 
                        if type(self.instructions[cur_instr + idx][psu_struct.rB]) ~= "table" then 
                            success = false;
                        end;
                    end;

                    if success then
                        local to_patch = instr;
                        local go_to = instr[psu_struct.rB];

                        self:patch_instruction(to_patch, go_to);
                        cur_instr = tf(self.instructions, go_to);
                        break;
                    end;
                end;

                cur_instr++;
            end;

            self.cur_instr = cur_instr;
        end;
    end;

    function patcher:patch_instructions(patch_type)
        if patch_type == 1 then -- module type
            self.instructions[0] = self.instructions[#self.instructions - 5];
        elseif patch_type == 2 then -- getkey type
            self:patch_method(1);
            self:patch_method(2);
            self:patch_method(3);
            self:patch_method(4);
            self:patch_method(5, 9);
            self:patch_method(5, 6);
            self:patch_method(5, 6);
            self:patch_method(6);
            self:patch_method(7);

            --[[
                self:patch_instruction(self.instructions[8], self.instructions[32]);
                self:patch_instruction(self.instructions[45], self.instructions[81]);
                self:patch_instruction(self.instructions[88], self.instructions[102]);
                self:patch_instruction(self.instructions[109], self.instructions[132]);
                self:patch_instruction(self.instructions[135], self.instructions[152]);
                self:patch_instruction(self.instructions[161], self.instructions[175]);
                self:patch_instruction(self.instructions[185], self.instructions[202]);
                self:patch_instruction(self.instructions[203], self.instructions[219]);
                self:patch_instruction(self.instructions[222], self.instructions[241]);
            ]]
        end;
    end;

    function patcher:patch(patch_type)
        self:grab_dependencies();

        self:patch_instructions(patch_type);
    end;
end;

assert(getscripthash(key_handler) == "082d0ac8b31be577c717ceac49ba57fdbdc2fcf23206fd4dfc1fdb22818962d0b95e655681f4d9f9bc584b365cff83b6", "Rogue KeyHandler Updated!");

local module = require(key_handler);

local module_patcher = patcher:new(getupvalues(module));
module_patcher:patch(1);

local get_key, set_key = unpack(module());

local get_key_patcher = patcher:new(getupvalues(get_key));
get_key_patcher:patch(2);

local dodge_fpe_key = (398 + 0.000100214 + (0.005328780 / (10 ^ 9)) + (0.33 / (10 ^ 18)));
local old_get_key = get_key;

getgenv().get_key = function(key, pass)
    pass = pass or "plum";
    key = key == "Dodge" and dodge_fpe_key or key;

    return old_get_key(key, pass);
end;
