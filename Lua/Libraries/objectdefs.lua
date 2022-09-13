--This library of objects was created by Blazephlozard for Alphys NEO
-- http://bit.ly/AlphysNEO

--[[
	HERE'S SOME KIND OF DOCUMENTATION FOR ALL YOU BITCHES.
	I may have forgotten some things but hopefully you're smart enough to figure things out by looking at my wave .luas!
	They're GREAT examples of how to use all this stuff!!!

Object types:
Box - An unshootable box. Absorbs player bullets. Will blow up along with a PlusBomb if spawned at the same Y at the same time.
ShootableBox - A shootable box. (WOW!) Not much more to say.
PlusBomb - A bomb that, when shot, will blink and then explode horizontally and vertically.
Bolt - A lightning bolt. Does not interact with player bullets. Does interact with the player's face. Simple as that.
Parasol - Parasol Mettaton. Fires heart projectiles directly at the player.
Heart - The Parasol Mettaton's projectile. Simple.
LaserBot - A little guy that fires either a blue or orange laser.
GasterBlaster - You know what it is. This object works differently than all the rest. All the rest are basically just little guys that move in a linear direction at a linear speed.

Variables shared by all:

Performance Improvers
-----
simple - An object with simple = true will just move in a straight line forever, ignoring its possible endX/endY. A good way to improve performance. Does nothing on Gaster Blasters.
offScreenDead - If true, the object will have dead set to true if it goes off-screen. Heart projectiles have this by default. Does nothing on Gaster Blasters.
bottomScreenDead - If true, the object will have dead set to true if it goes off the bottom of the screen. Good for boxes that start OOB at the top, and move to the bottom. Does nothing on Gaster Blasters.
lifetime - The object will die after this many seconds. Good for Gaster Blasters.

Movement/Placement Information (Probably Doesn't Apply To Gaster Blasters)
-----
startX, startY - Self-explanatory. This is where the object will start at. Note that all my x/y values are absolute. Has to be defined.
endX, endY - Self-explanatory. If the object has non-simple movement, they will start bouncing back towards their startX/startY after they reach this position. Defaults to startX/startY.
bounce - If bounce is false, the object will stay in place once it reaches its endX/endY. Defaults to true.
xspeed, yspeed - Pixels per second that this object will move in the x/y direction. Defaults to zero. Note: If simple = false, this number shouldn't be negative ever. If simple = true, it needs to be positive or negative depending on which direction you want it to go.
xspeed2, yspeed2 - In-game, Parasol Mettatons move fast at first and then slow down as they fire. I made these variables to simulate that. After speedTime seconds, the object will move at xspeed2/yspeed2 instead.
speedTime - IF you have a xspeed2/yspeed2, this is how long to move at the first xspeed/yspeed, in seconds.
circleID, rotation, rspeed - You can associate this bullet with a circle. rotation is their starting rotation. rspeed is how many degrees they'll rotate per second. (Look at yellow2 or circlemadness for good examples of circles, which are handled in the wave .lua)

Other Things
-----
time - The time that this object should be "created". If you know what I mean. Use Time.time/ourTime + (seconds until it appears)
damage - How much damage this object or its projectiles will deal. Default is 8, or 13 for Gaster Blasters.
shot, shotTime - Has this object been shot? When was it shot? Used to display the fade animations for boxes/metts, blowing up plus bomb, etc.
lastX, lastY - The last x/y position the object got drawn in. Used for the location of the fade animations, and probably some other things.
dead - Is this dead? Note that you need to check if this variable is true and remove it from the table in your wave update function.

Specific variables to certain objects:

Parasol Mettatons
-----
ammo - How many shots it'll fire. Defaults to 99.
firstShot - How long until the Mettaton's first shot. In seconds, of course.
delay - How long between subsequent Mettaton shots. Note that they still have to go through their whole animation before they can shoot again (which takes a little more than a second)
shooting, shootingTime, heartFired - Is it shooting? When did it start shooting? Has it shot a heart yet this shooting? No need to mess with these...
flingDir - When a Mettaton runs out of ammo, it'll fling off the screen either leftwards (-1) or rightwards (1). Defaults to 1.
ammoOutTime - When it started to run out of ammo. Used in conjunction with flingDir
shotTimes - The times that it shot each shot. Just for reversing its shooting animation correctly.
heartsDie - Should the hearts this Mettaton shoots kill themselves off-screen? Defaults to true. Should set it to false if you plan to rewind.

Plus Bombs
-----
fuse - The bomb will explode on its own after this amount of time. I use it to fake Gaster Blaster lasers "colliding" and setting off the bombs.

Laser Bots
-----
color - Blue or orange. Duh. Note that you need BLUE and ORANGE constants.
rotation - 0, 90, 180, or 270. 0 = facing downwards, 90 = leftwards, 180 = upwards, 270 = rightwards
off - Turn it off. Simple enough. Default is of course false.

Gaster Blasters
-----
endX, endY - If you set either of these to -42, it will change to the Player's x/y once it gets created.
size - NORMAL, THIN, or LARGE. Thin is half as wide as normal. Large is twice as wide and tall as normal.
laserDelay - How long until it begins to fire its laser. 0.75-0.8 is usually good for this, but play around with it however you want
laserLength - How long it fires its laser once it starts. 0.55 is usually good for this
s1, s2 - Should this blaster play its intro sound/firing sound? Defaults to true. In a group of blasters coming in at once, if they ALL had these set to false, it'd sound horrendous.
rs1, rs2 - Same as above but for going in reverse.
rotation - 0, 90, 180, or 270. 0 = facing downwards, 90 = leftwards, 180 = upwards, 270 = rightwards


Also, even though this isn't in the library:
Timeflow table variables. These are kinda weird and totally not all necessary probably
-----
icon - rec, rew, play, slow, ff. The sprite to display in the bottom right corner. Has no actual meaning beyond that.
start - The time multiplier that was present when this command started, so that it can properly change to the new one.
mult - The final multiplier for this command to reach.
dir - 1 or -1, for whether its increasing or decreasing/going reverse. Could have just checked the sign of rate but oh well
rate - How much it should change per second from its start to its mult
length - How long this flow command should last
blink - How frequently to blink the bottom right corner graphic. 2 = twice as frequently as the default that Undertale does.

]]


local objects = {}

--Simple check for if something is on screen. only works well for sprites less than 60x60?
function objects.OnScreen(x,y)
	if (x > 670 or x < -30 or y > 510 or y < -30) then return false
	else return true
	end
end

--Calculate the XY of all my objects that have a start X, end X, start Y, end Y, affected by timeflow,
--linear movement, bouncing, circle patterns, multiple speeds, etc.
function objects.GetXY(bullet)
	
	local timeDiff = ourTime - bullet.time
	local x = 0
	local y = 0
	
	if (bullet.circleID ~= nil) then
		if (circles[bullet.circleID].originX ~= nil) then
			bullet.startX = circles[bullet.circleID].originX
			bullet.startY = circles[bullet.circleID].originY
		end
	end
	
	if (timeDiff > 0) then
		local xmult = 1
		if (bullet.startX > bullet.endX) then xmult = -1 end
		local ymult = 1
		if (bullet.startY > bullet.endY) then ymult = -1 end
		
		if (bullet.xspeed == 0 or bullet.startX == bullet.endX) then
			x = bullet.startX
		elseif (bullet.xspeed2 == nil) then
			if (bullet.bounce ~= false) then
				x = bullet.startX + ((bullet.xspeed * timeDiff) % (2*math.abs(bullet.endX - bullet.startX))) * xmult
				x = bullet.endX - (math.abs(x - bullet.endX)*xmult)
			else
				x = bullet.startX + math.min(bullet.xspeed * timeDiff,math.abs(bullet.endX - bullet.startX)) * xmult
			end
		else
			local speedDiff = timeDiff - bullet.speedTime
			if (bullet.bounce ~= false) then
				x = bullet.startX + ((bullet.xspeed * math.min(timeDiff,bullet.speedTime) + bullet.xspeed2 * math.max(0, speedDiff)) % (2*math.abs(bullet.endX - bullet.startX))) * xmult
				x = bullet.endX - (math.abs(x - bullet.endX)*xmult)
			else
				x = bullet.startX + math.min(bullet.xspeed * math.min(timeDiff,bullet.speedTime) + bullet.xspeed2 * math.max(0, speedDiff), math.abs(bullet.endX - bullet.startX)) * xmult
			end
		end
		
		if (bullet.yspeed == 0 or bullet.startY == bullet.endY) then
			y = bullet.startY
		elseif (bullet.xspeed2 == nil) then
			if (bullet.bounce ~= false) then
				y = bullet.startY + ((bullet.yspeed * timeDiff) % (2*math.abs(bullet.endY - bullet.startY))) * ymult
				y = bullet.endY - (math.abs(y - bullet.endY)*ymult)
			else
				y = bullet.startY + math.min(bullet.yspeed * timeDiff,math.abs(bullet.endY - bullet.startY)) * ymult
			end
		else
			local speedDiff = timeDiff - bullet.speedTime
			if (bullet.bounce ~= false) then
				y = bullet.startY + ((bullet.yspeed * math.min(timeDiff,bullet.speedTime) + bullet.yspeed2 * math.max(0, speedDiff)) % (2*math.abs(bullet.endY - bullet.startY))) * ymult
				y = bullet.endY - (math.abs(y - bullet.endY)*ymult)
			else
				y = bullet.startY + math.min(bullet.yspeed * math.min(timeDiff,bullet.speedTime) + bullet.yspeed2 * math.max(0, speedDiff), math.abs(bullet.endY - bullet.startY)) * ymult
			end
		end
		
	else
		x = bullet.startX
		y = bullet.startY
	end
	
	if (bullet.circleID ~= nil) then
		--This box is in a circle. Calculate its x and y based on circle radius and rotation speed and etc
		--At the moment, boxx and boxy represent the center point of the circle.
		local radius = circles[bullet.circleID].radius
		local boxr = 0
		if (timeDiff > 0) then
			boxr = bullet.rotation + (bullet.rspeed * timeDiff) + circles[bullet.circleID].offset
		else boxr = bullet.rotation end
		x = x + (radius * math.cos(math.rad(boxr)))
		y = y + (radius * math.sin(math.rad(boxr)))
	end
	
	return { x, y }
	
	
end

function objects.GetXYCircle(bullet)
	--This function is for "simple" objects that are in a circle. All it does is the circle bits.
	--It should keep "Asgore circles" from being as laggy.
	local timeDiff = ourTime - bullet.time
	local x = 0
	local y = 0
	
	--This box is in a circle. Calculate its x and y based on circle radius and rotation speed and etc
	if (circles[bullet.circleID].originX ~= nil) then
		bullet.startX = circles[bullet.circleID].originX
		bullet.startY = circles[bullet.circleID].originY
	end
	
	local minzero = math.max(0,timeDiff)
	x = bullet.startX + (bullet.xspeed * minzero)
	y = bullet.startY + (bullet.yspeed * minzero)

	local radius = circles[bullet.circleID].radius
	local boxr = 0
	if (timeDiff > 0) then
		boxr = bullet.rotation + (bullet.rspeed * timeDiff) + circles[bullet.circleID].offset
	else boxr = bullet.rotation end
	x = x + (radius * math.cos(math.rad(boxr)))
	y = y + (radius * math.sin(math.rad(boxr)))
	
	
	return { x, y }
	
	
end

objects.Object = {}

function objects.Object.new(info)
	local self = info
	
	if (self.bounce == nil) then self.bounce = true end
	--Hacky way for gaster blasters to default to 13 while everything else defaults to 8: check for a GB-exclusive variable
	--Also, different depending on hard mode or not
	if (self.damage == nil) then
		if (GetGlobal("HARD") ~= true) then
			if (self.laserDelay == nil) then self.damage = 6
			else self.damage = 10
			end
		else
			if (self.laserDelay == nil) then self.damage = 8
			else self.damage = 13
			end
		end
	end
	self.lastX = self.startX
	self.lastY = self.startY
	if (self.endX == nil) then self.endX = self.startX end
	if (self.endY == nil) then self.endY = self.startY end
	if (self.xspeed == nil) then self.xspeed = 0 end
	if (self.yspeed == nil) then self.yspeed = 0 end
	self.shot = false
	self.shotTime = 0
	--It wouldn't make sense for these to remove themselves from a table during updating
	--So instead, they'll set dead to true, for the wave to remove them, if they go off screen in some waves or finish blowing up or etc
	self.dead = false
	if (self.lifetime == nil) then self.lifetime = 6969 end
	--Simple means that these just go forever. No need to mess about with endX/endY/whatever. Just startX/startY/speed.
	--Should help performance for things like the electric bolt maze
	if (self.simple == nil) then self.simple = false end
	
	
	function self.BaseUpdate()
		if (ourTime - self.time > self.lifetime) then self.dead = true end
		
	end
	
	return self
end

objects.Box = {}

function objects.Box.new(info)
	local self = objects.Object.new(info)
	
	self.bullet = CreateProjectileAbs("box", -500, -500)
	self.bullet.SetVar('damage',self.damage)
	
	function self.Update()
		self.BaseUpdate()
		
		local timeDiff = ourTime - self.time
		
		local result
		if (self.simple) then
			if (self.circleID ~= nil) then
				result = objects.GetXYCircle(self)
			else
				local minzero = math.max(0,timeDiff)
				result = {self.startX + (self.xspeed * minzero), self.startY + (self.yspeed * minzero)}
			end
		else
			result = objects.GetXY(self)
		end
		self.lastX = result[1]
		self.lastY = result[2]
		if (objects.OnScreen(result[1], result[2])) then
			--Colliding with player bullets
			for i=#pbs,1,-1 do
				local xdiff = math.abs(pbs[i].x - self.lastX)
				if (xdiff < 14 and self.lastY - 12 < pbs[i].lastY+40 and self.lastY + 12 > pbs[i].lastY+40-pbs[i].lastH) then
					--We're colliding. These boxes just absorb it!
					table.remove(pbs,i)
				end
			end
			
			self.bullet.MoveToAbs(result[1], result[2])
			self.bullet.SendToTop()
			--local bullet = CreateProjectileAbs("box", result[1], result[2])
			--bullet.SetVar('damage',self.damage)
			--table.insert(oneFrameBullets, bullet)
		elseif (self.offScreenDead == true or (self.bottomScreenDead == true and result[2] < -30)) then
			self.dead = true
			self.bullet.MoveToAbs(-500,-500)
		else
			self.bullet.MoveToAbs(-500,-500)
		end
	end
	
	return self
	
end

objects.Heart = {}

function objects.Heart.new(info)
	local self = objects.Object.new(info)
	
	self.bullet = CreateProjectileAbs("para/heart1", -500, -500)
	self.bullet.SetVar('tile',1)
	
	self.hitbox = CreateProjectileAbs("para/hearthitbox",-500,-500)
	self.hitbox.SetVar('damage',self.damage)
	
	function self.Update()
		self.BaseUpdate()
		
		local timeDiff = ourTime - self.time
		
		--Heart bullets shouldn't be drawn before they existed
		--These are always "simple". They just go in a straight line forever
		if (timeDiff > 0) then
			local boxx = self.startX + (self.xspeed * timeDiff)
			local boxy = self.startY + (self.yspeed * timeDiff)
			self.lastX = boxx
			self.lastY = boxy
			
			local curFrame = math.floor(timeDiff / (1/30))
			while (curFrame > 36) do curFrame = curFrame - 24 end
			
			if (objects.OnScreen(boxx,boxy)) then
				self.bullet.sprite.Set("para/heart" .. curFrame)
				self.bullet.MoveToAbs(boxx,boxy)
				self.bullet.SendToTop()
				self.hitbox.MoveToAbs(boxx,boxy)
				--local bullet = CreateProjectileAbs("para/heart" .. curFrame, boxx, boxy)
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)
				--Smaller, invisible hitbox to actually hit the player with
				--local bullet = CreateProjectileAbs("para/hearthitbox", boxx, boxy)
				--bullet.SetVar('damage',self.damage)
				--table.insert(oneFrameBullets, bullet)
			elseif (self.offScreenDead == true or (self.bottomScreenDead == true and result[2] < -30)) then
				self.dead = true
				self.bullet.MoveToAbs(-500,-500)
			else
				self.bullet.MoveToAbs(-500,-500)
			end
		end	
		
	end
	
	return self
