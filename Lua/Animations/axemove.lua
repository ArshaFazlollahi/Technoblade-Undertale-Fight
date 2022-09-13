function axemove()

	axe = CreateSprite("Preaxe")
	trail = CreateSprite("axeF11", "BelowPlayer")
	eyefl = CreateSprite("axeF11")
	axe.Move(0, 120)
	trail.move(0, 125)
	eyefl.move(-0.5, 221)
	eyefl.Scale(0.4,0.4)
	Audio.PlaySound('psound')
	eyefl.loopmode = "ONESHOTEMPTY"
	eyefl.SetAnimation({"eyeF1", "blank", "eyeF3", "blank", "eyeF5", "eyeF6", "eyeF7"}, 1/6)
	axe.SetAnimation({"Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "Preaxe", "axeF1", "axeF2", "axeF3", "axeF4", "axeF5", "axeF6", "axeF7", "axeF8", "axeF9", "axeF10", "axeF5", "axeF1", "axeF1", "axeF2", "axeF3", "axeF4", "axeF5", "axeF6", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7", "axeF7"}, 1/12)
	trail.SetAnimation({"blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "axeF11", "axeF111", "blank", "blank", "blank", "blank", "axeF12", "axeF122", "blank", "blank", "blank", "blank", "axeF11", "axeF111", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank", "blank"}, 1/12)

end

function stopaxe()

	axe.Remove()
	trail.Remove()
	eyefl.Remove()

end