/**
* DNA 2: The Spaghetti Strikes Back
*
* @author N3X15 <nexisentertainment@gmail.com>
*/

// What each index means:
#define DNA_OFF_LOWERBOUND 0
#define DNA_OFF_UPPERBOUND 1
#define DNA_ON_LOWERBOUND  2
#define DNA_ON_UPPERBOUND  3

// Define block bounds (off-low,off-high,on-low,on-high)
// Used in setupgame.dm
#define DNA_DEFAULT_BOUNDS list(1,2049,2050,4095)
#define DNA_HARDER_BOUNDS  list(1,3049,3050,4095)
#define DNA_HARD_BOUNDS    list(1,3490,3500,4095)

// UI Indices (can change to mutblock style, if desired)
#define DNA_UI_HAIR_R      1
#define DNA_UI_HAIR_G      2
#define DNA_UI_HAIR_B      3
#define DNA_UI_BEARD_R     4
#define DNA_UI_BEARD_G     5
#define DNA_UI_BEARD_B     6
#define DNA_UI_SKIN_TONE   7
#define DNA_UI_SKIN_R      8
#define DNA_UI_SKIN_G      9
#define DNA_UI_SKIN_B      10
#define DNA_UI_EYES_R      11
#define DNA_UI_EYES_G      12
#define DNA_UI_EYES_B      13
#define DNA_UI_GENDER      14
#define DNA_UI_BEARD_STYLE 15
#define DNA_UI_HAIR_STYLE  16
#define DNA_UI_BODY_HEIGHT 17
#define DNA_UI_S_HAIR_R    18
#define DNA_UI_S_HAIR_G    19
#define DNA_UI_S_HAIR_B    20
#define DNA_UI_LENGTH      20 // Update this when you add something, or you WILL break shit.

/////////////////
// GENE DEFINES
/////////////////
// Skip checking if it's already active.
// Used for genes that check for value rather than a binary on/off.
#define GENE_ALWAYS_ACTIVATE 1
/datum/dna
	// READ-ONLY, GETS OVERWRITTEN
	// DO NOT FUCK WITH THESE OR BYOND WILL EAT YOUR FACE
	var/uni_identity="" // Encoded UI
	var/unique_enzymes="" // MD5 of player name

	// Internal dirtiness checks
	var/dirtyUI=0

	// Okay to read, but you're an idiot if you do.
	// BLOCK = VALUE
	var/list/UI[DNA_UI_LENGTH]

	// From old dna.
	var/b_type = "A+"  // Should probably change to an integer => string map but I'm lazy.
	var/body_build = "Default"
	var/real_name          // Stores the real name of the person who originally got this dna datum. Used primarily for changelings,
	var/mcolor = null
	// New stuff
	var/species = SPECIES_HUMAN
	var/s_base = ""
	var/list/body_markings = list()
	var/body_height = HUMAN_HEIGHT_NORMAL

// Make a copy of this strand.
// USE THIS WHEN COPYING STUFF OR YOU'LL GET CORRUPTION!
/datum/dna/proc/Clone()
	var/datum/dna/new_dna = new()
	new_dna.unique_enzymes=unique_enzymes
	new_dna.b_type=b_type
	new_dna.body_build = body_build
	new_dna.real_name=real_name
	new_dna.species=species
	new_dna.body_markings=body_markings.Copy()
	new_dna.s_base=s_base
	new_dna.body_height=body_height
	new_dna.UpdateUI()
	return new_dna
///////////////////////////////////////
// UNIQUE IDENTITY
///////////////////////////////////////

// Create random UI.
/datum/dna/proc/ResetUI(defer=0)
	for(var/i=1,i<=DNA_UI_LENGTH,i++)
		switch(i)
			if(DNA_UI_SKIN_TONE)
				SetUIValueRange(DNA_UI_SKIN_TONE,rand(1,220),220,1) // Otherwise, it gets fucked
			else
				UI[i]=rand(0,4095)
	if(!defer)
		UpdateUI()

