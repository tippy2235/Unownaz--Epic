getgenv().config = {
    farm = {
        toggle = false,
        singleTarget = false,
        farmPrint = false,
        radius = 70,
        wait = 0.2
    },
    autoLootbag = false,
    autoOrb = false
}
 
repeat task.wait() until game:IsLoaded() if game.PlaceId ~= 8737899170 then game.Players.LocalPlayer:Kick("wrong game") end
print("Pet Simulator 99 | griffindoescooking")
 
local LocalPlayer = game.Players.LocalPlayer
local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart", true)
 
local vim = game:GetService("VirtualInputManager")
local sqrt = math.sqrt
local pow = math.pow
 
local Things = game.workspace['__THINGS']
local Lootbags = Things.Lootbags
local Orbs = Things.Orbs
local ShinyRelics = Things.ShinyRelics
local Breakables = Things.Breakables
local Pets = Things.Pets
local Network = game:GetService("ReplicatedStorage").Network
local PetInventory = LocalPlayer.PlayerGui.Inventory.Frame.Main.Pets.EquippedPets
 
getgenv().currentCoins = {}
getgenv().equippedPets = {}
getgenv().totalClaimed = 0
getgenv().totalTime = 0
 
local function indexPets()
    table.clear(equippedPets)
    for _,pet in ipairs(Pets:GetChildren()) do
        if PetInventory:FindFirstChild(pet.Name) then
            table.insert(equippedPets, pet.Name)
        end
    end
    return equippedPets
end
local function calcDistance(obj1,obj2)
    local pPosX,pPosZ = obj1.CFrame.X,obj1.CFrame.Z
    local hPosX, hPosZ = obj2.CFrame.X, obj2.CFrame.Z
 
    return sqrt(pow(pPosX-hPosX, 2) + pow(pPosZ-hPosZ, 2))
end
local function getCenter()
    local frame = Instance.new("Frame")
    frame.Parent = game.CoreGui
    frame.Name = LocalPlayer.Name
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = UDim2.fromScale(0.5,0.5)
    frame.Size = UDim2.fromOffset(10,10)
    frame.Visible = false
 
    return {frame.AbsolutePosition.X,frame.AbsolutePosition.Y}
end
local function sendNotification(title,text,duration)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = title,
        Text = text,
        Duration = tonumber(duration),
        Callback = function() end,
        Button1 = "Got It!"
    })
end
local libary = loadstring(game:HttpGet("https://raw.githubusercontent.com/idonthaveoneatm/Libraries/normal/tmp/src"))()
local main = libary:CreateWindow({
    Title = "Pet Simulator 99"
})
local farming = main:CreateTab({
    Name = "Farming",
    Icon = "rbxassetid://10709769841"
}) farming:CreateSection("Farming")
local egg = main:CreateTab({
    Name = "Egging",
    Icon = "rbxassetid://10723345518"
}) egg:CreateSection("Egging")
local teleports = main:CreateTab({
    Name = "Teleports"
}) teleports:CreateSection("Teleport")
local credits = main:CreateTab({
    Name = "Credits",
    Icon = "rbxassetid://10723396402"
}) credits:CreateSection("Credits")
 
farming:CreateToggle({
    Name = "Farm Coins",
    Callback = function(value)
        config.farm.toggle = value
        while config.farm.toggle and task.wait() do
 
            for _,v in ipairs(Breakables:GetChildren()) do
                if v.Name ~= "Highlight" and v:FindFirstChild("Hitbox", true) then
                    local part = v:FindFirstChild("Hitbox", true)
 
                    if calcDistance(part, HumanoidRootPart) <= config.farm.radius then
                        if config.farm.singleTarget then
                            local tmpName = v.Name
                            local startTime = os.clock()
 
                            repeat
                                if calcDistance(part, HumanoidRootPart) > config.farm.radius then
                                    break
                                end
                                task.wait(config.farm.wait)
                                Network.Breakables_PlayerDealDamage:FireServer(v.Name)
                            until not Breakables:FindFirstChild(v.Name)
 
                            totalClaimed = totalClaimed + 1; totalTime = totalTime + (os.clock() - startTime)
                            if config.farm.farmPrint then print("farmed "..tmpName.." in: "..tostring(os.clock() - startTime).." Avg: "..tostring(totalTime/totalClaimed)) end
                        else
                            if not table.find(currentCoins, v.Name) then
                                table.insert(currentCoins, v.Name)
                                task.spawn(function()
                                    local tmpPart = part
                                    local tmpName = v.Name
                                    local startTime = os.clock()
                                    repeat
                                        if calcDistance(tmpPart, HumanoidRootPart) > config.farm.radius then
                                            table.remove(currentCoins, table.find(currentCoins, v.Name))
                                            break
                                        end
 
                                        task.wait(config.farm.wait*math.random(1,2))
 
                                        Network.Breakables_PlayerDealDamage:FireServer(tmpName)
                                    until not Breakables:FindFirstChild(tmpName)
 
                                    table.remove(currentCoins, table.find(currentCoins, v.Name))
                                    totalClaimed = totalClaimed + 1; totalTime = totalTime + (os.clock() - startTime)
                                    if config.farm.farmPrint then print("farmed "..tmpName.." in: "..tostring(os.clock() - startTime).." Avg: "..tostring(totalTime/totalClaimed)) end
                                end)
                            end
                        end
                    end
                end
            end
 
        end
    end
})
farming:CreateToggle({
    Name = "Single Target",
    Callback = function(value)
        config.farm.singleTarget = value
    end
})
farming:CreateToggle({
    Name = "Console Print",
    Callback = function(value)
        config.farm.farmPrint = value
    end
})
farming:CreateInput({
    Name = "Radius (Default: 70)",
    Callback = function(value)
        if tonumber(value) then
            config.farm.radius = tonumber(value)
        else
            config.farm.radius = 40
            sendNotification("Radius Error","You need the RADIUS to be a number. It is now 40",50)
        end
    end
})
farming:CreateInput({
    Name = "Wait Time (Default: 0.2)",
    Callback = function(value)
        if tonumber(value) then
            config.farm.wait = tonumber(value)
        else
            config.farm.wait = 0.2
            sendNotification("Wait Time Error","You need the WAIT TIME to be a number. It is now 0.2",50)
        end
    end
})
farming:CreateSection("Collection")
farming:CreateToggle({
    Name = "Collect Orbs",
    Callback = function(value)
        config.autoOrb = value
        while config.autoOrb and task.wait() do
 
            for _, orb in ipairs(Orbs:GetChildren()) do
                if orb:IsA("Part") then
                    orb.CFrame = HumanoidRootPart.CFrame
                end
            end
 
        end
    end
})
farming:CreateToggle({
    Name = "Collect Lootbags",
    Callback = function(value)
        config.autoLootbag = value
        while config.autoLootbag and task.wait() do
 
            for _, lootbag in ipairs(Lootbags:GetDescendants()) do
                if lootbag:IsA("MeshPart") then
                    lootbag.CFrame = HumanoidRootPart.CFrame
                end
            end
 
        end
    end
})
 
egg:CreateTextLabel("Soon...")
 
teleports:CreateTextLabel("Soon...")
 
credits:CreateTextLabel("UI: griffindoescooking")
credits:CreateTextLabel("Script: griffindoescooking")
credits:CreateSection("Support: ")
credits:CreateButton({
    Name = "Discord",
    Callback = function()
        setclipboard("https://discord.gg/DBPHwFyCVT")
    end
})
