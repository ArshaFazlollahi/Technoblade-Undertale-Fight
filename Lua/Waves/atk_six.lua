spawntimer = 0
Encounter.SetVar("wavetimer", 12.0)
bullets = {}

function CreateBullet(x, y)
	bullet = CreateProjectile("arrow2", x, y)
	table.insert(bullets, bullet)
end

function Update()
	
	if spawntimer % 50 == 0 then

		value = math.random(-60,50)

		for i = 1, 2, 1
		do

			local xPos = -Arena.width

			if i == 1 then

				bowe = CreateSprite("bowF1")
				bowe.Scale(0.9,0.9)
				bowe.Move(-135, value - 78)
				bowe.loopmode = "ONESHOTEMPTY"
				bowe.SetAnimation({"bowF1", "bowF2", "bowF3"}, 1/24)
				CreateBullet(xPos, value)
				Audio.PlaySound('snd_arrow')

			elseif i == 2 then 

				value = value + 75
				if value <=35 then
				bowr = CreateSprite("bowF1")
				bowr.Scale(0.9,0.9)
				bowr.Move(-135, value - 78)
				bowr.loopmode = "ONESHOTEMPTY"
				bowr.SetAnimation({"bowF1", "bowF2", "bowF3"}, 1/24)
				CreateBullet(xPos, value)
				Audio.PlaySound('snd_arrow')
			end

			end

		end
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]

				currentBullet.Move(25, 0)
		
		if currentBullet.y < -200 then
			currentBullet.Remove()
			table.remove(bullets, i)
		end

	end
	
	spawntimer = spawntimer + 1
	
end