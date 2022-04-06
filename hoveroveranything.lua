PLUGIN.name = "RPG Balance"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Have you ever wanted to give your players and RPG, but they keep using them irresponsible, unfair and/or overpowered skills? Well, this plugin will help you to balance your RPG."

ix.config.Add("HoverColor", Color(255, 255, 255), "The Default Color For When hovering over an objetct.", nil, {category = PLUGIN.name})


PLUGIN.IgnoredEntities = {
	["player"] = true,
	["prop_physics"] = true,
	["prop_ragdoll"] = true,
	["worldspawn"] = true,
	["func_lod"] = true,
	["env_sprite"] = true,
	["env_sprite_clientside"] = true,
	["env_sprite_oriented"] = true,
	["prop_detail"] = true,
	["prop_detail_sprite"] = true,
	["point_spotlight"] = true,
	["beam"] = true,
	['func_monitor'] = true,
	["prop_dynamic"] = true,
	["class C_Func_Dust"] = true,
	["gmod_tool"] = true,
 	["viewmodel"] = true,
	["physgun_beam"] = true,
	["class C_LaserDot"] = true,
	["func_illusionary"] = true,
	["func_brush"] = true,
	["func_tracktrain"] = true,
}

if !(CLIENT) then return end
function PLUGIN:PreDrawHalos()
    local ply = LocalPlayer()
    local Trace = ply:GetEyeTrace()
	local distance = Trace.HitPos:Distance(ply:GetPos())
	local Pulse = (math.abs(math.sin(RealTime() / 5)) * 0.5)+ 0.5
	local r, g, b, a = ix.config.Get("HoverColor"):Unpack()
	local entsEffected = ents.FindInSphere(Trace.HitPos, 10)
	for k, v in pairs(entsEffected) do
		if distance < 200 and IsValid(v) and !(self.IgnoredEntities[v:GetClass()]) then
			-- create a num that ranges from 0 to 255 based on the distance 0 being the farthest away and 255 being the closest
			a = math.Clamp(255 - (distance / 200) * 255, 0, 255)
			local multiplyer = (distance / 200)
			halo.Add( {v}, Color(r*Pulse,g*Pulse,b*Pulse, a), 4*multiplyer, 4*multiplyer, 1*multiplyer, true, true )
		end
	end
end