PLUGIN.name = "Constructable Props"
PLUGIN.author = "Shooter"
PLUGIN.description = "Adds the ability to construct props and entities. (NOTE: EXTREMELY SIMPLE)"

function PLUGIN:LoadData()
	self:LoadConstructionProp()
end

function PLUGIN:SaveData()
	self:SaveConstructionProp()
end

if (SERVER) then
	function PLUGIN:SaveConstructionProp()
		local data = {}
		for _, v in ipairs(ents.FindByClass("prop_dynamic")) do
			data[#data + 1] = {
				pos = v:GetPos(),
				angles = v:GetAngles(),
				model = v:GetModel(),
			}
		end
		ix.data.Set("ConstructionProp", data)
	end

	function PLUGIN:LoadConstructionProp()
		for _, v in ipairs(ix.data.Get("ConstructionProp") or {}) do
			local prop = ents.Create( "prop_dynamic" )

			prop:SetModel( v.model )
			prop:SetPos( v.pos )
			prop:SetMoveType(MOVETYPE_VPHYSICS)
			prop:SetSolid(SOLID_VPHYSICS)
			prop:SetAngles(v.angles)
			prop:Spawn()
		end
	end
end