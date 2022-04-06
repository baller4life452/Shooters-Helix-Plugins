PLUGIN.name = "RPG Balance"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Have you ever wanted to give your players and RPG, but they keep using them irresponsible, unfair and/or overpowered skills? Well, this plugin will help you to balance your RPG."

ix.config.Add("Activation Time", 2, "Amount of time needed after a rocket is fired for it to become armed and ready to explode.", nil, {
	data = { min = 0.1, max = 10 },
	category = PLUGIN.name
})

PLUGIN.RPGweapons = {
	['weapon_rpg'] = true,
}


if !(SERVER) then return end
local function RPGFired(ply, weap)
	timer.Simple(FrameTime(), function()
		if !(IsValid(ply)) then return end
		if !(IsValid(ply:GetNWEntity("Missile"))) then return end
		local Distance = -80
		if !(ply:IsWepRaised()) then return end
		if (ply:Crouching()) then Distance = -50 end

		local tr = util.TraceLine( {
			start = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ( ply:GetAimVector() * Distance),
			filter = ply,
		} )
		local Explosion = ents.Create( "env_explosion" )
		Explosion:SetPos(tr.HitPos)
		Explosion:SetAngles(Angle(90,0,0))
		Explosion:SetKeyValue( "iMagnitude", "400" )
		Explosion:SetKeyValue( "iRadiusOverride", tostring(math.abs(Distance)-20) )
		Explosion:SetKeyValue( "DamageForce", "100.0" )
		Explosion:Spawn()
		Explosion:Activate()
		Explosion:Fire("Explode")
	end)
end

-- handles when a player fires an RPG
local RunOnce = true

function PLUGIN:OnEntityCreated(ent)
	timer.Simple(FrameTime(), function()
		if IsValid(ent) then
			if ent:GetClass() == "rpg_missile" and ent:GetOwner() then
				ent:GetOwner():SetNWEntity("Missile", ent)
				ent:GetOwner():SetNWFloat("ArmingTime", CurTime()+ix.config.Get("Activation Time", 2))
				local Trace = util.TraceLine( {
					start = ent:GetPos(),
					endpos = ent:GetPos() + ( ent:GetForward() * 100 ),
					filter = {ent:GetOwner(), ent},
				} )
				if Trace.Hit then ent:Remove() end
			end
			if ent:GetClass() == "env_rockettrail" and ent:GetParent() then
				ent:GetParent():SetNWEntity("RocketTrail", ent)
			end
		end
	end)
end

function PLUGIN:PlayerSwitchWeapon( player, oldWeapon, newWeapon )
	if self.RPGweapons[newWeapon:GetClass()] then
		newWeapon:SetNextPrimaryFire(1)
	end
end

function PLUGIN:Think()
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and IsValid(v:GetActiveWeapon()) then
			if (self.RPGweapons[v:GetActiveWeapon():GetClass()]) then 
				if CurTime()-v:GetActiveWeapon():GetNextPrimaryFire() < 0 then
					if RunOnce then
						RPGFired(v, v:GetActiveWeapon())
						RunOnce = false
					end
				else
					RunOnce = true
				end
			end
			if v:GetNWEntity("Missile") and IsValid(v:GetNWEntity("Missile")) then
				if v:GetNWFloat("ArmingTime") > CurTime() then
					local missle = v:GetNWEntity("Missile")
					local trail = missle:GetNWEntity("RocketTrail")
					local tr = util.TraceHull( {
						start = missle:GetPos() + ( missle:GetForward() * -4 ),
						endpos = missle:GetPos() + ( missle:GetForward() * 10 ),
						filter = {v, missle},
						mins = Vector( -10, -10, -10 ),
						maxs = Vector( 10, 10, 10 ),
					} )
					if tr.Hit then
						missle:StopSound( "Missile.Ignite" )
						if IsValid(trail) then trail:Remove() end
						if IsValid(missle) then missle:Remove() end
						v:GetActiveWeapon():SetNextPrimaryFire(CurTime()+2)
					end
				end
			end
		end
	end
end