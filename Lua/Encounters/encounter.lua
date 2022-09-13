-- A basic encounter script skeleton you can copy and modify for your own creations.

-- music = "shine_on_you_crazy_diamond" --Either OGG or WAV. Extension is added automatically. Uncomment for custom music.
encountertext = "Technoblade blocks the way." --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"bullettest_chaserorb"}
commands = {"Talk"}
comments = {"Technoblade blocks the way."}
wavetimer = 1.0
arenasize = {155, 130}
counter = 0
flee = false

deathtext = {"[voice:txtwilb][waitall:2][effect:none]There was a saying Tommy...\nBy a traitor.", "[voice:txtwilb][waitall:2][effect:none]...", "[voice:txtwilb][waitall:2][effect:none]It was never meant to be."}

pms = false
lms = false
jms = false
kew = false
mit = false
quiet = false

autolinebreak = true

enemies = {
"Technoblade"
}

enemypositions = {
{0, 0}
}

SetGlobal("dibr", false)
SetGlobal("intro", true)
SetGlobal("fms", true)
SetGlobal("fod", true)
SetGlobal("sod", true)
SetGlobal("tod", true)
SetGlobal("fuod", true)
SetGlobal("suod", true)
SetGlobal("uuod", true)
SetGlobal("wuod", true)
SetGlobal("yuod", true)
SetGlobal("auod", true)
SetGlobal("buod", true)
SetGlobal("cuod", true)
SetGlobal("duod", true)
SetGlobal("euod", true)

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"atk_one", "atk_two", "atk_four", "atk_five", "atk_three", "atk_six", "atk_seven", "atk_eight", "atk_nine"}

function EncounterStarting()
    -- If you want to change the game state immediately, this is the place.
    State("ENEMYDIALOGUE")
    Inventory.AddCustomItems({"Shield", "Axe of Peace", "Golden Apple", "Cobblestone", "Disc"}, {2, 1, 0, 3, 0})
    Inventory.SetInventory({"Shield", "Axe of Peace", "Golden Apple", "Golden Apple", "Cobblestone", "Cobblestone", "Cobblestone", "Disc"})
    Player.name = "Tommy"
    Player.lv = 1
    Player.hp = 20
    Audio.Stop()
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
    local intro = GetGlobal("intro")
    local fod = GetGlobal("fod")
    local sod = GetGlobal("sod")
    local tod = GetGlobal("tod")
    local fuod = GetGlobal("fuod")
    local suod = GetGlobal("suod")
    local uuod = GetGlobal("uuod")
    local wuod = GetGlobal("wuod")
    local yuod = GetGlobal("yuod")
    local auod = GetGlobal("auod")
    local buod = GetGlobal("buod")
    local cuod = GetGlobal("cuod")
    local duod = GetGlobal("duod")
    local euod = GetGlobal("euod")
    local mit = GetGlobal("mit")
    local kew = GetGlobal("kew")
    local vij = GetGlobal("vij")

    if vij == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]See? The disc is gone, and nothing happened.", "[voice:txttechn][effect:none]That's the thing with material possessions.", "[voice:txttechn][effect:none]What truly matters is people.\nAlways remember that Tommy.", "[func:Spare]"})
    	SetGlobal("vij", false)
    elseif quiet == true then
    	enemies[1].SetVar('currentdialogue', {"[next]"})
    	quiet = false
    elseif kew == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]You're using words...", "[voice:txttechn][effect:none]But the thing about this world Tommy...", "[voice:txttechn][effect:none]Is that the only universal language...", "[voice:txttechn][effect:none]Is violence."})
    	SetGlobal("kew", false)
    elseif mit == true then
    	enemies[1].SetVar('currentdialogue', {"", "[voice:txttechn][effect:none]Did you really think Tommy...", "[voice:txttechn][effect:none]That you could kill me that easily?"})
    elseif counter == 5 then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]I have a pickaxe...", "[voice:txttechn][effect:none]AND I'LL PUT IT THROUGH YOUR TEETH!"})
    elseif intro == true then
    	enemies[1].SetVar('currentdialogue', {"[func:startsp][voice:txttechn][effect:none][waitall:2]Do you want to be a hero Tommy?", "[func:startsou][func:startmove]", "[func:midmove][voice:txttechn][effect:none]THEN DIE LIKE ONE!", "[func:endmove][next]"})
    	SetGlobal("intro", false)
    elseif fod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]There's no other way.\nI CHOOSE BLOOD!"})
    	SetGlobal("fod", false)
    elseif sod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]WELCOME HOME THESEUS!"})
    	SetGlobal("sod", false)
    elseif tod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]Revolution waits for no man."})
    	SetGlobal("tod", false)
    elseif fuod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]When I said you don't have to help me Tommy...", "[voice:txttechn][effect:none]I meant that you could sit it out.", "[voice:txttechn][effect:none]NOT SWITCH SIDES AND FIGHT AGAINST ME!"})
    	SetGlobal("fuod", false)
    elseif duod == true then
    	enemies[1].SetVar('currentdialogue', {"[next]"})
    	SetGlobal("duod", false)
    elseif uuod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]You never thought of me as a friend Tommy..."})
    	SetGlobal("uuod", false)
    elseif wuod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]You went back to Tubbo, the guy that exiled you...", "[voice:txttechn][effect:none]That chose his country over you."})
    	SetGlobal("wuod", false)
    elseif yuod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]I'M A PERSON!", "[voice:txttechn][effect:none]DISCS AREN'T PEOPLE!"})
    	SetGlobal("yuod", false)
    elseif auod == true then
    	enemies[1].SetVar('currentdialogue', {"[next]"})
    	SetGlobal("auod", false)
    elseif buod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]I DID NOT SPEND WEEKS...", "[voice:txttechn][effect:none]PLANNING THIS REVOLUTION...", "[voice:txttechn][effect:none]FOR YOU TO GO IN, AND REPLACE ONE TYRANT WITH ANOTHER."})
    	SetGlobal("buod", false)
    elseif cuod == true then
    	enemies[1].SetVar('currentdialogue', {"[voice:txttechn][effect:none]DON'T YOU SEE WHAT'S HAPPENING HERE?", "[voice:txttechn][effect:none]DON'T YOU SEE HISTORY REPEATING ITSELF?"})
    	SetGlobal("cuod", false)
    end
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
enemies[1].Call("SetSprite","poseur")

