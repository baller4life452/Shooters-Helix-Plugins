PLUGIN.title = "Door Blaster"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Implements the ability shoot locks off doors, shoot the hinges of the door, blast open the door entirely."

ix.config.Add("Shot Distance", 3, "How close a shot has to be to a part of the door to destroy that part", nil, {
	data = { min = 1, max = 10 },
	category = "Door Blaster"
})

ix.config.Add("Range", 150, "How close a person has to be to the door to shoot it open", nil, {
	data = { min = 1, max = 300 },
	category = "Door Blaster"
})

ix.config.Add("Respawn Timer", 60, "How long it takes for the door to respawn", nil, {
	data = { min = 1, max = 600 },
	category = "Door Blaster"
})

PLUGIN.blastableweapons = {
	["weapon_shotgun"] = true,
}

PLUGIN.ignoredamage = {
	["weapon_crowbar"] = true,
	["weapon_stunstick"] = true,
	["ix_hands"] = true,
}

if (SERVER) then
	function PLUGIN:EntityTakeDamage(target, dmginfo) 
		if dmginfo:GetAttacker():IsPlayer() then
			if self.ignoredamage[dmginfo:GetAttacker():GetActiveWeapon()] == nil then
				if target:GetClass() == "prop_door_rotating" and (target.canbeshot == nil or target.canbeshot == true) and IsValid(dmginfo:GetInflictor()) and dmginfo:IsBulletDamage() then
					if dmginfo:GetInflictor():GetPos():Distance( target:GetPos() ) <= ix.config.Get("Range", 150) then
						
						print(self.blastableweapons[dmginfo:GetAttacker():GetActiveWeapon():GetClass()])
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
							timer.Simple(ix.config.Get("Respawn Timer", 60), function()
								target:SetCollisionGroup( 0 )
								target:SetRenderMode( 0 )
								target.bHindge2 = false
								target.bHindge1 = false
								if (Door) then
									Door:Remove()
								end
							end)
						end
						
						-- shooting lock
						if distance <= ix.config.Get("Shot Distance", 3) then
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
						end

						-- shooting hindges
						if (dampos:Distance(hindge1) <= ix.config.Get("Shot Distance", 3)*1.5) then
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
							timer.Simple(ix.config.Get("Respawn Timer", 60), function()
								target:SetCollisionGroup( 0 )
								target:SetRenderMode( 0 )
								target.bHindge2 = false
								target.bHindge1 = false
								if (Door) then
									Door:Remove()
								end
							end)
							
						end
					end
				end
			end
		end
	end
end
