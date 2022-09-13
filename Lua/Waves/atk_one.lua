spawntimer = 0
Encounter.SetVar("wavetimer", 7.0)
Arena.Resize(200, 130)
bullets = {}

function CreateBullet(x, y)
	local bullet = CreateProjectile("trident", x, y)
	table.insert(bullets, bullet)
end

function Update()
	
	if spawntimer % 10 == 0 then
	
			local xPos = math.random(-Arena.width/3.2 - 75,Arena.width/3.2 + 75)
			local yPos = Arena.height / 2 + 50
			CreateBullet(xPos, yPos)
		
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		
		currentBullet.Move(0, -2)
		
		if currentBullet.y < -170 then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end