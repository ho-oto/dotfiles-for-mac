local application = require "hs.application"
local window      = require "hs.window"
local hotkey      = require "hs.hotkey"
local geometry    = require "hs.geometry"
local timer       = require "hs.timer"
local screen      = require "hs.screen"

hotkey.bind(
    { 'ctrl', 'cmd' }, 'z', function()
    local wezterm = application.get("WezTerm")

    if not wezterm then
        application.launchOrFocus("WezTerm")
        -- wait until WezTerm launches and resize window
        local c = 0
        timer.waitUntil(
            function()
                if c > 50 then return true else c = c + 1 end
                return window.frontmostWindow():application():name() == "WezTerm"
            end,
            function()
                local w = window.frontmostWindow()
                if w:application():name() ~= "WezTerm" then return end
                local s = screen.mainScreen():fullFrame()
                w:setFrame(geometry.rect(s.x, (2 / 5) * s.h, s.w, (3 / 5) * s.h))
            end,
            0.01)
        return
    end

    local allWindows = wezterm:allWindows() -- get all windows of wezterm
    table.sort(allWindows, function(a, b) return a:id() < b:id() end)

    local weztermGui = application.get("wezterm-gui")
    local allWindowsGui = nil
    if weztermGui then -- check if wezterm-gui is active
        allWindowsGui = weztermGui:allWindows()
        table.sort(allWindowsGui, function(a, b) return a:id() < b:id() end)
        for _, w in ipairs(allWindowsGui) do table.insert(allWindows, w) end
    end

    if weztermGui then
        if not wezterm:isFrontmost() and not weztermGui:isFrontmost() then
            weztermGui:setFrontmost()
            allWindowsGui[1]:focus()
            wezterm:setFrontmost()
            allWindows[1]:focus()
            return
        end
    else
        if not wezterm:isFrontmost() then
            wezterm:setFrontmost()
            allWindows[1]:focus()
            return
        end
    end

    local currentFrontmostId = window.frontmostWindow():id()
    for k, w in ipairs(allWindows) do
        if w:id() == currentFrontmostId then
            local nw = allWindows[k + 1]
            if nw then nw:focus()
            else
                wezterm:hide()
                if weztermGui then weztermGui:hide() end
            end
            return
        end
    end
end
)

hotkey.bind({ 'ctrl', 'cmd' }, 'a', function()
    local wezterm = application.get("WezTerm")
    local weztermGui = application.get("wezterm-gui")

    if not wezterm then return end
    local allWindows = wezterm:allWindows()
    table.sort(allWindows, function(a, b) return a:id() < b:id() end)

    if weztermGui then
        local allWindowsGui = weztermGui:allWindows()
        table.sort(allWindowsGui, function(a, b) return a:id() < b:id() end)
        for _, w in ipairs(allWindowsGui) do table.insert(allWindows, w) end
    end

    if weztermGui then
        if not wezterm:isFrontmost() and not weztermGui:isFrontmost() then return end
    else
        if not wezterm:isFrontmost() then return end
    end

    local currentFrontmostId = window.frontmostWindow():id()
    for k, w in ipairs(allWindows) do
        if w:id() == currentFrontmostId then
            local nw = allWindows[k + 1]
            if nw then nw:focus() else allWindows[1]:focus() end
            return
        end
    end
end
)

hotkey.bind({ 'ctrl', 'cmd' }, 'down', function()
    local w = window.frontmostWindow()
    local appname = w:application():name()
    if appname ~= "WezTerm" and appname ~= "wezterm-gui" then return end
    local s = screen.mainScreen():fullFrame()
    w:setFrame(geometry.rect(s.x, (2 / 5) * s.h, s.w, (3 / 5) * s.h))
end
)
