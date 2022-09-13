fui_mask = nil
fui_container = nil

fui_var_hp = 0
fui_var_lasthp = 0
fui_hp = nil
fui_hpbars = {}
fui_currenthp = {}
fui_hpdivider = nil
fui_maxhp = {}

fui_var_lastname = ""
fui_name = {}

fui_var_lastlv = 0
fui_lv = nil
fui_lvnum = {}

fui_var_selectedbtn = 0
fui_var_lastselected = 0
fui_var_buttonsprites = {"fakeui/buttons/fight_", "fakeui/buttons/act_", "fakeui/buttons/item_", "fakeui/buttons/mercy_"}
fui_buttons = {}

fui_fakePlayer = nil

fui_visible = true
fui_selectingButton = false
fui_inMenu = true

fui_initialized = false

function fui_init()
	fui_mask = CreateSprite("fakeui/mask")
	fui_mask.SetPivot(0, 0)
	fui_mask.MoveTo(0, 0)

	fui_container = CreateSprite("fakeui/empty")
	fui_container.SetPivot(0, 0)
	fui_container.MoveTo(0, 0)

	fui_var_lastname = Player.name
	fui_redrawName()

	fui_var_lastlv = Player.lv
	fui_lv = CreateSprite("fakeui/lvtext")
	fui_lv.SetPivot(0, 0)
	fui_lv.SetAnchor(0, 0)
	fui_lv.SetParent(fui_container)
	fui_redrawLV()
	fui_repositionLVText()

	fui_var_hp = fui_getWeirdHP(Player.hp)
	fui_var_lasthp = fui_var_hp

	fui_hp = CreateSprite("UI/spr_hpname_0")
	fui_hp.SetPivot(0, 0)
	fui_hp.SetAnchor(0, 0)
	fui_hp.SetParent(fui_container)
	fui_hp.MoveTo(244, 65)
	fui_redrawHP()
	fui_initHPText()

	fui_var_selectedbtn = 0
	fui_var_lastselected = 0
	fui_initButtons()

	fui_mask.SendToBottom()

	fui_initialized = true
end

function fui_initHPText()
	fui_currenthp[1] = CreateSprite("fakeui/font/" .. math.floor(Player.hp / 10))
	fui_currenthp[1].SetPivot(0, 0)
	fui_currenthp[1].SetAnchor(0, 0)
	fui_currenthp[1].SetParent(fui_hp)
	fui_currenthp[2] = CreateSprite("fakeui/font/" .. Player.hp % 10)
	fui_currenthp[2].SetPivot(0, 0)
	fui_currenthp[2].SetAnchor(0, 0)
	fui_currenthp[2].SetParent(fui_hp)

	fui_hpdivider = CreateSprite("fakeui/font/slash")
	fui_hpdivider.SetPivot(0, 0)
	fui_hpdivider.SetAnchor(0, 0)
	fui_hpdivider.SetParent(fui_hp)

	local maxhp = (16 + (Player.lv * 4))
	fui_maxhp[1] = CreateSprite("fakeui/font/" .. math.floor(maxhp / 10))
	fui_maxhp[1].SetPivot(0, 0)
	fui_maxhp[1].SetAnchor(0, 0)
	fui_maxhp[1].SetParent(fui_hp)
	fui_maxhp[2] = CreateSprite("fakeui/font/" .. maxhp % 10)
	fui_maxhp[2].SetPivot(0, 0)
	fui_maxhp[2].SetAnchor(0, 0)
	fui_maxhp[2].SetParent(fui_hp)

	fui_repositionHPText()
end

function fui_initButtons()
	for i=1,4 do
		fui_buttons[i] = CreateSprite(fui_var_buttonsprites[i] .. "0")
		fui_buttons[i].SetPivot(0.5, 0.5)
		fui_buttons[i].SetAnchor(0, 0)
		fui_buttons[i].SetParent(fui_container)
	end
	fui_buttons[1].MoveTo(31 + (fui_buttons[1].width / 2), 6 + (fui_buttons[1].height / 2)) --FIGHT
	fui_buttons[2].MoveTo(184 + (fui_buttons[2].width / 2), 6 + (fui_buttons[2].height / 2)) --ACT
	fui_buttons[3].MoveTo(344 + (fui_buttons[3].width / 2), 6 + (fui_buttons[3].height / 2)) --ITEM
	fui_buttons[4].MoveTo(499 + (fui_buttons[4].width / 2), 6 + (fui_buttons[4].height / 2)) --MERCY
