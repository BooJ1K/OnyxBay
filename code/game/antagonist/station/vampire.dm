GLOBAL_DATUM_INIT(vampires, /datum/antagonist/vampire, new)

/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	feedback_tag = "vampire_objective"
	restricted_jobs = list(/datum/job/captain, /datum/job/hos, /datum/job/hop,
							/datum/job/rd, /datum/job/chief_engineer,/datum/job/merchant,
							/datum/job/iaa, /datum/job/barmonkey)
	additional_restricted_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/detective)

	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/chaplain)
	welcome_text = "You are a Vampire! Use the \"<b>Vampire Help</b>\" command to learn about the backstory and mechanics! Stay away from the Chaplain, and use the darkness to your advantage."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antaghud_indicator = "hudvampire"

/datum/antagonist/vampire/Initialize()
	. = ..()
	if(config.game.vampire_min_age)
		min_player_age = config.game.vampire_min_age

	// Building vampire powers list.
	if(!vampirepowers.len)
		for(var/P in vampirepower_types)
			vampirepowers += new P()

/datum/antagonist/vampire/get_special_objective_text(datum/mind/player)
	var/total_blood = player.vampire.blood_total
	var/message = ""
	switch(total_blood)
		if(0 to 100)
			message = pick("What a loser.", "Worse than a mosquito.", "A leech would do better.", "Almost reached a flea's level!", "Comparable to a bed bug.")
		if(101 to 250)
			message = pick("Not so impressive.", "Could do better.", "Try harder next time.")
		if(251 to 450)
			message = pick("Not so bad.", "Fine job.")
		if(451 to 800)
			message = pick("Nice job!", "Great results!", "What a creature of the night!", "A professional bloodfeeder!")
		else
			message = pick("Dear God.", "Somebody, stop them!", "The beast of bedtime tales!", "Night-time is their time!", "A bloody feast!")
	return "<br><b>They drank </b>[player.vampire.blood_total]<br> units of blood. [message]"


/datum/antagonist/vampire/create_objectives(datum/mind/player)
	if(!..())
		return

	var/kill
	var/escape
	var/protect
	var/enthrall
	var/vampirize

	switch(rand(1, 100))
		if(1 to 25)
			kill = TRUE
			escape = TRUE
		if(26 to 50)
			protect = TRUE
			escape = TRUE
		if(51 to 75)
			enthrall = TRUE
			escape = TRUE
		if(76 to 98)
			vampirize = TRUE
			escape = TRUE
		else
			enthrall = TRUE
			kill = TRUE
			escape = TRUE


	if(kill)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = player
		kill_objective.find_target()
		player.objectives += kill_objective
	if(protect)
		var/datum/objective/protect/protect_objective = new
		protect_objective.owner = player
		protect_objective.find_target()
		player.objectives += protect_objective
	if(vampirize)
		var/datum/objective/vampirize/vampirize_objective = new
		vampirize_objective.owner = player
		vampirize_objective.find_target()
		player.objectives += vampirize_objective
	if(enthrall)
		var/datum/objective/enthrall/enthrall_objective = new
		enthrall_objective.owner = player
		player.objectives += enthrall_objective
	if(escape)
		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = player
		player.objectives += survive_objective

/datum/antagonist/vampire/update_antag_mob(datum/mind/player)
	..()
	player.current.make_vampire()


/datum/antagonist/vampire/can_become_antag(datum/mind/player, ignore_role, max_stat)
	if(..())
		if(player.current)
			if(ishuman(player.current))
				var/mob/living/carbon/human/H = player.current
				if(H.isSynthetic())
					return 0
				if(H.species.species_flags & SPECIES_FLAG_NO_SCAN)
					return 0
				return 1
			else if(isnewplayer(player.current))
				if(player.current.client && player.current.client.prefs)
					var/datum/species/S = all_species[player.current.client.prefs.species]
					if(S && (S.species_flags & SPECIES_FLAG_NO_SCAN))
						return 0
					if(player.current.client.prefs.organ_data[BP_CHEST] == "cyborg") // Full synthetic.
						return 0
					return 1
	return 0

/datum/antagonist/vampire/remove_antagonist(datum/mind/player, show_message, implanted)
	if(!..())
		return 0
	to_chat(player.current, SPAN("danger", "An unfamiliar white light flashes through your mind... You can feel you fangs shrink, reverting to their normal size. Your hands get soft and warm yet again. Eh... What was that \"Veil\" thing, again?.."))
	player.memory = ""
	if(show_message)
		player.current.visible_message(SPAN("notice", "It looks like something veil's just abandoned [player.current]'s body..."))
	player.current.unmake_vampire()
