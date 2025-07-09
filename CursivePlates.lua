local L = AceLibrary("AceLocale-2.2"):new("CursivePlates")
CursivePlates = AceLibrary("AceAddon-2.0"):new(
    "AceEvent-2.0",
    "AceConsole-2.0"
)

local dependencies = {
    Cursive = false,
    ShaguPlates = false,
}

function CursivePlates:OnInitialize()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function CursivePlates:PLAYER_ENTERING_WORLD()
    if IsAddOnLoaded("Cursive") then
        dependencies.Cursive = true
    end
    if IsAddOnLoaded("ShaguPlates") then
        dependencies.ShaguPlates = true
    end

    self:CheckDependencies()

    if self.libcursive then
        if ShaguPlates.env.libdebuff then
            ShaguPlates.env.libdebuff:UnregisterAllEvents()
            ShaguPlates.env.libdebuff = self.libcursive
            self:Print("Libcursive loaded!")
        end
    end
end

function CursivePlates:CheckDependencies()
    if dependencies.Cursive and dependencies.ShaguPlates then
        self:Print("All dependencies loaded!")
    else
        self:Print("Missing dependencies:")
        if not dependencies.Cursive then
            self:Print("- Cursive")
            return
        end
        if not dependencies.ShaguPlates then
            self:Print("- ShaguPlates")
            return
        end
    end
end
