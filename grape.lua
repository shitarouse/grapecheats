local function svc(n)
	local s = game:GetService(n)
	return cloneref and cloneref(s) or s
end
--[[
СДЕЛАЛ - T.ME/SHITAROMAKE
SHITARO.LOL | T.ME/SHITAROUSE
]]--
local plrs = svc("Players")
local rs = svc("RunService")
local uis = svc("UserInputService")
local txs = svc("TextService")
local hs = svc("HttpService")
local gsv = svc("GuiService")
local lp = plrs.LocalPlayer

local rgb, hsv, c3 = Color3.fromRGB, Color3.fromHSV, Color3.new
local ud2, ofs, scl, ud, v2 = UDim2.new, UDim2.fromOffset, UDim2.fromScale, UDim.new, Vector2.new
local cseq, ckp, nseq = ColorSequence.new, ColorSequenceKeypoint.new, NumberSequence.new
local clamp, floor, max, min, abs = math.clamp, math.floor, math.max, math.min, math.abs
local sfmt, ssub, supper, slower, sgsub, smatch = string.format, string.sub, string.upper, string.lower, string.gsub, string.match
local tfind, tremove, tclear, tconcat, tsort, tclone = table.find, table.remove, table.clear, table.concat, table.sort, table.clone
local spawn, delay, defer = task.spawn, task.delay, task.defer

local xal = Enum.TextXAlignment
local aix, aiy, aixy, ainone = Enum.AutomaticSize.X, Enum.AutomaticSize.Y, Enum.AutomaticSize.XY, Enum.AutomaticSize.None
local ha, va = Enum.HorizontalAlignment, Enum.VerticalAlignment
local mb1, mb2, mb3 = Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3
local mmove, tch = Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch
local kunk = Enum.KeyCode.Unknown
local white, black = c3(1, 1, 1), c3(0, 0, 0)

local genv = getgenv and getgenv() or _G
local b64d = base64decode

local maid = {}
maid.__index = maid

function maid.new()
	return setmetatable({}, maid)
end

function maid:add(x)
	self[#self + 1] = x
	return x
end

function maid:clean()
	for i = #self, 1, -1 do
		local x = self[i]
		self[i] = nil
		local t = typeof(x)
		if t == "RBXScriptConnection" then
			x:Disconnect()
		elseif t == "Instance" then
			x:Destroy()
		elseif t == "function" then
			pcall(x)
		elseif t == "thread" then
			pcall(task.cancel, x)
		elseif t == "table" and type(x.clean) == "function" then
			x:clean()
		end
	end
end

local function con(s, f, md)
	local c = s:Connect(f)
	if md then
		md[#md + 1] = c
	end
	return c
end

local function jenc(t)
	local ok, r = pcall(hs.JSONEncode, hs, t)
	return ok and r or nil
end

local function jdec(s)
	if type(s) ~= "string" or s == "" then
		return nil
	end
	local ok, r = pcall(hs.JSONDecode, hs, s)
	if ok and type(r) == "table" then
		return r
	end
	return nil
end

local fs = {}

function fs.dir(p)
	local ok, r = pcall(isfolder, p)
	if ok and not r then
		pcall(makefolder, p)
	end
end

function fs.has(p)
	local ok, r = pcall(isfile, p)
	return ok and r == true
end

function fs.read(p)
	if fs.has(p) then
		local ok, r = pcall(readfile, p)
		if ok then
			return r
		end
	end
	return nil
end

function fs.write(p, s)
	return (pcall(writefile, p, s))
end

function fs.del(p)
	if fs.has(p) then
		pcall(delfile, p)
	end
end

function fs.list(p)
	local ok, r = pcall(isfolder, p)
	if ok and r then
		local ok2, l = pcall(listfiles, p)
		if ok2 and type(l) == "table" then
			return l
		end
	end
	return {}
end

local function hex(c, a)
	local s = sfmt("#%02X%02X%02X", floor(c.R * 255 + 0.5), floor(c.G * 255 + 0.5), floor(c.B * 255 + 0.5))
	if a then
		s ..= sfmt("%02X", floor(a * 255 + 0.5))
	end
	return s
end

local function unhex(s)
	if type(s) ~= "string" then
		return nil
	end
	s = sgsub(s, "[^%x]", "")
	local n = #s
	if n ~= 6 and n ~= 8 then
		return nil
	end
	local r, g, b = tonumber(ssub(s, 1, 2), 16), tonumber(ssub(s, 3, 4), 16), tonumber(ssub(s, 5, 6), 16)
	return rgb(r, g, b), n == 8 and tonumber(ssub(s, 7, 8), 16) / 255 or 1
end

local kshort = {
	Insert = "INS", Delete = "DEL", Home = "HOME", End = "END", PageUp = "PGUP", PageDown = "PGDN",
	LeftShift = "LSHIFT", RightShift = "RSHIFT", LeftControl = "LCTRL", RightControl = "RCTRL",
	LeftAlt = "LALT", RightAlt = "RALT", LeftSuper = "LWIN", RightSuper = "RWIN", CapsLock = "CAPS",
	Backspace = "BKSP", Return = "ENTER", Space = "SPACE", Tab = "TAB", Escape = "ESC",
	MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3",
	Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9",
	Backquote = "`", Minus = "-", Equals = "=", LeftBracket = "[", RightBracket = "]", BackSlash = "\\",
	Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/",
	Up = "UP", Down = "DOWN", Left = "LEFT", Right = "RIGHT",
}

local function kname(k)
	if not k then
		return "none"
	end
	local s = kshort[k]
	if not s then
		local np = smatch(k, "^Keypad(.+)$")
		s = np and ("NUM" .. (kshort[np] or supper(np))) or supper(k)
	end
	return slower(s)
end

local function inkey(i)
	if i.KeyCode ~= kunk then
		return i.KeyCode.Name
	end
	local t = i.UserInputType
	if t == mb1 or t == mb2 or t == mb3 then
		return t.Name
	end
	return nil
end

local thm = {
	bg = rgb(14, 14, 14),
	band = rgb(70, 70, 70),
	cbord = rgb(140, 140, 140),
	hbord = rgb(45, 45, 45),
	fbg = rgb(16, 16, 16),
	fbgh = rgb(26, 26, 26),
	fbga = rgb(34, 34, 34),
	fbord = rgb(34, 34, 34),
	btn = rgb(37, 37, 37),
	btnh = rgb(52, 52, 52),
	btna = rgb(66, 66, 66),
	sep = rgb(38, 38, 38),
	acc = rgb(232, 14, 14),
	gold = rgb(222, 166, 38),
	golda = rgb(244, 190, 72),
	sb = rgb(54, 54, 54),
	sbh = rgb(72, 72, 72),
	sba = rgb(90, 90, 90),
	txt = rgb(255, 255, 255),
	dim = rgb(128, 128, 128),
	pop = rgb(14, 14, 14),
	pbord = rgb(66, 66, 66),
	hdr = rgb(40, 40, 40),
	hdrh = rgb(56, 56, 56),
}

local m = {
	w = 502, h = 370, hc = 56,
	px = 20, ty = 5, th = 22, ay = 32, ah = 5, cdy = 34,
	tby = 46, tbh = 25, tbg = 5,
	cy = 80, ch = 256, cg = 9, cvy = 354,
	fh = 25, sp = 4, rr = 10, hr = 9,
	aw = 12, ahh = 14, ax = 7, tx = 30,
	isp = 6, swr = 4, gw = 16, gp = 2, gr = 4,
	sbw = 16, sbr = 3, cp = 3, bw = 4, fpx = 8,
	ts = 18, tts = 22, cts = 18,
	tl = 22, sel = 22, wp = 8, tps = 55,
}

local fnt = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular)

local defs = {
	Frame = { BorderSizePixel = 0 },
	ScrollingFrame = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = ud2(0, 0, 0, 0),
		AutomaticCanvasSize = aiy,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ElasticBehavior = Enum.ElasticBehavior.Never,
	},
	TextLabel = { BorderSizePixel = 0, BackgroundTransparency = 1, TextXAlignment = xal.Left, TextSize = m.ts, Text = "", AutoLocalize = false },
	TextButton = { BorderSizePixel = 0, BackgroundTransparency = 1, AutoButtonColor = false, Text = "", TextSize = m.ts, AutoLocalize = false },
	TextBox = { BorderSizePixel = 0, BackgroundTransparency = 1, ClearTextOnFocus = false, TextXAlignment = xal.Left, TextSize = m.ts, Text = "", AutoLocalize = false },
	ImageLabel = { BorderSizePixel = 0, BackgroundTransparency = 1 },
	CanvasGroup = { BorderSizePixel = 0, BackgroundTransparency = 1 },
}

local txtcls = { TextLabel = true, TextButton = true, TextBox = true }

local function mk(cls, p, th)
	local o = Instance.new(cls)
	local d = defs[cls]
	if d then
		for k, v in next, d do
			o[k] = v
		end
	end
	if txtcls[cls] then
		o.FontFace = fnt
		o.TextColor3 = thm.txt
	end
	local par
	if p then
		for k, v in next, p do
			if k == "Parent" then
				par = v
			else
				o[k] = v
			end
		end
	end
	if th then
		for k, v in next, th do
			o[k] = thm[v]
			o:SetAttribute("t_" .. k, v)
		end
	end
	if par then
		o.Parent = par
	end
	return o
end

local function corner(o, r)
	return mk("UICorner", { CornerRadius = ud(0, r or m.rr), Parent = o })
end

local function pill(o)
	return mk("UICorner", { CornerRadius = ud(1, 0), Parent = o })
end

local function pad(o, l, r, t, b)
	return mk("UIPadding", {
		PaddingLeft = ud(0, l or 0),
		PaddingRight = ud(0, r or 0),
		PaddingTop = ud(0, t or 0),
		PaddingBottom = ud(0, b or 0),
		Parent = o,
	})
end

local function vlist(o, p)
	return mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = ud(0, p or 0), Parent = o })
end

local function hlist(o, p, h)
	return mk("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = ud(0, p or 0),
		HorizontalAlignment = h or ha.Left,
		VerticalAlignment = va.Center,
		Parent = o,
	})
end

local bsin = (function()
	local ok, e = pcall(function()
		return Enum.BorderStrokePosition.Inner
	end)
	return ok and e or nil
end)()

local function bord(o, k, t, tr)
	local s = mk("UIStroke", { Thickness = t or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o }, { Color = k })
	if bsin then
		pcall(function()
			s.BorderStrokePosition = bsin
		end)
	end
	return s
end

