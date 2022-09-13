Arena.resize(90, 100)
Encounter.SetVar("wavetimer", 10.0)

bullets = {}
spawntimer = 0


speed = 2.5
function Update()
	spawntimer = spawntimer + 1
	if(spawntimer % 30 == 0) then
		local bullet = CreateProjectile('sword', -30 + (math.random(3)-1)*30, 80)
		bullet.SetVar('firing', 60)
		bullet.SetVar('fired', 0)
		table.insert(bullets,bullet)
		Audio.PlaySound('spawn')
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
				bullet.MoveTo(bullet.x, bullet.y-5)
			else
				bullet.SetVar('firing', firing-3)
				bullet.MoveTo(bullet.x, math.min(bullet.y-0.3, 80))
			end
		end
	end
end