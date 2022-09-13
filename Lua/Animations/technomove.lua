head = CreateSprite("head")
head.Move(0, 120)

torso = CreateSprite("torso")
torso.Move(0, 0)
torso.SetParent(head)
torso.SetAnchor(0.5, 1)

arm1 = CreateSprite("arm1")
arm1.Move(71, 147)
arm1.SetParent(head)
arm1.SetPivot(0.6, 0.6)

arm2 = CreateSprite("arm2")
arm2.Move(-49, 147)
arm2.SetParent(head)
arm2.SetPivot(0.6, 0.6)

legs = CreateSprite("legs")
legs.Move(0, 0)
legs.SetParent(torso)
legs.SetPivot(0.5, 0)


function AnimateTechno()
	head.MoveTo(math.sin(Time.time) * 2 + 320, head.y)
	torso.Scale(1, 1 + math.sin(Time.time) * 0.035)
	arm1.Scale(1, 1 + math.sin(Time.time) * 0.05)
	arm2.Scale(1, 1 + math.sin(Time.time) * 0.05)
	arm1.rotation = math.sin(Time.time) * 5
	arm2.rotation = math.sin(Time.time) * -5
end