local imgs = {
	tri = "iVBORw0KGgoAAAANSUhEUgAAADgAAABACAYAAABP97SyAAAD1klEQVR42t2bT4hVVRzHv+/eK0IUpTKgDYQUBC5cDIgIQtgmyEDIIGghhJsWQZsEERQVAhXcCJPaok2LQJBCoWA2gtKiGFHICoKgAsXxPyqDpu+9Twt/F39czpv3xrl37jkeuMx9Z87lnc/8fp977jvvNx1gStJuSdN60gpJPUnoOWgdAEkPJB2XdEjSNftdbqDJA/YkZfb6mqQDko5Keuz6+6lHEItWYf0XJe2TdDr1tC0By1YFPW2gF1MFrQKqkpKZpeoxS92Z1PycCzAziNz6ZgzyWEp+DgKUwWXuPEk/s0DfrKR/LHIdi1BhAF1JE5JO2TFhfdiYTsyAZQQeSNogaZekuwaKA+3bsUXSL5KOSFrpQPOoCHna+vbzDvAyIGA18LUb0wV67rxsV4HPgCV2XWaH2j5CgLeB5UDuBm4Ezrixj218387LdgHY4q4rgE6MgMtsQF4B/Qj4sxJRAqCngIkYQIcBdlzKlecvAruBe+66ErTnUvgRcARY6d4wjxUwNME3gG9i93O+gGVf4V6/BZyN1c9nAZSLhI/oNuCv2PxcCKBP23LcS8Be4H4sftYBGJrgm8C3MfhZJ2DIz7eBn9r0s27AQX5uB/5uw8+mAEN+vgJ84fz0TjbmZ9OAo/rZb8rPxQIM+fkO8HPTfi4mYMjPDPgE+LcpP9sADPm5AjgIzNbtZ5uAoQmuAU7U6WcMgCE/3wWm6/AzFsCQnwXwKXB5IX7GBhhK2zHgMPDwWfyMFdBHojxfC3wXmO8gP/OYIziXn5uAczbfXmX+Pm0vAR9nCX5hdFXSvdAmth3l9uerklbFHkHv4jjwpZunT1Hv4kNzdnnMKerXtaXA58D1ClD1AzXm6NqYbzKdStTeB36trIch36aBzTEvE9UbyTrgh8BCX71jXra1snApncX8qDYOTLrodAeseaVnY8OeSdsEHOZZd0TPitgetmv3LNYPvLV5FtuWRe2etQm4KJ61AVj17IMmPWtz43c9MNW0Z21s3b8GHK9s1zfmWdOA3rMXgJ3AzYBbjXnWFGDVsw+BP0bYXqjds6a/AG3ds6a+wo7Gs7qKEKL1bCGAWQqe1VEIFLVn8wX0pVxJeDZfwBs20R3ArRQ8m+sI1YvOWnH6665WNA+UO5+XtFfSjzHXjY5SENupVP5escrfr6yE0pdbRteKAf19m3jf1YD+J2nS/rfiRiq124MiiIOUpO8tHS+5P0w3hW3wLADWtbTMzbP3JG01uLJsuZvKPr+PYLKeDXMQ59Mj8+xgSp6NGsGTkvZL+i01z4ZF8HdJe+xG4tez5OEk6X8X/wXc6cU7ogAAAABJRU5ErkJggg==",
	trf = "iVBORw0KGgoAAAANSUhEUgAAADgAAABACAYAAABP97SyAAAB9UlEQVR42t3ZTUrDQBiA4bfpXEKv5M7zKOrG2oU7f+8gCN15BoUu1CMIFsGtqE3HRb9IKDUmzfx9M9BFk9XLfM8kpQNr7R2wB9yzXAYoAUsGa2CttcAHcAWMgZncG0qo+sASKOT7DBgBF8B37fpC+w5a2S0j16fAITDRPrZVYLVWQycSOtUauhrIykgWMqqXMrqv2nz+FVitUmKQuJHEqvH5XyDafbYJVO2zS6BKn5sEqvLZJ1CFz76Byft0FZisT9eByfn0FZiMT5+BSfgMERjVZ8jAKD5jBAb1GSswmM/Ygd59phLozWdqgc59phjo1GfKgU58agjs5VNT4EY+tQV29qk1sLVP7YFNPs+BMpfAdWP7BJwW5LMG8qk2bBvYMpnELWrPxE/gDDgG3k0GY7mo+bsFDoDHKrhQHDaXkRwCD8AOsCtxRu6pPGTqJ+aLnJjXEjys7ervA1GzszHw1vROajJwZmT31r5wFxk4m2v8udTJWdMyOTjTENjLWdMqcnCWqkFnzlIbUefOUgn05iy2Qe/OYhoM4izGiAZ1FjIwirMQBqM6820wujNfI5qMM9eByTlzZTBZZy4MJu2sz4iqcLZJoCpnXQyqdNbWoFpn/42orXn6Emcnmpy13cEb4Ijl3051Z6qXAZ6BfTlIqmtlDnEAPyQk7FOJhuNfAAAAAElFTkSuQmCC",
	chk = "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAAFklEQVR42mM+c+aMlJQUs5SUlI+PDwAjCQPrKm3L6wAAAABJRU5ErkJggg==",
}
local ast = {}

local lib = {
	flags = {},
	els = {},
	fl = {},
	dir = "grape",
	thm = thm,
	m = m,
	ver = "1.0.0",
}

local st = {
	md = maid.new(),
	pops = {},
	drag = {},
	bmap = {},
	open = true,
	exp = false,
	shown = true,
	dead = false,
	unl = {},
	ln = 0,
}

local cfgref = function() end

local function inside(o, p)
	local a, s = o.AbsolutePosition, o.AbsoluteSize
	return p.X >= a.X and p.Y >= a.Y and p.X <= a.X + s.X and p.Y <= a.Y + s.Y
end

local function mpos()
	local t = st.tp
	if t then
		return t
	end
	local ml = uis:GetMouseLocation()
	local p = st.probe
	if p then
		return ml + p.AbsolutePosition
	end
	return ml
end

local function ipos(i)
	local p = i.Position
	return v2(p.X, p.Y)
end

local function isptr(t)
	return t == mb1 or t == tch
end

local function startdrag(mv, up, own, i)
	local d = st.drag
	d.mv, d.up, d.own = mv, up, own
	d.ti = i and i.UserInputType == tch and i or nil
end

local function stopdrag(rel)
	local d = st.drag
	local u = d.up
	d.mv, d.up, d.own, d.ti = nil, nil, nil, nil
	if u then
		u(rel)
	end
end

local function hover(o, on, off)
	con(o.MouseEnter, on)
	con(o.MouseLeave, off)
end

local function bfx(b, k0, k1, k2)
	local h, d = false, false
	local function upd()
		b.BackgroundColor3 = thm[d and k2 or (h and k1 or k0)]
	end
	hover(b, function()
		h = true
		upd()
	end, function()
		h, d = false, false
		upd()
	end)
	con(b.MouseButton1Down, function()
		d = true
		upd()
	end)
	con(b.MouseButton1Up, function()
		d = false
		upd()
	end)
	return upd
end

local function arrow(par, pos, open)
	if ast.tri then
		return mk("ImageLabel", { AnchorPoint = v2(0.5, 0.5), Position = pos, Size = ofs(m.aw, m.ahh), Image = ast.tri, Rotation = open and 90 or 0, Parent = par }, { ImageColor3 = "txt" })
	end
	return mk("TextLabel", { AnchorPoint = v2(0.5, 0.5), Position = pos, Size = ofs(m.ahh, m.ahh), TextXAlignment = xal.Center, Text = open and "▽" or "▷", Parent = par })
end

local function aset(a, open)
	if a:IsA("ImageLabel") then
		a.Rotation = open and 90 or 0
	else
		a.Text = open and "▽" or "▷"
	end
end

local function checker(par, cell, r)
	if not ast.chk then
		return nil
	end
	local c = mk("ImageLabel", {
		Size = scl(1, 1),
		Image = ast.chk,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = ofs(cell * 2, cell * 2),
		ResampleMode = Enum.ResamplerMode.Pixelated,
		Parent = par,
	})
	if r then
		corner(c, r)
	end
	return c
end

local function swatch(par, w, h, lo)
	local b = mk("TextButton", { Size = ofs(w, h), LayoutOrder = lo or 0, Parent = par })
	local ck = checker(b, min(w, h) / 2.99, m.swr)
	local cf = mk("Frame", { Size = scl(1, 1), Parent = b })
	corner(cf, m.swr)
	return b, ck, cf
end

local function mkcheck(p, sz)
	local h = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Visible = false, Parent = p })
	local pd = max(1, floor(sz / 6))
	local s = sz - pd * 2
	local t = max(s / 5, 1)
	s -= t * 0.5
	local x0, y0 = pd + t * 0.25, pd + t * 0.25
	local th = s / 3
	local bx, by = x0 + th, y0 + s - th * 0.5
	local pts = { v2(bx - th, by - th), v2(bx, by), v2(bx + th * 2, by - th * 2) }
	for i = 1, 2 do
		local a, b = pts[i], pts[i + 1]
		local d = b - a
		local u = d.Unit * (t * 0.25) * (i == 1 and 1 or -1)
		local c = (a + b) / 2 + u
		mk("Frame", {
			AnchorPoint = v2(0.5, 0.5),
			Position = ofs(c.X, c.Y),
			Size = ofs(d.Magnitude + t * 0.5, t),
			Rotation = math.deg(math.atan2(d.Y, d.X)),
			Parent = h,
		}, { BackgroundColor3 = "gold" })
	end
	return h
end

local popcls = {}
popcls.__index = popcls

local function newpop(o)
	o = o or {}
	local p = setmetatable({ md = maid.new(), isopen = false, px = 0, py = 0, anchor = o.anchor }, popcls)
	local pd = o.pad or m.wp
	p.box = mk("Frame", { Size = ofs(o.w + pd * 2, o.h + pd * 2), Visible = false, Parent = st.pl }, { BackgroundColor3 = "pop" })
	bord(p.box, "pbord")
	mk("TextButton", { Size = scl(1, 1), ZIndex = 0, Parent = p.box })
	p.c = mk("Frame", { BackgroundTransparency = 1, Position = ofs(pd, pd), Size = ofs(o.w, o.h), Parent = p.box })
	return p
end

function popcls:clampit()
	local b = self.box
	if not b.Parent or not st.root then
		return
	end
	local sc = st.us.Scale
	local ap, gp, gs, as = st.root.AbsolutePosition, st.probe.AbsolutePosition, st.gui.AbsoluteSize, b.AbsoluteSize
	local sx = clamp(ap.X + self.px * sc, gp.X + 2, max(gp.X + 2, gp.X + gs.X - as.X - 2))
	local sy = clamp(ap.Y + self.py * sc, gp.Y + 2, max(gp.Y + 2, gp.Y + gs.Y - as.Y - 2))
	b.Position = ofs((sx - ap.X) / sc, (sy - ap.Y) / sc)
end

function popcls:place(sx, sy)
	local sc = st.us.Scale
	local ap = st.root.AbsolutePosition
	self.px, self.py = (sx - ap.X) / sc, (sy - ap.Y) / sc
	self.box.Position = ofs(self.px, self.py)
	self:clampit()
	self.md:add(self.box:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		self:clampit()
	end))
end

function popcls:hide()
	if not self.isopen then
		return
	end
	self.isopen = false
	self.md:clean()
	if st.drag.own == self then
		stopdrag()
	end
	local oc = self.onclose
	if oc then
		self.onclose = nil
		oc()
	end
	self.box:Destroy()
end

local function closefrom(i)
	local ps = st.pops
	for j = #ps, max(i, 1), -1 do
		local p = ps[j]
		ps[j] = nil
		p:hide()
	end
end

local function closeall()
	closefrom(1)
end

local function closepop(p)
	local i = tfind(st.pops, p)
	if i then
		closefrom(i)
	end
end

