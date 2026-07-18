AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("globalwarfare3/gamemode/vgui/cl_logipanel.lua")
include("globalwarfare3/gamemode/logihandler/sv_logihandler.lua")
include("shared.lua")

util.AddNetworkString("callClient")
util.AddNetworkString("crateVector")

local firstDeath = true

local randomSoundsBreak = {
	"ambient/materials/rock1.wav",
	"ambient/materials/rock2.wav",
	"ambient/materials/rock3.wav",
	"ambient/materials/rock4.wav",
	"ambient/materials/rock5.wav"
}

local randomSounds = {
	"physics/cardboard/cardboard_box_break1.wav",
	"physics/cardboard/cardboard_box_break2.wav",
	"physics/cardboard/cardboard_box_break3.wav",
	"physics/cardboard/cardboard_box_impact_bullet1.wav",
	"physics/cardboard/cardboard_box_impact_bullet2.wav",
	"physics/cardboard/cardboard_box_impact_bullet3.wav",
	"physics/cardboard/cardboard_box_impact_bullet4.wav",
	"physics/cardboard/cardboard_box_impact_bullet5.wav"
}

function ENT:Initialize()
	firstDeath = true
	self:SetMaxHealth(50)
    self:SetHealth(150)

    self:SetModel("models/sandbags_line2.mdl")
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    local phys = self:GetPhysicsObject() 
    if phys:IsValid() then
    	-- setting the mass, more than 200 is sketchy because player cant pick
        phys:SetMass(700)
        phys:Wake()
        phys:EnableGravity(true)
    end
end

function ENT:Use(activator, caller) 
end

function ENT:SekonderDeathselDonusum()
	self:SekonderDeathSonrasiCikanlar()
end

function ENT:SekonderDeathSonrasiCikanlar()
	for seks=1,15 do
		local prop = ents.Create("prop_physics")
		if not IsValid(prop) then return end
		local sandbagModel = "models/sandbag.mdl"

		prop:SetModel(sandbagModel)
		math.randomseed(CurTime()^seks)

		prop:SetPos(self:GetPos() + Vector(math.random(-100, 100),math.random(-15, 15), math.random(0, 25)))
		prop:SetAngles(AngleRand())
		prop:SetRenderMode(1)	   

		local alpha = 255
		local timerID1 = "FadeProp1_" .. prop:EntIndex()
		local timerID2 = "FadeProp2_" .. prop:EntIndex()

		local randomSound = table.Random(randomSounds)
		self:EmitSound(randomSound)	

		prop:Spawn()
		timer.Create(timerID2, 2, 1, function() 
			timer.Create(timerID1, 0.05, 51, function() 
				if IsValid(prop) then
				    alpha = alpha - 5

				    if alpha < 0 then alpha = 0 end
				        
				    prop:SetColor(Color(255, 255, 255, alpha))
				        
				    if alpha <= 0 then
				        prop:Remove()
				    end
				else
				    timer.Remove(timerID1)
				end
			end)
		end)
		local SelfPos = self:GetPos()
		local toz = EffectData()
		local Up = Vector(0, 0, 1)
		local EffectType = 1
		toz:SetNormal(Up)
		toz:SetRadius(EffectType)
		toz:SetOrigin(SelfPos)
		toz:SetColor(213,200,30)
		toz:SetScale(0.7)
		util.Effect("eff_jack_gmod_smalldustshock", toz, true, true)
		local randomSesler = table.Random(randomSoundsBreak)
		self:EmitSound(randomSesler, 90, 100)
		toz:SetScale(0.4)
		util.Effect("eff_jack_gmod_ezbuildsmoke", toz, true, true)
		util.ScreenShake(SelfPos, 10, 10, 1.5, 300)
	end
	self:Remove()
end

