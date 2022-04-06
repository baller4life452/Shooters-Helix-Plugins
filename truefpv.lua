PLUGIN.title = "True FPV"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Implements a world based first person view with crosshair draw."

ix.config.Add("First Person View", true, "Weather or not FPV is enabled.", nil, {
	category = PLUGIN.name
})


PLUGIN.IgnoredWeapons = {
	['weapon_physgun'] = true,
	['gmod_tool'] = true
}
function PLUGIN:RestartHeadSize( client )
	client:InvalidateBoneCache()
    client:SetupBones()
		
	local NeckboneID
	local HeadboneID

    for bone = 0, (client:GetBoneCount() - 1) do
        if client:GetBoneName(bone):lower():find("neck") then
            NeckboneID = bone
            break
        end
    end
	for bone = 0, (client:GetBoneCount() - 1) do
        if client:GetBoneName(bone):lower():find("head") then
            HeadboneID = bone
            break
        end
    end
	if NeckboneID and HeadboneID then
		client:ManipulateBoneScale( NeckboneID, Vector(1, 1, 1))
		client:ManipulateBoneScale( HeadboneID, Vector(1, 1, 1))
	end
end

function PLUGIN:CalcView(ply, origin, angles, fov)
	local view = {
		origin = origin,
		angles = angles,
		fov = 90,
		drawviewer = true
	}

	if ply:LookupAttachment("anim_attachment_head") != 0 then
		local head = ply:LookupAttachment("anim_attachment_head")
		head2 = ply:GetAttachment(head)
	else
		local head = ply:LookupAttachment("eyes")
		head2 = ply:GetAttachment(head)
	end
	if IsValid(ply) and ply:Alive() and IsValid(ply:GetActiveWeapon()) then
		if self.IgnoredWeapons[ply:GetActiveWeapon():GetClass()] == true then self:RestartHeadSize( ply ) return end
	end
    if not head2 or not head2.Pos then return end
	if IsValid(ix.gui.menu) or IsValid(ix.gui.characterMenu) then self:RestartHeadSize( ply )return end
    if not ix.config.Get("First Person View", false) then self:RestartHeadSize( ply ) return end
	if (ply:GetMoveType() == MOVETYPE_NOCLIP) then self:RestartHeadSize( ply ) return end
	

	

    ply:InvalidateBoneCache()
    ply:SetupBones()

    local NeckboneID
	local HeadboneID

	for bone = 0, (ply:GetBoneCount() - 1) do
        if ply:GetBoneName(bone):lower():find("neck") then
            NeckboneID = bone
            break
        end
    end
	for bone = 0, (ply:GetBoneCount() - 1) do
        if ply:GetBoneName(bone):lower():find("head") then
            HeadboneID = bone
            break
        end
    end

    if NeckboneID and HeadboneID then
		ply:ManipulateBoneScale( NeckboneID, Vector(0.5, 0.5, 0.5))
		ply:ManipulateBoneScale( HeadboneID, Vector(0, 0, 0))
    end
		
    local data = {}
		data.start = ply:GetPos()
		data.endpos = data.start + Vector( 0, 0, 100 )
		data.filter = ply
	local trace = util.TraceLine(data)
	
    view.origin = head2.Pos + head2.Ang:Up() + Vector(0,0,2)
	
	if ply:Crouching() then
		if math.sqrt(math.pow(ply:GetVelocity().x, 2 ) + math.pow(ply:GetVelocity().y, 2)) > 0 and trace.HitWorld then
			view.origin = head2.Pos + head2.Ang:Up() + Vector(0,0,-16)
		end
	end
	
    return view
end