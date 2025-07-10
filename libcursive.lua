local env1
if ShaguPlates then
  env1 = ShaguPlates:GetEnvironment()
elseif pfUI then
  env1 = pfUI:GetEnvironment()
end
local env2 = CursivePlates:GetEnvironment()
setfenv(1, setmetatable({}, {
  __index = function(t, k)
    return env1[k] or env2[k]
  end}))

local libcursive = CreateFrame("Frame", "libcursive", UIParent)
local scanner = libtipscan:GetScanner("libcursive")

libcursive.objects = {}

function libcursive:GetDuration(effect, _rank)
  curseData = Cursive.curses:GetCurseData(effect)
  if curseData then
    duration = curseData.duration
    return duration
  end
end

function libcursive:UpdateDuration(unit, unitlevel, effect, duration)
  if not unit or not effect or not duration then return end
  unitlevel = unitlevel or 0

  if libcursive.objects[unit] and libcursive.objects[unit][unitlevel] and libcursive.objects[unit][unitlevel][effect] then
    libcursive.objects[unit][unitlevel][effect].duration = duration
  end
end

function libcursive:UpdateUnits()
  if ShaguPlates then
    if not ShaguPlates.uf or not ShaguPlates.uf.target then return end
    ShaguPlates.uf:RefreshUnit(ShaguPlates.uf.target, "aura")
  elseif pfUI then
    if not pfUI.uf or not pfUI.uf.target then return end
    pfUI.uf:RefreshUnit(pfUI.uf.target, "aura")
  end
end

function libcursive:AddEffect(unit, unitlevel, effect, duration, caster)
  if not unit or not effect then return end
  unitlevel = unitlevel or 0
  if not libcursive.objects[unit] then libcursive.objects[unit] = {} end
  if not libcursive.objects[unit][unitlevel] then libcursive.objects[unit][unitlevel] = {} end
  if not libcursive.objects[unit][unitlevel][effect] then libcursive.objects[unit][unitlevel][effect] = {} end

  libcursive.objects[unit][unitlevel][effect].effect = effect
  libcursive.objects[unit][unitlevel][effect].start_old = libcursive.objects[unit][unitlevel][effect].start
  libcursive.objects[unit][unitlevel][effect].start = GetTime()
  libcursive.objects[unit][unitlevel][effect].duration = duration
  libcursive.objects[unit][unitlevel][effect].caster = caster

  libcursive:UpdateUnits()
end

function libcursive:UnitDebuff(unit, id)
  local unitname = UnitName(unit)
  local unitlevel = UnitLevel(unit)
  local texture, stacks, dtype = UnitDebuff(unit, id)
  local duration, timeleft = nil, -1
  local rank = nil -- no backport
  local caster = nil -- experimental
  local effect

  if texture then
    scanner:SetUnitDebuff(unit, id)
    effect = scanner:Line(1) or ""
  end

  if libcursive.objects[unitname] and libcursive.objects[unitname][unitlevel] and libcursive.objects[unitname][unitlevel][effect] then
    -- clean up cache
    if libcursive.objects[unitname][unitlevel][effect].duration and libcursive.objects[unitname][unitlevel][effect].duration + libcursive.objects[unitname][unitlevel][effect].start < GetTime() then
      libcursive.objects[unitname][unitlevel][effect] = nil
    else
      local _, guid = UnitExists(unit)
      curseData = Cursive.curses:GetCurseData(effect, guid)
      if curseData then
        duration = curseData.duration
        timeleft = Cursive.curses:TimeRemaining(curseData)
      else
        return
      end
      caster = libcursive.objects[unitname][unitlevel][effect].caster
    end

  -- no level data
  elseif libcursive.objects[unitname] and libcursive.objects[unitname][0] and libcursive.objects[unitname][0][effect] then
    -- clean up cache
    if libcursive.objects[unitname][0][effect].duration and libcursive.objects[unitname][0][effect].duration + libcursive.objects[unitname][0][effect].start < GetTime() then
      libcursive.objects[unitname][0][effect] = nil
    else
      local _, guid = UnitExists(unit)
      curseData = Cursive.curses:GetCurseData(effect, guid)
      if curseData then
        duration = curseData.duration
        timeleft = Cursive.curses:TimeRemaining(curseData)
      else
        return
      end
      caster = libcursive.objects[unitname][0][effect].caster
    end
  end

  return effect, rank, texture, stacks, dtype, duration, timeleft, caster
end

local cache = {}
function libcursive:UnitOwnDebuff(unit, id)
  -- clean cache
  for k, v in pairs(cache) do cache[k] = nil end

  -- detect own debuffs
  local count = 1
  for i=1,16 do
    local effect, rank, texture, stacks, dtype, duration, timeleft, caster = libcursive:UnitDebuff(unit, i)
    if effect then
      if not cache[effect] and caster and caster == "player" then
        cache[effect] = true
        if count == id then
          return effect, rank, texture, stacks, dtype, duration, timeleft, caster
        else
          count = count + 1
        end
      end
    end
  end
end

CursivePlates.libcursive = libcursive