local function openpop(p, sx, sy)
	closeall()
	local ps = st.pops
	ps[#ps + 1] = p
	p.isopen = true
	p.box.ZIndex = 1 + #ps
	p.box.Visible = true
	p:place(sx, sy)
end

local function popclick(mp)
	local ps = st.pops
	for i = #ps, 1, -1 do
		local p = ps[i]
		if inside(p.box, mp) or (p.anchor and p.anchor.Parent and inside(p.anchor, mp)) then
			closefrom(i + 1)
			return
		end
	end
	closeall()
end

local tip = {}

local function c255(x)
	return floor(x * 255 + 0.5)
end

local function tsz(s)
	local ok, v = pcall(txs.GetTextSize, txs, s, m.ts, Enum.Font.RobotoMono, v2(10000, 10000))
	return ok and v or v2(#s * floor(m.ts / 2), m.ts)
end

local function tipbuild()
	local f = mk("Frame", { Size = ofs(0, 0), Visible = false, ZIndex = 100, Parent = st.pl }, { BackgroundColor3 = "pop" })
	bord(f, "pbord")
	tip.f = f
	tip.n = mk("TextLabel", { Position = ofs(m.wp, m.wp), Size = ofs(0, m.tl), Parent = f })
	tip.s = mk("Frame", { Position = ofs(0, m.wp + m.tl + m.sp), Size = ud2(1, 0, 0, 1), Parent = f }, { BackgroundColor3 = "sep" })
	tip.b, tip.ck, tip.cf = swatch(f, m.tps, m.tps, 1)
	tip.t = mk("TextLabel", { Size = ofs(0, 0), TextYAlignment = Enum.TextYAlignment.Top, Parent = f })
end

local function tipupd(e)
	if not tip.f then
		return
	end
	local c, a = e.val, e.a
	local hn = e.name ~= ""
	tip.n.Text = e.name
	tip.n.Visible = hn
	tip.s.Visible = hn
	tip.cf.BackgroundColor3 = c
	tip.cf.BackgroundTransparency = 1 - a
	if tip.ck then
		tip.ck.Visible = a < 1
	end
	local r, g, b = c255(c.R), c255(c.G), c255(c.B)
	local s
	if e.ha then
		local ai = c255(a)
		s = sfmt("#%02X%02X%02X%02X\nR:%d, G:%d, B:%d, A:%d\n(%.3f, %.3f, %.3f, %.3f)", r, g, b, ai, r, g, b, ai, c.R, c.G, c.B, a)
	else
		s = sfmt("#%02X%02X%02X\nR: %d, G: %d, B: %d\n(%.3f, %.3f, %.3f)", r, g, b, r, g, b, c.R, c.G, c.B)
	end
	tip.t.Text = s
	local tb = tsz(s)
	local nw = hn and tsz(e.name).X or 0
	local cw = max(nw, m.tps + m.isp + tb.X)
	local y = m.wp + (hn and m.tl + m.sp * 2 + 1 or 0)
	tip.n.Size = ofs(cw, m.tl)
	tip.b.Position = ofs(m.wp, y)
	tip.t.Position = ofs(m.wp + m.tps + m.isp, y)
	tip.t.Size = ofs(tb.X + 2, tb.Y)
	tip.f.Size = ofs(cw + m.wp * 2, y + max(m.tps, tb.Y) + m.wp)
end

local function tippos()
	local f = tip.f
	if not f or not f.Visible or not st.root then
		return
	end
	local sc = st.us.Scale
	local ap = st.root.AbsolutePosition
	local mp = mpos()
	local gp, gs, as = st.probe.AbsolutePosition, st.gui.AbsoluteSize, f.AbsoluteSize
	local sx = clamp(mp.X + 16, gp.X + 2, max(gp.X + 2, gp.X + gs.X - as.X - 2))
	local sy = clamp(mp.Y + 8, gp.Y + 2, max(gp.Y + 2, gp.Y + gs.Y - as.Y - 2))
	f.Position = ofs((sx - ap.X) / sc, (sy - ap.Y) / sc)
end

local function tipshow(e)
	if not tip.f or st.drag.mv then
		return
	end
	st.tipe = e
	tipupd(e)
	tip.f.Visible = true
	tippos()
end

local function tiphide(e)
	if e and st.tipe ~= e then
		return
	end
	st.tipe = nil
	if tip.f then
		tip.f.Visible = false
	end
end

local function scroller(par, pos, size, pd, gap)
	local sf = mk("ScrollingFrame", { Position = pos, Size = size, Parent = par })
	local pp = pad(sf, pd, pd, pd, pd)
	vlist(sf, gap)
	local tr = mk("Frame", {
		AnchorPoint = v2(1, 0),
		Position = ud2(pos.X.Scale + size.X.Scale, pos.X.Offset + size.X.Offset, pos.Y.Scale, pos.Y.Offset),
		Size = ud2(0, m.sbw, size.Y.Scale, size.Y.Offset),
		Visible = false,
		ZIndex = 5,
		Parent = par,
	}, { BackgroundColor3 = "bg" })
	local th = mk("TextButton", { BackgroundTransparency = 0, Position = ud2(0, 1, 0, 0), Size = ud2(1, -2, 0, 0), ZIndex = 6, Parent = tr }, { BackgroundColor3 = "sb" })
	corner(th, m.sbr)
	local s = { sf = sf, tr = tr, th = th, on = false, hv = false, dg = false }
	local function col()
		th.BackgroundColor3 = s.dg and thm.sba or (s.hv and thm.sbh or thm.sb)
	end
	local function upd()
		local wh, chh = sf.AbsoluteWindowSize.Y, sf.AbsoluteCanvasSize.Y
		local on = chh > wh + 1
		if on ~= s.on then
			s.on = on
			tr.Visible = on
			pp.PaddingRight = ud(0, on and pd + m.sbw or pd)
		end
		if not on or chh <= 0 then
			return
		end
		local r = clamp(wh / chh, 0.05, 1)
		local mx = chh - wh
		local f = mx > 0 and clamp(sf.CanvasPosition.Y / mx, 0, 1) or 0
		th.Size = ud2(1, -2, r, 0)
		th.Position = ud2(0, 1, f * (1 - r), 0)
	end
	con(sf:GetPropertyChangedSignal("CanvasPosition"), upd)
	con(sf:GetPropertyChangedSignal("AbsoluteCanvasSize"), upd)
	con(sf:GetPropertyChangedSignal("AbsoluteWindowSize"), upd)
	hover(th, function()
		s.hv = true
		col()
	end, function()
		s.hv = false
		col()
	end)
	con(th.InputBegan, function(i)
		local t = i.UserInputType
		if not isptr(t) then
			return
		end
		local p0 = (t == tch and ipos(i) or mpos()).Y
		local c0 = sf.CanvasPosition.Y
		s.dg = true
		col()
		startdrag(function(p)
			local trh, thh = tr.AbsoluteSize.Y, th.AbsoluteSize.Y
			local mx = sf.AbsoluteCanvasSize.Y - sf.AbsoluteWindowSize.Y
			if trh - thh > 0 and mx > 0 then
				sf.CanvasPosition = v2(0, clamp(c0 + (p.Y - p0) * mx / (trh - thh), 0, mx))
			end
		end, function()
			s.dg = false
			col()
		end, nil, i)
	end)
	s.upd = upd
	return s
end

local function bmapadd(e, k)
	local l = st.bmap[k]
	if not l then
		l = {}
		st.bmap[k] = l
	end
	if not tfind(l, e) then
		l[#l + 1] = e
	end
end

local function bmapdel(e, k)
	local l = st.bmap[k]
	if not l then
		return
	end
	local i = tfind(l, e)
	if i then
		tremove(l, i)
	end
	if #l == 0 then
		st.bmap[k] = nil
	end
end

local mbtn = { MouseButton1 = true, MouseButton2 = true, MouseButton3 = true }

local function onmenu(mp)
	if not mp or not st.root or not st.root.Visible then
		return false
	end
	if inside(st.root, mp) then
		return true
	end
	local ps = st.pops
	for i = 1, #ps do
		if inside(ps[i].box, mp) then
			return true
		end
	end
	return false
end

local function onbegan(i)
	if st.dead then
		return
	end
	local t = i.UserInputType
	local mp
	if t == tch then
		mp = ipos(i)
		st.tp = mp
	elseif t == mb1 or t == mb2 or t == mb3 then
		st.tp = nil
		mp = mpos()
	end
	local l = st.listen
	if l then
		local k = inkey(i)
		if k then
			st.listen = nil
			l.lst = false
			if k == "Escape" or k == "Backspace" then
				l:setkey(nil)
			elseif k == "MouseButton1" and onmenu(mp) then
				l:draw()
			else
				if mbtn[k] then
					st.eat = l
					delay(0.3, function()
						if st.eat == l then
							st.eat = nil
						end
					end)
				end
				l:setkey(k)
			end
			return
		end
	end
	if mp and t ~= mb3 and #st.pops > 0 then
		popclick(mp)
	end
	if t == tch then
		return
	end
	local k = inkey(i)
	if not k or uis:GetFocusedTextBox() then
		return
	end
	if k == st.mkey then
		lib:toggle()
		return
	end
	if onmenu(mp) then
		return
	end
	local b = st.bmap[k]
	if b then
		for j = #b, 1, -1 do
			local e = b[j]
			if e then
				e:bdown()
			end
		end
	end
end

local function onended(i)
	if st.dead then
		return
	end
	local t, d = i.UserInputType, st.drag
	if t == tch then
		local g = st.tg
		if g and g.i == i then
			st.tg = nil
			g.tap(ipos(i))
		end
	end
	if d.mv and ((t == mb1 and not d.ti) or (t == tch and d.ti == i)) then
		stopdrag(true)
	end
	local k = inkey(i)
	if not k then
		return
	end
	local b = st.bmap[k]
	if b then
		for j = #b, 1, -1 do
			local e = b[j]
			if e then
				e:bup()
			end
		end
	end
end

local function onchanged(i)
	if st.dead then
		return
	end
	local t, d = i.UserInputType, st.drag
	if t == mmove then
		st.tp = nil
		if d.mv and not d.ti then
			d.mv(mpos())
		end
		if st.tipe then
			tippos()
		end
	elseif t == tch then
		local p = ipos(i)
		st.tp = p
		local g = st.tg
		if g and g.i == i then
			local dx, dy = abs(p.X - g.p0.X), abs(p.Y - g.p0.Y)
			if dx > 6 and dx >= dy then
				st.tg = nil
				g.drag(p)
			elseif dy > 6 then
				st.tg = nil
			end
		end
		if d.mv and d.ti == i then
			d.mv(p)
		end
	end
end

local function relall()
	for _, l in next, st.bmap do
		for j = #l, 1, -1 do
			local e = l[j]
			if e then
				e:bup()
			end
		end
	end
end

local elm = {}
elm.__index = elm
local eid = 0

local function newel(cls, c, o, kind)
	eid += 1
	return setmetatable({
		id = eid,
		kind = kind,
		c = c,
		o = o,
		name = o.name or o.text or "",
		flag = o.flag,
		cb = o.cb or o.callback,
		tmp = o.tmp or false,
		hid = false,
		shw = true,
	}, cls)
end

function elm:get()
	return self.val
end

function elm:ser()
	return self.val
end

function elm:unser(v)
	return v
end

function elm:load() end

function elm:draw() end

function elm:bdown() end

function elm:bup() end

function elm:onchange(f)
	local u = self.ucb
	if not u then
		u = {}
		self.ucb = u
	end
	u[#u + 1] = f
	return self
end

function elm:fire(nocb)
	local v = self.val
	if self.flag and not self.tmp then
		lib.flags[self.flag] = v
		if self.a ~= nil then
			lib.flags[self.flag .. "_a"] = self.a
		end
	end
	if not nocb then
		if self.cb then
			spawn(self.cb, v, self.a)
		end
		local u = self.ucb
		if u then
			for i = 1, #u do
				spawn(u[i], v, self.a)
			end
		end
	end
	local d = self.dnt
	if d then
		for i = 1, #d do
			d[i]:chkdep()
		end
	end
end

function elm:dep(src, want)
	local d = self.deps
	if not d then
		d = {}
		self.deps = d
	end
	d[#d + 1] = { src = src, want = want }
	local n = src.dnt
	if not n then
		n = {}
		src.dnt = n
	end
	if not tfind(n, self) then
		n[#n + 1] = self
	end
	self:chkdep()
	return self
end

function elm:chkdep()
	local ok = true
	local d = self.deps
	if d then
		for i = 1, #d do
			local x = d[i]
			local s, w = x.src, x.want
			local v = s.val
			local r
			if type(w) == "function" then
				r = w(v)
			elseif w == nil then
				r = v == true
			elseif type(v) == "table" then
				r = tfind(v, w) ~= nil
			else
				r = v == w
			end
			if not r or s.hid then
				ok = false
				break
			end
		end
	end
	self:sethid(not ok)
end

function elm:apvis()
	local o = self.row or self.bb
	if o then
		o.Visible = self.shw and not self.hid
	end
end

function elm:sethid(b)
	b = b == true
	if self.hid == b then
		return self
	end
	self.hid = b
	self:apvis()
	local n = self.dnt
	if n then
		for i = 1, #n do
			n[i]:chkdep()
		end
	end
	return self
end

function elm:vis(b)
	self.shw = b ~= false
	self:apvis()
	return self
end

function elm:destroy()
	if self.dead then
		return
	end
	self.dead = true
	if self.kind == "kbd" and self.val then
		bmapdel(self, self.val)
	end
	if st.listen == self then
		st.listen = nil
	end
	if st.tipe == self then
		tiphide()
	end
	local i = tfind(lib.els, self)
	if i then
		tremove(lib.els, i)
	end
	if self.flag and lib.fl[self.flag] == self then
		lib.fl[self.flag] = nil
		lib.flags[self.flag] = nil
	end
	local a = self.accs
	if a then
		for j = #a, 1, -1 do
			a[j]:destroy()
		end
	end
	if self.sw then
		self.sw:Destroy()
	end
	if self.bb then
		self.bb:Destroy()
	end
	if self.row and self.row.Parent then
		self.row:Destroy()
	end
end

local function reg(e)
	if e.tmp then
		return
	end
	local els = lib.els
	els[#els + 1] = e
	local d = e:ser()
	if type(d) == "table" then
		d = tclone(d)
	end
	e.def = d
	if e.flag then
		lib.fl[e.flag] = e
		lib.flags[e.flag] = e.val
		if e.a ~= nil then
			lib.flags[e.flag .. "_a"] = e.a
		end
	end
end

local cont = {}
cont.__index = cont

local function newcont(f, tab, cw)
	return setmetatable({ f = f, tab = tab, cw = cw or 0, n = 0 }, cont)
end

function cont:iw()
	return floor(self.cw * 0.65)
end

function cont:row(h)
	self.n += 1
	self.lb = nil
	return mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, h or m.fh), LayoutOrder = self.n, Parent = self.f })
end

function cont:line(h)
	local r = self:row(h)
	local l = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Parent = r })
	hlist(l, m.isp)
	return r, l
end

local function lbl(par, s, lo)
	return mk("TextLabel", { Size = ud2(0, 0, 1, 0), AutomaticSize = aix, Text = s, LayoutOrder = lo or 9, Parent = par })
end

function cont:sep()
	local r = self:row(1)
	mk("Frame", { Position = ofs(-m.cp, 0), Size = ud2(1, m.cp * 2, 1, 0), Parent = r }, { BackgroundColor3 = "sep" })
	return r
end

function cont:space(h)
	return self:row(h or m.sp)
end

function cont:section(o)
	if type(o) == "string" then
		o = { name = o }
	end
	o = o or {}
	local function body()
		self.n += 1
		self.lb = nil
		local f = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, 0), AutomaticSize = aiy, LayoutOrder = self.n, Parent = self.f })
		vlist(f, m.sp)
		return f
	end
	if not o.name then
		return newcont(body(), self.tab, self.cw)
	end
	local r = self:row(m.fh)
	local b = mk("TextButton", { Size = scl(1, 1), BackgroundTransparency = 0, Parent = r }, { BackgroundColor3 = "fbg" })
	corner(b, m.hr)
	bord(b, "hbord")
	local ar = arrow(b, ud2(0, m.ax + m.aw / 2, 0.5, 0), false)
	mk("TextLabel", { Position = ofs(m.tx, 0), Size = ud2(1, -m.tx, 1, 0), Text = o.name, TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
	local s1 = self:sep()
	local f = body()
	local s2 = self:sep()
	local c = newcont(f, self.tab, self.cw)
	local hv = false
	local function upd()
		local op = c.isopen
		s1.Visible, f.Visible, s2.Visible = op, op, op
		aset(ar, op)
		b.BackgroundColor3 = hv and thm.fbgh or thm.fbg
	end
	function c.setopen(_, v)
		c.isopen = v == true
		upd()
		return c
	end
	c.isopen = o.open == true
	c.hrow = r
	con(b.MouseButton1Click, function()
		c.isopen = not c.isopen
		upd()
	end)
	hover(b, function()
		hv = true
		upd()
	end, function()
		hv = false
		upd()
	end)
	upd()
	return c
end

local tgl = setmetatable({}, elm)
tgl.__index = tgl

function cont:toggle(o)
	o = o or {}
	local e = newel(tgl, self, o, "tgl")
	e.val = o.default == true
	local r, l = self:line()
	e.row, e.l, e.n = r, l, 1
	local g = mk("TextButton", { Size = ud2(0, 0, 1, 0), AutomaticSize = aix, LayoutOrder = 1, Parent = l })
	hlist(g, m.isp)
	local box = mk("Frame", { Size = ofs(m.fh, m.fh), LayoutOrder = 1, Parent = g }, { BackgroundColor3 = "fbg" })
	corner(box, m.rr)
	e.bs = bord(box, "fbord")
	e.ck = mkcheck(box, m.fh)
	lbl(g, e.name, 2)
	e.box = box
	con(g.MouseButton1Click, function()
		e:set(not e.val)
	end)
	hover(g, function()
		e.hov = true
		e:draw()
	end, function()
		e.hov = false
		e:draw()
	end)
	e:draw()
	reg(e)
	return e
end

function tgl:set(v, nocb)
	v = v == true
	if self.val == v then
		return self
	end
	self.val = v
	self:draw()
	self:fire(nocb)
	return self
end

function tgl:load(v)
	if type(v) == "boolean" then
		self:set(v)
	end
end

function tgl:draw()
	local on = self.val
	self.box.BackgroundColor3 = self.hov and thm.fbgh or thm.fbg
	self.box.BackgroundTransparency = on and 1 or 0
	self.bs.Transparency = on and 1 or 0
	self.ck.Visible = on
end

function tgl:color(o)
	return self.c:colorpicker(o or {}, self)
end

local sld = setmetatable({}, elm)
sld.__index = sld

function cont:slider(o)
	o = o or {}
	local e = newel(sld, self, o, "sld")
	e.min, e.max = o.min or 0, o.max or 100
	e.dec = o.dec or 0
	e.step = o.step or 10 ^ -e.dec
	e.pat = "%." .. e.dec .. "f"
	e.suf = o.suffix or ""
	e.val = e:rnd(o.default or e.min)
	local w = o.w or self:iw()
	e.w = w
	local r, l = self:line()
	e.row = r
	local b = mk("TextButton", { Size = ofs(w, m.fh), BackgroundTransparency = 0, LayoutOrder = 1, Parent = l }, { BackgroundColor3 = "fbg" })
	corner(b, m.rr)
	bord(b, "fbord")
	e.g = mk("Frame", { AnchorPoint = v2(0, 0.5), Size = ofs(m.gw, m.fh - m.gp * 2), Parent = b }, { BackgroundColor3 = "gold" })
	corner(e.g, m.gr)
	e.vt = mk("TextLabel", { Size = scl(1, 1), TextXAlignment = xal.Center, ZIndex = 2, Parent = b })
	if e.name ~= "" then
		lbl(l, e.name, 2)
	end
	e.b = b
	e.mv = function(p)
		local ax, aw = b.AbsolutePosition.X, b.AbsoluteSize.X
		if aw <= 0 then
			return
		end
		local k = aw / w
		local span = (w - m.gp * 2 - m.gw) * k
		local f = span > 0 and clamp((p.X - ax - (m.gp + m.gw / 2) * k) / span, 0, 1) or 0
		e:set(e.min + f * (e.max - e.min))
	end
	e.mu = function()
		e.drg = false
		e:draw()
	end
	con(b.InputBegan, function(i)
		local t = i.UserInputType
		if t == mb1 then
			e.drg = true
			e.mv(mpos())
			e:draw()
			startdrag(e.mv, e.mu, nil, i)
		elseif t == tch then
			local g = { i = i, p0 = ipos(i) }
			g.drag = function(p)
				e.drg = true
				e.mv(p)
				e:draw()
				startdrag(e.mv, e.mu, nil, i)
			end
			g.tap = function(p)
				e.mv(p)
			end
			st.tg = g
		end
	end)
	hover(b, function()
		e.hov = true
		e:draw()
	end, function()
		e.hov = false
		e:draw()
	end)
	e:draw()
	reg(e)
	return e
end

function sld:rnd(v)
	local lo, hi = self.min, self.max
	v = clamp(tonumber(v) or lo, lo, hi)
	local s = self.step
	if s > 0 then
		v = lo + floor((v - lo) / s + 0.5) * s
	end
	return tonumber(sfmt(self.pat, clamp(v, lo, hi)))
end

function sld:set(v, nocb)
	v = self:rnd(v)
	if v == self.val then
		return self
	end
	self.val = v
	self:draw()
	self:fire(nocb)
	return self
end

function sld:load(v)
	if type(v) == "number" then
		self:set(v)
	end
end

function sld:fmtv(v)
	local f = self.o.fmt
	if type(f) == "function" then
		return f(v)
	elseif type(f) == "string" then
		return sfmt(f, v)
	end
	return sfmt(self.pat, v) .. self.suf
end

function sld:draw()
	local v = self.val
	local rg = self.max - self.min
	local f = rg > 0 and (v - self.min) / rg or 0
	self.g.Position = ud2(0, m.gp + f * (self.w - m.gp * 2 - m.gw), 0.5, 0)
	self.g.BackgroundColor3 = self.drg and thm.golda or thm.gold
	self.b.BackgroundColor3 = (self.hov or self.drg) and thm.fbgh or thm.fbg
	self.vt.Text = self:fmtv(v)
end

local drp = setmetatable({}, elm)
drp.__index = drp

function cont:dropdown(o)
	o = o or {}
	local e = newel(drp, self, o, "drp")
	e.multi = o.multi == true
	e.values = o.values or o.options or {}
	if e.multi then
		e.val = {}
		local d = o.default
		if type(d) == "table" then
			for i = 1, #d do
				e.val[i] = d[i]
			end
		elseif d ~= nil then
			e.val[1] = d
		end
	else
		e.val = o.default
		if e.val == nil and not o.none then
			e.val = e.values[1]
		end
	end
	e.srt = function(a, b)
		return (tfind(e.values, a) or 0) < (tfind(e.values, b) or 0)
	end
	local w = o.w or self:iw()
	e.w = w
	local r, l = self:line()
	e.row = r
	local b = mk("TextButton", { Size = ofs(w, m.fh), BackgroundTransparency = 0, LayoutOrder = 1, Parent = l }, { BackgroundColor3 = "fbg" })
	corner(b, m.rr)
	bord(b, "fbord")
	local cl = mk("Frame", { BackgroundTransparency = 1, Position = ofs(m.fpx, 0), Size = ud2(1, -(m.fpx + m.fh + 2), 1, 0), ClipsDescendants = true, Parent = b })
	e.t = mk("TextLabel", { Size = ud2(0, 1000, 1, 0), Parent = cl })
	local ab = mk("Frame", { AnchorPoint = v2(1, 0), Position = ud2(1, -1, 0, 1), Size = ud2(0, m.fh - 2, 1, -2), Parent = b }, { BackgroundColor3 = "btn" })
	corner(ab, m.rr - 1)
	e.abp = mk("Frame", { Size = scl(0.5, 1), Parent = ab }, { BackgroundColor3 = "btn" })
	arrow(ab, scl(0.5, 0.5), true)
	if e.name ~= "" then
		lbl(l, e.name, 2)
	end
	e.b, e.ab = b, ab
	hover(b, function()
		e.hov = true
		e:draw()
	end, function()
		e.hov = false
		e:draw()
	end)
	con(b.MouseButton1Click, function()
		if e.lp and e.lp.isopen then
			closepop(e.lp)
		else
			e:openlist()
		end
	end)
	e:draw()
	reg(e)
	return e
end

function drp:has(v)
	if self.multi then
		return tfind(self.val, v) ~= nil
	end
	return self.val == v
end

function drp:text()
	if self.multi then
		local n = #self.val
		if n == 0 then
			return "none"
		end
		local t = table.create(n)
		for i = 1, n do
			t[i] = tostring(self.val[i])
		end
		return tconcat(t, ", ")
	end
	if self.val == nil then
		return "none"
	end
	return tostring(self.val)
end

function drp:draw()
	self.t.Text = self:text()
	local h = self.hov or (self.lp ~= nil and self.lp.isopen)
	self.b.BackgroundColor3 = h and thm.fbgh or thm.fbg
	local ac = h and thm.btnh or thm.btn
	self.ab.BackgroundColor3 = ac
	self.abp.BackgroundColor3 = ac
	local it = self.items
	if it then
		for i = 1, #it do
			local x = it[i]
			local on = self:has(x.v)
			x.b.BackgroundTransparency = (on or x.h) and 0 or 1
			x.b.BackgroundColor3 = x.h and thm.hdrh or thm.hdr
		end
	end
end

function drp:set(v, nocb)
	if self.multi then
		local t = self.val
		if v == t then
			v = tclone(v)
		end
		tclear(t)
		if type(v) == "table" then
			for i = 1, #v do
				local x = v[i]
				if tfind(self.values, x) and not tfind(t, x) then
					t[#t + 1] = x
				end
			end
		elseif v ~= nil and tfind(self.values, v) then
			t[1] = v
		end
		tsort(t, self.srt)
	else
		if v ~= nil and not tfind(self.values, v) then
			return self
		end
		if self.val == v then
			return self
		end
		self.val = v
	end
	self:draw()
	self:fire(nocb)
	return self
end

function drp:flip(v)
	local t = self.val
	local i = tfind(t, v)
	if i then
		tremove(t, i)
	else
		t[#t + 1] = v
		tsort(t, self.srt)
	end
	self:draw()
	self:fire()
end

function drp:setvalues(vals)
	self.values = vals or {}
	if self.multi then
		local t = self.val
		for i = #t, 1, -1 do
			if not tfind(self.values, t[i]) then
				tremove(t, i)
			end
		end
	elseif self.val ~= nil and not tfind(self.values, self.val) then
		self.val = self.values[1]
	end
	if self.lp and self.lp.isopen then
		closepop(self.lp)
	end
	self:draw()
	self:fire()
	return self
end

function drp:ser()
	if self.multi then
		return tclone(self.val)
	end
	return self.val
end

function drp:load(v)
	if self.multi then
		if type(v) == "table" then
			self:set(v)
		end
	elseif v ~= nil then
		self:set(v)
	end
end

function drp:openlist()
	local b = self.b
	local vals = self.values
	local n = #vals
	local h = min(n, 8) * m.sel + m.sp * 2
	local p = newpop({ w = self.w, h = h, pad = 0, anchor = b })
	local s = scroller(p.c, ofs(0, 0), scl(1, 1), m.sp, 0)
	local items = table.create(n)
	for i = 1, n do
		local v = vals[i]
		local ib = mk("TextButton", { Size = ud2(1, 0, 0, m.sel), BackgroundTransparency = 1, LayoutOrder = i, Parent = s.sf }, { BackgroundColor3 = "hdr" })
		mk("TextLabel", { Position = ofs(m.fpx - m.sp, 0), Size = ud2(1, -(m.fpx - m.sp), 1, 0), Text = tostring(v), Parent = ib })
		local x = { b = ib, v = v, h = false }
		hover(ib, function()
			x.h = true
			self:draw()
		end, function()
			x.h = false
			self:draw()
		end)
		con(ib.MouseButton1Click, function()
			if self.multi then
				self:flip(v)
			else
				closepop(p)
				self:set(v)
			end
		end)
		items[i] = x
	end
	self.items = items
	self.lp = p
	p.onclose = function()
		self.items = nil
		self.lp = nil
		if not self.dead then
			self:draw()
		end
	end
	local ap, as = b.AbsolutePosition, b.AbsoluteSize
	openpop(p, ap.X, ap.Y + as.Y)
	self:draw()
end

local cpk = setmetatable({}, elm)
cpk.__index = cpk

function cont:colorpicker(o, host)
	o = o or {}
	local e = newel(cpk, self, o, "cpk")
	local c = o.default or o.color or white
	e.val = c
	e.ha = o.alpha ~= nil
	e.a = o.alpha or 1
	e.h, e.s, e.v = c:ToHSV()
	local par, lo
	if host then
		local a = host.accs
		if not a then
			a = {}
			host.accs = a
		end
		a[#a + 1] = e
		host.n += 1
		par, lo = host.l, host.n + 10
		if not o.name then
			e.name = host.name
		end
	else
		local r, l = self:line()
		e.row = r
		par, lo = l, 1
		lbl(l, e.name, 2)
	end
	local sw, ck, cf = swatch(par, m.fh, m.fh, lo)
	e.sw, e.ck, e.cf = sw, ck, cf
	con(sw.MouseButton1Click, function()
		tiphide()
		if e.pp and e.pp.isopen then
			closepop(e.pp)
		else
			e:openpick()
		end
	end)
	hover(sw, function()
		if not (e.pp and e.pp.isopen) then
			tipshow(e)
		end
	end, function()
		tiphide(e)
	end)
	e:draw()
	reg(e)
	return e
end

function cpk:ser()
	return hex(self.val, self.a)
end

function cpk:unser(v)
	local c = unhex(v)
	return c or v
end

function cpk:load(v)
	local c, a = unhex(v)
	if c then
		self:set(c, a)
	end
end

function cpk:set(c, a, nocb)
	if typeof(c) ~= "Color3" then
		return self
	end
	a = self.ha and (a or self.a) or 1
	if c == self.val and a == self.a then
		return self
	end
	self.val, self.a = c, a
	local h, s, v = c:ToHSV()
	if s > 0 and v > 0 then
		self.h = h
	end
	if v > 0 then
		self.s = s
	end
	self.v = v
	self:draw()
	self:fire(nocb)
	return self
end

function cpk:sethsv(h, s, v, a)
	self.h, self.s, self.v = h, s, v
	if a and self.ha then
		self.a = a
	end
	self.val = hsv(h, s, v)
	self:draw()
	self:fire()
end

function cpk:draw()
	self.cf.BackgroundColor3 = self.val
	self.cf.BackgroundTransparency = 1 - self.a
	if self.ck then
		self.ck.Visible = self.a < 1
	end
	local pu = self.pu
	if pu then
		pu()
	end
	if st.tipe == self then
		tipupd(self)
	end
end

local function barr(par, bw)
	local h = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, 0), ZIndex = 5, Parent = par })
	if not ast.trf then
		return h
	end
	local q = floor(bw * 0.2)
	local function a(x, w, hh, rot, c)
		mk("ImageLabel", { AnchorPoint = v2(0, 0.5), Position = ofs(x, 0), Size = ofs(w, hh), Image = ast.trf, ImageColor3 = c, Rotation = rot, ZIndex = 5, Parent = h })
	end
	a(-2, q + 3, q * 2 + 2, 0, black)
	a(-1, q + 1, q * 2, 0, white)
	a(bw - q - 1, q + 3, q * 2 + 2, 180, black)
	a(bw - q, q + 1, q * 2, 180, white)
	return h
end

local function prev(par, x, y, w, h)
	local g = mk("CanvasGroup", { Position = ofs(x, y), Size = ofs(w, h), Parent = par })
	corner(g, m.swr)
	local l = mk("Frame", { Size = scl(0.5, 1), Parent = g })
	local r = mk("Frame", { BackgroundTransparency = 1, Position = scl(0.5, 0), Size = scl(0.5, 1), Parent = g })
	checker(r, h / 2.99)
	local rc = mk("Frame", { Size = scl(1, 1), Parent = r })
	local b = mk("TextButton", { Size = scl(1, 1), ZIndex = 3, Parent = g })
	return function(c, a)
		l.BackgroundColor3 = c
		rc.BackgroundColor3 = c
		rc.BackgroundTransparency = 1 - a
	end, b
end

local function frm(par, pos, size, cls)
	local b = mk(cls or "TextButton", { Position = pos, Size = size, BackgroundTransparency = 0, Parent = par }, { BackgroundColor3 = "fbg" })
	corner(b, m.rr)
	bord(b, "fbord")
	return b
end

local function dragint(par, x, y, w, get, set, fm)
	local b = frm(par, ofs(x, y), ofs(w, m.fh))
	b.TextXAlignment = xal.Center
	local tb = mk("TextBox", { Size = scl(1, 1), TextXAlignment = xal.Center, Visible = false, Parent = b })
	local function upd()
		if not tb.Visible then
			b.Text = sfmt(fm, get())
		end
	end
	con(b.InputBegan, function(i)
		local t = i.UserInputType
		if not isptr(t) or tb.Visible then
			return
		end
		local p0 = t == tch and ipos(i) or mpos()
		local v0 = get()
		local mv = false
		b.BackgroundColor3 = thm.fbga
		startdrag(function(p)
			local dx = p.X - p0.X
			if not mv and abs(dx) < 3 then
				return
			end
			mv = true
			set(clamp(floor(v0 + dx / st.us.Scale + 0.5), 0, 255))
		end, function()
			b.BackgroundColor3 = thm.fbg
			if not mv then
				tb.Text = tostring(get())
				tb.Visible = true
				b.Text = ""
				tb:CaptureFocus()
			end
		end, nil, i)
	end)
	con(tb.FocusLost, function()
		local n = tonumber(smatch(tb.Text, "%-?%d+"))
		tb.Visible = false
		if n then
			set(clamp(n, 0, 255))
		end
		upd()
	end)
	return upd
end

function cpk:openpick()
	local e = self
	local sq, is, gp = m.fh, m.isp, m.sp
	local pw = sq * 12
	local svs = pw - (e.ha and 2 or 1) * (sq + is)
	local hx = svs + is
	local axx = hx + sq + is
	local sx = pw + is
	local spw, sph = sq * 3, sq * 2
	local lh = m.tl
	local y0 = e.name ~= "" and lh + gp or 0
	local p = newpop({ anchor = e.sw, w = sx + spw, h = y0 + svs + gp + (sq + gp) * 2 + sq })
	e.pp = p
	local hd = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Parent = p.c })
	if y0 > 0 then
		mk("TextLabel", { Size = ofs(pw, lh), Text = e.name, Parent = hd })
	end
	local sv = mk("TextButton", { Position = ofs(0, y0), Size = ofs(svs, svs), BackgroundTransparency = 0, Parent = hd })
	local wl = mk("Frame", { Size = scl(1, 1), BackgroundColor3 = white, Parent = sv })
	mk("UIGradient", { Transparency = nseq(0, 1), Parent = wl })
	local bl = mk("Frame", { Size = scl(1, 1), BackgroundColor3 = black, Parent = sv })
	mk("UIGradient", { Rotation = 90, Transparency = nseq(1, 0), Parent = bl })
	bord(mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), ZIndex = 3, Parent = sv }), "fbord")
	local cur = mk("Frame", { AnchorPoint = v2(0.5, 0.5), Size = ofs(12, 12), ZIndex = 4, Parent = sv })
	pill(cur)
	mk("UIStroke", { Color = white, Thickness = 1, Parent = cur })
	local cuo = mk("Frame", { BackgroundTransparency = 1, AnchorPoint = v2(0.5, 0.5), Position = scl(0.5, 0.5), Size = ofs(14, 14), ZIndex = 4, Parent = cur })
	pill(cuo)
	mk("UIStroke", { Color = rgb(128, 128, 128), Thickness = 1, Parent = cuo })
	local hb = mk("TextButton", { Position = ofs(hx, y0), Size = ofs(sq, svs), BackgroundTransparency = 0, BackgroundColor3 = white, Parent = hd })
	local hk = table.create(7)
	for i = 0, 6 do
		hk[i + 1] = ckp(i / 6, hsv((i / 6) % 1, 1, 1))
	end
	mk("UIGradient", { Rotation = 90, Color = cseq(hk), Parent = hb })
	bord(mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), ZIndex = 3, Parent = hb }), "fbord")
	local har = barr(hb, sq)
	local ab, af, aar
	if e.ha then
		ab = mk("TextButton", { Position = ofs(axx, y0), Size = ofs(sq, svs), Parent = hd })
		checker(ab, sq / 2)
		af = mk("Frame", { Size = scl(1, 1), Parent = ab })
		mk("UIGradient", { Rotation = 90, Transparency = nseq(0, 1), Parent = af })
		bord(mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), ZIndex = 3, Parent = ab }), "fbord")
		aar = barr(ab, sq)
	end
	mk("TextLabel", { Position = ofs(sx, y0), Size = ofs(spw, lh), Text = "Current", Parent = hd })
	local pcur = prev(hd, sx, y0 + lh + gp, spw, sph)
	local oy = y0 + lh + gp + sph + gp
	mk("TextLabel", { Position = ofs(sx, oy), Size = ofs(spw, lh), Text = "Original", Parent = hd })
	local porg, pob = prev(hd, sx, oy + lh + gp, spw, sph)
	local oc, oa = e.val, e.a
	porg(oc, oa)
	con(pob.MouseButton1Click, function()
		e:set(oc, oa)
	end)
	local y1 = y0 + svs + gp
	local nc = e.ha and 4 or 3
	local w1 = floor((pw - is * (nc - 1)) / nc)
	local wl1 = pw - (nc - 1) * (w1 + is)
	local ups = {}
	local function rgbset(i, v)
		local r, g, b = c255(e.val.R), c255(e.val.G), c255(e.val.B)
		if i == 1 then
			r = v
		elseif i == 2 then
			g = v
		else
			b = v
		end
		e:set(rgb(r, g, b), e.a)
	end
	local rn, hn = { "R", "G", "B" }, { "H", "S", "V" }
	for i = 1, nc do
		local x = (i - 1) * (w1 + is)
		local w = i == nc and wl1 or w1
		if i <= 3 then
			ups[#ups + 1] = dragint(hd, x, y1, w, function()
				local c = e.val
				return c255(i == 1 and c.R or (i == 2 and c.G or c.B))
			end, function(v)
				rgbset(i, v)
			end, rn[i] .. ":%3d")
			ups[#ups + 1] = dragint(hd, x, y1 + sq + gp, w, function()
				return c255(i == 1 and e.h or (i == 2 and e.s or e.v))
			end, function(v)
				local k = v / 255
				if i == 1 then
					e:sethsv(min(k, 0.9999), e.s, e.v)
				elseif i == 2 then
					e:sethsv(e.h, k, e.v)
				else
					e:sethsv(e.h, e.s, k)
				end
			end, hn[i] .. ":%3d")
		else
			for j = 0, 1 do
				ups[#ups + 1] = dragint(hd, x, y1 + j * (sq + gp), w, function()
					return c255(e.a)
				end, function(v)
					e:sethsv(e.h, e.s, e.v, v / 255)
				end, "A:%3d")
			end
		end
	end
	local y3 = y1 + (sq + gp) * 2
	local hx_ = frm(hd, ofs(0, y3), ofs(pw, sq), "TextBox")
	pad(hx_, m.fpx, m.fpx, 0, 0)
	con(hx_.FocusLost, function()
		local c, a = unhex(hx_.Text)
		if c then
			e:set(c, a)
		end
		if e.pu then
			e.pu()
		end
	end)
	e.pu = function()
		sv.BackgroundColor3 = hsv(e.h, 1, 1)
		cur.Position = scl(e.s, 1 - e.v)
		cur.BackgroundColor3 = e.val
		har.Position = scl(0, e.h)
		if af then
			af.BackgroundColor3 = e.val
			aar.Position = scl(0, 1 - e.a)
		end
		pcur(e.val, e.a)
		for i = 1, #ups do
			ups[i]()
		end
		if not hx_:IsFocused() then
			hx_.Text = e.ha and hex(e.val, e.a) or hex(e.val)
		end
	end
	local function drg(o, fn)
		con(o.InputBegan, function(i)
			local t = i.UserInputType
			if isptr(t) then
				fn(t == tch and ipos(i) or mpos())
				startdrag(fn, nil, p, i)
			end
		end)
	end
	drg(sv, function(mp)
		local a, s = sv.AbsolutePosition, sv.AbsoluteSize
		e:sethsv(e.h, clamp((mp.X - a.X) / s.X, 0, 1), 1 - clamp((mp.Y - a.Y) / s.Y, 0, 1))
	end)
	drg(hb, function(mp)
		local a, s = hb.AbsolutePosition, hb.AbsoluteSize
		e:sethsv(clamp((mp.Y - a.Y) / s.Y, 0, 0.9999), e.s, e.v)
	end)
	if ab then
		drg(ab, function(mp)
			local a, s = ab.AbsolutePosition, ab.AbsoluteSize
			e:sethsv(e.h, e.s, e.v, 1 - clamp((mp.Y - a.Y) / s.Y, 0, 1))
		end)
	end
	p.onclose = function()
		e.pu = nil
		e.pp = nil
	end
	e.pu()
	local ap, as = e.sw.AbsolutePosition, e.sw.AbsoluteSize
	openpop(p, ap.X, ap.Y + as.Y + m.sp * st.us.Scale)
