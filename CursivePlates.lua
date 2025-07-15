CursivePlates = CreateFrame("Frame")
local dependencies = {
    Cursive = false,
    ShaguPlates = false,
    pfUI = false,
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
    -- unregister the entering world effect to only do it on login
    CursivePlates:UnregisterEvent("PLAYER_ENTERING_WORLD")

    if event == "PLAYER_ENTERING_WORLD" then
        if IsAddOnLoaded("Cursive") then
            dependencies.Cursive = true
        end
        if IsAddOnLoaded("ShaguPlates") then
            dependencies.ShaguPlates = true
        end
        if IsAddOnLoaded("pfUI") then
            dependencies.pfUI = true
        end

        if CursivePlates:CheckDependencies() then
            if CursivePlates.libcursive then
                if ShaguPlates then
                    ShaguPlates.env.libdebuff:UnregisterAllEvents()
                    ShaguPlates.env.libdebuff = CursivePlates.libcursive
                elseif pfUI then
                    pfUI.env.libdebuff:UnregisterAllEvents()
                    pfUI.env.libdebuff = CursivePlates.libcursive
                end
                CursivePlates:Print("Replaced libdebuff with libcursive!")
            end
        end
    end
end)

function CursivePlates:CheckDependencies()
    if dependencies.Cursive and (dependencies.ShaguPlates or dependencies.pfUI) then
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
        if not dependencies.pfUI then
            CursivePlates:Print("- pfUI")
        end
        return false
    end
end
