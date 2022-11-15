local _G, SUI, L = _G, SUI, SUI.L
local spartan = LibStub("AceAddon-3.0"):GetAddon("SpartanUI")
local L = LibStub("AceLocale-3.0"):GetLocale("SpartanUI_Animated", true)
local Smooth = LibStub("LibSmoothStatusBar-1.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local addon = spartan:NewModule("Animation")

local t_power = {}
local lUnitExists = UnitExists
local UnitPowerType = UnitPowerType
local powerTable = {}
for i = 0, 18 do
	powerTable[i] = {}
end
local s_table = {}
local s_table_party_target = {}

function addon:ResetSettings()
	SUI.DB.Animation = {
		enable = true,
		animationIntervalStop = 0.09,
		health = "interface\\addons\\SpartanUI_Animated\\Animations\\Health\\HealthBar",
		mana = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
		cast = "interface\\addons\\SpartanUI_Animated\\Animations\\Cast\\CastBar",
		focus = "interface\\addons\\SpartanUI_Animated\\Animations\\Energy\\EnergyBar",
		runicpower = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
		energy = "interface\\addons\\SpartanUI_Animated\\Animations\\Energy\\EnergyBar",
		rage = "interface\\addons\\SpartanUI_Animated\\Animations\\Rage\\RageBar",
		malestorm = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
		insanity = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
		astralpower = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
		fury = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
		pain = "interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar",
	}
end

function addon:OnInitialize()
	if not SUI.DB.Animation then
		addon:ResetSettings()
	end
	if not SUI.DB.Animation.fury then
		addon:ResetSettings()
	end --New 1.3.1
	local textures = {
		["interface\\addons\\SpartanUI_Animated\\Animations\\Health\\HealthBar"] = HEALTH,
		["interface\\addons\\SpartanUI_Animated\\Animations\\Cast\\CastBar"] = L["Bar/Casting"],
		["interface\\addons\\SpartanUI_Animated\\Animations\\Mana\\Manabar"] = MANA,
		["interface\\addons\\SpartanUI_Animated\\Animations\\Rage\\RageBar"] = RAGE,
		["interface\\addons\\SpartanUI_Animated\\Animations\\Energy\\EnergyBar"] = ENERGY,
		["interface\\addons\\SpartanUI_Animated\\Animations\\DeusEx\\DeusEx"] = L["Bar/DeusEx"],
	}
	addon:CreateMemFrame(textures)
	spartan.opt.args["ModSetting"].args["Animation"] =
		{ name = "Bar Animation", type = "group", order = 990, args = {} }
	spartan.opt.args["ModSetting"].args["Animation"].args = {
		enable = {
			name = L["Animation/Enabled"],
			type = "toggle",
			order = 1,
			width = "full",
			get = function(info)
				return SUI.DB.Animation.enable
			end,
			set = function(info, val)
				SUI.DB.Animation.enable = val
			end,
		},
		enableinfo = { name = L["Animation/ReloadRequired"], type = "description", order = 2 },
		health = {
			name = L["BarTexture/Health"],
			type = "select",
			order = 5,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.health
			end,
			set = function(info, val)
				SUI.DB.Animation.health = val
				addon:SetAnimationTexture(14, val)
			end,
		},
		cast = {
			name = L["BarTexture/Casting"],
			type = "select",
			order = 6,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.cast
			end,
			set = function(info, val)
				SUI.DB.Animation.cast = val
				addon:SetAnimationTexture(15, val)
			end,
		},
		mana = {
			name = L["BarTexture/Mana"],
			type = "select",
			order = 7,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.mana
			end,
			set = function(info, val)
				SUI.DB.Animation.mana = val
				addon:SetAnimationTexture(0, val)
			end,
		},
		rage = {
			name = L["BarTexture/Rage"],
			type = "select",
			order = 8,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.rage
			end,
			set = function(info, val)
				SUI.DB.Animation.rage = val
				addon:SetAnimationTexture(1, val)
			end,
		},
		energy = {
			name = L["BarTexture/Energy"],
			type = "select",
			order = 9,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.energy
			end,
			set = function(info, val)
				SUI.DB.Animation.energy = val
				addon:SetAnimationTexture(3, val)
			end,
		},
		focus = {
			name = L["BarTexture/Focus"],
			type = "select",
			order = 10,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.focus
			end,
			set = function(info, val)
				SUI.DB.Animation.focus = val
				addon:SetAnimationTexture(4, val)
			end,
		},
		runicpower = {
			name = L["BarTexture/RunicPower"],
			type = "select",
			order = 11,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.runicpower
			end,
			set = function(info, val)
				SUI.DB.Animation.runicpower = val
				addon:SetAnimationTexture(6, val)
				addon:SetAnimationTexture(5, val)
			end,
		},

		astralpower = {
			name = L["BarTexture/AstralPower"],
			type = "select",
			order = 12,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.astralpower
			end,
			set = function(info, val)
				SUI.DB.Animation.astralpower = val
				addon:SetAnimationTexture(8, val)
			end,
		},
		malestorm = {
			name = L["BarTexture/Maelstrom"],
			type = "select",
			order = 13,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.malestorm
			end,
			set = function(info, val)
				SUI.DB.Animation.malestorm = val
				addon:SetAnimationTexture(11, val)
			end,
		},
		insanity = {
			name = L["BarTexture/Insanity"],
			type = "select",
			order = 14,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.insanity
			end,
			set = function(info, val)
				SUI.DB.Animation.insanity = val
				addon:SetAnimationTexture(13, val)
			end,
		},
		fury = {
			name = L["BarTexture/Fury"],
			type = "select",
			order = 15,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.fury
			end,
			set = function(info, val)
				SUI.DB.Animation.fury = val
				addon:SetAnimationTexture(17, val)
			end,
		},
		pain = {
			name = L["BarTexture/Fury"],
			type = "select",
			order = 15,
			style = "dropdown",
			values = textures,
			get = function(info)
				return SUI.DB.Animation.pain
			end,
			set = function(info, val)
				SUI.DB.Animation.pain = val
				addon:SetAnimationTexture(18, val)
			end,
		},
		animationIntervalStop = {
			name = L["BarTexture/Speed"],
			type = "range",
			order = 22,
			width = "double",
			min = 1,
			max = 23,
			step = 1,
			get = function(info)
				return abs(1 / tonumber(SUI.DB.Animation.animationIntervalStop)) or abs(1 / 0.09)
			end,
			set = function(info, val)
				SUI.DB.Animation.animationIntervalStop = abs(1 / tonumber(val))
				addon.Ticker:Cancel()
				addon.Ticker =
					C_Timer.NewTicker(math.max(SUI.DB.Animation.animationIntervalStop, 0.01), addon.NewUpdater)
			end,
		},
		resetframes = {
			name = L["Bars/ResetSettings"],
			type = "execute",
			order = 23,
			desc = L["Bars/resetallDesc"],
			func = function()
				addon:ResetSettings()
			end,
		},
		reloadframes = {
			name = RELOADUI,
			type = "execute",
			order = 24,
			desc = L["Bars/reloadDesc"],
			func = function()
				ReloadUI()
			end,
		},
	}
end

function addon:OnEnable()
	local UF = SUI.UF
	f = CreateFrame("Frame", "Animation", WorldFrame)
	f:SetFrameStrata("BACKGROUND")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("GROUP_ROSTER_UPDATE")

	if SUI.DB.Animation.enable then
		UF.Unit.player.Castbar:SetStatusBarColor(1, 1, 1, 1)
		f:SetScript("OnEvent", function(this, event, ...)
			addon[event](addon, ...)
		end)
		addon.Ticker = C_Timer.NewTicker(math.max(SUI.DB.Animation.animationIntervalStop, 0.01), addon.NewUpdater)
		f:SetScript("OnShow", function()
			addon.Ticker:Cancel()
			addon.Ticker =
				C_Timer.NewTicker(math.max(SUI.DB.Animation.animationIntervalStop, 0.01), addon.NewUpdater)
		end)
		f:SetScript("OnHide", function()
			addon.Ticker:Cancel()
		end)
		local partyFrames = UF.Unit.party
		partyframes.RealUpdate = partyframes.UpdateAll
		partyframes.UpdateAll = addon.PartyInjection
	else
		addon:PLAYER_ENTERING_WORLD()
	end
end

function addon:PartyInjection(event)
	local partyframes = SUI.UF.party
	partyframes:RealUpdate(event)
	C_Timer.After(1, addon.Refresh)
end

function addon:PLAYER_ENTERING_WORLD()
	t_power[0] = SUI.DB.Animation.mana --"mana",
	t_power[1] = SUI.DB.Animation.rage --"rage",
	t_power[2] = SUI.DB.Animation.focus --"focus",
	t_power[3] = SUI.DB.Animation.energy --"energy",
	t_power[6] = SUI.DB.Animation.runicpower --"runic power"
	t_power[14] = SUI.DB.Animation.health -- health unsused
	t_power[15] = SUI.DB.Animation.cast --castbar unused
	t_power[8] = SUI.DB.Animation.astralpower
	t_power[11] = SUI.DB.Animation.malestorm
	t_power[13] = SUI.DB.Animation.insanity
	t_power[17] = SUI.DB.Animation.fury
	t_power[18] = SUI.DB.Animation.pain

	for powerType, texture in pairs(t_power) do
		addon:SetAnimationTexture(powerType, texture)
	end
	for i = 0, 18 do
		if not powerTable[i]["textured"] then
			addon:SetAnimationTexture(i, t_power[0])
		end
	end
	if SUI.DB.Animation.enable then
		addon:Refresh()
		for k, v in pairs(s_table) do
			Smooth:SmoothBar(v.Power)
			Smooth:SmoothBar(v.Health)
			if v.CastBar then
				Smooth:SmoothBar(v.CastBar)
			end
		end
	end
end

function addon:GROUP_ROSTER_UPDATE()
	C_Timer.After(1, addon.Refresh)
end

function addon:SetAnimationTexture(powerType, texture)
	powerTable[powerType]["textured"] = true
	for i = 1, 40 do
		powerTable[powerType][i] = texture .. tostring(i)
	end
end

function addon:CreateMemFrame(...)
	-- This frame and statusbar is only so that WoW will keep the textures in memory and not read them from disk.
	if not ... then
		return
	end
	local textures = {}
	for k, _ in pairs(...) do
		table.insert(textures, k)
	end
	local f = CreateFrame("Frame", "AnimationMemory", WorldFrame)
	f:SetFrameStrata("BACKGROUND")
	f:SetSize(128, 16)
	for k, v in pairs(textures) do
		for i = 1, 40 do
			local t = CreateFrame("StatusBar", nil, f)
			t:SetSize(150, 16)
			t:SetStatusBarTexture(v .. tostring(i))
			t:SetPoint("TOPLEFT", f, (k * 150) - 150, (i * 16) - 16)
			f[k .. i] = t
		end
	end
	f:SetPoint("BOTTOMLEFT", 0, 0)
	f:Hide()
end

function addon:Refresh()
	s_table = {
		["player"] = SUI.UF.Unit.player, --work around sins we can't have "player" appear twice in a table.
		["target"] = SUI.UF.Unit.target,
		["pet"] = SUI.UF.Unit.pet,
		["focus"] = SUI.UF.Unit.focus,
		["focustarget"] = SUI.UF.Unit.focustarget,
		["targettarget"] = SUI.UF.Unit.targettarget,
		["party1"] = SUI.UF.Unit.party.frames[1],
		["party2"] = SUI.UF.Unit.party.frames[2],
		["party3"] = SUI.UF.Unit.party.frames[3],
		["party4"] = SUI.UF.Unit.party.frames[4],
		["party5"] = SUI.UF.Unit.party.frames[5],
		["boss1"] = SUI.UF.Unit.boss.frames[1],
		["boss2"] = SUI.UF.Unit.boss.frames[2],
		["boss3"] = SUI.UF.Unit.boss.frames[3],
		["boss4"] = SUI.UF.Unit.boss.frames[4],
		["boss5"] = SUI.UF.Unit.boss.frames[5],
		["boss6"] = SUI.UF.Unit.boss.frames[6],
		["boss7"] = SUI.UF.Unit.boss.frames[7],
		["boss8"] = SUI.UF.Unit.boss.frames[8],
	}
	s_table_party_target = {
		["partytarget1"] = SUI.UF.Unit.partytarget.frames[1],
		["partypet1"] = SUI.UF.Unit.partypet.frames[1],
		["partytarget2"] = SUI.UF.Unit.partytarget.frames[2],
		["partypet2"] = SUI.UF.Unit.partypet.frames[2],
		["partytarget3"] = SUI.UF.Unit.partytarget.frames[3],
		["partypet3"] = SUI.UF.Unit.partypet.frames[3],
		["partytarget4"] = SUI.UF.Unit.partytarget.frames[4],
		["partypet4"] = SUI.UF.Unit.partypet.frames[4],
		["partytarget5"] = SUI.UF.Unit.partytarget[5],
		["partypet5"] = SUI.UF.Unit.partypet[5],
	}
	if InCombatLockdown() then --Possible fix for incombat partyframe creation.
		C_Timer.After(10, addon.Refresh)
	end
	return true
end

local AnimationUpdate = function(self, powerType)
	local frameCount = (self.frameCount or 0) % 40 + 1
	self.frameCount = frameCount
	self:SetStatusBarTexture(powerTable[powerType][frameCount])
	return
end

function addon:NewUpdater()
	for unit, frame in pairs(s_table) do
		if lUnitExists(unit) and frame:IsVisible() then
			local powerType = (UnitPowerType(unit) or 0)
			AnimationUpdate(frame.Health, 14)
			AnimationUpdate(frame.Power, powerType)
			if frame.Castbar and (frame.Castbar.casting or frame.Castbar.channeling) then
				AnimationUpdate(frame.Castbar, 15)
			end
		end
	end
	for unit, frame in pairs(s_table_party_target) do
		if lUnitExists(unit) and frame:IsVisible() then
			AnimationUpdate(frame.Health, 14)
		end
	end
end

function SUIA_Refresh()
	addon:Refresh()
end

function SUIA_Add(UnitID,frame)
	if not UnitID or not frame then
		print("missing UnitID or frame")
		return
	end
	if (frame.Castbar) then
		s_table[UnitID] = frame
	elseif (frame.Health) then
		s_table_party_target[UnitID] = frame
	end
end
