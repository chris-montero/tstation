
-- NICE AND EASY PUBLISH/SUBSCRIBE SYSTEM
-- Copyright Chris Montero 2024

local function _create_pcall_error_message(func, result)

    if type(func) ~= "function" then 
        return "Expected function, got: " .. func
    end
    local info = debug.getinfo(func, "f")
    return "Calling function \"" .. tostring(info.func) .. "\" failed: " .. tostring(result)
end

local function subscribe_function(station, func)
    if type(func) ~= "function" then 
        local error_msg = "Can't subscribe function on station <" .. tostring(station) .. ">. Expected function. Got: " .. tostring(func)
        print(debug.traceback(error_msg));
        return
    end
    station[func] = true
end

local function subscribe_function_with_data(station, func, subscriber_data)
    station[func] = subscriber_data
end

local function unsubscribe_function(station, func)
    station[func] = nil
end

local function emit(station, ...)

    for func, subscriber_data in pairs(station) do

        if subscriber_data == true then -- there's no subscriber data
            local success, result = pcall(func, ...)
            if not success then
                io.stdout:write(debug.traceback(_create_pcall_error_message(func, result)) .. "\n")
                io.stdout:flush()
            end
        else
            local success, result = pcall(func, subscriber_data, ...)
            if not success then
                io.stdout:write(debug.traceback(_create_pcall_error_message(func, result)) .. "\n")
                io.stdout:flush()
            end
        end

    end
end

local function new()
    local station = {}
    return station
end

return {
    new = new,

    emit = emit,
    subscribe_function = subscribe_function,
    subscribe_function_with_data = subscribe_function_with_data,
    unsubscribe_function = unsubscribe_function,
}


