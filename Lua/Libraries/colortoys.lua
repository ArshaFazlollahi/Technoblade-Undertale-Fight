-- Returns an RBG color from a hue value and an intensity value
----------------------------------------------------------------------------------------------------------------------
-- @param hue hue value from 0 to 2 * Math.pi (ideally, going beyond that range will yeild unexpected results)
-- @param intensity brightness value from 0 to 1 (ideally. Going beyond that range will also yield unexpected results)
----------------------------------------------------------------------------------------------------------------------
function hue_to_rgb(hue, intensity)
    if hue < math.pi / 3 then
	    local diff = hue / (math.pi / 3)
		return {intensity, intensity * diff, 0}
	elseif hue < 2 * math.pi / 3 then
		local diff = (hue - math.pi / 3) / (math.pi / 3)
		return {intensity * (1 - diff), intensity, 0}
	elseif hue < math.pi then
		local diff = (hue - 2 * math.pi / 3) / (math.pi / 3)
		return {0, intensity, intensity * diff}
	elseif hue < 4 * math.pi / 3 then
		local diff = (hue - math.pi) / (math.pi / 3)
		return {0, intensity * (1 - diff), intensity}
	elseif hue < 5 * math.pi / 3 then
		local diff = (hue - 4 * math.pi / 3) / (math.pi / 3)
		return {intensity * diff, 0, intensity}
	else
		local diff = (hue - 5 * math.pi / 3) / (math.pi / 3)
		return {intensity, 0, intensity * (1 - diff)}
	end
end

-- Some demonic function that helps with hsv_to_rgb
--------------------------------------------------------------
-- @param p
-- @param q
-- @param t
--
-- Credit for this function goes to Garry Tan
-- http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
-------------------------------------------------------------------------------
function qphue_to_rgb(p,q,t)
    if (t < 0) then t = t + 1 end
    if (t > 1) then t = t - 1 end
    if (t < 1/6) then return p + (q - p) * 6 * t end
    if (t < 1/2) then return q end
    if (t < 2/3) then return p + (q - p) * (2/3 - t) * 6 end
    return p
end

-- Returns an RGB color from an HSV (hue, saturation, lightness) value
--------------------------------------------------------------------------------------------------------------------
-- @param hue value from 0 to 2 * Math.pi (ideally. Going beyond that range will yield unexpected results)
-- @param saturation value from 0 to 1 (100% is a pure color, 50% is a muted color, 0% is color free))
-- @param lightness value from 0 to 1 (0% will yield black, 50% is standard, 100% will get white -- 70% for pastels)
--
-- Credit for formulas goes to Garry Tan
-- http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c
--------------------------------------------------------------------------------------------------------------------
function hsv_to_rgb(hue, saturation, lightness)
	local q = nil
	
	if lightness < 0.5 then
	    q = lightness * (1 + saturation)
	else
		q = lightness + saturation - lightness * saturation
	end
	
	local p = 2 * lightness - q

	return{qphue_to_rgb(p, q, (hue / (2 * math.pi)) + 1 / 3),
		qphue_to_rgb(p, q, (hue / (2 * math.pi))),
		qphue_to_rgb(p, q, (hue / (2 * math.pi)) - 1 / 3)}
end

-- Returns a color on a linear gradient at pos distance from color1 between color1 and color2
-------------------------------------------------------------------------------------------------------------
-- @param color1 first color value {r,g,b}
-- @param color2 second color vlue {r,g,b}
-- @param pos distance away from color 1. The distance away from color2 is 1 - pos (should be btween 0 and 1)
-------------------------------------------------------------------------------------------------------------
function color_between(color1, color2, pos)
    local color_1_comp = 1 - pos
	local color_2_comp = pos
	return {color1[1] * color_1_comp + color2[1] * color_2_comp,
			color1[2] * color_1_comp + color2[2] * color_2_comp,
			color1[3] * color_1_comp + color2[3] * color_2_comp}
end

-- Color intensity multiplication function - Multiplies a color by a constant value
------------------------------------------------------------------------------------------------
-- @param color RGB color value
-- @param multiplier must be >= 0, each RGB value will be multiplied by this and clamped above 1
------------------------------------------------------------------------------------------------
function color_multiply(color, multiplier)
    return {math.min(color[1] * multiplier, 1.0), math.min(color[2] * multiplier, 1.0), math.min(color[3] * multiplier, 1.0)}
end


-- Gradient Class - An RGB gradient specifies colors at equidistant points on an axis from 0 to 1.
--                  When getColorAt() is used to pick a color from the axis, it is chosen as the
--                  color value of the weigthed average between the two colors that point sits between
------------------------------------------------------------------------------------------------------
Gradient = {}
Gradient.__index = Gradient

-- Gradient Constructor - A gradient contains a table of different colors that make up the gradient.
----------------------------------------------------------------------------------------------------
-- @param color_table a table containing N colors (a single color is an {r,g,b} color)
----------------------------------------------------------------------------------------------------
function Gradient.new(color_table)
	local self = setmetatable({}, Gradient)
	self.color_table = color_table
	return self
end

-- Gradient Color Selection function - Returns color at position from the gradient
--------------------------------------------------------------------------------------------------------
-- @param self Gradient object
-- @param pos Value between 0 and 1 with 0 being the beginning of the gradient and 1 being the end of it
--------------------------------------------------------------------------------------------------------
function Gradient.getColorAt(self, pos)
    local color_table = self.color_table
	local color1 = (math.floor(((#color_table - 1) * pos)) % #color_table) + 1 --2
	local color2 = color1 + 1 --3
	
	-- Trying to go higher is outside the gradient, just return the highest color value --
	if color2 > #color_table then
	    return color_table[#color_table]
	end

	local pos_of_one = (color1 - 1) / (#color_table - 1) --
	local pos_from_one = (pos - pos_of_one) * (#color_table - 1)
	
	return color_between(color_table[color1], color_table[color2], pos_from_one)
end