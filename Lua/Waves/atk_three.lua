spawntimer = 0
Encounter.SetVar("wavetimer", 4.0)
bullets = {}

function CreateBullet(x, y)
	bullet = CreateProjectile("blankw", x, y)
	table.insert(bullets, bullet)
end
function CreateBullett(x, y)
	bullett = CreateProjectile("blanks", x, y)
end

function Update()

	spawntimer = spawntimer + 1

	if spawntimer == 115 then
	
			CreateBullet(0, 40)
				function OnHit(bullet)
				    if not Player.isMoving then
				        Player.Hurt(3)
				    end
				end
	end
	if spawntimer == 150 then
			
			bullet.Remove()
			CreateBullett(0, 40)
				function OnHit(bullett)
				    if Player.isMoving then
				        Player.Hurt(3)
				    end
				end
	end
	if spawntimer == 175 then
			
			bullett.Remove()
			CreateBullet(0, 40)
				function OnHit(bullet)
				    if not Player.isMoving then
				        Player.Hurt(3)
				    end
				end
	end
	if spawntimer == 185 then
			
			bullet.Remove()
	end
	
end