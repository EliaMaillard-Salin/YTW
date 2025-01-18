require ("World")

PlayerFeeling = {} 

function PlayerFeeling:Create()
    local feeling = 
    {
        allFeelings = {
            Neutral = {
                    Enter = function()
                        print("Neutral")
                    end,
                    Update = function()
                        print("Neutral Update")
                    end,
                    Exit = function()
                        print("Neutral Exit")
                    end
            },
            Sadness =     {
                Enter = function()
                    print("Sadness")
                end,
                Update = function()
                    print("Sadness Update")
                end,
                Exit = function()
                    print("Sadness Exit")
                end
            },
            
            Anger = {
                Enter = function()
                    print("Anger")
                end,
                Update = function()
                    print("Anger Update")
                end,
                Exit = function()
                    print("Anger Exit")
                end
            },
            
            
            Joy = {
                Enter = function()
                    print("Joy")
                end,
                Update = function()
                    print("Joy Update")
                end,
                Exit = function()
                    print("Joy Exit")
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