end

objects.Parasol = {}

function objects.Parasol.new(info)
	local self = objects.Object.new(info)
	
	if (self.ammo == nil) then self.ammo = 99 end
	
	self.shotsFired = 0
	self.shooting = false
	self.shootingTime = ourTime
	self.heartFired = false
	if (self.flingDir == nil) then self.flingDir = 1 end
	self.ammoOutTime = 0
	--This is a dumb thing that lets the mettatons do their shooting animation when they did originally when time is going in reverse
	self.shotTimes = {}
	if (self.heartsDie == nil) then self.heartsDie = true end
	
	self.bullet = CreateProjectileAbs("para/para0", -500, -500)
	self.bullet.SetVar('tile',1)
	
	--Parasol Mettatons
	function self.Update()
		self.BaseUpdate()
		
		local timeDiff = ourTime - self.time
		
		--Time to fire a heart? There's a lot of criteria??
		if (timeMult > 0 and self.shot == false and self.shooting == false and self.shotsFired < self.ammo and timeDiff > self.firstShot + self.shotsFired * self.delay) then 
			self.shooting = true
			self.shootingTime = ourTime
			self.heartFired = false
		end
		
		local result
		if (self.simple) then
			if (self.circleID ~= nil) then
				result = objects.GetXYCircle(self)
			else
				local minzero = math.max(0,timeDiff)
				result = {self.startX + (self.xspeed * minzero), self.startY + (self.yspeed * minzero)}
			end
		else
			result = objects.GetXY(self)
		end
		
		if (self.shot == true) then
			local curFrame = math.floor((Time.time - self.shotTime) / (1/30))
			if (curFrame < 15) then
				self.bullet.sprite.Set("para/fade" .. curFrame)
				self.bullet.MoveToAbs(self.lastX, self.lastY)
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("para/fade" .. curFrame, self.lastX, self.lastY)
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)
			else
				self.dead = true
				self.bullet.MoveToAbs(-500,-500)
			end
		else
			--Mettaton is out of ammo. Fling it off the screen
			if (self.shotsFired >= self.ammo) then
				if (self.ammoOutTime == 0) then self.ammoOutTime = ourTime end
				local ammoDiff = ourTime - self.ammoOutTime
				result[1] = result[1] + ((ammoDiff^3 * 200) * self.flingDir)
			end
			
			self.lastX = result[1]
			self.lastY = result[2]
			
			--Colliding with player bullets. Hitbox is kinda weird on Parasol Metts because parasol.
			for i=#pbs,1,-1 do
				local xdiff = math.abs(pbs[i].x - (self.lastX + 3))
				if (xdiff < 14 and self.lastY - 24 < pbs[i].lastY+40 and self.lastY + 2 > pbs[i].lastY+40-pbs[i].lastH) then
					--We're colliding
					self.shot = true
					self.shotTime = Time.time
					Audio.PlaySound("shotbox")
					table.remove(pbs,i)
				end
			end
			
			--Check for if shooting heart
			if (self.shooting == true) then
				local curFrame = math.floor((ourTime - self.shootingTime) / (1/15))
				if (curFrame > 17 or curFrame < 0) then
					--Shooting is complete, or time is going in reverse
					self.shooting = false
					if (curFrame > 17) then
						table.insert(self.shotTimes, ourTime)
					end
					self.bullet.sprite.Set("para/para0")
					self.bullet.MoveToAbs(result[1], result[2])
					self.bullet.SendToTop()
					--local bullet = CreateProjectileAbs("para/para0", result[1], result[2])
					--bullet.SetVar('tile',1)
					--table.insert(oneFrameBullets, bullet)
				else
					--Has to be in bounds to shoot a heart.
					if (self.heartFired == false and curFrame >= 12 and result[1] > -30 and result[1] < 670 and result[2] > -30 and result[2] < 510) then
						--Fire a heart!!
						self.shotsFired = self.shotsFired + 1
						self.heartFired = true
						--the -10 and +3 are because boxx and boxy are the center of the entire sprite;
						--parasol mettatons are kinda weird because their center for THIS shouldnt include their parasol
						local theAngle = math.atan2(Player.absy-(result[2]-10),Player.absx-(result[1]+3))
						--Need to have a hearts array in the wave .lua
						table.insert(hearts, oblib.Heart.new({ startX = result[1] + 3, startY = result[2] - 10, xspeed = 150*math.cos(theAngle), yspeed = 150*math.sin(theAngle), time = ourTime }))
						if (self.heartsDie == true) then
							hearts[#hearts].offScreenDeath = true
						end
					end
					self.bullet.sprite.Set("para/para" .. curFrame)
					self.bullet.MoveToAbs(result[1], result[2])
					self.bullet.SendToTop()
					--local bullet = CreateProjectileAbs("para/para" .. curFrame, result[1], result[2])
					--bullet.SetVar('tile',1)
					--table.insert(oneFrameBullets, bullet)
				end
			elseif (timeMult < 0) then
				--Time is going in reverse. we might want to draw the frames of him shooting a heart
				if (objects.OnScreen(result[1],result[2])) then
					local curFrame = 0
					if (#self.shotTimes > 0) then
						local lastShotTime = self.shotTimes[#self.shotTimes]
						if (lastShotTime > ourTime) then
							curFrame = 17 - math.floor((lastShotTime - ourTime) / (1/15))
							if (curFrame < 0) then
								curFrame = 0
								table.remove(self.shotTimes, #self.shotTimes)
							end
						end
					end
					
					self.bullet.sprite.Set("para/para" .. curFrame)
					self.bullet.MoveToAbs(result[1], result[2])
					self.bullet.SendToTop()
					--local bullet = CreateProjectileAbs("para/para" .. curFrame, result[1], result[2])
					--bullet.SetVar('tile',1)
					--table.insert(oneFrameBullets, bullet)
				end
			else
				if (objects.OnScreen(result[1],result[2])) then
					self.bullet.sprite.Set("para/para0")
					self.bullet.MoveToAbs(result[1], result[2])
					self.bullet.SendToTop()
					--local bullet = CreateProjectileAbs("para/para0", result[1], result[2])
					--bullet.SetVar('tile',1)
					--table.insert(oneFrameBullets, bullet)
				elseif (self.offScreenDead == true or (self.bottomScreenDead == true and result[2] < -30)) then
					self.dead = true
					self.bullet.MoveToAbs(-500,-500)
				else
					self.bullet.MoveToAbs(-500,-500)
				end
			end
		end
			
	end
	
	
	return self
end

objects.ShootableBox = {}

function objects.ShootableBox.new(info)
	local self = objects.Object.new(info)
	
	self.bullet = CreateProjectileAbs("sbox/sbox", -500, -500)
	self.bullet.SetVar('damage',self.damage)
	
	function self.Update()
		self.BaseUpdate()

		local timeDiff = ourTime - self.time
		
		if (self.shot == true) then
			local curFrame = math.floor((Time.time - self.shotTime) / (1/30))
			if (curFrame < 15) then
				self.bullet.sprite.Set("sbox/sbox" .. curFrame)
				self.bullet.MoveToAbs(self.lastX, self.lastY)
				self.bullet.SetVar('tile', 1)
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("sbox/sbox" .. curFrame, self.lastX, self.lastY)
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)
			else
				self.dead = true
				self.bullet.MoveToAbs(-500,-500)
			end
		else
			local result
			if (self.simple) then
				if (self.circleID ~= nil) then
					result = objects.GetXYCircle(self)
				else
					local minzero = math.max(0,timeDiff)
					result = {self.startX + (self.xspeed * minzero), self.startY + (self.yspeed * minzero)}
				end
			else
				result = objects.GetXY(self)
			end
			self.lastX = result[1]
			self.lastY = result[2]
			if (objects.OnScreen(result[1], result[2])) then
			
				--Colliding with player bullets
				for i=#pbs,1,-1 do
					local xdiff = math.abs(pbs[i].x - self.lastX)
					if (xdiff < 14 and self.lastY - 12 < pbs[i].lastY+40 and self.lastY + 12 > pbs[i].lastY+40-pbs[i].lastH) then
						--We're colliding
						self.shot = true
						self.shotTime = Time.time
						Audio.PlaySound("shotbox")
						table.remove(pbs,i)
					end
				end
				self.bullet.MoveToAbs(result[1], result[2])
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("sbox/sbox", result[1], result[2])
				--bullet.SetVar('damage',self.damage)
				--table.insert(oneFrameBullets, bullet)
			elseif (self.offScreenDead == true or (self.bottomScreenDead == true and result[2] < -30)) then
				self.dead = true
				self.bullet.MoveToAbs(-500,-500)
			else
				self.bullet.MoveToAbs(-500,-500)
			end
		end
	end
	
	return self
end

objects.PlusBomb = {}

function objects.PlusBomb.new(info)
	local self = objects.Object.new(info)

	if (self.fuse == nil) then self.fuse = 6969 end
	
	self.bullet = CreateProjectileAbs("plus/plus0", -500, -500)
	self.bullet.SetVar('damage',self.damage)
	
	function self.Update()
		self.BaseUpdate()
		
		local timeDiff = ourTime - self.time
		
		if (self.shot == false and timeDiff > self.fuse) then 
			self.shot = true
			self.shotTime = Time.time
			--Note: bombsound has to be declared in the wave .lua. It's to stop multiple explosion sounds from happening at once
			if (bombsound == false) then
				Audio.PlaySound("plusexplode")
				bombsound = true
			end
		end
		
		local result
		if (self.simple) then
			if (self.circleID ~= nil) then
				result = objects.GetXYCircle(self)
			else
				local minzero = math.max(0,timeDiff)
				result = {self.startX + (self.xspeed * minzero), self.startY + (self.yspeed * minzero)}
			end
		else
			result = objects.GetXY(self)
		end
		
		if (self.shot == true) then
			local curFrame = math.floor((Time.time - self.shotTime) / (1/30))
			if (curFrame < 5) then
				--Bomb is flashing
				self.lastX = result[1]
				self.lastY = result[2]
				
				self.bullet.sprite.Set("plus/plus" .. curFrame)
				self.bullet.MoveToAbs(result[1], result[2])
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("plus/plus" .. curFrame, result[1], result[2])
				--bullet.SetVar('damage',self.damage)
				--table.insert(oneFrameBullets, bullet)
			elseif (curFrame < 12) then
				if (self.bullet.isactive == true) then
					self.bullet.Remove()
				end
				--Bomb is exploding.
				--boxes has to be declared in the wave .lua
				if (self.blewBoxes ~= true) then
					self.blewBoxes = true
					for j = #boxes,1,-1 do
						--If an unshootable box has the same y and start time as this bomb, destroy it
						if (self.startY == boxes[j].startY and self.time == boxes[j].time) then
							boxes[j].dead = true
						end
					end
				end
				curFrame = curFrame - 5
				--These have variable hitboxes so I'll keep them as one frame bullets.
				local bullet = CreateProjectileAbs("plus/hor" .. curFrame, self.lastX, self.lastY)
				bullet.SetVar('damage',self.damage)
				table.insert(oneFrameBullets, bullet)
				local bullet = CreateProjectileAbs("plus/ver" .. curFrame, self.lastX, self.lastY)
				bullet.SetVar('damage',self.damage)
				table.insert(oneFrameBullets, bullet)
				local bullet = CreateProjectileAbs("plus/blast" .. curFrame, self.lastX, self.lastY)
				bullet.SetVar('damage',self.damage)
				table.insert(oneFrameBullets, bullet)
			else
				--Bomb is done exploding
				self.dead = true
			end
		else
			self.lastX = result[1]
			self.lastY = result[2]
			
			--Colliding with player bullets
			for i=#pbs,1,-1 do
				local xdiff = math.abs(pbs[i].x - self.lastX)
				if (xdiff < 14 and self.lastY - 15 < pbs[i].lastY+40 and self.lastY + 15 > pbs[i].lastY+40-pbs[i].lastH) then
					--We're colliding
					self.shot = true
					self.shotTime = Time.time
					Audio.PlaySound("plusexplode")
					table.remove(pbs,i)
				end
			end
			
			if (objects.OnScreen(result[1], result[2])) then
				self.bullet.MoveToAbs(result[1],result[2])
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("plus/plus0", result[1], result[2])
				--bullet.SetVar('damage',self.damage)
				--table.insert(oneFrameBullets, bullet)
			elseif (self.offScreenDead == true or (self.bottomScreenDead == true and result[2] < -30)) then
				self.dead = true
				self.bullet.MoveToAbs(-500,-500)
			else
				self.bullet.MoveToAbs(-500,-500)
			end
		end
	end
	
	return self
	
end

objects.Bolt = {}

function objects.Bolt.new(info)
	local self = objects.Object.new(info)
	
	self.bullet = CreateProjectileAbs("bolt", -500, -500)
	self.bullet.SetVar('damage',self.damage)
	
	function self.Update()
		self.BaseUpdate()
		
		local timeDiff = ourTime - self.time
		
		local result
		if (self.simple) then
			if (self.circleID ~= nil) then
				result = objects.GetXYCircle(self)
			else
				local minzero = math.max(0,timeDiff)
				result = {self.startX + (self.xspeed * minzero), self.startY + (self.yspeed * minzero)}
			end
		else
			result = objects.GetXY(self)
		end

		if (objects.OnScreen(result[1], result[2])) then
			self.lastX = result[1]
			self.lastY = result[2]
			self.bullet.MoveToAbs(result[1],result[2])
			self.bullet.SendToTop()
			--local bullet = CreateProjectileAbs("bolt", result[1], result[2])
			--bullet.SetVar('damage',self.damage)
			--table.insert(oneFrameBullets, bullet)
		elseif (self.offScreenDead == true or (self.bottomScreenDead == true and result[2] < -30)) then
			self.dead = true
			self.bullet.MoveToAbs(-500,-500)
		else
			self.bullet.MoveToAbs(-500,-500)
		end
	end
	
	return self
end

objects.LaserBot = {}

function objects.LaserBot.new(info)
	local self = objects.Object.new(info)
	
	if (self.off == nil) then self.off = false end
	
	self.bullet = CreateProjectileAbs("bot" .. self.rotation .. "/spr_lasermachine_off_0", -500, -500)
	self.bullet.SetVar('tile',1)
	
	function self.Update()
		self.BaseUpdate()
		
			--Laser bots!!
	--Note: Should remake these to use an xspeed/yspeed and the GetXY function all the others use.
	--Oh well.
		-- Seconds since this bot's spawned
		local timeDiff = ourTime - self.time

	    if (timeDiff > 0) then
			--Always firing laser.
			--The sprite for the bot can be based on global time instead of timeDiff. All bots should be synced
			local botFrame = (math.floor(ourTime / (1/15))) % 5

			local botx = 0
			local boty = 0
			local laserx = 0
			local lasery = 0
			local laserfile = ""
			local botfile = ""
			
			local result
			if (self.simple) then
				if (self.circleID ~= nil) then
					result = objects.GetXYCircle(self)
				else
					local minzero = math.max(0,timeDiff)
					result = {self.startX + (self.xspeed * minzero), self.startY + (self.yspeed * minzero)}
				end
			else
				result = objects.GetXY(self)
			end
			
			botx = result[1]
			boty = result[2]
			
			--firing up/down (moving left/right)
			if (self.rotation == 0 or self.rotation == 180) then
				--[[if (self.startX > self.endX) then
					botx = self.startX - (self.speed * timeDiff) % (2*math.abs(self.endX - self.startX))
					botx = self.endX + math.abs(botx - self.endX)
				else
					botx = self.startX + (self.speed * timeDiff) % (2*math.abs(self.endX - self.startX))
					botx = self.endX - math.abs(botx - self.endX)
				end
				boty = self.startY]]
				laserx = botx
				if (self.rotation == 0) then lasery = boty - 253
				else lasery = boty + 251 end
				if (self.color == BLUE) then 
					laserfile = "bolasers/blaser6v"
					botfile = "bot" .. self.rotation .. "/spr_lasermachine_b_" .. botFrame
				else 
					laserfile = "bolasers/olaser6v"
					botfile = "bot" .. self.rotation .. "/spr_lasermachine_o_" .. botFrame
				end
			--firing left/right (moving up/down)
			elseif (self.rotation == 90 or self.rotation == 270) then
				--[[botx = self.startX
				--boty = self.startY + (self.speed * timeDiff)
				if (self.startY > self.endY) then
					boty = self.startY - (self.speed * timeDiff) % (2*math.abs(self.endY - self.startY))
					boty = self.endY + math.abs(boty - self.endY)
				else
					boty = self.startY + (self.speed * timeDiff) % (2*math.abs(self.endY - self.startY))
					boty = self.endY - math.abs(boty - self.endY)
				end]]
				if (self.rotation == 90) then laserx = botx - 333
				else laserx = botx + 331 end
				lasery = boty
				if (self.color == BLUE) then 
					laserfile = "bolasers/blaser6h"
					botfile = "bot" .. self.rotation .. "/spr_lasermachine_b_" .. botFrame
				else 
					laserfile = "bolasers/olaser6h"
					botfile = "bot" .. self.rotation .. "/spr_lasermachine_o_" .. botFrame
				end
			end

			--Need to change this to use sprite rotation
			--Or, not. whatever
			
			if (self.off == true) then
				self.bullet.sprite.Set("bot" .. self.rotation .. "/spr_lasermachine_off_0")
				self.bullet.MoveToAbs(botx,boty)
				self.bullet.SendToTop()
				if (self.laser ~= nil) then
					self.laser.Remove()
					self.laser = nil
				end
				--local bullet = CreateProjectileAbs("bot" .. self.rotation .. "/spr_lasermachine_off_0", botx, boty)
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)
			else
				self.bullet.sprite.Set(botfile)
				self.bullet.MoveToAbs(botx,boty)
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs(botfile, botx, boty)
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)
				
				if (self.laser == nil) then
					self.laser = CreateProjectileAbs(laserfile, laserx, lasery)
					self.laser.SetVar('damage',self.damage)
					if (self.color == BLUE) then self.laser.SetVar('color',BLUE)
					else self.laser.SetVar('color',ORANGE) end
				end
				
				self.laser.MoveToAbs(laserx, lasery)
				self.laser.SendToTop()
				--local laserbullet = CreateProjectileAbs(laserfile, laserx, lasery)
				--if (self.color == BLUE) then laserbullet.SetVar('color',BLUE)
				--else laserbullet.SetVar('color',ORANGE) end
				--laserbullet.SetVar('damage',self.damage)
				--table.insert(oneFrameBullets, laserbullet)
			end
		else
			--The laser is currently off, because of a negative timeDiff
			self.bullet.sprite.Set("bot" .. self.rotation .. "/spr_lasermachine_off_0")
			self.bullet.MoveToAbs(self.startX, self.startY)
			self.bullet.SendToTop()
			if (self.laser ~= nil) then
				self.laser.Remove()
				self.laser = nil
			end
			--local bullet = CreateProjectileAbs("bot" .. self.rotation .. "/spr_lasermachine_off_0", self.startX, self.startY)
			--bullet.SetVar('tile',1)
			--table.insert(oneFrameBullets, bullet)
	   end
		
	end
	
	return self
end

objects.GasterBlaster = {}

function objects.GasterBlaster.new(info)
	local self = objects.Object.new(info)
	
	if (self.s1 == nil) then self.s1 = true end
	if (self.s2 == nil) then self.s2 = true end
	if (self.rs1 == nil) then self.rs1 = true end
	if (self.rs2 == nil) then self.rs2 = true end
	
	self.bullet = CreateProjectileAbs("gaster" .. self.size .. "/gb0", -500, -500)
	self.bullet.SetVar('tile',1)
	
	function self.Update()
		self.BaseUpdate()
		--Oh boy, Gaster Blaster logic! What a mess.
		--This can probably be fixed up in a lot of ways. Whatever. It doesn't lag for me
		--Length of intro sound: 0.881. Fire sound: 2.018
		
		-- Seconds since this blaster's spawned
		local timeDiff = ourTime - self.time
		--Rotating/moving into place takes a third of a second.
		local phase1length = 0.33333
		
		--Playing reverse sounds. Done here just cause I dunno.
		if (timeMult < 0) then
			if (self.rs1 == false and timeDiff < 0.881) then
				if (flow[1].mult <= -1.5) then
					Audio.PlaySound("gasterintrorev5")
				elseif (flow[1].mult <= -1.33) then
					Audio.PlaySound("gasterintrorev33")
				elseif (flow[1].mult <= -1.25) then
					Audio.PlaySound("gasterintrorev25")
				else
					Audio.PlaySound("gasterintrorev")
				end
				self.rs1 = true
			end
			if (self.rs2 == false and timeDiff < self.laserDelay + 2.018) then
				if (flow[1].mult <= -1.5) then
					Audio.PlaySound("gasterfirerev5")
				elseif (flow[1].mult <= -1.33) then
					Audio.PlaySound("gasterfirerev33")
				elseif (flow[1].mult <= -1.25) then
					Audio.PlaySound("gasterfirerev25")
				else
					Audio.PlaySound("gasterfirerev")
				end
				self.rs2 = true
			end
		end
		
		
		if (timeDiff > 0) then
			if (timeDiff < phase1length) then
				if (self.s1 == false) then
					self.s1 = true
					if (#flow == 0) then
						Audio.PlaySound("gasterintro")
					elseif (flow[1].mult >= 1.5) then
						Audio.PlaySound("gasterintro5")
					elseif (flow[1].mult >= 1.4) then
						Audio.PlaySound("gasterintro4")
					elseif (flow[1].mult >= 1.33) then
						Audio.PlaySound("gasterintro33")
					elseif (flow[1].mult >= 1.25) then
						Audio.PlaySound("gasterintro25")
					elseif (flow[1].mult >= 1.2) then
						Audio.PlaySound("gasterintro2")
					elseif (flow[1].mult >= 1.125) then
						Audio.PlaySound("gasterintro125")
					else
						Audio.PlaySound("gasterintro")
					end
				end
				if (self.endX == -42) then
					self.endX = Player.absx
				end
				if (self.endY == -42) then
					self.endY = Player.absy
				end
				--This is a way to make it so the blasters move a lot at first, then sharply slow down.
				local diffsqrt = (timeDiff)^(0.3)
				local conssqrt = (phase1length)^(0.3)
				local diffX = self.endX - self.startX
				local diffY = self.endY - self.startY
				local rot = 0

				if (self.rotation < 180) then
					rot = (self.rotation * diffsqrt/conssqrt)
				else
					rot = 360 - ((360 - self.rotation) * diffsqrt/conssqrt)
				end
				
				self.bullet.MoveToAbs(self.startX + (diffX * (diffsqrt/conssqrt)), self.startY + (diffY * (diffsqrt/conssqrt)))
				self.bullet.sprite.rotation = -rot
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("gaster" .. self.size .. "/gb" .. rot,
				--local bullet = CreateProjectileAbs("gaster" .. self.size .. "/gb0",
				--		self.startX + (diffX * (diffsqrt/conssqrt)),
				--		self.startY + (diffY * (diffsqrt/conssqrt)))
				--bullet.sprite.rotation = -rot
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)

			elseif (timeDiff < self.laserDelay) then
				self.bullet.MoveToAbs(self.endX,self.endY)
				self.bullet.sprite.rotation = -self.rotation
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("gaster" .. self.size .. "/gb" .. (self.rotation / 5), self.endX, self.endY)
				--local bullet = CreateProjectileAbs("gaster" .. self.size .. "/gb0", self.endX, self.endY)
				--bullet.sprite.rotation = -self.rotation
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)

			else
				--Currently firing laser.
				if (self.s2 == false) then
					self.s2 = true
					if (#flow == 0) then
						Audio.PlaySound("gasterfire")
					elseif (flow[1].mult >= 1.5) then
						Audio.PlaySound("gasterfire5")
					elseif (flow[1].mult >= 1.4) then
						Audio.PlaySound("gasterfire4")
					elseif (flow[1].mult >= 1.33) then
						Audio.PlaySound("gasterfire33")
					elseif (flow[1].mult >= 1.25) then
						Audio.PlaySound("gasterfire25")
					elseif (flow[1].mult >= 1.2) then
						Audio.PlaySound("gasterfire2")
					elseif (flow[1].mult >= 1.125) then
						Audio.PlaySound("gasterfire125")
					else
						Audio.PlaySound("gasterfire")
					end
				end
				local laserDiff = timeDiff - self.laserDelay
				local curFrame = math.floor(laserDiff / (1/30))
				local diffpow = (laserDiff^4 * 1000)

				local gbx = 0
				local gby = 0
				local laserx = 0
				local lasery = 0
				local laserfile = ""

				--0 = firing down
				if (self.rotation == 0) then
					gbx = self.endX
					gby = math.min(self.endY + diffpow, 680)
					laserx = gbx
					lasery = gby - 690
					if (self.size == LARGE) then lasery = lasery - 60 end
					laserfile = "laser" .. self.size .. "/laserv"
				--90 = firing left
				elseif (self.rotation == 90) then
					gbx = math.min(self.endX + diffpow, 840)
					gby = self.endY
					laserx = gbx - 690
					if (self.size == LARGE) then laserx = laserx - 60 end
					lasery = gby
					laserfile = "laser" .. self.size .. "/laserh"
				--180 = firing up
				elseif (self.rotation == 180) then
					gbx = self.endX
					gby = math.max(self.endY - diffpow, -200)
					laserx = gbx
					lasery = gby + 690
					if (self.size == LARGE) then lasery = lasery + 60 end
					laserfile = "laser" .. self.size .. "/laserv"
				--270 = firing right
				else
					gbx = math.max(self.endX - diffpow, -200)
					gby = self.endY
					laserx = gbx + 690
					if (self.size == LARGE) then laserx = laserx + 60 end
					lasery = gby
					laserfile = "laser" .. self.size .. "/laserh"
				end

				local gbFrame = curFrame
				while (gbFrame > 5) do gbFrame = gbFrame - 2 end
				
				self.bullet.sprite.Set("gbfire/gb_" .. self.size .. "_0_" .. gbFrame)
				self.bullet.MoveToAbs(gbx,gby)
				self.bullet.sprite.rotation = -self.rotation
				self.bullet.SendToTop()
				--local bullet = CreateProjectileAbs("gbfire/gb_" .. self.size .. "_0_" .. gbFrame, gbx, gby)
				--bullet.sprite.rotation = -self.rotation
				--bullet.SetVar('tile',1)
				--table.insert(oneFrameBullets, bullet)
				if (curFrame >= 4) then
					--Creating the laser! Keep this as one frame bullet because hitbox changes
					if (timeDiff < (self.laserDelay + self.laserLength)) then
						local laserFrame = curFrame - 4
						while (laserFrame > 10) do laserFrame = laserFrame - 8 end
						local bullet = CreateProjectileAbs(laserfile .. laserFrame, laserx, lasery)
						--bullet.SetVar('tile',1)
						bullet.SetVar('damage',self.damage)
						table.insert(oneFrameBullets, bullet)
					--Laser should be fading out!
					else
						local laserDiff2 = laserDiff - self.laserLength
						local laserFrame = math.floor(laserDiff2 / (1/30))
						if (laserFrame <= 9) then
							local bullet = CreateProjectileAbs(laserfile .. "fade" .. laserFrame, laserx, lasery)
							bullet.SetVar('tile',1)
							table.insert(oneFrameBullets, bullet)
						else
							--table.remove(gbs,i)
						end
					end
				end
			end
		else
			self.bullet.MoveToAbs(-500,-500)
		end
	end

	return self
end

return objects