end

local kbd = setmetatable({}, elm)
kbd.__index = kbd

function cont:keybind(o)
	o = o or {}
	local e = newel(kbd, self, o, "kbd")
	local d = o.default
	if typeof(d) == "EnumItem" then
		d = d.Name
	end
	if d == "None" then
		d = nil
	end
	e.val = d
	local w = o.w or self:iw()
	local r, l = self:line()
	e.row = r
	local b = mk("TextButton", { Size = ofs(w, m.fh), BackgroundTransparency = 0, TextXAlignment = xal.Center, LayoutOrder = 1, Parent = l }, { BackgroundColor3 = "btn" })
	if e.name ~= "" then
		lbl(l, e.name, 2)
	end
	e.b = b
	hover(b, function()
		e.hov = true
		e:draw()
	end, function()
		e.hov, e.prs = false, false
		e:draw()
	end)
	con(b.MouseButton1Down, function()
		e.prs = true
		e:draw()
	end)
	con(b.MouseButton1Up, function()
		e.prs = false
		e:draw()
	end)
	con(b.MouseButton1Click, function()
		if st.eat ~= e then
			e:listen()
		end
	end)
	con(b.MouseButton2Click, function()
		if st.eat ~= e then
			e:setkey(nil)
		end
	end)
	if d and not e.tmp then
		bmapadd(e, d)
	end
	e:draw()
	reg(e)
	return e
