/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 5, bomb = 0, bio = 0)
	siemens_coefficient = 0 // These are ELITE

/obj/item/clothing/gloves/insulated
	desc = "These gloves will protect the wearer from electric shocks."
	name = "insulated gloves"
	color = COLOR_YELLOW
	icon_state = "white"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	armor = list(melee = 10, bullet = 5, laser = 10, energy = 10, bomb = 0, bio = 30)

	drop_sound = SFX_DROP_RUBBER
	pickup_sound = SFX_PICKUP_RUBBER

/obj/item/clothing/gloves/insulated/cheap                             //Cheap Chinese Crap
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	name = "budget insulated gloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()

/obj/item/clothing/gloves/insulated/cheap/New()
	..()
	//average of 0.4, better than regular gloves' 0.75
	siemens_coefficient = pick(0, 0.1, 0.2, 0.3, 0.4, 0.6, 1.3)

/obj/item/clothing/gloves/forensic
	desc = "Specially made gloves for forensic technicians. The luminescent threads woven into the material stand out under scrutiny."
	name = "forensic gloves"
	icon_state = "forensic"
	item_state = "black"
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 5, bomb = 0, bio = 0)

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick
	desc = "These work gloves are thick and fire-resistant."
	name = "work gloves"
	icon_state = "black"
	siemens_coefficient = 0.5
	permeability_coefficient = 0.05
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 5, bomb = 0, bio = 0)

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick/modified
	item_flags = ITEM_FLAG_PREMODIFIED

/obj/item/clothing/gloves/thick/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	force = 5
	armor = list(melee = 45, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10)
	siemens_coefficient = 0.3

/obj/item/clothing/gloves/thick/security
	name = "\improper Security Gloves"

/obj/item/clothing/gloves/thick/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "sec_gloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	force = 5
	armor = list(melee = 45, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick/botany
	desc = "These leather work gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "thick leather gloves"
	icon_state = "leather"

/obj/item/clothing/gloves/thick/botany/modified
	item_flags = ITEM_FLAG_PREMODIFIED

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "white"
	siemens_coefficient = 1.1 //thin latex gloves, much more conductive than fabric gloves (basically a capacitor for AC)
	permeability_coefficient = 0.01
	germ_level = 0
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 70)

	drop_sound = SFX_DROP_RUBBER
	pickup_sound = SFX_PICKUP_RUBBER

/obj/item/clothing/gloves/latex/modified
	item_flags = ITEM_FLAG_PREMODIFIED

/obj/item/clothing/gloves/latex/nitrile
	name = "nitrile gloves"
	desc = "Sterile nitrile gloves"
	icon_state = "nitrile"

/obj/item/clothing/gloves/latex/nitrile/modified
	item_flags = ITEM_FLAG_PREMODIFIED

/obj/item/clothing/gloves/duty
	desc = "These brown duty gloves are made from a durable synthetic."
	name = "work gloves"
	icon_state = "work"
	siemens_coefficient = 0.50
	armor = list(melee = 15, bullet = 10, laser = 10, energy = 5, bomb = 0, bio = 0)

/obj/item/clothing/gloves/duty/modified
	item_flags = ITEM_FLAG_PREMODIFIED

/obj/item/clothing/gloves/tactical
	desc = "These brown tactical gloves are made from a durable synthetic, and have hardened knuckles."
	name = "tactical gloves"
	icon_state = "work"
	force = 5
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0)

/obj/item/clothing/gloves/guards
	desc = "A pair of synthetic gloves and arm pads reinforced with armor plating."
	name = "arm guards"
	icon_state = "guards"
	body_parts_covered = HANDS|ARMS
	w_class = ITEM_SIZE_NORMAL
	siemens_coefficient = 0.7
	permeability_coefficient = 0.03
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 25, bomb = 30, bio = 0)
