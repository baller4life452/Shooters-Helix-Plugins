ITEM.name = "Prop Constructable Base"
ITEM.description = "The constructable base."
ITEM.category = "Constructable"
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.prop = "models/props_c17/FurnitureBathtub001a.mdl"
ITEM.offset = Vector(0,0,10)
ITEM.maxdistance = 200
ITEM.mindistance = 80
ITEM.defaultturn = 90
ITEM.time = 5
ITEM.width = 2
ITEM.height = 2


ITEM.functions.Place = {
	name = "Place",
	tip = "Place Object",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() 
		local hit = trace.HitPos

		local prop = ents.Create( "prop_dynamic" )
		hit:Add(item.offset)
		client:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0), item.time-0.1, 1 )
		client:Freeze( true )
		client:SetAction("Constructing", item.time, function()

			prop:SetModel( item.prop )
			prop:SetPos( hit )
			prop:SetMoveType(MOVETYPE_VPHYSICS)
			prop:SetSolid(SOLID_VPHYSICS)
			local ang = client:GetAngles()
			ang:RotateAroundAxis(ang:Up(), item.defaultturn)
			prop:SetAngles(ang)
			prop:Spawn()
			client:Freeze( false )
			client:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), item.time-0.1, 1 )
			return true	
		end)
	end,
	OnCanRun = function(item)
		local client = item.player
		local eyepos = client:EyePos()
		local trace = client:GetEyeTraceNoCursor() 
		local hit = trace.HitPos
		local data = {}
			data.start = hit 
			data.endpos = data.start + Vector(0,0,-1)
			data.filter = client
		local trace = util.TraceLine(data)
		
		
		if eyepos:Distance( hit ) > item.maxdistance or eyepos:Distance( hit ) < item.mindistance then
			return false
		end
		return !IsValid(item.entity) and IsValid(client) and trace.HitWorld
	end
}


