PLUGIN.name = "Tarot Major Arcana"
PLUGIN.author = "Howl with Chancer's code/ ported by SHOOTER"
PLUGIN.desc = "Adds a Major Arcana command."

ix.command.Add("tarot", {
    description = 'Pull a tarot card from tarot deck.',
	OnRun = function(self, client)
		local inventory = client:GetCharacter():GetInventory()
		if (!inventory:HasItem("tarot")) then
			client:notify("You do not have a tarot deck.")
			return
		end

		local family = {"The Fool", "The Magician", "The High Priestess", "The Empress", "The Emperor", "The Hierophant", "The Lovers", "The Chariot", "Justice", "The Hermit", "The Wheel of Fortune", "Strength", "The Hanged Man", "Death", "Temperance", "The Devil", "The Tower", "The Star", "The Moon", "The Sun", "Judgement", "The World",}
		local fam2 = {"reversed position", "upright position"}
		
		local msg = "draws " ..table.Random(family).. " in the " ..table.Random(fam2)
		
		ix.chat.Send(client, "me", msg)
	end
})


/*
ix.command.Add('Name', {
    description = 'Says your name.',
    OnRun = function(self, client)
        local character = client:GetCharacter()

        if character then
            ix.chat.Send(client, 'ic', client:Name())
        end
    end
})*/