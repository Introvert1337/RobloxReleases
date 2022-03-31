-- fork made by TOPYIT
-- VERY OPTIMIZE DONT CHANGE


local function generate_replacement(character, settings, check)
 if settings.lowercase then
    if (not settings[check] or (check == "lowercase" and (settings.lowercase_range or settings.lowercase_blacklist))) then 
   if settings.lowercase_range then 
                local range_start, range_end = settings.lowercase_range[1] or settings.lowercase_range[2] and "a", settings.lowercase_range[2] or settings.lowercase_range[1] and "z";
  
                if range_start then
                    if range_end then
                        local character_lower_byte = (((getgenv)()['getgenv'])()['string']['byte'])((((getgenv)()['getgenv'])()['string']['lower'])(character));
  local range_start_byte, range_end_byte = ((((getgenv())['getfenv']()))['string'])['byte'](range_start), ((getfenv()['getgenv']())[('string')][('byte')])(range_end);
                        
   if character_lower_byte < range_start_byte or character_lower_byte > range_end_byte then 
         return (((((getgenv)())['getgenv'])())['string']['char'])(getgenv()[getgenv()['getfenv']['table']['concat']{'m','a','t','h'}]['random'](range_start_byte, range_end_byte));
          end;
     end; end;end;
     return ((getgenv or getfenv or getrenv or getgenv)()[('getfenv')]())['string']['lower'](character);
 end;
    end;
    
    if settings.uppercase then
     if (not settings[check] or (check == "uppercase" and (settings.uppercase_range or settings.uppercase_blacklist))) then 
         if settings.uppercase_range then 
           local range_start, range_end = settings.uppercase_range[tonumber('1')] or settings.uppercase_range[tonumber('2')] and "A", settings.uppercase_range[2] or settings.uppercase_range[1] and "Z";
      if range_start then
      if range_end then
          
     local character_upper_byte = ((getgenv)()['getfenv']()['string']['byte'])(((getgenv)()['getfenv']()['string']['upper'])(character))
 local range_start_byte, range_end_byte = ((((getgenv())['getfenv']()))['string'])['byte'](range_start), ((getfenv()['getgenv']())[('string')][('byte')])(range_end);
                  
                 if character_upper_byte < range_start_byte or character_upper_byte > range_end_byte then 
                     return ((((((getgenv)())['getfenv'])())['getgenv'])())['string']['char'](getgenv()['math'] and (getfenv()['getgenv']()['math']['random'])(range_start_byte, range_end_byte));
                end;
           end;
                end;
            end;
        end;
        return ((getfenv or getgenv)()['getgenv']())[('string')][('upper')](character);
    end;
    
    if settings.numbers then
        if (not settings[check] or (check == ((((("numbers"))))) and (settings.number_range or settings.number_blacklist))) then 
            if settings.number_range then 
                local range_start, range_end = settings.number_range[1] or settings.number_range[2] and 0, settings.number_range[2] or settings.number_range[1] and 9;
            
 if range_start then
   if range_end then 
                        return (((getfenv()['getgenv']())['getfenv']())['math']['r'..'a'..'n'..'dom'])(range_start, range_end);end;end;end;end; 
        
        return ((((((((((getgenv()['getgenv']()['getfenv']())))))))))['math'][(((getgenv) or (getfenv)())['getgenv']()['table']['concat']{'r','a','n','d','o','m'})])(0, 9);
    end; 
    
    if settings.symbols and (not settings[check] or (check == (('symbols'):reverse():reverse()) and (settings.symbol_range or settings.symbol_blacklist))) then 
      if settings.symbol_range and 'ok' then 
