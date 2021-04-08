PLUGIN.name = "Fudge Rolling"
PLUGIN.author = "Pilot (ported by SHOOTER)"
PLUGIN.desc = "Fixing Serious Roleplay the way no one else could."

--[[
TODO:
a derma panel to view that?
--]]

--[[
Point >= 100
Close = 200
Medium = 350
Far > 350
--]]

local distances = {}
	distances[1] = 100
	distances[2] = 200
	distances[3] = 350

local weaponsList = {
	--weaponclass, distancethreshold, basevalue, addedtrait, melee/range
	{"ix_hands", distances[1], 0, "str", "Melee"},
	{"wasteland_staplegun", distances[2], 1, "stm", "Range"},
	{"wasteland_handmadepistol", distances[2], 2, "stm", "Range"}, -- pistol
	{"wasteland_handmadepistols", distances[2], 2, "stm", "Range"},
	{"wasteland_nailgun", distances[2], 1, "stm", "Range"},
	{"wasteland_handmadesmg", distances[2], 1, "stm", "Range"},
	{"tfa_ins2_mpx", distances[3], 2, "stm", "Range"}, -- smgs
	{"tfa_ins2_warface_mcmillan_cs5", 1000, 5, "stm", "Range"}, -- snipers
	{"tfa_fas2_g3", distances[3], 5, "stm", "Range"}, -- tac rifles
	{"tfa_fas2_ks23", distances[1], 4, "stm", "Range"}, 
	{"tfa_fas2_mp5", distances[2], 3, "stm", "Range"},
	{"tfa_fas2_p226", distances[1], 2, "stm", "Range"},
	{"tfa_fas2_sg55x", distances[3], 5, "stm", "Range"},
	{"tfa_fas2_sks", 1000, 5, "stm", "Range"},
	{"tfa_fas2_svd", 1000, 6, "stm", "Range"},
	{"tfa_ins2_ak400", distances[3], 4, "stm", "Range"},
	{"tfa_ins2_cw_ar15", distances[3], 4, "stm", "Range"},
	{"tfa_ins2_ar10", 1000, 4, "stm", "Range"},
	{"tfa_ins2_deagle", distances[2], 4, "stm", "Range"},
	{"tfa_eft_downrange_tomahawk", distances[1], 3, "str", "Melee"}, -- melee
	{"tfa_ins2_glock_19", distances[2], 2, "stm", "Range"},
	{"tfa_ins2_glock_p80", distances[2], 2, "stm", "Range"},
	{"tfa_ins2_hk416a5", distances[3], 3, "stm", "Range"},
	{"tfa_ins2_hk416", distances[3], 3, "stm", "Range"},
	{"tfa_ins2_417", distances[3], 3, "stm", "Range"},
	{"tfa_eft_kiba_arms_axe", distances[1], 3, "str", "Melee"},
	{"tfa_ins2_sopmod2", distances[3], 3, "stm", "Range"},-- rifles
	{"tfa_ins2_m500", distances[1], 4, "stm", "Range"}, -- shotguns
	{"tfa_ins2_m590o", distances[1], 4, "stm", "Range"},
	{"tfa_nam_m60", distances[3], 4, "stm", "Range"}, --lmg
	{"tfa_nam_m79", distances[3], 6, "stm", "Range"}, --gl
	{"tfa_ins2_m9", distances[2], 2, "stm", "Range"},
	{"tfa_bo3_china_lake", distances[3], 6, "stm", "Range"},
	{"tfa_ins2_minimi", distances[3], 4, "stm", "Range"},
	{"tfa_ins2_mk18mod", distances[3], 3, "stm", "Range"},
	{"tfa_ins2_sai_gry", distances[3], 3, "stm", "Range"},
	{"tfa_ins2_mp5a4", distances[3], 2, "stm", "Range"},
	{"tfa_ins2_qsz92", distances[2], 2, "stm", "Range"},
	{"tfa_ins2_sr25", distances[3], 5, "stm", "Range"},
	{"tfa_ins2_kaclmg", distances[3], 4, "stm", "Range"},
	{"tfa_ins2_usp_match", distances[2], 2, "stm", "Range"},
	{"weapon_baton", distances[1], 3, "str", "Melee"},
	{"ln_balistic_shield", distances[1], 4, "str", "Melee"},
	{"ln_rebel_shield", distances[1], 4, "str", "Melee"},
	{"riot_shield", distances[1], 4, "str", "Melee"},
	{"ln_shank", distances[1], 2, "str", "Melee"},
	{"iw_banshee", distances[1], 7, "stm", "Range"},
	{"iw_dcm8", distances[1], 5, "stm", "Range"},
	{"iw_emc", distances[2], 3, "stm", "Range"},
	{"iw_erad", distances[3], 4, "stm", "Range"},
	{"iw_fhr40", distances[3], 4, "stm", "Range"},
	{"iw_kbar32", distances[3], 4, "stm", "Range"},
	{"tfa_fas2_g3", 1000, 6, "stm", "Range"},
	{"iw_mauler", distances[3], 5, "stm", "Range"},
	{"iw_oni", distances[2], 4, "stm", "Range"},
	{"iw_raijin", distances[3], 4, "stm", "Range"},
	{"iw_rprevo", distances[3], 4, "stm", "Range"},
	{"iw_vpr", distances[3], 4, "stm", "Range"},
	{"iw_stallion44", 1000, 6, "stm", "Range"},
}

