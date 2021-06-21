ITEM.name = "Entity Constructable Base"
ITEM.description = "The constructable base."
ITEM.category = "Constructable"
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.entitys = "grenade_helicopter"
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
		local prop = ents.Create( item.entitys )
		local trace = client:GetEyeTraceNoCursor() 
		local hit = trace.HitPos
	
		hit:Add(item.offset)
		
		client:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0), item.time-0.1, 1 )
		client:Freeze( true )
		client:SetAction("Constructing", item.time, function()
			
			prop:SetPos( hit )
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
		
		if eyepos:Distance( hit ) > item.maxdistance or eyepos:Distance( hit ) < item.mindistance then
			return false
		end
		return !IsValid(item.entity) and IsValid(client) 
	end
}