end

function kbd:listen()
	local l = st.listen
	if l and l ~= self then
		l.lst = false
		l:draw()
	end
	st.listen = self
	self.lst = true
	self:draw()
end

function kbd:setkey(k, nocb)
	self.lst = false
	if st.listen == self then
		st.listen = nil
	end
	if k == self.val then
		self:draw()
		return self
	end
	if self.val and not self.tmp then
		bmapdel(self, self.val)
	end
	self.val = k
	if k and not self.tmp then
		bmapadd(self, k)
	end
	self:draw()
	self:fire(nocb)
	return self
end

function kbd:set(k)
	if typeof(k) == "EnumItem" then
		k = k.Name
	end
	return self:setkey(k)
end

function kbd:ser()
	return self.val or "None"
end

function kbd:unser(v)
	if v == "None" then
		return nil
	end
	return v
end

function kbd:load(v)
	if v == nil or v == "None" then
		self:setkey(nil)
	elseif type(v) == "string" then
		self:setkey(v)
	end
end

function kbd:bdown()
	local f = self.o.onpress
	if f then
		spawn(f, self.val)
	end
end

function kbd:bup()
	local f = self.o.onrelease
	if f then
		spawn(f, self.val)
	end
end

function kbd:down()
	local k = self.val
	if not k then
		return false
	end
	if mbtn[k] then
		return uis:IsMouseButtonPressed(Enum.UserInputType[k])
	end
	local ok, kc = pcall(function()
		return Enum.KeyCode[k]
	end)
	return ok and uis:IsKeyDown(kc) or false
