Arena.resize(155, 130)
Encounter.SetVar("wavetimer", 10.0)

bullets = {}
spawntimer = 0
i = 1
bullet = 0

Player.SetControlOverride(true)

speed = 2.5
function Update()
	spawntimer = spawntimer + 1

	if spawntimer == 30 then
		Audio.PlaySound('rodsnd')
	end

	if spawntimer >= 90 then
		Arena.resize(100, 20)
		if spawntimer == 95 then
		Player.SetControlOverride(false)
		end
		if(spawntimer % 40 == 0) then
			if i % 2 == 0 then

				bullet = CreateProjectile('sword2', 90, 0)
				bullet.sprite.rotation = 180

			else 

				bullet = CreateProjectile('sword2', -90, 0)

			end
			bullet.SetVar('firing', 60)
			bullet.SetVar('fired', 0)
			table.insert(bullets,bullet)
			Audio.PlaySound('spawn')

			i = i + 1
		end

		for i=1, #bullets do
			local bullet = bullets[i]
			if bullet.isactive then
				local firing = bullet.GetVar('firing')
				if firing <= 0 then
					if bullet.GetVar('fired') == 0 then
						bullet.SetVar('yvel', 5)
						Audio.PlaySound('pierce')
						bullet.SetVar('fired', 1)
					end
						if i % 2 == 0 then
							if bullet.x >= 40 then
							bullet.MoveTo(bullet.x-5, bullet.y)
							else 
								bullet.Remove()
							end
						else 
							if bullet.x <= -40 then
							bullet.MoveTo(bullet.x+5, bullet.y)
							else 
								bullet.Remove()
							end
						end

				else
					if i % 2 == 0 then
					bullet.SetVar('firing', firing-3)
					bullet.MoveTo(math.min(bullet.x-0.3, 120), 0)
					else 
						bullet.SetVar('firing', firing-3)
						bullet.MoveTo(math.min(bullet.x+0.3, 20), 0)
					end
				end
			end
		end
	end
end