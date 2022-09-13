frametimer = 0
Encounter.SetVar("wavetimer", 7.0)
bullets = {}

bulletamount = 40
spawntime = 200

Player.hp = 1

i = 0

playpierce = true

Player.SetControlOverride(true)

function CreateBullet(x, y)
	bullet = CreateProjectile("sword", x, y)
	bullet.sprite.rotation = 0
	bullet["velx"] = -bullet.x / 200
	bullet["vely"] = -bullet.y / 200
	table.insert(bullets, bullet)
end

function Update()
	
	bulletAmountMultiplier = spawntime / bulletamount / 2
	
	if frametimer % 5 == 0 and frametimer < spawntime then
		local xPos = math.sin(frametimer / (bulletamount * bulletAmountMultiplier) * math.pi) * (Arena.width / 2 + 40)
		local yPos = math.cos(frametimer / (bulletamount * bulletAmountMultiplier) * math.pi) * (Arena.height / 2 + 40)
		CreateBullet(xPos, yPos)
		Audio.PlaySound('spawn')
		if frametimer > 0 then

			i = i - 9
			bullet.sprite.rotation = i

		end

	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		
		if frametimer > spawntime then
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
			if playpierce == true then
				Audio.PlaySound('pierce')
				playpierce = false
			end
		end
	end
	
	frametimer = frametimer + 1
end