//these are probably broken

/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = 1
	var/on = 0
	var/obj/item/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = 0
	var/open = 0
	var/l_max_bright = 0.8 // brightness of light when on, must not be greater than 1
	var/l_inner_range = 1 // inner range of light when on, can be negative
	var/l_outer_range = 6 // outer range of light when on, can be negative

/obj/machinery/floodlight/Initialize()
	. = ..()
	cell = new /obj/item/cell/crap(src)

/obj/machinery/floodlight/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/machinery/floodlight/on_update_icon()
	ClearOverlays()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/Process()
	if(!on)
		return

	if(!cell || (cell.charge < (use * CELLRATE)))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((CELL_PERCENT(cell) < 10) && prob(5))
		set_light(l_max_bright / 2, l_inner_range, l_outer_range)
		spawn(20)
			if(on)
				set_light(l_max_bright, l_inner_range, l_outer_range)

	cell.use(use*CELLRATE)


// Returns 0 on failure and 1 on success
/obj/machinery/floodlight/proc/turn_on(loud = 0)
	if(!cell)
		return 0
	if(cell.charge < (use * CELLRATE))
		return 0

	on = 1
	set_light(l_max_bright, l_inner_range, l_outer_range)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
	return 1

/obj/machinery/floodlight/proc/turn_off(loud = 0)
	on = 0
	set_light(0)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")

/obj/machinery/floodlight/attack_ai(mob/user as mob)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")


/obj/machinery/floodlight/attack_hand(mob/user as mob)
	if(open && cell)
		if(ishuman(user))
			user.pick_or_drop(cell, loc)
		else
			cell.dropInto(loc)

		cell.add_fingerprint(user)
		cell.update_icon()

		src.cell = null
		on = 0
		set_light(0)
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		turn_off(1)
	else
		if(!turn_on(1))
			to_chat(user, "You try to turn on \the [src] but it does not work.")

	update_icon()


/obj/machinery/floodlight/attackby(obj/item/W as obj, mob/user as mob)
	if(isScrewdriver(W))
		if (!open)
			if(unlocked)
				unlocked = 0
				to_chat(user, "You screw the battery panel in place.")
			else
				unlocked = 1
				to_chat(user, "You unscrew the battery panel.")

	if(isCrowbar(W))
		if(unlocked)
			if(open)
				open = 0
				to_chat(user, "You crowbar the battery panel in place.")
			else
				if(unlocked)
					open = 1
					to_chat(user, "You remove the battery panel.")

	if (istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is a power cell already installed.")
			else if(user.drop(W, src))
				cell = W
				to_chat(user, "You insert the power cell.")
	update_icon()

/obj/item/floodlight_diy
	name = "Emergency Floodlight Kit"
	desc = "A do-it-yourself kit for constructing the finest of emergency floodlights."
	icon = 'icons/obj/storage/misc.dmi'
	icon_state = "flood_box"
	item_state = "lockbox"

/obj/item/floodlight_diy/attack_self(mob/user)
	to_chat(usr, "<span class='notice'>You start piecing together the kit...</span>")
	if(do_after(user, 80))
		var/obj/machinery/floodlight/R = new /obj/machinery/floodlight(user.loc)
		user.visible_message("<span class='notice'>[user] assembles \a [R].\
			</span>", "<span class='notice'>You assemble \a [R].</span>")
		R.add_fingerprint(user)
		qdel(src)
