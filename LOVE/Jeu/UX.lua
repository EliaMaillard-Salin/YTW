UX = {}
list_button = {}

function CreateButton(x, y, image_path)
    Button = {}
    Button.x = x
    Button.y = y
    Button.image = love.graphics.newImage("images/"..image_path..".png")
    Button.width = Button.image:getWidth()
    Button.height = Button.image:getHeight()

    table.insert(list_button, Button)
end

function DetectClick(element, x, y)
    if y > element.y - element.height/2 and y < element.y + element.height/2 then
        if  x > element.x - element.width/2 and x < element.x + element.width/2 then
            --Animation bouton
            -- if love.mousereleased( x, y, button, istouch, presses ) then --!!!!
            --     print("yes")
            -- end
            love.graphics.setColor(55, 00, 00, 55)
        end
    end
end

function UX.Load(screen_width, screen_height)
    CreateButton(screen_width/2, screen_height/3, "start_button")
    CreateButton(screen_width/2, screen_height/2, "settings_button")
end

function UX.Update()
    local x_mouse, y_mouse = love.mouse.getPosition()

    for i, element in ipairs(list_button) do
        DetectClick(element, x_mouse, y_mouse)
    end
end

function UX.Draw()
    local i 
    for i, element in ipairs(list_button) do
        love.graphics.draw(element.image, element.x, element.y, 0, 1, 1, element.width/2, element.height/2)
    end
end