end

function kbd:draw()
	local b = self.b
	b.Text = self.lst and "..." or kname(self.val)
	b.BackgroundColor3 = (self.prs or self.lst) and thm.btna or (self.hov and thm.btnh or thm.btn)
end

local inp = setmetatable({}, elm)
inp.__index = inp

function cont:input(o)
	o = o or {}
	local e = newel(inp, self, o, "inp")
	e.val = tostring(o.default or "")
	local w = o.w or self:iw()
	local r, l = self:line()
	e.row = r
	local b = frm(l, ofs(0, 0), w < 0 and scl(1, 1) or ofs(w, m.fh), "TextBox")
	b.LayoutOrder = 1
	b.Text = e.val
	b.PlaceholderText = o.placeholder or ""
	b.PlaceholderColor3 = thm.dim
	b.ClipsDescendants = true
	pad(b, m.fpx, m.fpx, 0, 0)
	if e.name ~= "" and w >= 0 then
		lbl(l, e.name, 2)
	end
	e.b = b
	hover(b, function()
		b.BackgroundColor3 = thm.fbgh
	end, function()
		b.BackgroundColor3 = thm.fbg
	end)
	con(b.FocusLost, function(ent)
		e:set(b.Text)
		if ent and o.onenter then
			spawn(o.onenter, e.val)
		end
	end)
	if o.live then
		con(b:GetPropertyChangedSignal("Text"), function()
			if b:IsFocused() and b.Text ~= e.val then
				e.val = b.Text
				e:fire()
			end
		end)
	end
	reg(e)
	return e