local armorList = {
	{"models/armacham/security2/guard_1.mdl", 1},
	{"models/armacham/security2/guard_2.mdl", 1},
	{"models/armacham/security2/guard_3.mdl", 1},
	{"models/armacham/security2/guard_4.mdl", 1},
	{"models/armacham/security2/guard_5.mdl", 1},
	{"models/armacham/security2/guard_6.mdl", 1},
	{"models/armacham/security2/guard_7.mdl", 1},
	{"models/armacham/security2/guard_8.mdl", 1},
	{"models/armacham/security2/guard_9.mdl", 1},
	{"models/player/kerry/class_securety.mdl", 3},
	{"models/player/kerry/class_securety_2.mdl", 3},
	{"models/ninja/mgs4_praying_mantis_merc.mdl", 4},
	{"models/ninja/mgs4_praying_mantis_merc_short_sleeved.mdl", 4},
	{"models/ninja/mgs4_raven_sword_merc.mdl", 4},
	{"models/tfusion/playermodels/mw3/juggernaut_c.mdl", 5},
	{"models/tfusion/playermodels/mw3/juggernaut_explosive_so.mdl", 6},
	{"models/tfusion/playermodels/mw3/juggernaut_novisor_b.mdl", 6},
	{"models/tfusion/playermodels/mw3/mp_fullbody_ally_juggernaut.mdl", 6},
	{"models/tfusion/playermodels/mw3/mp_fullbody_opforce_juggernaut.mdl", 6},
	{"models/tfusion/playermodels/mw3/sp_juggernaut.mdl", 7},
	{"models/player/kerry/epsilon2.mdl", 4},
	{"models/player/pmc_4/pmc__01.mdl", 4},
	{"models/player/pmc_4/pmc__02.mdl", 4},
	{"models/player/pmc_4/pmc__03.mdl", 4},
	{"models/player/pmc_4/pmc__04.mdl", 4},
	{"models/player/pmc_4/pmc__05.mdl", 4},
	{"models/player/pmc_4/pmc__06.mdl", 4},
	{"models/player/pmc_4/pmc__07.mdl", 4},
	{"models/player/pmc_4/pmc__08.mdl", 4},
	{"models/player/pmc_4/pmc__08.mdl", 4},
	{"models/player/pmc_4/pmc__09.mdl", 4},
	{"models/player/pmc_4/pmc__10.mdl", 4},
	{"models/player/pmc_4/pmc__11.mdl", 4},
	{"models/player/pmc_4/pmc__12.mdl", 4},
	{"models/player/pmc_4/pmc__13.mdl", 4},
	{"models/player/pmc_4/pmc__14.mdl", 4},
	{"models/scp/guard_noob.mdl", 4},
	{"models/scp/guard_med.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_02.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_04.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_05.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_06.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_07.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_08.mdl", 4},
	{"models/scp_mtf_russian/mtf_rus_09.mdl", 4},
	{"models/scp_operators/scp_security_heavy_p.mdl", 4},
	{"models/scp_operators/scp_security_light_p.mdl", 4},
	{"models/scp_operators/scp_security_standard_p.mdl", 4},
	{"models/kss/tsremastered/smod_tactical_soldier.mdl", 5},
	{"models/kss/tsremastered/smod_operator_tac_03.mdl", 4},
	{"models/kss/tsremastered/smod_operator_tac_02.mdl", 4},
	{"models/kss/tsremastered/smod_operator_tac_01.mdl", 4},
	{"models/player/r6s_r6hazmat.mdl", 3},
	{"models/ninja/mw3/delta/delta4_masked.mdl", 5},

}

local wordValue = {}
	wordValue[3] = "Excellent"
	wordValue[2] = "Great"
	wordValue[1] = "Good"
	wordValue[0] = "Fair"
	wordValue[-1] = "Mediocre"
	wordValue[-2] = "Poor"
	wordValue[-3] = "Terrible"

local hurtValue = {}
	hurtValue[1] = "Scratch"
	hurtValue[2] = "Scratch"
	hurtValue[3] = "Hurt"
	hurtValue[4] = "Hurt"
	hurtValue[5] = "Hurt"
	hurtValue[6] = "Very Hurt"
	hurtValue[7] = "Very Hurt"
	hurtValue[8] = "Incapacitated"

local playerMeta = FindMetaTable("Player")

