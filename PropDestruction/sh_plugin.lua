PLUGIN.name = "Prop Destruction"
PLUGIN.author = "SHOOTER#5269"
PLUGIN.description = "Adds the ability to destroy any Prop"

ix.config.Add("propdestruction", true, "Weather or not props are even destructable.", nil, {
	category = "Prop Destruction"
})
ix.config.Add("propdestructionhud", true, "Weather or not the health hud is desplayed for the entity.", nil, {
	category = "Prop Destruction"
})
ix.config.Add("propdestructionhpmultiply", 2.2, "The amount to multiply the Mass of the object to get it's health.", nil, {
	data = { min = 1, max = 1000 },
	category = "Prop Destruction"
})

PLUGIN.ModifiedHealth = {
	{'models/props_debris/metal_panel02a.mdl', 750}, -- string model, int health
	{'models/props_debris/metal_panel01a.mdl', 1000}
}

if (SERVER) then
	if(ix.config.Get("propdestruction", false)) then
		function PLUGIN:OnEntityCreated( enti )
			if IsValid(enti) then
				if enti:GetClass() == "prop_physics" and enti:GetClass() != "ix_container" then 
					timer.Simple( 0.1, function()
						if IsValid(enti) then
						local phys = enti:GetPhysicsObject()
							if IsValid( phys ) then
								enti:SetMaxHealth(phys:GetMass() * ix.config.Get("propdestructionhpmultiply", 2.2))
								enti:SetHealth(enti:GetMaxHealth())
								for k, v in pairs(self.ModifiedHealth) do
									if v[1] == enti:GetModel() then
										enti:SetMaxHealth(v[2])
										enti:SetHealth(enti:GetMaxHealth())
									end
								end
							end
						end
					end)
				end
			end
		end
		
		function PLUGIN:EntityTakeDamage(target, dmginfo) 
			if target:GetClass() == "prop_physics" then
				if dmginfo:GetInflictor():GetClass() != "ix_hands" then
					target:SetHealth(target:Health() - dmginfo:GetDamage())
					if target:Health() <= 0 then
						target:EmitSound("physics/metal/metal_box_break" .. math.random(1, 2) .. ".wav")
						target:Remove()
					end 
				end
			end
		end
	end
end

if (CLIENT) then
	local w, h = ScrW(), ScrH()
	surface.CreateFont( "PropDestructionFont", {
	font = "Arial",
	extended = false,
	size = 20 * h/700,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = true,
	} )
		
	function PLUGIN:HUDPaint()
		if(ix.config.Get("propdestructionhud", false)) then
		local tr = LocalPlayer():GetEyeTraceNoCursor()
			if IsValid(tr.Entity) and tr.HitPos:DistToSqr(LocalPlayer():EyePos()) < 22500 and tr.Entity:GetClass() == "prop_physics" then
				local ent = tr.Entity

				draw.SimpleText("Health: " .. math.Round(ent:Health()) .. "/" .. math.Round(ent:GetMaxHealth()), "PropDestructionFont", ScrW() / 2, ScrH() / 1.85 + 20, color_white, TEXT_ALIGN_CENTER)
			end
		end
	end
end
