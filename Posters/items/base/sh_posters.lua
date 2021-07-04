ITEM.name = "Posters Base"
ITEM.description = "The Posters base."
ITEM.category = "Poster"
ITEM.model = "models/props_junk/garbage_newspaper001a.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Place = {
	name = "Place",
	tip = "Place Poster",
	icon = "icon16/arrow_up.png",
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() 
		local hit = trace.HitPos
		local Pos1 = trace.HitPos + trace.HitNormal
		local Pos2 = trace.HitPos - trace.HitNormal
		
		util.Decal( item.poster, Pos1, Pos2 )
		client:EmitSound( "player/sprayer.wav", 75, 100, 0.5)

		return true
		
	end,
	OnCanRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() 
		
		
		return !IsValid(item.entity) and IsValid(client) and trace.HitWorld and client:GetPos():Distance(trace.HitPos) < 300 and trace.Hit
	end
}


