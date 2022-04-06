PLUGIN.name = "Arma Inspired Pointing System"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Adds the /point command, when you do all players close to you will see a cicle where you are looking"
    
ix.command.Add("point", {
    description = 'Point at whatever you want and others will see what your looking at.',
	OnRun = function(self, client)
	    local table = ents.FindInSphere(client:EyePos(), 200)
	    local i = #table
        local pointing = client:GetEyeTraceNoCursor()
        
		::GOTO_REVERSE::
        if table[i]:IsPlayer() then
            local trace = util.TraceLine{
				start = client:EyePos(),
				endpos = table[i]:EyePos(),
				mask  = MASK_SOLID_BRUSHONLY,
			}
            if !trace.Hit then
                net.Start("Pointing")
                    net.WriteFloat( (CurTime()+10) )
                    net.WriteVector( pointing.HitPos  )
                net.Send( table[i] )
            end
		end
		i = i - 1
    	if (i ~= 0) then
		   	goto GOTO_REVERSE
    	end
	end
})

if SERVER then
    util.AddNetworkString( "Pointing" )
end

if CLIENT then
    local flo = 0
    local vec
    function PLUGIN:HUDPaint()
        net.Receive( "Pointing", function(len)
            flo = net.ReadFloat()
            vec = net.ReadVector()
        end)
        if flo >= CurTime() then
            local toScream = vec:ToScreen()
            local distance = 40/(LocalPlayer():GetPos():Distance(vec)/300)
            surface.DrawCircle( toScream.x, toScream.y, distance, 0, 255, 0, 255 )
        end
    end
end