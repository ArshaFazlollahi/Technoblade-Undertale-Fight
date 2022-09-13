function CreateVSprite(spritename)
	local vsprite = {
		sprite = CreateSprite(spritename),
		data = {}
	}
	function vsprite.SetVar(name, value)
		vsprite.data[name] = value
	end
	function vsprite.GetVar(name)
		return vsprite.data[name]
	end
	return vsprite
end