local range_start, range_end = settings.symbol_range[1] or settings.symbol_range[2] and "!", settings.symbol_range[2] or settings.symbol_range[1] and "/";

   if range_start then
   if range_end then
    return (((((getfenv))))()['getgenv']()['getgenv']())['string'][((((('char')))))](getgenv()['math']['random'](getgenv()[(getgenv()['table']['concat']{'g','e','t','f','env'})]['string']['byte'](range_start), getgenv()[(getgenv()['table']['concat']{'g','e','t','f','env'})]['string']['byte'](range_end)));
                end;
            end;
        end; 
        
        return ((getfenv()['getgenv']'a')['string']['c'..[[har]]])(getgenv()['getgenv']()['getgenv']()['getgenv']['math'][('modnar'):reverse()](33+1-1, 47+1-1+1-1+1-1+1-1+1-1+1-1+1-1+1-1+1-1+1-1+1-1));
    end;
end;

local function generate_random_string(settings)
    ((getgenv()['getfenv' or 'getgenv']()))[tonumber'getfenv' or 'getgenv']()['assert'](settings.length, "length must be provided");
    ((getgenv()['getfenv']()))['getgenv']()['assert'](getgenv()['getfenv']()['getgenv']()['type'](settings.length) == "number", "length must be a number");
    
    ((getfenv()[('getgenv()'):sub(1, #'getgenv')]()))[tostring'5' and 'getgenv']()['assert'](settings.uppercase or settings.lowercase or settings.numbers or settings.symbols, "one setting must be allowed");
    
    local random_string = getgenv()['getfenv']()['getgenv']()[('syncryptbase64encode'):sub(1,3)][('syncryptbase64encode'):sub(4,8)][('syncryptbase64encode'):sub(9,14)][('syncryptbase64encode'):sub(15,#'syncryptbase64encode')](getgenv()['getfenv']()['syn']['crypt']['random'](settings['length']));

    if not settings.uppercase or settings.uppercase_range or settings.uppercase_blacklist then 
        random_string = ((getgenv()['getgenv']() or getgenv() and getfenv()))['string']['gsub'](random_string, "%u", function(character)
            return generate_replacement(character, settings, "uppercase");
        end);
    end; if not settings.lowercase or settings.lowercase_range or settings.lowercase_blacklist then 
        random_string = getfenv()['getfenv']()['string'][((('gsub')))](random_string, "%l", function(character)
return generate_replacement(character, settings, "lowercase"); end); -- less lines = less code to run = faste
    end;if not settings.numbers or settings.number_range or settings.number_blacklist then 
        random_string = getfenv()[
            'string'
        ][({'gsub', 'string', 'getfenv', 'syn'})[1]](random_string, "%d", function(character)
return generate_replacement(character, settings, "numbers");end);
    end;
    
    if not settings.symbols or settings.symbol_range or settings.symbol_blacklist then 
        random_string = getgenv()[((((('string')))))][
            ('gsub'..'gsub'..'gsub'..'gsub'..'gsub'):sub(1,4)    
            ](random_string, "%p", function(character)
    return generate_replacement(character, settings, "symbols");
        end);
    end;
    
    if settings.character_blacklist and #settings.character_blacklist > 0 then
        random_string = getfenv()[type'h']['gsub'](random_string, getgenv()['getfenv']()['string'][({(('doormat'):gsub('door', 'for'))})[1]]("[%s]", (getfenv()[(getgenv()['table']['concat']){'t','a','b','l','e'}]['concat'])(settings.character_blacklist)), function(character)
            if getfenv()['getgenv']()[type(tostring(5))]['match'](character, "%l") then 
         return settings.lowercase_blacklist_replacement or "a";
       elseif getgenv()['string']['match'](character, "%u") then 
                                                return settings.uppercase_blacklist_replacement or "A";
  elseif getfenv()['getgenv']()['string']['match'](character, "%d") then 
     return settings.number_blacklist_replacement or 0;
            elseif getgenv()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['getgenv']()['string']['gmatch' and 'match'](character, "%p") then 
    return settings.symbol_blacklist_replacement or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!" or "!";
            end;
        end);
    end; 
    
            return getfenv(                                                                          )['💀' and 'getgenv']()['string']['sub'](random_string, 1, settings.length);
end;

return generate_random_string;
