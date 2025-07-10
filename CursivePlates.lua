CursivePlates = CreateFrame("Frame")
local dependencies = {
    Cursive = false,
    ShaguPlates = false,
}

function CursivePlates:GetEnvironment()
    return getfenv(0)
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
                print("libcursive is loaded in!")
            end
        end
    end
end)

function CursivePlates:CheckDependencies()
    if dependencies.Cursive and dependencies.ShaguPlates then
        print("All addon dependencies loaded!")
        return true
    else
        print("Missing addon dependencies:")
        if not dependencies.Cursive then
            print("- Cursive")
        end
        if not dependencies.ShaguPlates then
            print("- ShaguPlates")
        end
        return false
    end
end
