--[[
usage example: 

    -- LIST OF SYMBOL CHARACTERS, IN ORDER FOR RANGE: "!", '"', "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/"

    generate_random_string({
        length = 16, -- length of string
        
        uppercase = true, -- allow uppercase characters
        lowercase = true, -- allow lowercase characters
        numbers = true, -- allow numerical characters
        symbols = true, -- allow symbol characters
        
        lowercase_range = {"a", "z"}, -- the range between lowercase characters to allow
        uppercase_range = {"A", "Z"}, -- the range between uppercase characters to allow
        number_range = {0, 9}, -- the range between numerical characters to allow
        symbol_range = {},  -- the range between synbol characters to allow
        
        character_blacklist = {}, -- characters to disallow
        
        lowercase_blacklist_replacement = "a", -- character to replace blacklisted lowercase characters with
        uppercase_blacklist_replacement = "A", -- character to replace blacklisted uppercase characters with
        number_blacklist_replacement = 0, -- character to replace blacklisted numerical characters with
        symbol_blacklist_replacement = "!" -- character to replace blacklisted symbol characters with
    });
]]

local function generate_replacement(character, settings, check)
    if settings.lowercase and (not settings[check] or (check == "lowercase" and (settings.lowercase_range or settings.lowercase_blacklist))) then 
        if settings.lowercase_range then 
            local range_start, range_end = settings.lowercase_range[1] or settings.lowercase_range[2] and "a", settings.lowercase_range[2] or settings.lowercase_range[1] and "z";
            
            if range_start and range_end then -- i could just skip all the checks but id rather it just use string.lower if it fits in the range
                local character_lower_byte = character:lower():byte();
                local range_start_byte, range_end_byte = range_start:byte(), range_end:byte();
                
                if character_lower_byte < range_start_byte or character_lower_byte > range_end_byte then 
                    return string.char(math.random(range_start_byte, range_end_byte));
                end;
            end;
        end;
        
        return character:lower();
    end;
    
    if settings.uppercase and (not settings[check] or (check == "uppercase" and (settings.uppercase_range or settings.uppercase_blacklist))) then 
        if settings.uppercase_range then 
            local range_start, range_end = settings.uppercase_range[1] or settings.uppercase_range[2] and "A", settings.uppercase_range[2] or settings.uppercase_range[1] and "Z";
            
            if range_start and range_end then -- i could just skip all the checks but id rather it just use string.upper if it fits in the range
                local character_upper_byte = character:upper():byte();
                local range_start_byte, range_end_byte = range_start:byte(), range_end:byte();
                
                if character_upper_byte < range_start_byte or character_upper_byte > range_end_byte then 
                    return string.char(math.random(range_start_byte, range_end_byte));
                end;
            end;
        end;
        
        return character:upper();
    end;
    
    if settings.numbers and (not settings[check] or (check == "numbers" and (settings.number_range or settings.number_blacklist))) then 
        if settings.number_range then 
            local range_start, range_end = settings.number_range[1] or settings.number_range[2] and 0, settings.number_range[2] or settings.number_range[1] and 9;
            
            if range_start and range_end then 
                return math.random(range_start, range_end);
            end;
        end; 
        
        return math.random(0, 9);
    end; 
    
    if settings.symbols and (not settings[check] or (check == "symbols" and (settings.symbol_range or settings.symbol_blacklist))) then 
        if settings.symbol_range then 
            local range_start, range_end = settings.symbol_range[1] or settings.symbol_range[2] and "!", settings.symbol_range[2] or settings.symbol_range[1] and "/";
            
            if range_start and range_end then
                return string.char(math.random(range_start:byte(), range_end:byte()));
            end;
        end; 
        
        return string.char(math.random(33, 47));
    end;
end;

local function generate_random_string(settings) -- i could validate the ranges and blacklists in here to optimize but ehhhh
    assert(settings.length, "length must be provided"); -- assert is really ugly but whatever
    assert(type(settings.length) == "number", "length must be a number");
    
    assert(settings.uppercase or settings.lowercase or settings.numbers or settings.symbols, "one setting must be allowed");
    
    local random_string = syn.crypt.base64.encode(syn.crypt.random(settings.length));

    if not settings.uppercase or settings.uppercase_range or settings.uppercase_blacklist then 
        random_string = random_string:gsub("%u", function(character)
            return generate_replacement(character, settings, "uppercase");
        end);
    end;
    
    if not settings.lowercase or settings.lowercase_range or settings.lowercase_blacklist then 
        random_string = random_string:gsub("%l", function(character)
            return generate_replacement(character, settings, "lowercase");
        end);
    end;
    
    if not settings.numbers or settings.number_range or settings.number_blacklist then 
        random_string = random_string:gsub("%d", function(character)
            return generate_replacement(character, settings, "numbers");
        end);
    end;
    
    if not settings.symbols or settings.symbol_range or settings.symbol_blacklist then 
        random_string = random_string:gsub("%p", function(character)
            return generate_replacement(character, settings, "symbols");
        end);
    end;
    
    if settings.character_blacklist and #settings.character_blacklist > 0 then
        random_string = random_string:gsub(("[%s]"):format(table.concat(settings.character_blacklist)), function(character)
            if character:match("%l") then 
                return settings.lowercase_blacklist_replacement or "a";
            elseif character:match("%u") then 
                return settings.uppercase_blacklist_replacement or "A";
            elseif character:match("%d") then 
                return settings.number_blacklist_replacement or 0;
            elseif character:match("%p") then 
                return settings.symbol_blacklist_replacement or "!";
            end;
        end);
    end; 
    
    return random_string:sub(1, settings.length);
end;

return generate_random_string;