end

function inp:set(v, nocb)
	v = tostring(v or "")
	local mx = self.o.max
	if mx then
		v = ssub(v, 1, mx)
	end
	if self.b.Text ~= v then
		self.b.Text = v
	end
	if v == self.val then
		return self
	end
	self.val = v
	self:fire(nocb)
	return self
end

function inp:load(v)
	if type(v) == "string" then
		self:set(v)
	end
end

function inp:focus()
	self.b:CaptureFocus()
	return self
end

local btn = setmetatable({}, elm)
btn.__index = btn

function cont:button(o)
	if type(o) == "string" then
		o = { name = o }
	end
	o = o or {}
	local e = newel(btn, self, o, "btn")
	local l = self.lb
	if o.same and l and l.Parent then
		self.bn += 1
	else
		local r
		r, l = self:line()
		self.lb, self.bn = l, 1
		e.row = r
	end
	local full = o.w == -1
	local b = mk("TextButton", {
		Size = full and scl(1, 1) or (o.w and ofs(o.w, m.fh) or ud2(0, 0, 1, 0)),
		AutomaticSize = (full or o.w) and ainone or aix,
		BackgroundTransparency = 0,
		TextXAlignment = xal.Center,
		Text = e.name,
		LayoutOrder = self.bn,
		Parent = l,
	}, { BackgroundColor3 = "btn" })
	if not (full or o.w) then
		pad(b, m.fpx + 2, m.fpx + 2, 0, 0)
	end
	if not e.row then
		e.bb = b
	end
	e.b = b
	bfx(b, "btn", "btnh", "btna")
	con(b.MouseButton1Click, function()
		if e.cb then
			spawn(e.cb)
		end
	end)
	return e
end

function btn:press()
	if self.cb then
		spawn(self.cb)
	end
end

local txt = setmetatable({}, elm)
txt.__index = txt

function cont:text(o)
	if type(o) ~= "table" then
		o = { text = tostring(o or "") }
	end
	local e = newel(txt, self, o, "txt")
	local r = self:row(m.tl)
	e.row = r
	e.l = mk("TextLabel", {
		Size = scl(1, 1),
		Text = e.name,
		RichText = o.rich == true,
		TextXAlignment = o.center and xal.Center or xal.Left,
		Parent = r,
	}, { TextColor3 = o.dim and "dim" or "txt" })
	if o.wrap then
		r.AutomaticSize = aiy
		e.l.Size = ud2(1, 0, 0, m.tl)
		e.l.AutomaticSize = aiy
		e.l.TextWrapped = true
	end
	return e
end

cont.label = cont.text

function txt:set(s)
	self.name = tostring(s or "")
	self.l.Text = self.name
	return self
end

local lst = setmetatable({}, elm)
lst.__index = lst

function cont:list(o)
	o = o or {}
	local e = newel(lst, self, o, "lst")
	e.values = o.values or {}
	e.val = o.default
	self.n += 1
	self.lb = nil
	local r = mk("Frame", { BackgroundTransparency = 1, Size = ud2(1, 0, 0, 0), AutomaticSize = aiy, LayoutOrder = self.n, Parent = self.f })
	vlist(r, 0)
	e.row = r
	e:build()
	reg(e)
	return e
end

function lst:build()
	local r = self.row
	for _, x in ipairs(r:GetChildren()) do
		if x:IsA("GuiObject") then
			x:Destroy()
		end
	end
	local it = {}
	for i, v in ipairs(self.values) do
		local b = mk("TextButton", { Size = ud2(1, 0, 0, m.sel), BackgroundTransparency = 1, LayoutOrder = i, Parent = r }, { BackgroundColor3 = "hdr" })
		mk("TextLabel", { Position = ofs(4, 0), Size = ud2(1, -4, 1, 0), Text = tostring(v), TextTruncate = Enum.TextTruncate.AtEnd, Parent = b })
		local x = { b = b, v = v, h = false }
		hover(b, function()
			x.h = true
			self:draw()
		end, function()
			x.h = false
			self:draw()
		end)
		con(b.MouseButton1Click, function()
			self:set(v)
		end)
		it[i] = x
	end
	self.items = it
	self:draw()
end

function lst:draw()
	local it = self.items
	if not it then
		return
	end
	for i = 1, #it do
		local x = it[i]
		local on = x.v == self.val
		x.b.BackgroundTransparency = (on or x.h) and 0 or 1
		x.b.BackgroundColor3 = x.h and thm.hdrh or thm.hdr
	end
end

function lst:set(v, nocb)
	self.val = v
	self:draw()
	self:fire(nocb)
	return self
end

function lst:setvalues(t)
	self.values = t or {}
	if self.val ~= nil and not tfind(self.values, self.val) then
		self.val = nil
	end
	self:build()
	return self
end

local function cdir()
	return lib.dir .. "/configs"
end

local function cpath(n)
	return cdir() .. "/" .. n .. ".cfg"
end

local function cname(n)
	n = sgsub(tostring(n or ""), '[\\/:%*%?"<>|]', "")
	n = smatch(n, "^%s*(.-)%s*$") or ""
	n = sgsub(n, "%.cfg$", "")
	return ssub(n, 1, 40)
end

local function snap()
	local d = {}
	local els = lib.els
	for i = 1, #els do
		local e = els[i]
		if e.flag and not e.o.nocfg then
			d[e.flag] = e:ser()
		end
	end
	return { ver = lib.ver, flags = d }
end

local function applysnap(d)
	if type(d) ~= "table" then
		return false
	end
	local fl = type(d.flags) == "table" and d.flags or {}
	local els = lib.els
	for i = 1, #els do
		local e = els[i]
		local f = e.flag
		if f and not e.o.nocfg then
			local v = fl[f]
			if v == nil then
				v = e.def
			end
			e:load(v)
		end
	end
	return true
end

local function setcur(n)
	st.cfg = n
	fs.write(lib.dir .. "/last.txt", n or "")
end

function lib:save(n)
	n = cname(n or st.cfg or "default")
	if n == "" then
		n = "default"
	end
	local s = jenc(snap())
	if s and fs.write(cpath(n), s) then
		setcur(n)
		self:notify("saved " .. n .. ".cfg")
		cfgref()
		return true
	end
	return false
end

function lib:load(n)
	n = cname(n)
	local d = jdec(fs.read(cpath(n)))
	if not d then
		self:notify("config not found")
		return false
	end
	applysnap(d)
	setcur(n)
	self:notify("loaded " .. n .. ".cfg")
	cfgref()
	return true
end

function lib:delete(n)
	n = cname(n)
	if not fs.has(cpath(n)) then
		return false
	end
	fs.del(cpath(n))
	if st.cfg == n then
		setcur(nil)
	end
	self:notify("deleted " .. n .. ".cfg")
	cfgref()
	return true
end

