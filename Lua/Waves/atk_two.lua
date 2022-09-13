spawntimer = 0
Encounter.SetVar("wavetimer", 2.5)
bullets = {}

function CreateBullet(x, y)
	bullet = CreateProjectile("arrow", x, y)
	bullet.sprite.rotation = -40
	table.insert(bullets, bullet)
end

function Update()
	
	if spawntimer % 50 == 0 then

		for i = 1, 3, 1
		do

			local xPos = -Arena.width / 2 + i * Arena.width / 4
			local yPos = Arena.height / 2 + 10
			CreateBullet(xPos, yPos)
			Audio.PlaySound('mus_sfx_swipe')

			if i == 1 then

				bullet.sprite.rotation = -40
			elseif i == 2 then

				bullet.sprite.rotation = 0
			elseif i == 3 then 

				bullet.sprite.rotation = 40
			end

		end
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		
		if i == 1 then

				currentBullet.Move(-17, -17)
			elseif i == 2 then

				currentBullet.Move(0, -17)
			elseif i == 3 then 

				currentBullet.Move(17, -17)
			end
		
		if currentBullet.y < -200 then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
	
end