function ENT:DeathSonrasiCikanlar()
	for seks=1,10 do
		local prop = ents.Create("prop_physics")
		if not IsValid(prop) then return end
		local sandbagModel = "models/sandbag.mdl"

		prop:SetModel(sandbagModel)
		math.randomseed(CurTime()^seks)
		prop:SetPos(self:GetPos() + Vector(0 + math.random(-8, 8), 0 + math.random(-23, 23), 10))
		prop:SetAngles(AngleRand())
		prop:SetRenderMode(1)	   

		local alpha = 255
		local timerID1 = "FadeProp1_" .. prop:EntIndex()
		local timerID2 = "FadeProp2_" .. prop:EntIndex()

		local randomSound = table.Random(randomSounds)
		self:EmitSound(randomSound)

		prop:Spawn()
		timer.Create(timerID2, 2, 1, function() 
			timer.Create(timerID1, 0.05, 51, function() 
				if IsValid(prop) then
				    alpha = alpha - 5

				    if alpha < 0 then alpha = 0 end
				        
				    prop:SetColor(Color(255, 255, 255, alpha))
				        
				    if alpha <= 0 then
				        prop:Remove()
				    end
				else
				    timer.Remove(timerID1)
				end
			end)
		end)
		local SelfPos = self:GetPos()
		local toz = EffectData()
		local Up = Vector(0, 0, 1)
		local EffectType = 1
		toz:SetNormal(Up)
		toz:SetRadius(EffectType)
		toz:SetOrigin(SelfPos)
		toz:SetColor(213,200,30)
		toz:SetScale(1)
		util.Effect("eff_jack_gmod_smalldustshock", toz, true, true)
		toz:SetScale(0.4)
		util.Effect("eff_jack_gmod_ezbuildsmoke", toz, true, true)
		util.ScreenShake(SelfPos, 10, 10, 1.5, 300)
		local randomSesler = table.Random(randomSoundsBreak)
		self:EmitSound(randomSesler, 90, 100)
	end
end

function ENT:DeathselDonusum()
	print("my health is" ..self:Health())
	self:SetModel("models/anzio_sandbags_destroyed.mdl")
	self:SetHealth(150)
	print("my NEW health is" ..self:Health())
	self:PhysicsInit(SOLID_VPHYSICS) 
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
		   
	local entOLDpos = self:GetLocalPos()
	print("my OLD pos" .. tostring(entOLDpos))
	local entNEWpos = entOLDpos + Vector(0,0,21)
	self:SetPos(entNEWpos)

	local phys = self:GetPhysicsObject() 
	if phys:IsValid() then
		phys:SetMass(700)
		phys:Wake()
		phys:EnableGravity(true)
	end
	self:DeathSonrasiCikanlar()
end

function ENT:firstDeathTakeDamage()
	local prop = ents.Create("prop_physics")
	if not IsValid(prop) then return end
	local sandbagModel = "models/sandbag.mdl"
	prop:SetModel(sandbagModel)
	math.randomseed(CurTime())
	prop:SetPos(self:GetPos() + Vector(0 + math.random(-5, 5), 0 + math.random(-60, 60), 50))
	prop:SetAngles(AngleRand())
	prop:SetRenderMode(1)	   
	local propPos = prop:GetPos()

	local alpha = 255
	local timerID1 = "FadeProp1_" .. prop:EntIndex()
	local timerID2 = "FadeProp2_" .. prop:EntIndex()

	local randomSound = table.Random(randomSounds)
	self:EmitSound(randomSound)

	local naganigi = EffectData()
	naganigi:SetOrigin(propPos)
	naganigi:SetColor(213,200,30)
	naganigi:SetScale(0.2)
	util.Effect("eff_jack_gmod_ezbuildsmoke", naganigi, true, true)
	util.ScreenShake(propPos, 3, 3, 0.4, 100)

	prop:Spawn()
	timer.Create(timerID2, 2, 1, function() 
		timer.Create(timerID1, 0.05, 51, function() 
			if IsValid(prop) then
			    alpha = alpha - 5
			    if alpha < 0 then alpha = 0 end
			        
			    prop:SetColor(Color(255, 255, 255, alpha))
			        
			    if alpha <= 0 then
			        prop:Remove()
			    end
			else
			    timer.Remove(timerID1)
			end
		end)
	end)
