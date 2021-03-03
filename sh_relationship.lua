local PLUGIN = PLUGIN

PLUGIN.name = "NPC Relationship"
PLUGIN.author = "SHOOTER"
PLUGIN.description = "Makes it so NPC CPs don't shoot at player CPs, and NPCs don't shoot at players with nothing."

ix.config.Add("npcrelationship", true, "Weather or not on NPC have relations with Players.", nil, {
	category = "NPC Relationship"
})

PLUGIN.npcEffected = {
		"npc_combine_s",
		"npc_combinedropship",
		"npc_combinegunship",
		"npc_cscanner",
		"npc_helicopter",
		"npc_hunter",
		"npc_manhack",
		"npc_metropolice",
		"npc_sniper",
		"npc_stalker",
		"npc_strider",
		"npc_turret_ceiling",
		"npc_turret_floor",
		"npc_turret_ground",
		"npc_combine_camera",
		"npc_combinedropship",
		"npc_rollermine",
		"npc_clawscanner",
		"npc_turret_ground",
		"npc_apcdriver",
}

PLUGIN.AllowedWeapons = {
    ['ix_hands'] = true,
	['ix_keys'] = true,
	['weapon_physgun'] = true,
	['gmod_tool'] = true
}

--[[
Doesn't matter whats the item just make to have these in some kind of outfit file
 
function ITEM:OnEquipped()
    self.player:SetNWBool("isRebel",true)
end
 
function ITEM:OnUnequipped()
    self.player:SetNWBool("isRebel",false)
end

--]]

if (SERVER) then 
    function PLUGIN:PlayerWeaponChanged(client) 
        if(ix.config.Get("npcrelationship", false)) then
            local char = client:GetCharacter()
            if char then
                if !char:IsCombine() and self.AllowedWeapons[client:GetActiveWeapon():GetClass()] == nil or client:GetNWBool("isRebel") then 
                    for _, NPCt in pairs( ents.FindByClass("npc_*")) do
                        for k, v in pairs(self.npcEffected) do
                            if (NPCt:GetClass() == v) then
                                NPCt:AddEntityRelationship(client, D_HT, 99)
                            end
                        end
                    end
                end
                if self.AllowedWeapons[client:GetActiveWeapon():GetClass()] != nil or char:IsCombine() then
                    for _, NPCt in pairs( ents.FindByClass("npc_*")) do
                        for k, v in pairs(self.npcEffected) do
                            if (NPCt:GetClass() == v) then
                                NPCt:AddEntityRelationship(client, D_LI, 99)
                            end
                        end
                    end
                end
            end
        end
    end
    function PLUGIN:OnEntityCreated(ent)
        if(ix.config.Get("npcrelationship", false)) then
		    if ent:IsNPC() then
		    	for k, v in pairs(player.GetAll()) do
	    			local char = v:GetCharacter()
    				if char then
						for k2, v2 in pairs(self.npcEffected) do
						    if (ent:GetClass() == v2) then
						        ent:AddEntityRelationship(v, D_LI, 99)
						    end
					    end
				    end
			    end
	        end
        end
    end
end