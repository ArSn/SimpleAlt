-- A simple altimeter setter by a few clicks, in 100 and 1000 ft steps
-- (c) Kolja Zuelsdorf

require "graphics"

dataref("SELECTED_ALT", "sim/cockpit2/autopilot/altitude_dial_ft", "writable")








local KazUiUtil = {}
KazUiUtil.__index = KazUiUtil

setmetatable(KazUiUtil, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function KazUiUtil.new()
    local self = setmetatable({}, KazUiUtil)
    return self
end

-- draws an "empty" rectancle (just the lines)
function KazUiUtil.drawRectangle(x1, y1, x2, y2)
    -- top
    graphics.draw_line(x1, y2, x2, y2)
    -- right
    graphics.draw_line(x2, y2, x2, y1)
    -- bottom
    graphics.draw_line(x1, y1, x2, y1)
    -- left
    graphics.draw_line(x1, y1, x1, y2)
end














local KazWindow = {}
KazWindow.__index = KazWindow

setmetatable(KazWindow, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function KazWindow.new(x, y, width, height)
    local self = setmetatable({}, KazWindow)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.title = '';
    return self
end

function KazWindow:setTitle(title)
    self.title = title;
end

function KazWindow:draw()
    -- init the graphics system
    XPLMSetGraphicsState(0,0,0,1,1,0,0)

    -- draw transparent backgroud
    graphics.set_color(0, 0, 0, 0.5)
    graphics.draw_rectangle(self.x, self.y, self.x + self.width, self.y + self.height)

    graphics.set_color(1, 1, 1, 1)

    if self.title ~= '' then
        draw_string_Helvetica_10(self.x + 2, self.y + self.height - 12, self.title)
    end


    -- draw the info text
    --    draw_string_Helvetica_18(SCREEN_WIDTH - 90, 20, string.format("%5d", getNextHighestThousand()))
    --    draw_string_Helvetica_18(SCREEN_WIDTH - 90, 2, string.format("%5d", getNextLowestThousand()))
end











local KazButton = {}
KazButton.__index = KazButton

setmetatable(KazButton, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function KazButton.new(x, y, width, height)
    local self = setmetatable({}, KazButton)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.label = '';
    return self
end

function KazButton:setLabel(label)
    self.label = label;
end

function KazButton:draw()
    -- init the graphics system
    XPLMSetGraphicsState(0,0,0,1,1,0,0)

    -- draw transparent backgroud
    graphics.set_color(0, 0, 0, 0.5)
    graphics.draw_rectangle(self.x, self.y, self.x + self.width, self.y + self.height)

    graphics.set_color(1, 1, 1, 1)

    graphics.set_width(1)

    KazUiUtil.drawRectangle(self.x, self.y, self.x + self.width, self.y + self.height)

    if self.label ~= '' then
        draw_string_Helvetica_10(self.x + 5, self.y + self.height - 15, self.label)
    end
--
--    -- top
--    graphics.draw_line(self.x, self.y + self.height, self.x + self.width, self.y + self.height)
--    -- right
--    graphics.draw_line(self.x + self.width, self.y + self.height, self.x + self.width, self.y)
--    -- bottom
--    graphics.draw_line(self.x, self.y, self.x + self.width, self.y)
--    -- left
--    graphics.draw_line(self.x, self.y, self.x, self.y + self.height)


    -- draw the info text
    --    draw_string_Helvetica_18(SCREEN_WIDTH - 90, 20, string.format("%5d", getNextHighestThousand()))
    --    draw_string_Helvetica_18(SCREEN_WIDTH - 90, 2, string.format("%5d", getNextLowestThousand()))
end








function getNextHighestThousand()
    return math.floor(SELECTED_ALT / 1000 + 1) * 1000
end

function getNextLowestThousand()
    return math.floor((SELECTED_ALT - 1) / 1000) * 1000
end

function getNextHighestHundred()
    return math.floor(SELECTED_ALT / 100 + 1) * 100
end

function getNextLowestHundred()
    return math.floor((SELECTED_ALT - 1) / 100) * 100
end






local simpleAltWindow = KazWindow.new(SCREEN_WIDTH - 115, 20, 95, 75)
simpleAltWindow:setTitle('SimpleAlt');

local increaseByHunderedButton = KazButton.new(simpleAltWindow.x + 5, simpleAltWindow.y + 35, 41, 21)
local decreaseByHunderedButton = KazButton.new(simpleAltWindow.x + 5, simpleAltWindow.y + 5, 41, 21)

local increaseByThousandButton = KazButton.new(simpleAltWindow.x + 50, simpleAltWindow.y + 35, 41, 21)
local decreaseByThousandButton = KazButton.new(simpleAltWindow.x + 50, simpleAltWindow.y + 5, 41, 21)






function draw_alt_selector()
    -- does we have to draw anything?
--    if MOUSE_Y > 50 or MOUSE_X < SCREEN_WIDTH - 100 then
--        return
--    end


    simpleAltWindow:draw()

    increaseByHunderedButton:setLabel(getNextHighestHundred());
    increaseByHunderedButton:draw()

    decreaseByHunderedButton:setLabel(getNextLowestHundred());
    decreaseByHunderedButton:draw()

    increaseByThousandButton:setLabel(getNextHighestThousand());
    increaseByThousandButton:draw()

    decreaseByThousandButton:setLabel(getNextLowestThousand());
    decreaseByThousandButton:draw()
end

do_every_draw("draw_alt_selector()")

function simple_alt_mouse_click_events()
    -- we will only react once
    if MOUSE_STATUS ~= "down" then
        return
    end

    if MOUSE_X > SCREEN_WIDTH - 100 and MOUSE_Y < 50 then
        SELECTED_ALT = getNextHighestThousand()
    end
end

--do_on_mouse_click("simple_alt_mouse_click_events()")








