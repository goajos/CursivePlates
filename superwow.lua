setfenv(1, ShaguPlates:GetEnvironment())

-- add support for superwow channel castevents
local superdebuff = CreateFrame("Frame")
superdebuff:RegisterEvent("UNIT_CASTEVENT")
superdebuff:SetScript("OnEvent", function()
-- variable assignments
local caster, target, event, spell, duration = arg1, arg2, arg3, arg4

-- skip other caster and empty target events
local _, guid = UnitExists("player")
if caster ~= guid then return end
if event ~= "CHANNEL" then return end
if not target or target == "" then return end

-- assign all required data
local unit = UnitName(target)
local unitlevel = UnitLevel(target)
local effect, rank = SpellInfo(spell)
local duration = libdebuff:GetDuration(effect, rank)
local caster = "player"

-- add effect to current debuff data
libdebuff:AddEffect(unit, unitlevel, effect, duration, caster)
end)