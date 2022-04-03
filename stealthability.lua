PLUGIN.name = "Stealth Ability"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Implements the ability to stealthaly open door and move with silence."

ix.config.Add("StealthySpeed", 10, "How fast the door opens when a player attempts to stealthy open it.", nil, {
	data = { min = 1, max = 100 },
	category = PLUGIN.name
})

PLUGIN.doors = {
	["func_door_rotating"] = true,
	["prop_door_rotating"] = true,
}

if !(SERVER) then return end
function PLUGIN:PlayerUse( ply, ent )
	-- if the player is holding alt and is trying to use a door
	if !(ply) then return end
	if !(ent) then return end
	if !(self.doors[ent:GetClass()]) then return end
	if !(!ent:IsLocked()) then return end
	for k, v in pairs(ents.FindInSphere(ent:GetPos(), 200)) do
		if !(self.doors[v:GetClass()]) then continue end
		if (v:GetPos():Distance(ent:GetPos()) < 100) then 
			if v:GetNWBool("RunOnce") then 
				if v:GetName() == ent:GetName() then 
					v:SetNWEntity("ControlingPlayer", ply)
					if (ply:KeyDown(IN_WALK)) then
						if (v:GetKeyValues()["speed"] == v:GetNWInt("DefaultSpeed", 100)) then 
							v:Fire("setspeed", ix.config.Get("StealthySpeed"))
							v:Fire("openawayfrom", ply:UniqueID()..CurTime())
						end
					else
						if v:GetKeyValues()["speed"] == ix.config.Get("StealthySpeed") then
							v:Fire("setspeed", ent:GetNWInt("DefaultSpeed"))
							v:Fire("openawayfrom", ply:UniqueID()..CurTime())
						end
					end
					v:SetNWBool("RunOnce", false)
				end
			else
				v:SetNWBool("RunOnce", true)
			end
		end
	end
end

function PLUGIN:EntityKeyValue( ent, key, value )
	if (self.doors[ent:GetClass()]) then
		if (key == "speed") then
			ent:SetNWInt("DefaultSpeed", tonumber(value))
		end
	end 
end

function PLUGIN:EntityEmitSound( data )
	if (self.doors[data.Entity:GetClass()]) then
		if IsValid(data.Entity:GetNWEntity("ControlingPlayer")) then
			if (data.Entity:GetKeyValues()["speed"] == ix.config.Get("StealthySpeed") or (data.Entity:GetNWEntity("ControlingPlayer"):KeyDown(IN_WALK) or false)) then 
				return false
			elseif (data.Entity:GetKeyValues()["speed"] == data.Entity:GetNWInt("DefaultSpeed", tonumber(value)) or !(data.Entity:GetNWEntity("ControlingPlayer"):KeyDown(IN_WALK) or false)) then
				return true 
			end
		end
	end
