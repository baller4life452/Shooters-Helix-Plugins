PLUGIN.title = "In-Development Hud"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Implements a small hud for players to see at all times, admins will have access to a dev varient as well."

PLUGIN.servername = "Delta"
PLUGIN.updatetext = "Core Update - 1"

ix.config.Add("DevHud", true, "Weather or not players see the hud at all.", nil, {
	category = "Dev Hud"
})	

CAMI.RegisterPrivilege({
	Name = "Helix - Staff Hud",
	MinAccess = "admin"
})


ix.option.Add("Staff Hud", ix.type.bool, true, {
	bNetworked = true,
	category = "Dev Hud",
	hidden = function()
		return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Staff Hud", nil)
	end
})

if (CLIENT) then
	local w, h = ScrW(), ScrH()
	
	
	surface.CreateFont( "DevHudServerName", {
		font = "Times New Roman",
		extended = false,
		size = 20 * h/950,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
	surface.CreateFont( "DevHudText", {
		font = "Times New Roman",
		extended = false,
		size = 20 * h/1000,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
	function PLUGIN:HUDPaint()
		local lclient = LocalPlayer()
		if ix.config.Get("DevHud", true) then
			if IsValid(LocalPlayer()) then
				--Server Name
				draw.SimpleText( 
				"".. self.servername .. "",
				"DevHudServerName",
				w/5.25,
				h/1.14,
				Color( 255, 255, 255, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER
				)
				--User Info
				draw.SimpleText( 
				"| ".. self.updatetext .." | " .. lclient:SteamID64() .. " | ".. lclient:SteamID() .. " | "..os.date( "%m/%d/%Y | %X" , os.time() ) .. " | ",
				"DevHudText",
				w/5.25,
				h/1.12,
				Color( 210, 210, 210, 255 ),
				TEXT_ALIGN_LEFT,
				TEXT_ALIGN_CENTER
				)
				if CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Staff Hud", nil) then
					if (ix.option.Get("Staff Hud", true)) then
						local trace = lclient:GetEyeTraceNoCursor() 
						local entTrace = trace.Entity
						--Dev Info
						draw.SimpleText( 
						"| Pos: ".. math.Round(lclient:GetPos().x, 2) .."," .. math.Round(lclient:GetPos().y, 2) .."," .. math.Round(lclient:GetPos().z, 2) .." | Angle: ".. math.Round(lclient:GetAngles().x, 2) ..",".. math.Round(lclient:GetAngles().y, 2) ..",".. math.Round(lclient:GetAngles().z, 2) .." | FPS: " ..  math.Round( 1 / FrameTime(), 0) .. " | Trace Dis: ".. math.Round(lclient:GetPos():Distance( trace.HitPos ), 2) .. " | ",
						"DevHudText",
						w/5.25,
						h/1.10,
						Color( 210, 210, 210, 255 ),
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_CENTER
						)
						-- more info
						draw.SimpleText( 
						"| Trace Pos: ".. math.Round(trace.HitPos.x, 2) ..",".. math.Round(trace.HitPos.y, 2) ..",".. math.Round(trace.HitPos.z, 2) .." | Cur Health: " .. math.Round(lclient:Health(), 2) .. " | FrameTime: " .. FrameTime() .. " | PING: " ..lclient:Ping().. " | ",
						"DevHudText",
						w/5.25,
						h/1.08,
						Color( 210, 210, 210, 255 ),
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_CENTER
						)
						if IsValid(entTrace) then
						-- more info
						draw.SimpleText( 
						"| Cur Trace: ".. entTrace:GetClass() .." | Trace Model: " .. entTrace:GetModel() .. " | ",
						"DevHudText",
						w/5.25,
						h/1.06,
						Color( 210, 210, 210, 255 ),
						TEXT_ALIGN_LEFT,
						TEXT_ALIGN_CENTER
						)
						end
					end
				end
			end
		end
	end
end
