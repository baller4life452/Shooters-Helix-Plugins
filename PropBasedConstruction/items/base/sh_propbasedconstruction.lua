ITEM.name = "Prop Based Constructable Base"
ITEM.description = "The constructable base."
ITEM.category = "Constructable"
ITEM.model = "models/Items/item_item_crate.mdl"
ITEM.prop = "models/props_c17/FurnitureBathtub001a.mdl"
ITEM.time = 5
ITEM.width = 2
ITEM.height = 2

function ITEM:GetModel()
    return ( (self.invID == 0 or not self.invID) and self.model ) or self.prop
end

ITEM.functions.Place = {
	name = "Place",
	tip = "Place Object",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		local client = item.player
		local trace = client:GetEyeTraceNoCursor() 
		local hit = trace.HitPos

		client:SetNWString( "ConstructablePropModel" , item.prop )
		client:SetNWBool( "ConstructablePropPlacing", true )
		client:SetNWInt( "ConstructablePropID", item.id )		
		return false
		
	end,
	OnCanRun = function(item)
		local client = item.player
		
		return !IsValid(item.entity) and IsValid(client)
	end
}


