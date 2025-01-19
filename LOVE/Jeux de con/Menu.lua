


Button = {}

function Button:Create(x, y, width, height, functionOnClick)
    local btn = {
        x = x,
        y = y,
        w = width, 
        h = height,
        func = functionOnClick
    }
    setmetatable(btn,self)
    self.__index = self
    return btn
end


Menu = {
    Start = nil,
    Settings = nil,
    Exit = nil
}

function  Menu:Init(winW,winH)
    Menu.Start = Button:Create( winW*0.5 - (winW/3) *0.5 ,(winH/4) - 50 )
end

function Menu:Update()
end

function Menu:Draw()
end