function lib:list()
	local out = {}
	local fl = fs.list(cdir())
	for i = 1, #fl do
		local nm = smatch(fl[i], "([^/\\]+)%.cfg$")
		if nm then
			out[#out + 1] = nm
		end
	end
	tsort(out, function(x, y)
		return slower(x) < slower(y)
	end)
	return out
end

function lib:export()
	return jenc(snap())
end

function lib:import(s)
	return applysnap(jdec(s))
end

function cont:configs(o)
	o = o or {}
	local ni = self:input({ name = "config name", tmp = true })
	self:button({
		name = "save",
		cb = function()
			lib:save(ni.val ~= "" and ni.val or nil)
		end,
	})
	self:button({
		name = "load",
		same = true,
		cb = function()
			lib:load(ni.val)
		end,
	})
	self:button({
		name = "delete",
		same = true,
		cb = function()
			lib:delete(ni.val)
		end,
	})
	self:text("cfg list")
	local ls = self:list({
		tmp = true,
		cb = function(v)
			ni:set(v)
		end,
	})
	cfgref = function()
		if st.dead then
			return
		end
		local l = lib:list()
		ls.val = st.cfg
		ls:setvalues(l)
	end
	cfgref()
	if o.autoload ~= false then
		defer(function()
			local n = fs.read(lib.dir .. "/last.txt")
			if n and n ~= "" and fs.has(cpath(n)) and not st.dead then
				lib:load(n)
				ni:set(n, true)
			end
		end)
	end
	return ls
end

function lib:get(f)
	return self.flags[f]
end

function lib:set(f, v, a)
	local e = self.fl[f]
	if not e then
		return nil
	end
	if e.kind == "cpk" then
		e:set(v, a)
	else
		e:set(v)
	end
	return e
end

function lib:el(f)
	return self.fl[f]
end

function lib:onunload(f)
	st.unl[#st.unl + 1] = f
end

function lib:notify(s, t)
	local lf = st.logs
	if not lf or st.dead then
		return
	end
	st.ln += 1
	local f = mk("Frame", { Size = ofs(0, 0), AutomaticSize = aixy, LayoutOrder = st.ln, Parent = lf }, { BackgroundColor3 = "bg" })
	mk("UIStroke", { Thickness = 2, Transparency = 0.4, LineJoinMode = Enum.LineJoinMode.Miter, Parent = f }, { Color = "band" })
	pad(f, m.wp, m.wp, 2, 2)
	mk("TextLabel", { Size = ofs(0, m.tl), AutomaticSize = aix, Text = tostring(s), Parent = f })
	local ch = lf:GetChildren()
	local n, old, ol = 0, nil, math.huge
	for i = 1, #ch do
		local x = ch[i]
		if x:IsA("Frame") then
			n += 1
			if x.LayoutOrder < ol then
				ol, old = x.LayoutOrder, x
			end
		end
	end
	if n > 6 and old then
		old:Destroy()
	end
	delay(t or 3, function()
		if f.Parent then
			f:Destroy()
		end
	end)
end

local thp = { "BackgroundColor3", "TextColor3", "ImageColor3", "Color", "PlaceholderColor3" }
local tha = {}
for i = 1, #thp do
	tha[i] = "t_" .. thp[i]
end

function lib:settheme(k, c)
	if thm[k] == nil or typeof(c) ~= "Color3" then
		return
	end
	thm[k] = c
	local g = st.gui
	if g then
		local ds = g:GetDescendants()
		for i = 1, #ds do
			local o = ds[i]
			for j = 1, #tha do
				if o:GetAttribute(tha[j]) == k then
					o[thp[j]] = c
				end
			end
		end
	end
	local els = self.els
	for i = 1, #els do
		els[i]:draw()
	end
end

local mus = { rk = hs:GenerateGUID(false) }
local mdef = Enum.MouseBehavior.Default

local function mfree(v)
	v = v == true
	if mus.on == v then
		return
	end
	mus.on = v
	if st.modal then
		st.modal.Visible = v
	end
	if v then
		mus.mb, mus.mi = uis.MouseBehavior, uis.MouseIconEnabled
		rs:BindToRenderStep(mus.rk, Enum.RenderPriority.Last.Value, function()
			if uis.MouseBehavior ~= mdef then
				uis.MouseBehavior = mdef
			end
			if not uis.MouseIconEnabled then
				uis.MouseIconEnabled = true
			end
		end)
		return
	end
	pcall(rs.UnbindFromRenderStep, rs, mus.rk)
	if mus.mb then
		uis.MouseBehavior = mus.mb
		uis.MouseIconEnabled = mus.mi
	end
	mus.mb, mus.mi = nil, nil
end

local function rescale()
	local us, g = st.us, st.gui
	if not us or not g then
		return
	end
	local sz = g.AbsoluteSize
	if sz.Y <= 0 then
		sz = workspace.CurrentCamera.ViewportSize
	end
	local s = st.fsc or min(st.sc or 1, (sz.Y - 16) / m.h, (sz.X - 16) / m.w)
	s = clamp(s, 0.35, 3)
	if us.Scale ~= s then
		us.Scale = s
		defer(function()
			local ps = st.pops
			for i = 1, #ps do
				ps[i]:clampit()
			end
		end)
	end
end

function lib:scale(s)
	st.fsc = tonumber(s)
	rescale()
end

function lib:menukey(k)
	if typeof(k) == "EnumItem" then
		k = k.Name
	end
	st.mkey = k
end

local function setexp(v)
	st.exp = v
	local r = st.root
	if not r then
		return
	end
	r.Size = ofs(m.w, v and m.h or m.hc)
	st.body.Visible = v
	st.cdn.Visible = not v
	if not v then
		closeall()
		tiphide()
		stopdrag()
		local l = st.listen
		if l then
			st.listen = nil
			l.lst = false
			l:draw()
		end
	end
	mfree(v and st.shown)
end

function lib:toggle(v)
	if st.dead or not st.root then
		return
	end
	if v == nil then
		v = not st.exp
	end
	if v ~= st.exp then
		setexp(v == true)
	end
end

function lib:show(v)
	if st.dead or not st.root then
		return
	end
	st.shown = v ~= false
	st.root.Visible = st.shown
	if not st.shown then
		closeall()
		tiphide()
	end
	mfree(st.exp and st.shown)
end

local function dragger(hit, obj)
	con(hit.InputBegan, function(i)
		local t = i.UserInputType
		if not isptr(t) then
			return
		end
		local m0, p0 = t == tch and ipos(i) or mpos(), obj.Position
		startdrag(function(mm)
			obj.Position = ud2(p0.X.Scale, p0.X.Offset + mm.X - m0.X, p0.Y.Scale, p0.Y.Offset + mm.Y - m0.Y)
		end, nil, nil, i)
	end)
end

local function loadimgs()
	for k, b in next, imgs do
		local p = lib.dir .. "/assets/" .. k .. "1.png"
		if not fs.has(p) and b64d then
			fs.write(p, b64d(b))
		end
		local ok, id = pcall(getcustomasset, p)
		if ok and type(id) == "string" and id ~= "" then
			ast[k] = id
		end
	end
end

local tabcls = {}
tabcls.__index = tabcls

function tabcls:left()
	return self.cl
end

function tabcls:right()
	return self.cr
end

function tabcls:section(o)
	if type(o) == "string" then
		o = { name = o }
	end
	o = o or {}
	local c = (o.side == 2 or o.side == "right") and self.cr or self.cl
	return c:section(o)
end

local wincls = {}
wincls.__index = wincls

local function mkchild(par, x, w, tab)
	local f = mk("Frame", { Position = ofs(x, 0), Size = ofs(w, m.ch), Parent = par }, { BackgroundColor3 = "bg" })
	bord(f, "cbord")
	local s = scroller(f, ofs(1, 1), ud2(1, -2, 1, -2), m.cp, m.sp)
	return newcont(s.sf, tab, w)
end

function wincls:tab(o)
	if type(o) == "string" then
		o = { name = o }
	end
	o = o or {}
	local t = setmetatable({ win = self, name = o.name or "tab" }, tabcls)
	local tabs = self.tabs
	tabs[#tabs + 1] = t
	local b = mk("TextButton", { BackgroundTransparency = 0, TextXAlignment = xal.Center, Text = t.name, LayoutOrder = #tabs, Parent = self.tb }, { BackgroundColor3 = "btn" })
	bfx(b, "btn", "btnh", "btna")
	t.b = b
	local n = #tabs
	for i = 1, n do
		tabs[i].b.Size = ud2(1 / n, -m.tbg * (n - 1) / n, 1, 0)
	end
	t.pg = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Visible = false, Parent = self.pg })
	local cw = floor((m.w - m.px * 2 - m.cg) / 2)
	t.cl = mkchild(t.pg, 0, cw, t)
	t.cr = mkchild(t.pg, cw + m.cg, m.w - m.px * 2 - m.cg - cw, t)
	con(b.MouseButton1Click, function()
		self:select(t)
	end)
	if not self.cur then
		self:select(t)
	end
	return t
end

function wincls:select(t)
	if self.cur == t then
		return
	end
	closeall()
	tiphide()
	if self.cur then
		self.cur.pg.Visible = false
	end
	self.cur = t
	t.pg.Visible = true
end

function wincls:settitle(s)
	st.ttl.Text = tostring(s or "")
	return self
end

function wincls:toggle(v)
	lib:toggle(v)
	return self
end

function lib:window(o)
	o = o or {}
	local old = genv.grape_lib
	if old and old ~= lib and type(old.unload) == "function" then
		pcall(old.unload, old)
	end
	genv.grape_lib = lib
	lib.dir = o.folder or lib.dir
	fs.dir(lib.dir)
	fs.dir(cdir())
	fs.dir(lib.dir .. "/assets")
	loadimgs()
	if typeof(o.accent) == "Color3" then
		thm.acc = o.accent
	end
	local k0 = o.key
	if typeof(k0) == "EnumItem" then
		k0 = k0.Name
	end
	st.mkey = k0 or "Insert"
	st.sc = o.scale
	local gui = mk("ScreenGui", {
		Name = hs:GenerateGUID(false),
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 10000,
		AutoLocalize = false,
	})
	st.gui = gui
	st.probe = mk("Frame", { BackgroundTransparency = 1, Size = ofs(0, 0), Parent = gui })
	local root = mk("Frame", { AnchorPoint = v2(0.5, 0), Position = ud2(0.5, 0, 0, o.y or 8), Size = ofs(m.w, m.hc), ZIndex = 5, Parent = gui }, { BackgroundColor3 = "bg" })
	st.root = root
	mk("UIStroke", { Thickness = m.bw, Transparency = 0.4, LineJoinMode = Enum.LineJoinMode.Miter, Parent = root }, { Color = "band" })
	st.us = mk("UIScale", { Parent = root })
	local sink = mk("TextButton", { Size = scl(1, 1), ZIndex = 0, Parent = root })
	dragger(sink, root)
	st.ttl = mk("TextLabel", { Position = ofs(0, m.ty), Size = ud2(1, 0, 0, m.th), TextXAlignment = xal.Center, TextSize = m.tts, Text = o.title or "GrapeCheats", Parent = root })
	local ac = mk("Frame", { Position = ofs(m.px, m.ay), Size = ud2(1, -m.px * 2, 0, m.ah), Parent = root }, { BackgroundColor3 = "acc" })
	pill(ac)
	st.cdn = mk("TextButton", { AnchorPoint = v2(0.5, 0.5), Position = ud2(0.5, 0, 0, m.cdy), Size = ofs(36, 20), TextXAlignment = xal.Center, TextSize = m.cts, Text = "\\/", ZIndex = 3, Parent = root })
	local body = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), Visible = false, Parent = root })
	st.body = body
	local tb = mk("Frame", { BackgroundTransparency = 1, Position = ofs(m.px, m.tby), Size = ud2(1, -m.px * 2, 0, m.tbh), Parent = body })
	hlist(tb, m.tbg)
	local pg = mk("Frame", { BackgroundTransparency = 1, Position = ofs(m.px, m.cy), Size = ud2(1, -m.px * 2, 0, m.ch), Parent = body })
	local cup = mk("TextButton", { AnchorPoint = v2(0.5, 0.5), Position = ud2(0.5, 0, 0, m.cvy), Size = ofs(36, 20), TextXAlignment = xal.Center, TextSize = m.cts, Text = "/\\", Parent = body })
	st.pl = mk("Frame", { BackgroundTransparency = 1, Size = scl(1, 1), ZIndex = 50, Parent = root })
	st.modal = mk("TextButton", { Modal = true, Size = ofs(0, 0), Visible = false, Parent = gui })
	con(st.cdn.MouseButton1Click, function()
		lib:toggle(true)
	end)
	con(cup.MouseButton1Click, function()
		lib:toggle(false)
	end)
	tipbuild()
	local ins = gsv:GetGuiInset()
	st.logs = mk("Frame", { BackgroundTransparency = 1, Position = ofs(12, ins.Y + 10), Size = ofs(0, 0), AutomaticSize = aixy, Parent = gui })
	vlist(st.logs, 6)
	st.md:add(uis.InputBegan:Connect(onbegan))
	st.md:add(uis.InputEnded:Connect(onended))
	st.md:add(uis.InputChanged:Connect(onchanged))
	st.md:add(uis.WindowFocusReleased:Connect(relall))
	st.md:add(gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(rescale))
	local w = setmetatable({ tabs = {}, tb = tb, pg = pg, root = root }, wincls)
	st.win = w
	if protect_gui then
		pcall(protect_gui, gui)
	end
	gui.Parent = gethui and gethui() or lp:WaitForChild("PlayerGui")
	rescale()
	setexp(o.open ~= false)
	return w
end

function lib:unload()
	if st.dead then
		return
	end
	closeall()
	tiphide()
	stopdrag()
	mfree(false)
	st.dead = true
	st.listen = nil
	st.tg = nil
	st.md:clean()
	if st.gui then
		st.gui:Destroy()
	end
	local u = st.unl
	for i = 1, #u do
		pcall(u[i])
	end
	tclear(u)
	tclear(st.bmap)
	tclear(st.pops)
	tclear(self.els)
	tclear(self.fl)
	tclear(self.flags)
	tclear(tip)
	st.gui, st.root, st.pl, st.win, st.logs, st.us, st.probe, st.modal, st.body, st.cdn, st.ttl = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	cfgref = function() end
	if genv.grape_lib == self then
		genv.grape_lib = nil
	end
end

return lib
