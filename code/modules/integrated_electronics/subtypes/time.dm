/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Now you can build your own clock!"
	complexity = 1
	inputs = list()
	outputs = list()
	category_text = "Time"

/obj/item/integrated_circuit/time/delay
	name = "two-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of two seconds."
	icon_state = "delay-20"
	var/delay = 2 SECONDS
	activators = list("incoming"= IC_PINTYPE_PULSE_IN,"outgoing" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 2

/obj/item/integrated_circuit/time/delay/do_work()
	addtimer(CALLBACK(src, nameof(.proc/activate_pin), 2), delay)

/obj/item/integrated_circuit/time/delay/five_sec
	name = "five-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of five seconds."
	icon_state = "delay-50"
	delay = 5 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/one_sec
	name = "one-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of one second."
	icon_state = "delay-10"
	delay = 1 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/half_sec
	name = "half-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of half a second."
	icon_state = "delay-5"
	delay = 0.5 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/tenth_sec
	name = "tenth-sec delay circuit"
	desc = "This sends a pulse signal out after a delay, critical for ensuring proper control flow in a complex machine.  \
	This circuit is set to send a pulse after a delay of 1/10th of a second."
	icon_state = "delay-1"
	delay = 0.1 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/custom
	name = "custom delay circuit"
	desc = "This sends a pulse signal out after a delay defined in tenths of a second, critical for ensuring proper control \
	flow in a complex machine. This circuit's delay can be customized, between 1/10th of a second to one hour. \
	The delay is updated upon receiving a pulse."
	extended_desc = "The delay is defined in tenths of a second. For instance, 4 will be a delay of 0.4 seconds, or 15 for 1.5 seconds."
	icon_state = "delay"
	inputs = list("delay time" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/time/delay/custom/on_data_written()
	..()
	var/delay_input = get_pin_data(IC_INPUT, 1)
	if(!isnum_safe(delay_input))
		return
	if(delay_input < 1 || delay_input > 1 HOURS) // Value had to be clamped, update the pin. Check's here to avoid infinitely setting the pin.
		set_pin_data(IC_INPUT, 1, Clamp(delay_input, 1, 1 HOURS))
		return
	delay = delay_input

/obj/item/integrated_circuit/time/ticker
	name = "ticker circuit"
	desc = "This circuit sends an automatic pulse every four seconds."
	icon_state = "tick-m"
	complexity = 4
	var/delay = 4 SECONDS
	var/is_running = FALSE
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN)
	activators = list("outgoing pulse" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/time/ticker/Destroy()
	return ..()

/obj/item/integrated_circuit/time/ticker/on_data_written()
	var/do_tick = get_pin_data(IC_INPUT, 1)
	if(do_tick && !is_running)
		is_running = TRUE
		set_next_think(world.time)
	else if(!do_tick && is_running)
		is_running = FALSE
		set_next_think(0)

/obj/item/integrated_circuit/time/ticker/think()
	activate_pin(1)

	set_next_think(world.time + delay)

/obj/item/integrated_circuit/time/ticker/custom
	name = "custom ticker"
	desc = "This advanced circuit sends an automatic pulse every given interval, defined in tenths of a second."
	extended_desc ="This advanced circuit sends an automatic pulse every given interval, defined in tenths of a second. \
	For example, setting the time pin to 4 will send a pulse every 0.4 seconds, or 15 for every 1.5 seconds."
	icon_state = "tick-f"
	complexity = 8
	delay = 2 SECONDS
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN,"delay time" = IC_PINTYPE_NUMBER)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 8

/obj/item/integrated_circuit/time/ticker/custom/on_data_written()
	..()
	var/delay_input = get_pin_data(IC_INPUT, 2)
	if(!isnum_safe(delay_input))
		return
	if(delay_input < 1 || delay_input > 1 HOURS)
		set_pin_data(IC_INPUT, 2, Clamp(delay_input ,1 ,1 HOURS))
		return
	delay = delay_input

/obj/item/integrated_circuit/time/ticker/fast
	name = "fast ticker"
	desc = "This advanced circuit sends an automatic pulse every two seconds."
	icon_state = "tick-f"
	complexity = 6
	delay = 2 SECONDS
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 8

/obj/item/integrated_circuit/time/ticker/slow
	name = "slow ticker"
	desc = "This simple circuit sends an automatic pulse every six seconds."
	icon_state = "tick-s"
	complexity = 2
	delay = 6 SECONDS
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 2

/obj/item/integrated_circuit/time/clock
	name = "integrated clock (NT Common Time)"
	desc = "Tells you what the time is, in Nanotrasen Common Time."				//round time
	icon_state = "clock"
	inputs = list()
	outputs = list(
		"time" = IC_PINTYPE_STRING,
		"hours" = IC_PINTYPE_NUMBER,
		"minutes" = IC_PINTYPE_NUMBER,
		"seconds" = IC_PINTYPE_NUMBER,
		"absolute decisecond elapsed time" = IC_PINTYPE_NUMBER
		)
	activators = list("get time" = IC_PINTYPE_PULSE_IN, "on time got" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 2

/obj/item/integrated_circuit/time/clock/proc/get_time()
	return world.time

/obj/item/integrated_circuit/time/clock/do_work()
	var/current_time = get_time()
	set_pin_data(IC_OUTPUT, 1, time2text(current_time, "hh:mm:ss") )
	set_pin_data(IC_OUTPUT, 2, text2num(time2text(current_time, "hh") ) )
	set_pin_data(IC_OUTPUT, 3, text2num(time2text(current_time, "mm") ) )
	set_pin_data(IC_OUTPUT, 4, text2num(time2text(current_time, "ss") ) )
	set_pin_data(IC_OUTPUT, 5, current_time)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/time/clock/station
	name = "integrated clock (Station Time)"
	desc = "Tells you what the time is, in terms and adjusted for your local station or planet"

/obj/item/integrated_circuit/time/clock/station/get_time()
	return station_time_in_ticks

/obj/item/integrated_circuit/time/clock/bluespace
	name = "integrated clock (Bluespace Absolute Time)"
	desc = "Tells you what the time is, in Bluespace Absolute Time, unaffected by local time dilation or other phenomenon."

/obj/item/integrated_circuit/time/clock/bluespace/get_time()
	return REALTIMEOFDAY
