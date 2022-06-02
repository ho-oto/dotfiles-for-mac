local application = require "hs.application"
local window      = require "hs.window"
local hotkey      = require "hs.hotkey"

hotkey.bind({ 'ctrl', 'cmd' }, 'x', function()
    local wezterm = application.get("WezTerm")
    if not wezterm then -- launch WezTerm if not launched
        application.launchOrFocus("WezTerm")
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