local mit = GetGlobal("mit")

function Update()
	require "Animations/technomove"
	AnimateTechno()
end
    if counter == 0 then
    	nextwaves = { possible_attacks[8] }
    	counter = counter + 1
    elseif mit == true then
		nextwaves = { possible_attacks[9] }
    	counter = counter + 1
    elseif counter == 1 or counter == 10 or counter == 15 or counter == 22 or counter == 29 then
		nextwaves = { possible_attacks[1] }
    	counter = counter + 1
	elseif counter == 2 or counter == 9 or counter == 16 or counter == 23 or counter == 30 then
		nextwaves = { possible_attacks[2] }
    	counter = counter + 1
    	lms = true
    	require "Animations/crsbwmove"
    	crsbw()
    elseif counter == 3 or counter == 8 or counter == 17 or counter == 24 or counter >= 31 then
		nextwaves = { possible_attacks[3] }
    	counter = counter + 1
    elseif counter == 4 or counter == 11 or counter == 18 or counter == 25 then
		nextwaves = { possible_attacks[4] }
    	counter = counter + 1
    elseif counter == 5 or counter == 12 or counter == 19 or counter == 26 then
		nextwaves = { possible_attacks[5] }
    	counter = counter + 1
    	pms = true
    	require "Animations/axemove"
    	axemove()
    elseif counter == 6 or counter == 13 or counter == 20 or counter == 27 then
		nextwaves = { possible_attacks[6] }
    	counter = counter + 1
    elseif counter == 7 or counter == 14 or counter == 21 or counter == 28 then
		nextwaves = { possible_attacks[7] }
    	counter = counter + 1
    	jms = true
    	require "Animations/rodmove"
    	fisrod()
    end
end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.nextwaves = { possible_attacks[math.random(#possible_attacks)] }
    
	if lms == true then

    	require "Animations/crsbwmove"
    	stopcrsbw()
    	lms = false

	end

    if pms == true then

    	require "Animations/axemove"
    	stopaxe()
    	pms = false

	end

	if jms == true then

    	require "Animations/rodmove"
    	stoprod()
    	jms = false

	end
    
    local fms = GetGlobal("fms")
    if fms == true then
    Audio.LoadFile("Battleship")
    SetGlobal("fms", false)
	end
end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    if ItemID == "SHIELD" then
    	Inventory.SetAmount(8)
    	BattleDialog({"You equipped your shield.\n Your DEF has increased."})
    else if ItemID == "AXE OF PEACE" then
    	Inventory.SetAmount(15)
    	BattleDialog({"You equipped the Axe of Peace.\n Your ATK has increased."})
    else if ItemID == "GOLDEN APPLE" then
    	BattleDialog({"You ate a Golden Apple.\n Your HP maxed out."})
    	Player.hp = 20
    else if ItemID == "DISC" then
    	BattleDialog({"You broke one of your music discs.\n Technoblade looks surprised.", "You can now TALK with Technoblade."})
    	SetGlobal("dibr", true)
    	quiet = true
    end
    end
    end
end
end