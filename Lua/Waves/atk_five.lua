require "Libraries/colortoys"

spawntimer = 0
bullets = {}
Arena.Resize(300, 130)
Encounter.SetVar("wavetimer", 14.0)

state = 0

warning_gradient = Gradient.new({{1, 0, 0}, {1, 0.5, 0}, {1, 0, 0}})

function create_lightning(x, large)
	local left_right = math.random(0, 1)
	
	if left_right == 1 then
		left_right = "bolt_left"
	else
		left_right = "bolt_right"
	end
	
	local bolt = CreateProjectile(left_right, x, 84)
	bolt.SetVar('bullet_type', 2)
	bolt.SetVar('lifetime', 30)
	bolt.SetVar('large', large)
	bolt.sprite.Set(left_right)
	if large then
		bolt.sprite.xscale = 2
		bolt.sprite.yscale = 2
		bolt.MoveTo(bolt.x, bolt.y + bolt.sprite.height)
	end
	table.insert(bullets, bolt)

	local pillar_sprite = 'bolt_pillar'
	local offset = 0
	if large then
		pillar_sprite = 'bolt_pillar_large'
		offset = 100
	end
	local pillar = CreateProjectile(pillar_sprite, x, offset + 84)
	bolt.MoveTo(pillar.x, pillar.y)
	pillar.SetVar('bullet_type', 1)
	pillar.SetVar('lifetime', 10)
	pillar.SetVar('large', large)

	if large then

		Audio.PlaySound('bolt')
		
	else

		Audio.PlaySound('bolt_high')
		
	end
	table.insert(bullets, pillar)
end

function update_warning(bullet)
	if not bullet.isactive then
		return
	end
	
	local life_left = bullet.GetVar('lifetime')
	bullet.SetVar('lifetime', life_left - 1)
	bullet.sprite.color = warning_gradient:getColorAt((life_left % 30) / 30)

	if life_left == 0 then
		local big = bullet.GetVar('big')
		local bolt_pillar = create_lightning(bullet.x, big)
		bullet.Remove()
		return
	end
end

function update_bolt(bullet)
	if not bullet.isactive then
		return
	end
	
	local life_left = bullet.GetVar('lifetime')
	local large = bullet.GetVar('large')
	
	bullet.SetVar('lifetime', life_left - 1)
	bullet.sprite.alpha = life_left / 30

	if large then
		bullet.sprite.xscale = (2 - life_left / 30)
	else
		bullet.sprite.xscale = (2 - life_left / 30)
	end
	
	if life_left == 0 then
		bullet.Remove()
	end
end

function update_pillar(bullet)
	if not bullet.isactive then
		return
	end
	
	local life_left = bullet.GetVar('lifetime')
	
	bullet.sprite.alpha = life_left / 10
	
	if life_left > 0 then
		bullet.SetVar('lifetime', life_left - 1)
	else
		bullet.Remove()
	end
end

function OnHit(bullet)
	
	local bullet_type = bullet.GetVar('bullet_type')
	
	if bullet_type == 1 then
		local large = bullet.GetVar('large')
		if large then
			Player.Hurt(9)
		else
			Player.Hurt(6)
		end
	end
end

function Update()
	spawntimer = spawntimer + 1
	
		if spawntimer % 50 == 0 then
			local warning = CreateProjectile('bolt_warning', math.random() * Arena.width - Arena.width / 2, 0 - Arena.height / 2 + 32)
			warning.sprite.set('bolt_warning')
			warning.sprite.xscale = 2
			warning.sprite.yscale = 2
			warning.SetVar('bullet_type', 0)
			warning.SetVar('lifetime', 120)
			warning.SetVar('big', true)
			table.insert(bullets, warning)
		end
	
    for i=1,#bullets do
        local bullet = bullets[i]
        local bullet_type = bullet.GetVar('bullet_type')
		if bullet_type == 0 then
			update_warning(bullet)
		elseif bullet_type == 1 then
			update_pillar(bullet)
		elseif bullet_type == 2 then
			update_bolt(bullet)
		end
    end
end