end

function fui_update()
	fui_updateHP()
	fui_updateName()
	fui_updateLV()
	fui_updateButtons()
	if not fui_visible then
		fui_hide()
	else
		fui_show()
	end
	fui_var_lastname = Player.name
	fui_var_lastlv = Player.lv
	fui_var_lasthp = fui_var_hp
	fui_var_lastselected = fui_var_selectedbtn
end

function fui_updateHP()
	fui_var_hp  = fui_getWeirdHP(Player.hp)
	if(fui_var_lastlv ~= Player.lv) then
		fui_redrawHP()
		local maxhp = (16 + (Player.lv * 4))
		fui_maxhp[1].Set("fakeui/font/" .. math.floor(maxhp / 10))
		fui_maxhp[2].Set("fakeui/font/" .. maxhp % 10)
	end
	if(fui_var_lasthp ~= fui_var_hp) then
		for i=1,#fui_hpbars do
			if(fui_var_hp >= i) then
				fui_hpbars[i].color = {1.0, 1.0, 0}
			else
				fui_hpbars[i].color = {1.0, 0, 0}
			end
		end
		fui_currenthp[1].Set("fakeui/font/" .. math.floor(Player.hp / 10))
		fui_currenthp[2].Set("fakeui/font/" .. Player.hp % 10)
	end
	fui_repositionHPText()
end

function fui_updateName()
	if(fui_var_lastname ~= Player.name) then
		fui_redrawName()
	end
end

function fui_updateLV()
	if(fui_var_lastlv ~= Player.lv) then
		fui_redrawLV()
	end
	fui_repositionLVText()
end

function fui_updateButtons()
	if(fui_selectingButton and Player.absy == 25) then
		if(Player.absx == 48) then
			fui_var_selectedbtn = 1
		elseif(Player.absx == 202) then
			fui_var_selectedbtn = 2
		elseif(Player.absx == 361) then
			fui_var_selectedbtn = 3
		elseif(Player.absx == 515) then
			fui_var_selectedbtn = 4
		end
	end
	if not fui_inMenu then
		fui_var_selectedbtn = 0
	end
	if(fui_selectingButton and fui_var_selectedbtn ~= 0 and fui_fakePlayer == nil) then
		Player.sprite.Set("fakeui/empty")
		fui_fakePlayer = CreateSprite("ut-heart")
		fui_fakePlayer.SetAnchor(0.15, 0.45)
		fui_fakePlayer.color = {1.0, 0, 0}
		fui_fakePlayer.SetParent(fui_buttons[fui_var_selectedbtn])
		fui_fakePlayer.MoveTo(0, 0)
		fui_fakePlayer.rotation = fui_buttons[fui_var_selectedbtn].rotation
	elseif((fui_var_selectedbtn == 0 or (not fui_selectingButton)) and fui_fakePlayer ~= nil) then
		Player.sprite.set("ut-heart")
		fui_fakePlayer.Remove()
		fui_fakePlayer = nil
	end
	if(fui_var_selectedbtn ~= fui_var_lastselected) then
		for i=1,#fui_buttons do
			if(fui_var_selectedbtn == i) then
				fui_buttons[i].Set(fui_var_buttonsprites[i] .. "1")
			else
				fui_buttons[i].Set(fui_var_buttonsprites[i] .. "0")
			end
		end
		if(fui_fakePlayer ~= nil) then
			fui_fakePlayer.SetParent(fui_buttons[fui_var_selectedbtn])
			fui_fakePlayer.MoveTo(0, 0)
			fui_fakePlayer.rotation = fui_buttons[fui_var_selectedbtn].rotation
		end
	end
end