ix.command.Add("combatroll", {
	syntax = "<attack or dodge>",
	description = "Rolls for attack or dodge",
	arguments = {
		ix.type.text
	},
	OnRun = function(self, client, arguments)
		local td = {}
			td.start = client:GetShootPos()
			--td.endpos = td.start + client:GetAimVector()*84
			td.endpos = td.start + client:EyeAngles():Forward()*10000
			td.filter = client
		local trace = util.TraceLine(td)
		local entity = trace.Entity

		local dice = {}
			dice[1] = math.random(-1, 1)
			dice[2] = math.random(-1, 1)
			dice[3] = math.random(-1, 1)

		--Weapon damage
		local weaponValue = 0

		--Concentric circles of damage
		local distanceModifier = 0

		--Armor damage
		local armorValue = 0

		--Stamina modifier
		local staminaValue = math.random(0, math.floor(client:GetCharacter():GetAttribute("stm", 0) / 5))

		if (IsValid(entity) and entity:IsPlayer()) then --and entity:IsPlayer() and entity.character) then 
			local clientDistance = td.start:Distance(entity:GetPos())
			--[[
				Weapon Handling
			--]]
			for _, v in pairs(weaponsList) do		
				if v[1] == client:GetActiveWeapon():GetClass() && client:GetActiveWeapon():HasAmmo() then --What weapon is your character holding
					--Concentric circles of damage based on distance
					for k in pairs(distances) do
						if clientDistance > distances[k] then
							distanceModifier = distanceModifier - 1
						elseif clientDistance < distances[k] && distances[k] < v[2] then
							distanceModifier = distanceModifier + 1
						end
					end

					--Compile Weapon Damages
					if v[5] == "Melee" then
						if clientDistance <= distances[1] then
							weaponValue = v[3] + math.floor(client:GetCharacter():GetAttribute(v[4], 0) / 2)
						else
							client:NotifyLocalized("You are too far to use a melee weapon.")
							return
						end
					elseif v[5] == "Range" then
						weaponValue = v[3] + distanceModifier + math.floor(client:GetCharacter():GetAttribute(v[4], 0) / 5)
					end
				elseif v[1] == client:GetActiveWeapon():GetClass() && client:GetActiveWeapon():HasAmmo() == false && clientDistance >= distances[1] then
					client:NotifyLocalized("This weapon does not have ammunition loaded!")
					return false
				end
			end

			--[[
				Armor Handling
			--]]
			for _, v in pairs(armorList) do
				if v[1] == entity:GetModel() then
					armorValue = -(math.random(0, v[2]) + math.floor(entity:GetCharacter():GetAttribute("end", 0) / 6))
				end
			end

			--[[
				Hunger Handling
				
				75%-100% = 0 Penalty
				50%-75% = -1 Penalty
				25%-50% = -2 Penalty
				0%-25% = -3 Penalty
			--]]
			
			local enemyluck = -(math.floor(entity:GetCharacter():GetAttribute("lck", 0) / 2))
            local playerluck = math.floor(client:GetCharacter():GetAttribute("lck", 0) / 2)


			--[[
				Dice Handling
			--]]
			local dicesumSimple = dice[1] + dice[2] + dice[3]
			local dicesumFinalAttack = dice[1] + dice[2] + dice[3] + weaponValue + armorValue + playerluck
			local dicesumFinalDodge = (dice[1] + dice[2] + dice[3] + staminaValue) + enemyluck
			--Hurt messages
			local hurtMessage = "No Damage"
			for k2, v2 in pairs(hurtValue) do
				if (dicesumFinalAttack or dicesumFinalDodge) <= 0 then
					hurtMessage = "No Damage"
				elseif (dicesumFinalAttack or dicesumFinalDodge) == k2 then
					hurtMessage = v2
				elseif (dicesumFinalAttack or dicesumFinalDodge) >= 9 then
					hurtMessage = "Near Death"
				end
			end

			if (arguments == "attack") then
				ix.chat.Send(client, "mel", "...\n\nDice: "..dice[1]..", "..dice[2]..", "..dice[3].." = "..dicesumSimple.."; "..wordValue[dice[1]+dice[2]+dice[3]].."\nWeapon: "..weaponValue.."\nArmor: "..armorValue.."\nLuck: "..playerluck.."\nFinal: "..dicesumFinalAttack.."; "..hurtMessage)
				ix.util.Notify(("You have been hit with "..dicesumFinalAttack.."; "..hurtMessage), entity)
			elseif (arguments == "dodge") then
				ix.chat.Send(client, "mel", "...\n\nDice: "..dice[1]..", "..dice[2]..", "..dice[3].." = "..dicesumSimple.."; "..wordValue[dice[1]+dice[2]+dice[3]].."\nStamina: "..staminaValue.."\nEnemy Luck: "..enemyluck.."\nFinal: "..dicesumFinalDodge)
				ix.util.Notify(("You have been hit with "..dicesumFinalDodge.."; "..hurtMessage), entity)
			else
				client:NotifyLocalized("Please specify attack or dodge.")
			end
		else
			client:NotifyLocalized("You are not looking at a valid player.")
		end
	end
})