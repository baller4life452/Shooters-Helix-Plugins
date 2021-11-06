PLUGIN.title = "Secret Actions"
PLUGIN.author = "Shooter#5269"
PLUGIN.description = "Implements /me that will only show up to people within line of sight of you."

function PLUGIN:InitializedChatClasses()
	ix.chat.Register("me", {
		format = "** %s %s",
		GetColor = function(self, speaker, text)
			local color = ix.chat.classes.ic:GetColor(speaker, text)

			return Color(color.r - 35, color.g - 35, color.b - 35)
		end,
		CanHear = function(self, speaker, listener)
            local trace = util.TraceLine{start = speaker:EyePos(), mask  = MASK_SOLID_BRUSHONLY, endpos = listener:EyePos()}
            if !trace.Hit then
                if (speaker:EyePos():Distance(listener:EyePos()) <= ix.config.Get("chatRange", 280)) then
                    return true
                end
            end
            return false
		end,
		prefix = {"/Me", "/Action"},
		description = "@cmdMe",
		indicator = "chatPerforming",
		deadCanChat = true
	})
end
