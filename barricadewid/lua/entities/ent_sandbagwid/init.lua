AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("globalwarfare3/gamemode/vgui/cl_logipanel.lua")
include("globalwarfare3/gamemode/logihandler/sv_logihandler.lua")
include("shared.lua")

local sandbagBreak = {
	"ambient/materials/rock1.wav",
	"ambient/materials/rock2.wav",
	"ambient/materials/rock3.wav",
	"ambient/materials/rock4.wav",
	"ambient/materials/rock5.wav"
}

local sandbagFly = {
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
	self.firstDeath = true
	self:SetMaxHealth(150)
    self:SetHealth(150)
	math.randomseed(os.time())
    self:SetModel("models/sandbags_line2.mdl")
    self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    
    local phys = self:GetPhysicsObject() 
    if phys:IsValid() then
    	-- setting the mass, more than 200 is sketchy because player cant pick
        phys:SetMass(1000)
        phys:Wake()
        phys:EnableGravity(true)
    end
end

function ENT:Use(activator, caller) 
end

function ENT:PropCikar(setPosX, setPosY, setPosZ, totalDestroy)
	local sandbagModel = "models/sandbag.mdl"
	local prop = ents.Create("prop_physics")
	local propPos = prop:GetPos()
	local alpha = 255
	local timerID1 = "FadeProp1_" .. prop:EntIndex()
	local timerID2 = "FadeProp2_" .. prop:EntIndex()
	local amiPatladi = totalDestroy

	if not IsValid(prop) then return end -- block possible errors
	
	prop:SetModel(sandbagModel)
	
	prop:SetPos(self:GetPos() + Vector(setPosX, setPosY, setPosZ))
	prop:SetAngles(AngleRand())
	prop:SetRenderMode(1)	   

	local randomSound = table.Random(sandbagFly)
	self:EmitSound(randomSound)

	if amiPatladi then
		print("if amiPatladi then")
		local propPos = prop:GetPos()
		local ffrrggh = EffectData()
		local Up = Vector(0, 0, 1)
		local EffectType = 1
		ffrrggh:SetNormal(Up)
		ffrrggh:SetRadius(EffectType)
		ffrrggh:SetOrigin(propPos)
		ffrrggh:SetColor(0,0,0)
		ffrrggh:SetScale(1.1)
		util.Effect("eff_jack_gmod_smalldustshock", ffrrggh, true, true)
		local randomSesler = table.Random(sandbagBreak)
		self:EmitSound(randomSesler, 90, 100)
		ffrrggh:SetScale(0.33)
		util.Effect("eff_jack_gmod_ezbuildsmoke", ffrrggh, true, true)
		util.ScreenShake(propPos, 10, 10, 1.5, 100)
	elseif not amiPatladi then
		print("elseif not amiPatladi then")
		local propPos = prop:GetPos()
		local naganigi = EffectData()
		local Up = Vector(0, 0, 1)
		local EffectType = 1
		naganigi:SetNormal(Up)
		naganigi:SetRadius(EffectType)
		naganigi:SetOrigin(propPos)
		naganigi:SetColor(0,0,0)
		naganigi:SetScale(0.3)
		util.Effect("eff_jack_gmod_ezbuildsmoke", naganigi, true, true)
		util.ScreenShake(propPos, 5, 5, 1.5, 120)
	else
		print("amiPatladi hatası")
	end

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

function ENT:SekonderDeathSonrasiCikanlar()
	for seks=1,15 do
		self:PropCikar(0, 0, 30, true)
	end
	self:Remove()
end

function ENT:DeathSonrasiCikanlar()
	for seks=1,10 do
		self:PropCikar(0, 0, 30, true)
	end
end

function ENT:DeathselDonusum()
	self:SetModel("models/anzio_sandbags_destroyed.mdl")
	self:SetHealth(150)
 
	local entOLDpos = self:GetLocalPos()
	local entNEWpos = entOLDpos + Vector(0,0,21)
	self:SetPos(entNEWpos)

	self:PhysicsInit(SOLID_VPHYSICS) 
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

	self:DeathSonrasiCikanlar()
end

function ENT:OnTakeDamage( dmginfo )
    local damage = dmginfo:GetDamage()
    self:SetHealth(self:Health() - damage)
    local randomSayi = math.random(1, 5)
    if randomSayi == 1 and self.firstDeath then
		self:PropCikar(0, 0, 30, false)
	elseif randomSayi == 1 and not self.firstDeath then
		self:PropCikar(0, 0, 30, false)
	end

	if self:Health() <= 0 and self.firstDeath then
		self:DeathselDonusum()
		self.firstDeath = false
	elseif self:Health() <= 0 and not self.firstDeath then
		self:SekonderDeathSonrasiCikanlar()
	end
end