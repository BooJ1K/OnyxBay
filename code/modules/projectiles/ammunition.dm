/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "s-casing"
	randpixel = 10
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEM_SIZE_TINY

	var/leaves_residue = 1
	var/caliber = ""					//Which kind of guns it can be loaded into
	var/projectile_type					//The bullet type to create when New() is called
	var/spent_icon = "s-casing-spent"
	var/is_spent = FALSE
	var/projectile_label
	var/fall_sounds = SFX_CASING_DROP

/obj/item/ammo_casing/Initialize()
	if(!ispath(projectile_type))
		is_spent = TRUE

	if(randpixel)
		pixel_x = rand(-randpixel, randpixel)
		pixel_y = rand(-randpixel, randpixel)
	. = ..()

//removes the projectile from the ammo casing
/obj/item/ammo_casing/proc/expend()
	if(!ispath(projectile_type))
		return
	if(is_spent)
		return

	var/obj/item/projectile/proj = new projectile_type(src)
	is_spent = TRUE
	if(projectile_label)
		proj.SetName("[initial(proj.name)] (\"[projectile_label]\")")

	// Aurora forensics port, gunpowder residue.
	if(leaves_residue)
		leave_residue()

	update_icon()

	return proj

/obj/item/ammo_casing/proc/leave_residue()
	var/mob/living/carbon/human/H
	if(ishuman(loc))
		H = loc //in a human, somehow
	else if(loc && ishuman(loc.loc))
		H = loc.loc //more likely, we're in a gun being held by a human

	if(H)
		if(H.gloves && (H.l_hand == loc || H.r_hand == loc))
			var/obj/item/clothing/G = H.gloves
			G.gunshot_residue = caliber
		else
			H.gunshot_residue = caliber

	pixel_x = rand(-randpixel, randpixel)
	pixel_y = rand(-randpixel, randpixel)

/obj/item/ammo_casing/attackby(obj/item/W, mob/user)
	if(!isScrewdriver(W))
		return ..()

	if(is_spent)
		to_chat(user, SPAN_NOTICE("There is no bullet in the casing to inscribe anything into."))
		return

	var/tmp_label = ""
	var/label_text = sanitizeSafe(input(user, "Inscribe some text into \the [initial(projectile_type["name"])]","Inscription",tmp_label), MAX_NAME_LEN)
	if(length(label_text) > 20)
		to_chat(user, SPAN_WARNING("The inscription can be at most 20 characters long."))
	else if(!label_text)
		to_chat(user, SPAN_NOTICE("You scratch the inscription off of [initial(projectile_type["name"])]."))
		projectile_label = null
	else
		to_chat(user, SPAN_NOTICE("You inscribe \"[label_text]\" into \the [initial(projectile_type["name"])]."))
		projectile_label = label_text

/obj/item/ammo_casing/on_update_icon()
	if(spent_icon && is_spent)
		icon_state = spent_icon

/obj/item/ammo_casing/_examine_text(mob/user)
	. = ..()
	if(caliber)
		. += "\nIts caliber is [caliber]."
	if(is_spent)
		. += "\nThis one is spent."

//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define SINGLE_LOAD		3	//Loads one at a time.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun

//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = "357"
	icon = 'icons/obj/ammo.dmi'
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	matter = list(MATERIAL_STEEL = 500)
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	throw_range = 10

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/caliber = "357"
	var/max_ammo = 7
	var/display_default_ammo_left = TRUE

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo = null

	var/multiple_sprites = 0
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

/obj/item/ammo_magazine/box
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_magazine/Initialize()
	. = ..()
	if(multiple_sprites)
		initialize_magazine_icondata(src)

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo += new ammo_type(src)
	update_icon()

/obj/item/ammo_magazine/Destroy()
	QDEL_NULL_LIST(stored_ammo)
	return ..()

/obj/item/ammo_magazine/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ammo_casing) && max_ammo)
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			to_chat(user, "<span class='warning'>[C] does not fit into [src].</span>")
			return
		if(stored_ammo.len >= max_ammo)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		if(!user.drop(C, src))
			return
		stored_ammo.Add(C)

		playsound(user, "bullet_insert", rand(45, 60), FALSE)

		update_icon()
	else ..()

/obj/item/ammo_magazine/attack_self(mob/user)
	if(!stored_ammo.len)
		to_chat(user, "<span class='notice'>[src] is already empty!</span>")
		return
	to_chat(user, "<span class='notice'>You empty [src].</span>")
	for(var/obj/item/ammo_casing/C in stored_ammo)
		C.forceMove(user.loc)
		C.set_dir(pick(GLOB.alldirs))
	stored_ammo.Cut()
	update_icon()


/obj/item/ammo_magazine/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(!stored_ammo.len)
			to_chat(user, "<span class='notice'>[src] is already empty!</span>")
		else
			var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
			stored_ammo -= C
			user.pick_or_drop(C, loc)
			user.visible_message("\The [user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
			playsound(user, "bullet_insert", rand(45, 60), FALSE)
			update_icon()
	else
		..()
		return

/obj/item/ammo_magazine/on_update_icon()
	if(multiple_sprites)
		//find the lowest key greater than or equal to stored_ammo.len
		var/new_state = null
		for(var/idx in 1 to icon_keys.len)
			var/ammo_count = icon_keys[idx]
			if (ammo_count >= stored_ammo.len)
				new_state = ammo_states[idx]
				break
		icon_state = (new_state)? new_state : initial(icon_state)

/obj/item/ammo_magazine/_examine_text(mob/user)
	. = ..()
	if(display_default_ammo_left)
		. += "\nThere [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left!"

//magazine icon state caching
/var/global/list/magazine_icondata_keys = list()
/var/global/list/magazine_icondata_states = list()

/proc/initialize_magazine_icondata(obj/item/ammo_magazine/M)
	var/typestr = "[M.type]"
	if(!(typestr in magazine_icondata_keys) || !(typestr in magazine_icondata_states))
		magazine_icondata_cache_add(M)

	M.icon_keys = magazine_icondata_keys[typestr]
	M.ammo_states = magazine_icondata_states[typestr]

/proc/magazine_icondata_cache_add(obj/item/ammo_magazine/M)
	var/list/icon_keys = list()
	var/list/ammo_states = list()
	var/list/states = icon_states(M.icon)
	for(var/i = 0, i <= M.max_ammo, i++)
		var/ammo_state = "[M.icon_state]-[i]"
		if(ammo_state in states)
			icon_keys += i
			ammo_states += ammo_state

	magazine_icondata_keys["[M.type]"] = icon_keys
	magazine_icondata_states["[M.type]"] = ammo_states
