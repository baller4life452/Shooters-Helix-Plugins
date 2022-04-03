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