function fui_repositionHPText()
	fui_currenthp[1].MoveTo(fui_hpbars[#fui_hpbars].x + 15, -3)
	fui_currenthp[2].MoveTo(fui_currenthp[1].x + fui_currenthp[1].width + 3, fui_currenthp[1].y)
	fui_hpdivider.MoveTo(fui_currenthp[2].x + fui_currenthp[2].width + 17, -3)
	fui_maxhp[1].MoveTo(fui_hpdivider.x + fui_hpdivider.width + 17, -3)
	fui_maxhp[2].MoveTo(fui_maxhp[1].x + fui_maxhp[1].width + 3, fui_maxhp[1].y)
end

function fui_repositionLVText()
	fui_lv.MoveTo(fui_name[#fui_name].x + fui_name[#fui_name].width + 31, fui_name[1].y)
	for i=1,#fui_lvnum do
		if(i == 1) then
			fui_lvnum[i].MoveTo(fui_lv.x + fui_lv.width + 17, fui_lv.y)
		else
			fui_lvnum[i].MoveTo(fui_lvnum[i-1].x + fui_lvnum[i-1].width + 3, fui_lvnum[i-1].y)
		end
	end
end

function fui_redrawHP()
	for i=1,#fui_hpbars do
		fui_hpbars[i].Remove()
	end
	fui_hpbars = {}
	local maxhp = fui_getWeirdHP(16 + (Player.lv * 4))
	for i=1,maxhp do
		local hpbar = CreateSprite("fakeui/hpbar")
		hpbar.SetPivot(0, 0)
		hpbar.SetAnchor(0, 0)
		hpbar.SetParent(fui_hp)
		hpbar.x = 30 + i
		hpbar.y = -5
		if(fui_var_hp >= i) then
			hpbar.color = {1.0, 1.0, 0}
		else
			hpbar.color = {1.0, 0, 0}
		end
		fui_hpbars[i] = hpbar
	end
end

function fui_redrawName()
	for i=1,#fui_name do
		fui_name[i].Remove()
	end
	fui_name = {}
	for i=1,Player.name:len() do
		local letter = CreateSprite("fakeui/font/" .. Player.name:sub(i,i):lower())
		letter.SetPivot(0, 0)
		letter.SetAnchor(0, 0)
		letter.SetParent(fui_container)
		if(i > 1) then
			letter.MoveTo(fui_name[i-1].x + fui_name[i-1].width + 3, fui_name[i-1].y)
		else
			letter.MoveTo(30, 62)
		end
		fui_name[i] = letter
	end
end

function fui_redrawLV()
	for i=1,#fui_lvnum do
		fui_lvnum[i].Remove()
	end
	fui_lvnum = {}
	local digits = string.len("" .. Player.lv)
	for i=1,digits do
		local num = CreateSprite("fakeui/font/" .. string.sub("" .. Player.lv, i, i))
		num.SetPivot(0, 0)
		num.SetAnchor(0, 0)
		num.SetParent(fui_container)
		fui_lvnum[i] = num
	end
end

function fui_getWeirdHP(hp)
	return hp + fui_round(hp / 5)
end

function fui_round(num)
	if(num - math.floor(num) < 0.5) then
		return math.floor(num)
	else
		return math.ceil(num)
	end
end

function fui_hide()
	fui_mask.alpha = 0
	fui_lv.alpha = 0
	fui_hp.alpha = 0
	fui_currenthp[1].alpha = 0
	fui_currenthp[2].alpha = 0
	fui_hpdivider.alpha = 0
	fui_maxhp[1].alpha = 0
	fui_maxhp[2].alpha = 0
	if(fui_fakePlayer ~= nil) then
		fui_fakePlayer.alpha = 0
		Player.sprite.Set("ut-heart")
	end
	for i=1,#fui_name do
		fui_name[i].alpha = 0
	end
	for i=1,#fui_lvnum do
		fui_lvnum[i].alpha = 0
	end
	for i=1,#fui_hpbars do
		fui_hpbars[i].alpha = 0
	end
	for i=1,#fui_buttons do
		fui_buttons[i].alpha = 0
	end
end

function fui_show()
	fui_mask.alpha = 1
	fui_lv.alpha = 1
	fui_hp.alpha = 1
	fui_currenthp[1].alpha = 1
	fui_currenthp[2].alpha = 1
	fui_hpdivider.alpha = 1
	fui_maxhp[1].alpha = 1
	fui_maxhp[2].alpha = 1
	if(fui_fakePlayer ~= nil) then
		fui_fakePlayer.alpha = 1
		Player.sprite.Set("fakeui/empty")
	end
	for i=1,#fui_name do
		fui_name[i].alpha = 1
	end
	for i=1,#fui_lvnum do
		fui_lvnum[i].alpha = 1
	end
	for i=1,#fui_hpbars do
		fui_hpbars[i].alpha = 1
	end
	for i=1,#fui_buttons do
		fui_buttons[i].alpha = 1
	end
end