PlayerFeeling = {}


function PlayerFeeling:Create()
    local feeling = 
    {
        allFeelings = {
            Neutral = {
                    Enter = function()
                        --print("Neutral")
                    end,
                    Update = function()
                        --("Neutral Update")
                    end,
                    Exit = function(player)
                        print("Neutral Exit")
                    end
            },

            Sadness = 
            {
                Enter = function(player)
                    print("Sadness")
                end,
                Update = function(player, dt)
                    print("Sadness Update")
                end,
                Exit = function(player)
                    print("Sadness Exit")
                end
            },
            
            Anger = 
            {
                Enter = function(player)
                    print("Anger")
                end,
                Update = function(player, dt)
                    print("Anger Update")
                end,
                Exit = function(player)
                    print("Anger Exit")
                end
            },
            
            
            Joy = 
            {
                Enter = function(player)
                    print("Joy")
                    player.jumpCount = player.maxJump
                end,
                Update = function(player, dt)
                    print("Joy Update")
                end,
                Exit = function(player)
                    print("Joy Exit")
                    player.jumpCount = 0
                end
            }
        },
        state = nil
    }
    setmetatable(feeling, PlayerFeeling)
    self.__index = self
    feeling.state = feeling.allFeelings.Neutral
    feeling.state.Enter()
    return feeling
end

function PlayerFeeling:SwitchFeeling(feeling) --table
    if feeling == self.state then
        return
    end
    self:Exit()
    self.state = feeling
    self:Enter()
end

function PlayerFeeling:Enter()
    self.state:Enter()
end

function PlayerFeeling:Update()
    self.state:Update()
end

function PlayerFeeling:Exit()
    self.state:Exit()
end

return PlayerFeeling