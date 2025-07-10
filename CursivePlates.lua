CursivePlates = CreateFrame("Frame")
local dependencies = {
    Cursive = false,
    ShaguPlates = false,
}

function CursivePlates:GetEnvironment()
    return getfenv(0)
end

local ADDON_NAME = "CursivePlates"
function CursivePlates:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff00[" .. ADDON_NAME .. "]|r " .. ( msg or "nil" ))
end

CursivePlates:RegisterEvent("PLAYER_ENTERING_WORLD")

CursivePlates:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        if IsAddOnLoaded("Cursive") then
            dependencies.Cursive = true
        end
        if IsAddOnLoaded("ShaguPlates") then
            dependencies.ShaguPlates = true
        end

        if CursivePlates:CheckDependencies() then
            if CursivePlates.libcursive then
                ShaguPlates.env.libdebuff:UnregisterAllEvents()
                ShaguPlates.env.libdebuff = CursivePlates.libcursive
                CursivePlates:Print("replaced libdebuff with libcursive!")
            end
        end
    end
end)

function CursivePlates:CheckDependencies()
    if dependencies.Cursive and dependencies.ShaguPlates then
        CursivePlates:Print("All addon dependencies loaded!")
        return true
    else
        CursivePlates:Print("Missing addon dependencies:")
        if not dependencies.Cursive then
            CursivePlates:Print("- Cursive")
        end
        if not dependencies.ShaguPlates then
            CursivePlates:Print("- ShaguPlates")
        end
        return false
    end
end