end

function ENT:sekonderDeathTakeDamage()
	--prop:SetPos(self:GetPos() + Vector(0 + math.random(-5, 5), 0 + math.random(-60, 60), 50))
	print("not firstDeath")
	local prop = ents.Create("prop_physics")
	if not IsValid(prop) then return end

	local sandbagModel = "models/sandbag.mdl"
	prop:SetModel(sandbagModel)
	math.randomseed(CurTime())
	local tarafBelirleRandom = math.random(1, 2)

	if tarafBelirleRandom == 1 then
		print("taraf belirle random 1")
		math.randomseed(CurTime())
		prop:SetPos(self:GetPos() + Vector(0,math.random(-55, -35),math.random(20, 35)))
		prop:SetAngles(AngleRand())
		prop:SetRenderMode(1)	   
		local propPos = prop:GetPos()

		local alpha = 255
		local timerID1 = "FadeProp1_" .. prop:EntIndex()
		local timerID2 = "FadeProp2_" .. prop:EntIndex()

		local randomSound = table.Random(randomSounds)
		self:EmitSound(randomSound)

		local dakalak = EffectData()
		dakalak:SetOrigin(propPos)
		dakalak:SetColor(213,200,30)
		dakalak:SetScale(0.2)
		util.Effect("eff_jack_gmod_ezbuildsmoke", dakalak, true, true)
		util.ScreenShake(propPos, 3, 3, 0.4, 100)

		prop:Spawn()
		timer.Create(timerID2, 2, 1, function() 
			timer.Create(timerID1, 0.05, 51, function() 
				if IsValid(prop) then
				    alpha = alpha - 5
				    if alpha < 0 then alpha = 0 end
				        
				    prop:SetColor(Color(255, 255, 255, alpha))
				        
				    if alpha <= 0 then
				        prop:Remove()
				    end
				else
				    timer.Remove(timerID1)
				end
			end)
		end)
	elseif tarafBelirleRandom == 2 then
		print("taraf belirle random 2")
		math.randomseed(CurTime())
		prop:SetPos(self:GetPos() + Vector(0,math.random(55, 35),math.random(20, 35)))
		prop:SetAngles(AngleRand())
		prop:SetRenderMode(1)	   
		local propPos = prop:GetPos()

		local alpha = 255
		local timerID1 = "FadeProp1_" .. prop:EntIndex()
		local timerID2 = "FadeProp2_" .. prop:EntIndex()

		local randomSound = table.Random(randomSounds)
		self:EmitSound(randomSound)

		local budalak = EffectData()
		budalak:SetOrigin(propPos)
		budalak:SetColor(213,200,30)
		budalak:SetScale(0.2)
		util.Effect("eff_jack_gmod_ezbuildsmoke", budalak, true, true)
		util.ScreenShake(propPos, 3, 3, 0.4, 100)

		prop:Spawn()
		timer.Create(timerID2, 2, 1, function() 
			timer.Create(timerID1, 0.05, 51, function() 
				if IsValid(prop) then
				    alpha = alpha - 5
				    if alpha < 0 then alpha = 0 end
				        
				    prop:SetColor(Color(255, 255, 255, alpha))
				        
				    if alpha <= 0 then
				        prop:Remove()
				    end
				else
				    timer.Remove(timerID1)
				end
			end)
		end)
	end
end

function ENT:OnTakeDamage( dmginfo )
    local damage = dmginfo:GetDamage()
    self:SetHealth(self:Health() - damage)
    local randomSayi = math.random(1, 5)
    if randomSayi == 1 and firstDeath then
		self:firstDeathTakeDamage()
	elseif randomSayi == 1 and not firstDeath then
		self:sekonderDeathTakeDamage()
	end

	if self:Health() <= 0 and firstDeath then
		self:DeathselDonusum()
		firstDeath = false
	elseif self:Health() <= 0 and not firstDeath then
		self:SekonderDeathselDonusum()
	end
end