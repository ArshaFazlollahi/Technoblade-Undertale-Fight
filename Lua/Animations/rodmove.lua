function fisrod()

	rod = CreateSprite("hookF2", "BelowBullet")
	rod.Scale(0.75,0.75)
	rod.Move(3, 125)
	rod.loopmode = "ONESHOTEMPTY"
	rod.SetAnimation({"blank", "blank", "blank", "blank", "blank", "blank", "blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank","blank", "hookF2", "hookF3", "hookF4", "hookF5", "hookF6", "hookF7", "hookF8", "hookF9", "hookF10", "hookF11", "hookF12", "hookF13", "hookF14", "hookF15", "hookF16", "hookF17"}, 1/24)

end

function stoprod()

	rod.Remove()

end