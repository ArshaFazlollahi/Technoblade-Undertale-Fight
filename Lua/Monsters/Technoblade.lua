-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {"Technoblade blocks the way."}
commands = {"Talk"}
randomdialogue = {"[next]"}

sprite = "poseur" --Always PNG. Extension is added automatically.
name = "Technoblade"
hp = 620
atk = 7
def = 14
check = "3/3 Cannon Lives\nThey call him the Blood God."
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = true
SetBubbleOffset(-70, 70)
SetDamageUIOffset(0, 0)
SetSliceAnimOffset(0, 50)
p = 0
dibr = false
SetGlobal("mit", false)
SetGlobal("kew", false)
SetGlobal("vij", false)
-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        p = p + 1
    end
end
 
-- This handles the commands; all-caps versions of the commands list you have above.

function HandleCustomCommand(command)

local dibr = GetGlobal("dibr")

    if command == "TALK" then
    	if dibr == false then
        	SetGlobal("kew", true)
        	BattleDialog({"You tried to reason with Technoblade.", "...", "He refuses to listen."})
        elseif dibr == true then
        	SetGlobal("vij", true)
        	Audio.Stop()
        	BattleDialog({"You told Technoblade that you support his philosophy.", "...", "He looks relieved."})
        end
    end
end

function startsp()

	startC = CreateSprite("StartC")
	startC.Move(0, 120)

end

function startmove()
	startC.Remove()
	start = CreateSprite("StartF1")
	start.Move(0, 120)
	start.loopmode = "ONESHOT"
	start.SetAnimation({"StartF1", "StartF2", "StartF3", "StartF4", "StartF5", "StartF6", "StartF7", "StartF8", "StartF9", "StartF10", "StartF100", "StartF11", "StartF12", "StartF12"}, 1/12)
	
end

function midmove()

	start.SetAnimation({"StartF12"}, 1/12)

end

function endmove()

	start.Remove()

end

function startsou()

	Audio.PlaySound('mus_sfx_cinematiccut')

end

function OnDeath()

	SetGlobal("mit", true)
	Audio.Stop()
	SetDamageUIOffset(0, 700)
	totem = CreateSprite("TotemF1", "BelowBullet")
	totem.Scale(3.0, 3.0)
	totem.Move(14, 144)
	totem.loopmode = "ONESHOTEMPTY"
	Audio.PlaySound('totembrk')
	totem.SetAnimation({"TotemF1", "TotemF1", "TotemF2", "TotemF3", "TotemF4", "TotemF5", "TotemF6", "TotemF7", "TotemF7", "TotemF8", "TotemF7", "TotemF7", "TotemF7", "TotemF8", "TotemF9", "TotemF10", "TotemF11", "TotemF12"}, 1/9)

end

function BeforeDamageCalculation()

end