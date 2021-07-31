ACCESSOR(PANEL, "Text", "m_sText", "Label")
ACCESSOR(PANEL, "TextColor", "m_cTextColor", color_black)
ACCESSOR(PANEL, "FontFile", "m_sFontFile")
ACCESSOR(PANEL, "FontSize", "m_iFontSize")
ACCESSOR(PANEL, "FontHint", "m_iFontHint")
ACCESSOR(PANEL, "ShadowDistance", "m_iShadowDistance", 1)
ACCESSOR(PANEL, "ShadowColor", "m_cShadowColor", color_lightgrey)
ACCESSOR(PANEL, "OutlineThickness", "m_iOutlineThickness")
ACCESSOR(PANEL, "OutlineColor", "m_cOutlineColor", color_black)
ACCESSOR(PANEL, "Wrapped", "m_bWrapped", false)
ACCESSOR(PANEL, "TextAlignment", "m_sAlignment", "left")

function PANEL:Initialize()
	self:super() -- Initialize our baseclass

	self.m_tTextMargins = { left = 0, top = 0, right = 0, bottom = 0 }

	self:SetBGColor(color_blank)
	self:SetBorderColor(color_blank)
	self:SetFocusable(false)
	
	self.m_pFont = graphics.newFont("fonts/melee.otf", 12)
end

function PANEL:TextMargin(left, top, right, bottom)
	self.m_tTextMargins.left = left
	self.m_tTextMargins.top = top
	self.m_tTextMargins.right = right
	self.m_tTextMargins.bottom = bottom
end

function PANEL:GetDockMargin()
	return self.m_tTextMargins
end

function PANEL:Think(dt)
	if not self.m_pFont and self.m_sFontFile then
		self.m_pFont = graphics.newFont(self.m_sFontFile, self.m_iFontSize, self.m_iFontHint)
	end
end

function PANEL:SetFont(filename, size, hinting)
	self.m_pFont = graphics.newFont(filename, size, hinting)
	self.m_sFontFile = filename
	self.m_iFontSize = size
	self.m_iFontHint = hinting
end

local floor = math.floor

function PANEL:Paint(w, h)
	self:super("Paint", w, h)

	graphics.setColor(self.m_cTextColor)
	graphics.setFont(self.m_pFont)

	local x, y = self.m_tTextMargins.left, self.m_tTextMargins.top

	w = w - self.m_tTextMargins.right - self.m_tTextMargins.left
	h = h - self.m_tTextMargins.top - self.m_tTextMargins.bottom

	local tw,th = self.m_pFont:getWidth(self.m_sText), self.m_pFont:getAscent() - self.m_pFont:getDescent()

	if self.m_bWrapped then
		graphics.printf(self.m_sText, x, y, self:GetWidth(), self.m_sAlignment)
	else
		--print(self.m_pFont:getHeight(), self.m_pFont:getLineHeight(), self.m_pFont:getDescent(), self.m_pFont:getAscent(), self.m_pFont:getBaseline())

		-- Set alignment for non-wrapped text
		if self.m_sAlignment == "center" then
			x, y = x + floor(w/2 - (tw/2)), y + floor(h/2 - (th/2))
		elseif self.m_sAlignment == "right" then
			x, y = x + w - tw, y + floor(h/2 - (th/2))
		else -- Assume left
			y = y + floor(h/2 - (th/2))
		end

		local ol = tonumber(self.m_iOutlineThickness)

		if ol and ol > 0 then
			graphics.setColor(self.m_cOutlineColor)
			graphics.textOutline(self.m_sText, ol, x, y)
		end

		local sd = tonumber(self.m_iShadowDistance)

		if sd and sd > 0 then
			graphics.setColor(self.m_cShadowColor)
			graphics.print(self.m_sText, x + sd, y + sd)
		end

		graphics.setColor(self.m_cTextColor)
		graphics.print(self.m_sText, x, y)
	end
end

function PANEL:SizeToText()
	self:SetSize(self.m_pFont:getWidth(self.m_sText), self.m_pFont:getAscent() - self.m_pFont:getDescent() )
end

function PANEL:WidthToText()
	self:SetWidth(self.m_pFont:getWidth(self.m_sText))
end

gui.register("Label", PANEL, "Panel")