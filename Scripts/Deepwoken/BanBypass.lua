local old_coroutine_wrap;
old_coroutine_wrap = replaceclosure(coroutine.wrap, newcclosure(function(func, ...)
    if not checkcaller() then
        local caller_info = getinfo(5, "f");

        if caller_info and caller_info.func == pcall then
            return coroutine.yield();
        end;
    end;
    
    return old_coroutine_wrap(func, ...);
end));