end


	--[[
	function PLUGIN:EntityTakeDamage(target, dmginfo) 
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetInflictor():IsPlayer() then
			if self.ignoredamage[dmginfo:GetAttacker():GetActiveWeapon()] == nil then
				if target:GetClass() == "prop_door_rotating" and (target.canbeshot == nil or target.canbeshot == true) and IsValid(dmginfo:GetInflictor()) and dmginfo:IsBulletDamage() then
					if dmginfo:GetInflictor():GetPos():Distance( target:GetPos() ) <= ix.config.Get("Range", 150) then
						
						local matrix = target:GetBoneMatrix(0)
						local originpos = matrix:GetTranslation()
						local hindge1 = originpos + (target:GetUp() * 34)
						local hindge2 = originpos - (target:GetUp() * 34)
						local dampos = dmginfo:GetDamagePosition()
						local handle = target:LookupBone("handle")
						local matrix = target:GetBoneMatrix(handle)
						local handlepos = matrix:GetTranslation()
						local distance = dampos:Distance(handlepos)
						dmginfo:GetInflictor():SetName(dmginfo:GetInflictor():UniqueID()..CurTime())
						
						-- door blaster
						
						if self.blastableweapons[dmginfo:GetAttacker():GetActiveWeapon():GetClass()] then
							local effect = EffectData()
								effect:SetStart(dampos)
								effect:SetOrigin(dampos)
								effect:SetScale(2)
							util.Effect("GlassImpact", effect, true, true)
							local Door = ents.Create("prop_physics")
							local TargetDoorsPos = target:GetPos()
							Door:SetAngles(target:GetAngles())
							Door:SetPos(target:GetPos() + target:GetUp())
							Door:SetModel(target:GetModel())
							Door:SetSkin(target:GetSkin())
							Door:SetCollisionGroup(0)
							Door:SetRenderMode(RENDERMODE_TRANSALPHA)
							target:Fire("unlock")
							target:Fire("openawayfrom", dmginfo:GetInflictor():UniqueID()..CurTime())
							target:SetCollisionGroup( 20 )
							target:SetRenderMode( 10 )
							Door:Spawn()
							Door:EmitSound( "/physics/wood/wood_crate_break"..math.random(1, 4)..".wav" , 150, 50, 1)
							Door:GetPhysicsObject():ApplyForceCenter( Door:GetForward() * 1000 )
							target.canbeshot = false
							target:SetPos(target:GetPos() + Vector(0,0,-1000))
							timer.Simple(ix.config.Get("Respawn Timer", 60), function()
								target:SetCollisionGroup( 0 )
								target:SetRenderMode( 0 )
								target.bHindge2 = false
								target.bHindge1 = false
								target:SetPos(target:GetPos() - Vector(0,0,-1000))
								if (Door) then
									Door:Remove()
									target.canbeshot = true
								end
							end)
						
						
						-- shooting lock
						elseif distance <= ix.config.Get("Shot Distance", 3) then
							target:Fire("setspeed", 350)
							target:Fire("unlock")
							target:Fire("openawayfrom", dmginfo:GetInflictor():UniqueID()..CurTime())
							target:EmitSound( "/physics/wood/wood_crate_break"..math.random(1, 4)..".wav" , 150, 50, 1)
							local effect = EffectData()
								effect:SetStart(handlepos)
								effect:SetOrigin(handlepos)
								effect:SetScale(2)
							util.Effect("GlassImpact", effect, true, true)
							target.canbeshot = false
							timer.Simple(0.5, function()
								if (IsValid(target)) then
									target:Fire("setspeed", 100)
								end
							end)
							timer.Simple(2, function()
								target.canbeshot = true
							end)
						

						-- shooting hindges
						elseif (dampos:Distance(hindge1) <= ix.config.Get("Shot Distance", 3)*1.5) then
							target.bHindge1 = true
							local effect = EffectData()
								effect:SetStart(hindge1)
								effect:SetOrigin(hindge1)
								effect:SetScale(2)
							util.Effect("GlassImpact", effect, true, true)
							target:EmitSound( "/physics/wood/wood_crate_break"..math.random(1, 4)..".wav" , 150, 50, 1)
						elseif (dampos:Distance(hindge2) <= ix.config.Get("Shot Distance", 3)*1.5) then
							target.bHindge2 = true
							local effect = EffectData()
								effect:SetStart(hindge2)
								effect:SetOrigin(hindge2)
								effect:SetScale(2)
							util.Effect("GlassImpact", effect, true, true)
							target:EmitSound( "/physics/wood/wood_crate_break"..math.random(1, 4)..".wav" , 150, 50, 1)
						end

						if (target.bHindge1 and target.bHindge2) then
							local Door = ents.Create("prop_physics")
							Door:SetAngles(target:GetAngles())
							Door:SetPos(target:GetPos() + target:GetUp())
							Door:SetModel(target:GetModel())
							Door:SetSkin(target:GetSkin())
							Door:SetCollisionGroup(0)
							Door:SetRenderMode(RENDERMODE_TRANSALPHA)
							target:Fire("unlock")
							target:Fire("openawayfrom", dmginfo:GetInflictor():UniqueID()..CurTime())
							target:SetCollisionGroup( 20 )
							target:SetRenderMode( 10 )
							Door:Spawn()
							target.canbeshot = false
							target:SetPos(target:GetPos() + Vector(0,0,-1000))
							timer.Simple(ix.config.Get("Respawn Timer", 60), function()
								target:SetCollisionGroup( 0 )
								target:SetRenderMode( 0 )
								target.bHindge2 = false
								target.bHindge1 = false
								target:SetPos(target:GetPos() - Vector(0,0,-1000))
								if (Door) then
									Door:Remove()
									target.canbeshot = true
								end
							end)
						end
					end
				end
			end
		end
	end
end
--]]