/datum/dna/proc/ResetUIFrom(mob/living/carbon/human/character)
	// INITIALIZE!
	ResetUI(1)
	// Hair
	// FIXME:  Species-specific defaults pls
	if(!character.h_style)
		character.h_style = "Skinhead"
	var/hair = GLOB.hair_styles_list.Find(character.h_style)

	// Facial Hair
	if(!character.f_style)
		character.f_style = "Shaved"
	var/beard	= GLOB.facial_hair_styles_list.Find(character.f_style)

	body_build = character.body_build.name
	if(character.species.fixed_mut_color)
		mcolor = character.species.fixed_mut_color
	else
		mcolor = "#[rand_hex_color()]"

	SetUIValueRange(DNA_UI_HAIR_R,    character.r_hair,    255,    1)
	SetUIValueRange(DNA_UI_HAIR_G,    character.g_hair,    255,    1)
	SetUIValueRange(DNA_UI_HAIR_B,    character.b_hair,    255,    1)

	SetUIValueRange(DNA_UI_S_HAIR_R,    character.r_s_hair,    255,    1)
	SetUIValueRange(DNA_UI_S_HAIR_G,    character.g_s_hair,    255,    1)
	SetUIValueRange(DNA_UI_S_HAIR_B,    character.b_s_hair,    255,    1)

	SetUIValueRange(DNA_UI_BEARD_R,   character.r_facial,  255,    1)
	SetUIValueRange(DNA_UI_BEARD_G,   character.g_facial,  255,    1)
	SetUIValueRange(DNA_UI_BEARD_B,   character.b_facial,  255,    1)

	SetUIValueRange(DNA_UI_EYES_R,    character.r_eyes,    255,    1)
	SetUIValueRange(DNA_UI_EYES_G,    character.g_eyes,    255,    1)
	SetUIValueRange(DNA_UI_EYES_B,    character.b_eyes,    255,    1)

	SetUIValueRange(DNA_UI_SKIN_R,    character.r_skin,    255,    1)
	SetUIValueRange(DNA_UI_SKIN_G,    character.g_skin,    255,    1)
	SetUIValueRange(DNA_UI_SKIN_B,    character.b_skin,    255,    1)

	SetUIValueRange(DNA_UI_SKIN_TONE, 35-character.s_tone, 220,    1) // Value can be negative.

	SetUIState(DNA_UI_GENDER,         character.gender!=MALE,        1)

	SetUIValueRange(DNA_UI_HAIR_STYLE,  hair,  GLOB.hair_styles_list.len,       1)
	SetUIValueRange(DNA_UI_BEARD_STYLE, beard, GLOB.facial_hair_styles_list.len,1)

	body_markings.Cut()
	s_base = character.s_base
	body_height = character.body_height
	for(var/obj/item/organ/external/E in character.organs)
		E.s_base = s_base
		if(E.markings.len)
			body_markings[E.organ_tag] = E.markings.Copy()

	UpdateUI()

// Set a DNA UI block's raw value.
/datum/dna/proc/SetUIValue(block,value,defer=0)
	if (block<=0) return
	ASSERT(value>0)
	ASSERT(value<=4095)
	UI[block]=value
	dirtyUI=1
	if(!defer)
		UpdateUI()

// Get a DNA UI block's raw value.
/datum/dna/proc/GetUIValue(block)
	if (block<=0) return 0
	return UI[block]

// Set a DNA UI block's value, given a value and a max possible value.
// Used in hair and facial styles (value being the index and maxvalue being the len of the hairstyle list)
/datum/dna/proc/SetUIValueRange(block,value,maxvalue,defer=0)
	if (block<=0) return
	if (value==0) value = 1   // FIXME: hair/beard/eye RGB values if they are 0 are not set, this is a work around we'll encode it in the DNA to be 1 instead.
	ASSERT(maxvalue<=4095)
	var/range = (4095 / maxvalue)
	if(value)
		SetUIValue(block,round(value * range),defer)

// Getter version of above.
/datum/dna/proc/GetUIValueRange(block,maxvalue)
	if (block<=0) return 0
	var/value = GetUIValue(block)
	return round(1 +(value / 4096)*maxvalue)

// Is the UI gene "on" or "off"?
// For UI, this is simply a check of if the value is > 2050.
/datum/dna/proc/GetUIState(block)
	if (block<=0) return
	return UI[block] > 2050


// Set UI gene "on" (1) or "off" (0)
/datum/dna/proc/SetUIState(block,on,defer=0)
	if (block<=0) return
	var/val
	if(on)
		val=rand(2050,4095)
	else
		val=rand(1,2049)
	SetUIValue(block,val,defer)

// Get a hex-encoded UI block.
/datum/dna/proc/GetUIBlock(block)
	return EncodeDNABlock(GetUIValue(block))

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA modifiers.
/datum/dna/proc/SetUIBlock(block,value,defer=0)
	if (block<=0) return
	return SetUIValue(block,hex2num(value),defer)

// Get a sub-block from a block.
/datum/dna/proc/GetUISubBlock(block,subBlock)
	return copytext(GetUIBlock(block),subBlock,subBlock+1)

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA modifiers.
/datum/dna/proc/SetUISubBlock(block,subBlock, newSubBlock, defer=0)
	if (block<=0) return
	var/oldBlock=GetUIBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	SetUIBlock(block,newBlock,defer)

/proc/EncodeDNABlock(value)
	return add_zero2(num2hex(value,1), 3)

/datum/dna/proc/UpdateUI()
	src.uni_identity=""
	for(var/block in UI)
		uni_identity += EncodeDNABlock(block)
	//testing("New UI: [uni_identity]")
	dirtyUI=0

// BACK-COMPAT!
//  Just checks our character has all the crap it needs.
/datum/dna/proc/check_integrity(mob/living/carbon/human/character)
	if(character)
		if(UI.len != DNA_UI_LENGTH)
			ResetUIFrom(character)

		if(length(unique_enzymes) != 32)
			unique_enzymes = md5(character.real_name)
	else
		if(length(uni_identity) != 3*DNA_UI_LENGTH)
			uni_identity = "00600200A00E0110148FC01300B0095BD7FD3F4"

// BACK-COMPAT!
//  Initial DNA setup.  I'm kind of wondering why the hell this doesn't just call the above.
/datum/dna/proc/ready_dna(mob/living/carbon/human/character)
	ResetUIFrom(character)

	unique_enzymes = md5(character.real_name)
	GLOB.reg_dna[unique_enzymes] = character.real_name
