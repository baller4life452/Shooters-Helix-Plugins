ITEM.name = "Sledge Hammer"
ITEM.description = "The way to destroy props ."
ITEM.category = "Constructable"
ITEM.model = "models/props_debris/wood_board04a.mdl"
ITEM.time = 2 
ITEM.width = 1
ITEM.height = 2


ITEM.functions.Destroy = {
	name = "Destroy",
	tip = "Destroy Object",
	icon = "icon16/delete.png",
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() 
		local entTrace = trace.Entity
		
		client:ScreenFade( SCREENFADE.OUT, Color( 0, 0, 0), item.time-0.1, 0.1 )
		client:SetAction("Constructing", item.time)
		client:DoStaredAction(entTrace, function() 

			entTrace:Remove()
			client:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0), item.time-0.1, 1 )
			
		end, item.time)
		
		return false	
	end,
	OnCanRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() 
		local entTrace = trace.Entity
		 
		return !IsValid(item.entity) and IsValid(client) and entTrace:GetClass() == "prop_dynamic" 
	end
}


