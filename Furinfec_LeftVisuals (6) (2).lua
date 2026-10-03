local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"
))()

local Window = Library:CreateWindow({
    Title = "kPiannwu Premium ✨",
    Footer = "Basic v2",
    ToggleKeybind = Enum.KeyCode.RightControl,
})

local Tab = Window:AddTab("General", "user")
local Character = Tab:AddLeftGroupbox("Character")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

--// SPEED BOOST
Character:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 21,
    Min = 1,
    Max = 100,
    Rounding = 0,

    Callback = function(Value)
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end,
})

Character:AddToggle("EnableSpeedBoost", {
    Text = "Enable Speed Boost",
    Default = false,

    Callback = function(Value)
        local Character = Player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            if Value then
                Humanoid.WalkSpeed = Library.Options.SpeedBoost.Value
            else
                Humanoid.WalkSpeed = 16
            end
        end
    end,
})

--// FLY
local FlyEnabled = false
local FlyConnection

Character:AddToggle("Fly", {
    Text = "Fly",
    Default = false,

    Callback = function(Value)
        FlyEnabled = Value

        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end

        if not Value then
            local Root = Player.Character
                and Player.Character:FindFirstChild("HumanoidRootPart")

            if Root then
                Root.AssemblyLinearVelocity = Vector3.zero
            end
            return
        end

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then return end

            local Character = Player.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")

            if not Root then return end

            local Camera = workspace.CurrentCamera
            local Speed = Library.Options.FlySpeed.Value

            local Direction = Vector3.zero

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                Direction += Camera.CFrame.LookVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                Direction -= Camera.CFrame.LookVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                Direction -= Camera.CFrame.RightVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                Direction += Camera.CFrame.RightVector
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                Direction += Vector3.new(0, 1, 0)
            end

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                Direction -= Vector3.new(0, 1, 0)
            end

            if Direction.Magnitude > 0 then
                Direction = Direction.Unit * Speed
            end

            Root.AssemblyLinearVelocity = Direction
        end)
    end,
})

Character:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Default = 20,
    Min = 1,
    Max = 100,
    Rounding = 0,
})

--// NOCLIP
local NoclipEnabled = false
local NoclipConnection

Character:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,

    Callback = function(Value)
        NoclipEnabled = Value

        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        if Value then
            NoclipConnection = RunService.Stepped:Connect(function()
                local Character = Player.Character

                if Character then
                    for _, Part in ipairs(Character:GetDescendants()) do
                        if Part:IsA("BasePart") then
                            Part.CanCollide = false
                        end
                    end
                end
            end)
        else
            local Character = Player.Character

            if Character then
                for _, Part in ipairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = true
                    end
                end
            end
        end
    end,
})

--// AUTO PUNCH
local PunchRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("SkillRemote")

Character:AddToggle("AutoPunch", {
    Text = "Auto punch",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Library.Toggles.AutoPunch.Value do

                    local Character = Player.Character
                    local Root = Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if Root then
                        local Camera = workspace.CurrentCamera

                        local args = {
                            [1] = {
                                ["Camera"] = Camera.CFrame,
                                ["SkillId"] = "1",
                                ["Began"] = true,
                                ["CFrame"] = Root.CFrame,
                                ["Typ\208\181"] = 1,
                                ["Aim"] = Root.Position + Camera.CFrame.LookVector * 100
                            }
                        }

                        PunchRemote:FireServer(unpack(args))
                    end

                    task.wait(Library.Options.PunchDelay.Value)
                end
            end)
        end
    end,
})

--// PUNCH DELAY
Character:AddSlider("PunchDelay", {
    Text = "Punch Delay",
    Default = 0.07,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
})

Library:OnUnload(function()
    if FlyConnection then
        FlyConnection:Disconnect()
    end

    if NoclipConnection then
        NoclipConnection:Disconnect()
    end
end)
--// AUTOMATION
local Automation = Tab:AddRightGroupbox("Automation")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- AUTO FARM SPEED
--==================================================

Automation:AddToggle("AutoFarmSpeed", {
    Text = "Auto farm speed",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Library.Toggles.AutoFarmSpeed.Value do
                    local Character = LocalPlayer.Character
                    local Humanoid = Character
                        and Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid then
                        -- Auto walk tại chỗ
                        Humanoid:Move(Vector3.new(1, 0, 0), false)
                    end

                    task.wait(0.05)
                end

                local Character = LocalPlayer.Character
                local Humanoid = Character
                    and Character:FindFirstChildOfClass("Humanoid")

                if Humanoid then
                    Humanoid:Move(Vector3.zero, false)
                end
            end)
        end
    end,
})

--==================================================
-- AUTO GET GOOD BOTH TRADING PLAZA
--==================================================

Automation:AddToggle("AutoGetGoodBoth", {
    Text = "Auto get good both trading plaza",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Library.Toggles.AutoGetGoodBoth.Value do

                    for i = 1, 16 do
                        if not Library.Toggles.AutoGetGoodBoth.Value then
                            break
                        end

                        local Booth = workspace:FindFirstChild("Misc")
                            and workspace.Misc:FindFirstChild("Booths")
                            and workspace.Misc.Booths:FindFirstChild("Booth" .. i)

                        local TradeBooth = Booth
                            and Booth:FindFirstChild("TradeBooth")

                        local RE = TradeBooth
                            and TradeBooth:FindFirstChild("RE")

                        local Claim = RE
                            and RE:FindFirstChild("Claim")

                        if Claim then
                            pcall(function()
                                Claim:FireServer(true)
                            end)
                        end

                        task.wait(0.05)
                    end

                    task.wait(0.05)
                end
            end)
        end
    end,
})

--==================================================
-- AUTO SOUND SERVER / DASH
--==================================================

local SoundServerStarted = false

Automation:AddToggle("AutoSoundServer", {
    Text = "Auto sound server",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        -- Lần đầu chỉ hiện thông báo
        if not SoundServerStarted then
            SoundServerStarted = true

            Library:Notify({
                Title = "Auto sound server",
                Description = "You need bypass cooldown dash",
                Time = 4
            })

            return
        end

        -- Lần bật tiếp theo mới chạy
        task.spawn(function()
            while Library.Toggles.AutoSoundServer.Value do

                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root then
                    local Camera = workspace.CurrentCamera

                    local args = {
                        [1] = {
                            ["Camera"] = Camera.CFrame,
                            ["SkillId"] = "7",
                            ["Typ\208\181"] = 1,
                            ["Began"] = true,
                            ["CFrame"] = Root.CFrame,
                            ["DashDirection"] = Camera.CFrame.LookVector,
                            ["Aim"] = Root.Position
                                + Camera.CFrame.LookVector * 150
                        }
                    }

                    pcall(function()
                        ReplicatedStorage
                            :WaitForChild("Remotes")
                            :WaitForChild("SkillRemote")
                            :FireServer(unpack(args))
                    end)
                end

                task.wait(0.02)
            end
        end)
    end,
})

--==================================================
-- ENEMY BLAST AURA
--==================================================

local EnemyBlastRange = 300

Automation:AddToggle("EnemyBlastAura", {
    Text = "Enemy blast aura",
    Default = false,

    Callback = function(Value)
        if Value then
            task.spawn(function()

                while Library.Toggles.EnemyBlastAura.Value do

                    local Character = LocalPlayer.Character
                    local Root = Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if Root then

                        local MobsFolder = workspace
                            :FindFirstChild("World Mobs")

                        if MobsFolder then

                            for _, Folder in ipairs(MobsFolder:GetChildren()) do

                                if Folder:IsA("Folder") or Folder:IsA("Model") then

                                    for _, Mob in ipairs(Folder:GetChildren()) do

                                        if not Library.Toggles.EnemyBlastAura.Value then
                                            break
                                        end

                                        if Mob:IsA("Model") then

                                            local MobRoot =
                                                Mob:FindFirstChild("HumanoidRootPart")
                                                or Mob.PrimaryPart

                                            if MobRoot then

                                                local Distance =
                                                    (MobRoot.Position - Root.Position).Magnitude

                                                if Distance <= EnemyBlastRange then

                                                    -- Lock mob
                                                    pcall(function()
                                                        ReplicatedStorage
                                                            :WaitForChild("Packages")
                                                            :WaitForChild("_Index")
                                                            :WaitForChild("sleitnick_knit@1.4.7")
                                                            :WaitForChild("knit")
                                                            :WaitForChild("Services")
                                                            :WaitForChild("SkillManager")
                                                            :WaitForChild("RE")
                                                            :WaitForChild("LockedOnChanged")
                                                            :FireServer(Mob)
                                                    end)

                                                    -- Enemy Blast
                                                    local Camera =
                                                        workspace.CurrentCamera

                                                    local args = {
                                                        [1] = {
                                                            ["Camera"] = Camera.CFrame,
                                                            ["SkillId"] = "101",
                                                            ["Began"] = true,
                                                            ["CFrame"] = Root.CFrame,
                                                            ["Typ\208\181"] = 1,
                                                            ["Aim"] = MobRoot.Position
                                                        }
                                                    }

                                                    pcall(function()
                                                        ReplicatedStorage
                                                            :WaitForChild("Remotes")
                                                            :WaitForChild("SkillRemote")
                                                            :FireServer(unpack(args))
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    task.wait(0.02)
                end
            end)
        end
    end,
})

Automation:AddSlider("EnemyBlastRange", {
    Text = "Range enemy blast",
    Default = 300,
    Min = 50,
    Max = 500,
    Rounding = 0,

    Callback = function(Value)
        EnemyBlastRange = Value
    end,
})

--==================================================
-- AUTO KILL ZAJA
--==================================================

Automation:AddToggle("AutoKillZaja", {
    Text = "Auto kill Zaja",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                while Library.Toggles.AutoKillZaja.Value do

                    local EventMobs = workspace
                        :FindFirstChild("World Mobs")
                        and workspace["World Mobs"]:FindFirstChild("Event Mobs")

                    local Zaja = EventMobs
                        and EventMobs:FindFirstChild("Zaja")

                    local Character = LocalPlayer.Character
                    local Root = Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if Zaja and Root then

                        local ZajaRoot =
                            Zaja:FindFirstChild("HumanoidRootPart")
                            or Zaja.PrimaryPart

                        if ZajaRoot then

                            -- Tween liên tục tới Zaja
                            local TargetCFrame =
                                ZajaRoot.CFrame * CFrame.new(0, 0, 8)

                            local Distance =
                                (Root.Position - ZajaRoot.Position).Magnitude

                            local Time =
                                math.clamp(Distance / 250, 0.05, 0.5)

                            local Tween = TweenService:Create(
                                Root,
                                TweenInfo.new(
                                    Time,
                                    Enum.EasingStyle.Linear
                                ),
                                {
                                    CFrame = TargetCFrame
                                }
                            )

                            Tween:Play()
                            Tween.Completed:Wait()
                        end
                    else
                        -- Chờ Zaja xuất hiện
                        task.wait(0.1)
                    end
                end
            end)
        end
    end,
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer



local Tab1 = Window:AddTab("Exploits", "zap")

--==================================================
-- LEFT BOX
--==================================================

local Left = Tab1:AddLeftGroupbox("Bypass")

local DashGuard = false
local TeleportLock = false
local StunGuard = false
local HideEffects = false

local SavedCFrame = nil

-- Bypass Dash -> Dash Guard
Left:AddToggle("BypassDash", {
    Text = "Bypass Dash",
    Default = false,

    Callback = function(Value)
        DashGuard = Value
    end,
})

-- Bypass Teleport -> Position Lock
Left:AddToggle("BypassTeleport", {
    Text = "Bypass Teleport",
    Default = false,

    Callback = function(Value)
        TeleportLock = Value

        local Character = LocalPlayer.Character
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")

        if Value and Root then
            SavedCFrame = Root.CFrame
        else
            SavedCFrame = nil
        end
    end,
})

-- Bypass Stun -> Stun Guard
Left:AddToggle("BypassStun", {
    Text = "Bypass Stun",
    Default = false,

    Callback = function(Value)
        StunGuard = Value
    end,
})

-- Bypass Fake Lockon -> Lockon Tracker
Left:AddToggle("BypassFakeLockon", {
    Text = "Bypass Fake Lockon",
    Default = false,

    Callback = function(Value)
        -- Local tracker only
    end,
})

-- Bypass Skill Effect -> Hide Effects
Left:AddToggle("BypassSkillEffect", {
    Text = "Bypass Skill Effect",
    Default = false,

    Callback = function(Value)
        HideEffects = Value

        local Effects = workspace:FindFirstChild("Effects")

        if Effects then
            for _, Object in ipairs(Effects:GetDescendants()) do
                if Object:IsA("ParticleEmitter")
                or Object:IsA("Trail")
                or Object:IsA("Beam") then
                    Object.Enabled = not Value
                end
            end
        end
    end,
})

--==================================================
-- RIGHT BOX
--==================================================

local Right = Tab1:AddRightGroupbox("Bypass")

local AntiFall = false
local VelocityEnabled = false
local VelocityValue = 16
local InfinitePVP = false
local TeleportLockon = false

local SelectedTarget = nil

-- Anti Fall
Right:AddToggle("AntiFall", {
    Text = "Anti Fall",
    Default = false,

    Callback = function(Value)
        AntiFall = Value
    end,
})

-- Velocity Manipulation
Right:AddToggle("VelocityManipulation", {
    Text = "Velocity Manipulation",
    Default = false,

    Callback = function(Value)
        VelocityEnabled = Value
    end,
})

Right:AddSlider("VelocityValue", {
    Text = "Velocity",
    Default = 16,
    Min = 0,
    Max = 100,
    Rounding = 0,

    Callback = function(Value)
        VelocityValue = Value
    end,
})

-- Infinite PvP
Right:AddToggle("InfinitePvP", {
    Text = "Infinite PvP",
    Default = false,

    Callback = function(Value)
        InfinitePVP = Value
    end,
})

-- Target list
local function GetPlayers()
    local List = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            table.insert(List, Player.Name)
        end
    end

    table.sort(List)

    return List
end

Right:AddDropdown("LockonTarget", {
    Text = "Lockon",
    Values = GetPlayers(),
    Default = nil,

    Callback = function(Value)
        SelectedTarget = Players:FindFirstChild(Value)
    end,
})

Right:AddToggle("TeleportLockon", {
    Text = "Teleport Lockon",
    Default = false,

    Callback = function(Value)
        TeleportLockon = Value
    end,
})

-- Refresh player list
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            Library.Options.LockonTarget:SetValues(GetPlayers())
        end)
    end
end)

--==================================================
-- MAIN LOOP
--==================================================

RunService.Heartbeat:Connect(function()

    local Character = LocalPlayer.Character
    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not Root then
        return
    end

    -- Position Lock
    if TeleportLock and SavedCFrame then
        Root.CFrame = SavedCFrame
        Root.AssemblyLinearVelocity = Vector3.zero
    end

    -- Anti Fall
    if AntiFall then
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall
        or Humanoid:GetState() == Enum.HumanoidStateType.FallingDown then

            Root.AssemblyLinearVelocity = Vector3.new(
                Root.AssemblyLinearVelocity.X,
                0,
                Root.AssemblyLinearVelocity.Z
            )
        end
    end

    -- Velocity
    if VelocityEnabled then
        local Velocity = Root.AssemblyLinearVelocity

        if Velocity.Magnitude > VelocityValue then
            Root.AssemblyLinearVelocity =
                Velocity.Unit * VelocityValue
        end
    end

    -- Stun Guard
    if StunGuard then
        if Humanoid.WalkSpeed < 1 then
            Humanoid.WalkSpeed = 16
        end

        if Humanoid.JumpPower < 1 then
            Humanoid.JumpPower = 50
        end
    end

    -- Teleport Lockon
    if TeleportLockon and SelectedTarget then

        local TargetCharacter = SelectedTarget.Character
        local TargetRoot = TargetCharacter
            and TargetCharacter:FindFirstChild("HumanoidRootPart")

        if TargetRoot then
            Root.CFrame =
                TargetRoot.CFrame * CFrame.new(0, 0, 5)
        end
    end

end)

--==================================================
-- CHARACTER RESPAWN
--==================================================

LocalPlayer.CharacterAdded:Connect(function(Character)

    task.wait(1)

    if TeleportLock then
        local Root = Character:FindFirstChild("HumanoidRootPart")

        if Root then
            SavedCFrame = Root.CFrame
        end
    end
end)

Library:OnUnload(function()
    DashGuard = false
    TeleportLock = false
    StunGuard = false
    HideEffects = false
    AntiFall = false
    VelocityEnabled = false
    InfinitePVP = false
    TeleportLockon = false
end)
-- Obsidian Character / Self / Audio / Remove UI
-- Local-only replacements; no Remote hooks or anti-cheat bypasses.



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer


-- =========================================================
-- CHARACTER / JUMP
-- =========================================================

local JumpBox = Tab:AddLeftGroupbox("Jump")

local InfiniteJump = false
local JumpConnection

JumpBox:AddToggle("EnableJumping", {
    Text = "Enable Jumping",
    Default = true,
    Callback = function(Value)
        local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, Value)
        end
    end,
})

JumpBox:AddToggle("EnableSliding", {
    Text = "Enable Sliding",
    Default = true,
    Callback = function(Value)
        -- Local preference flag. The game keeps control of its own slide system.
    end,
})

JumpBox:AddToggle("InfiniteJumps", {
    Text = "Infinite Jumps",
    Default = false,
    Callback = function(Value)
        InfiniteJump = Value

        if JumpConnection then
            JumpConnection:Disconnect()
            JumpConnection = nil
        end

        if Value then
            JumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end,
})

-- =========================================================
-- SELF
-- =========================================================

local SelfBox = Tab:AddLeftGroupbox("Self")

local DoorReach = false
local IdleKickProtection = false
local PromptReach = 2
local PromptClip = false
local AutoCollect = false
local AutoCollectConnection

SelfBox:AddToggle("DoorReach", {
    Text = "Door Reach",
    Default = false,
    Callback = function(Value)
        DoorReach = Value
    end,
})

SelfBox:AddToggle("DisableIdleKick", {
    Text = "Disable Idle Kick",
    Default = false,
    Callback = function(Value)
        IdleKickProtection = Value
        -- Client-side anti-idle is handled without hooking game remotes.
        if Value then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                LP.Idled:Connect(function()
                    if IdleKickProtection then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                end)
            end)
        end
    end,
})

SelfBox:AddSlider("PromptReachMultiplier", {
    Text = "Prompt Reach Multiplier",
    Default = 2,
    Min = 1,
    Max = 5,
    Rounding = 1,
    Callback = function(Value)
        PromptReach = Value
    end,
})

-- Auto Collect Item: local ProximityPrompt helper.
SelfBox:AddToggle("AutoCollectItem", {
    Text = "Auto Collect Item",
    Default = false,
    Callback = function(Value)
        AutoCollect = Value

        if AutoCollectConnection then
            AutoCollectConnection:Disconnect()
            AutoCollectConnection = nil
        end

        if Value then
            AutoCollectConnection = RunService.Heartbeat:Connect(function()
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then return end

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not AutoCollect then break end

                    if obj:IsA("ProximityPrompt") then
                        local part = obj.Parent
                        if part and part:IsA("BasePart") then
                            local dist = (part.Position - root.Position).Magnitude
                            if dist <= 20 then
                                pcall(function()
                                    if typeof(fireproximityprompt) == "function" then
                                        fireproximityprompt(obj)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end,
})

SelfBox:AddToggle("PromptClip", {
    Text = "Prompt Clip",
    Default = false,
    Callback = function(Value)
        PromptClip = Value

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                pcall(function()
                    obj.RequiresLineOfSight = not Value
                end)
            end
        end
    end,
})

-- =========================================================
-- MISCELLANEOUS
-- =========================================================

local MiscBox = Tab:AddRightGroupbox("Miscellaneous")

MiscBox:AddButton({
    Text = "Play Again",
    Func = function()
        -- Intentionally left game-specific.
    end,
})

MiscBox:AddButton({
    Text = "Return to Lobby",
    Func = function()
        pcall(function()
            ReplicatedStorage
                :WaitForChild("Packages")
                :WaitForChild("_Index")
                :WaitForChild("sleitnick_knit@1.4.7")
                :WaitForChild("knit")
                :WaitForChild("Services")
                :WaitForChild("DungeonService")
                :WaitForChild("RF")
                :WaitForChild("ReturnToWorld")
                :InvokeServer()
        end)
    end,
})

MiscBox:AddButton({
    Text = "Revive",
    Func = function()
        -- Intentionally left game-specific.
    end,
})

MiscBox:AddButton({
    Text = "Reset Character",
    Func = function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
        end
    end,
})

-- =========================================================
-- AUDIO
-- =========================================================

local AudioBox = Tab1:AddLeftGroupbox("Audio")

local RemoveFootsteps = false
local RemoveMusic = false
local RemoveInteractSounds = false

local function SetSoundState(predicate, enabled)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Sound") and predicate(obj) then
            pcall(function()
                obj.Volume = enabled and 1 or 0
            end)
        end
    end
end

AudioBox:AddToggle("RemoveFootstepSounds", {
    Text = "Remove Footstep Sounds",
    Default = false,
    Callback = function(Value)
        RemoveFootsteps = Value
        SetSoundState(function(s)
            local n = string.lower(s.Name)
            return n:find("foot") or n:find("step")
        end, not Value)
    end,
})

AudioBox:AddToggle("RemoveJamminMusic", {
    Text = "Remove Jammin Music",
    Default = false,
    Callback = function(Value)
        RemoveMusic = Value
        SetSoundState(function(s)
            local n = string.lower(s.Name)
            return n:find("jam") or n:find("music")
        end, not Value)
    end,
})

AudioBox:AddToggle("RemoveInteractingSounds", {
    Text = "Remove Interacting Sounds",
    Default = false,
    Callback = function(Value)
        RemoveInteractSounds = Value
        SetSoundState(function(s)
            local n = string.lower(s.Name)
            return n:find("interact") or n:find("pickup") or n:find("prompt")
        end, not Value)
    end,
})

-- =========================================================
-- REMOVE / VISUAL
-- =========================================================

local RemoveBox = Tab1:AddRightGroupbox("Remove")

local HiddenEntities = {
    Screech = false,
    Halt = false,
    A90 = false,
    Dread = false,
    Surge = false,
}

local function SetEntityHidden(name, hidden)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == name then
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.LocalTransparencyModifier = hidden and 1 or 0
                    end)
                elseif part:IsA("ParticleEmitter")
                    or part:IsA("Trail")
                    or part:IsA("Beam") then
                    pcall(function()
                        part.Enabled = not hidden
                    end)
                end
            end

            if obj:IsA("BasePart") then
                pcall(function()
                    obj.LocalTransparencyModifier = hidden and 1 or 0
                end)
            end
        end
    end
end

for _, name in ipairs({"Screech", "Halt", "A-90", "Dread", "Surge"}) do
    local key = name:gsub("%W", "")
    RemoveBox:AddToggle("Remove_" .. key, {
        Text = "Remove " .. name,
        Default = false,
        Callback = function(Value)
            HiddenEntities[name] = Value
            SetEntityHidden(name, Value)
        end,
    })
end

RemoveBox:AddDivider()

RemoveBox:AddToggle("HideDamageEffects", {
    Text = "Hide Damage Effects",
    Default = false,
    Callback = function(Value)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter")
                or obj:IsA("Beam")
                or obj:IsA("Trail") then
                local n = string.lower(obj.Name)
                if n:find("damage") or n:find("hit") then
                    pcall(function()
                        obj.Enabled = not Value
                    end)
                end
            end
        end
    end,
})

-- Refresh local visual/audio changes periodically.
task.spawn(function()
    while task.wait(1) do
        for name, hidden in pairs(HiddenEntities) do
            if hidden then
                SetEntityHidden(name, true)
            end
        end

        if RemoveFootsteps then
            SetSoundState(function(s)
                local n = string.lower(s.Name)
                return n:find("foot") or n:find("step")
            end, false)
        end

        if RemoveMusic then
            SetSoundState(function(s)
                local n = string.lower(s.Name)
                return n:find("jam") or n:find("music")
            end, false)
        end

        if RemoveInteractSounds then
            SetSoundState(function(s)
                local n = string.lower(s.Name)
                return n:find("interact") or n:find("pickup") or n:find("prompt")
            end, false)
        end
    end
end)

Library:OnUnload(function()
    if JumpConnection then
        JumpConnection:Disconnect()
    end

    if AutoCollectConnection then
        AutoCollectConnection:Disconnect()
    end
end)
--// =========================================================
--// TAB 2 - VISUALS / ESP
--// Paste after Library + Window have already been created
--// =========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Options = Library.Options
local Toggles = Library.Toggles

--==========================================================
-- SETTINGS
--==========================================================

local NOTIFY_SOUND_ID = "rbxassetid://6026984224"

local HEALTH_DAMAGE_PERCENT = 0.10
local HEALTH_DAMAGE_WINDOW = 0.45
local ENERGY_PERCENT = 0.10

local ESP_UPDATE_RATE = 0.20

local ESPSettings = {
    Rainbow = false,
    ShowDistance = true,

    FillTransparency = 0.75,
    OutlineTransparency = 0,
    TextTransparency = 0,
    TextOutlineTransparency = 0,

    FadeTime = 0.25,
    RenderLimit = 240,
    TextSize = 20,
    Font = Enum.Font.Highway,

    MobColor = Color3.fromRGB(255, 0, 0),
    PlayerColor = Color3.fromRGB(255, 255, 255),
    ItemColor = Color3.fromRGB(170, 0, 255),
    OrbColor = Color3.fromRGB(255, 255, 0),
    QuestColor = Color3.fromRGB(0, 255, 0),
}

--==========================================================
-- TAB 2
--==========================================================

local Tab2 = Window:AddTab("Visuals", "eye")


--==========================================================
-- LEFT BOX: CAMERA
--==========================================================

local CameraBox = Tab2:AddLeftGroupbox("Camera", "camera")
local Lighting = game:GetService("Lighting")

local OriginalAmbient = Lighting.Ambient
local OriginalOutdoorAmbient = Lighting.OutdoorAmbient
local OriginalFogEnd = Lighting.FogEnd
local OriginalFogStart = Lighting.FogStart
local OriginalCameraMode = LocalPlayer.CameraMode
local OriginalMinZoom = LocalPlayer.CameraMinZoomDistance
local OriginalMaxZoom = LocalPlayer.CameraMaxZoomDistance

CameraBox:AddToggle("VisualAmbient", {
    Text = "Ambient",
    Default = true,
    Callback = function(Value)
        if Value then
            Lighting.Ambient = Color3.fromRGB(80, 80, 100)
            Lighting.OutdoorAmbient = Color3.fromRGB(80, 80, 100)
        else
            Lighting.Ambient = OriginalAmbient
            Lighting.OutdoorAmbient = OriginalOutdoorAmbient
        end
    end,
})

CameraBox:AddSlider("VisualFOV", {
    Text = "Field of View",
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        Camera.FieldOfView = Value
    end,
})

CameraBox:AddToggle("RemoveCameraShake", {
    Text = "Remove Camera Shake",
    Default = false,
    Callback = function(Value)
        -- Generic local camera shake removal is game-dependent.
        -- This toggle is kept local so it does not interfere with game remotes.
    end,
})

CameraBox:AddToggle("RemoveCameraBobbing", {
    Text = "Remove Camera Bobbing",
    Default = false,
    Callback = function(Value)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            if Value then
                Humanoid.CameraOffset = Vector3.zero
            end
        end
    end,
})

CameraBox:AddToggle("RemoveCutscenes", {
    Text = "Remove Cutscenes",
    Default = false,
    Callback = function(Value)
        -- Local-only placeholder; cutscenes are game-specific.
    end,
})

CameraBox:AddToggle("RemoveFog", {
    Text = "Remove Fog",
    Default = false,
    Callback = function(Value)
        if Value then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1000000
        else
            Lighting.FogStart = OriginalFogStart
            Lighting.FogEnd = OriginalFogEnd
        end
    end,
})

CameraBox:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Default = false,
    Callback = function(Value)
        if Value then
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance = 5
            LocalPlayer.CameraMaxZoomDistance = 20
        else
            LocalPlayer.CameraMode = OriginalCameraMode
            LocalPlayer.CameraMinZoomDistance = OriginalMinZoom
            LocalPlayer.CameraMaxZoomDistance = OriginalMaxZoom
        end
    end,
})

CameraBox:AddSlider("ThirdPersonX", {
    Text = "X Offset",
    Default = 1.5,
    Min = -10,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Toggles.ThirdPerson.Value then
            Humanoid.CameraOffset = Vector3.new(
                Value,
                Library.Options.ThirdPersonY.Value,
                Library.Options.ThirdPersonZ.Value
            )
        end
    end,
})

CameraBox:AddSlider("ThirdPersonY", {
    Text = "Y Offset",
    Default = 1,
    Min = -10,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Toggles.ThirdPerson.Value then
            Humanoid.CameraOffset = Vector3.new(
                Library.Options.ThirdPersonX.Value,
                Value,
                Library.Options.ThirdPersonZ.Value
            )
        end
    end,
})

CameraBox:AddSlider("ThirdPersonZ", {
    Text = "Z Offset",
    Default = 5,
    Min = -20,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Toggles.ThirdPerson.Value then
            Humanoid.CameraOffset = Vector3.new(
                Library.Options.ThirdPersonX.Value,
                Library.Options.ThirdPersonY.Value,
                Value
            )
        end
    end,
})

CameraBox:AddToggle("WallCheck", {
    Text = "Wall Check",
    Default = false,
    Callback = function(Value)
        -- Camera collision is handled by Roblox's normal camera controller.
    end,
})

CameraBox:AddToggle("ViewmodelOffset", {
    Text = "Viewmodel Offset",
    Default = false,
    Callback = function(Value)
        -- Generic viewmodel offsets are game-specific.
    end,
})

CameraBox:AddSlider("ViewmodelX", {
    Text = "X Offset",
    Default = 0,
    Min = -10,
    Max = 10,
    Rounding = 1,
})


--==========================================================
-- HELPERS
--==========================================================

local function Notify(title, text)
    Library:Notify({
        Title = title,
        Description = text,
        Time = 4,
        SoundId = NOTIFY_SOUND_ID,
        Volume = 0.7,
    })
end

local function GetRoot(instance)
    if not instance then
        return nil
    end

    if instance:IsA("BasePart") then
        return instance
    end

    if instance:IsA("Model") then
        local root =
            instance:FindFirstChild("HumanoidRootPart")
            or instance.PrimaryPart

        if root and root:IsA("BasePart") then
            return root
        end

        for _, v in ipairs(instance:GetDescendants()) do
            if v:IsA("BasePart") then
                return v
            end
        end
    end

    return nil
end

local function GetDistance(instance)
    local root = GetRoot(instance)
    local char = LocalPlayer.Character
    local myRoot = char and GetRoot(char)

    if root and myRoot then
        return (root.Position - myRoot.Position).Magnitude
    end

    return math.huge
end

local function GetRainbowColor()
    return Color3.fromHSV((tick() % 5) / 5, 1, 1)
end

--==========================================================
-- RIGHT BOX: ENTITIES
--==========================================================

local EntitiesBox = Tab2:AddRightGroupbox("Entities", "radar")

-- MOBS DROPDOWN
local WorldMobs = Workspace:FindFirstChild("World Mobs")

local function GetMobFolders()
    local result = {}

    if WorldMobs then
        for _, child in ipairs(WorldMobs:GetChildren()) do
            table.insert(result, child.Name)
        end
    end

    table.sort(result)
    return result
end

local MobFolderNames = GetMobFolders()

local MobDropdown = EntitiesBox:AddDropdown("MobEntityList", {
    Values = MobFolderNames,
    Default = MobFolderNames,
    Multi = true,
    Searchable = true,
    MaxVisibleDropdownItems = 8,
    Text = "Mobs",
})

-- ITEM LIST
local function GetItemNames()
    local result = {}

    local PickItem = Workspace:FindFirstChild("PickItem")

    if PickItem then
        for _, child in ipairs(PickItem:GetChildren()) do
            table.insert(result, child.Name)
        end
    end

    table.sort(result)

    if #result == 0 then
        table.insert(result, "No Items")
    end

    return result
end

local ItemDropdown = EntitiesBox:AddDropdown("ItemList", {
    Values = GetItemNames(),
    Default = 1,
    Multi = false,
    Searchable = true,
    MaxVisibleDropdownItems = 8,
    Text = "Item List",
})

-- EQUIP TOOL SLOT
local SelectedSlot = 1

EntitiesBox:AddDropdown("EquipToolSlot", {
    Values = {
        "1",
        "2",
        "3",
        "4",
        "5"
    },
    Default = "1",
    Multi = false,
    Text = "Equiptools Slot",

    Callback = function(Value)
        SelectedSlot = tonumber(Value) or 1
    end,
})

local EquipRemote

pcall(function()
    EquipRemote =
        game:GetService("ReplicatedStorage")
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.4.7")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("ToolService")
        :WaitForChild("RE")
        :WaitForChild("UpdatePlayerToolbarSelection")
end)

EntitiesBox:AddToggle("EquipTools", {
    Text = "Equiptools",
    Default = false,

    Callback = function(Value)
        if not Value or not EquipRemote then
            return
        end

        task.spawn(function()
            while Toggles.EquipTools.Value do
                pcall(function()
                    EquipRemote:FireServer(SelectedSlot)
                end)

                task.wait(0.10)
            end
        end)
    end,
})

--==========================================================
-- NOTIFICATIONS
--==========================================================

EntitiesBox:AddDivider()

local NotifyCrit = EntitiesBox:AddToggle("NotifyCritDamage", {
    Text = "Notify Crit Dame",
    Default = false,
})

local NotifyEnergy = EntitiesBox:AddToggle("NotifyEnergy", {
    Text = "Notify Energy",
    Default = false,
})

local NotifyHaste = EntitiesBox:AddToggle("NotifyHasteTime", {
    Text = "Notify Haste Time",
    Default = false,
})

--==========================================================
-- MOB SPAWN NOTIFIER
--==========================================================

local MobConnections = {}

local function IsMobFolderSelected(folderName)
    local value = MobDropdown.Value

    if type(value) == "table" then
        return value[folderName] == true
    end

    return false
end

local function NotifyMobSpawn(instance)
    if not instance or not instance.Parent then
        return
    end

    Notify(
        "Mob Spawn",
        "Spawned: " .. instance.Name
    )
end

local function WatchMobFolder(folder)
    if not folder then
        return
    end

    if MobConnections[folder] then
        MobConnections[folder]:Disconnect()
    end

    MobConnections[folder] = folder.ChildAdded:Connect(function(child)
        task.wait()

        if IsMobFolderSelected(folder.Name) then
            NotifyMobSpawn(child)
        end
    end)
end

if WorldMobs then
    for _, folder in ipairs(WorldMobs:GetChildren()) do
        WatchMobFolder(folder)
    end

    WorldMobs.ChildAdded:Connect(function(folder)
        WatchMobFolder(folder)

        task.wait()

        if IsMobFolderSelected(folder.Name) then
            NotifyMobSpawn(folder)
        end
    end)
end

--==========================================================
-- PLAYER HEALTH / ENERGY NOTIFIER
--==========================================================

local HealthConnections = {}
local EnergyConnections = {}

local function SetupCharacter(character)
    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")
        or character:WaitForChild("Humanoid", 5)

    if humanoid then
        if HealthConnections[humanoid] then
            HealthConnections[humanoid]:Disconnect()
        end

        local lastHealth = humanoid.Health
        local lastDamageTime = 0

        HealthConnections[humanoid] =
            humanoid.HealthChanged:Connect(function(newHealth)

                if Toggles.NotifyCritDamage.Value then
                    local maxHealth = humanoid.MaxHealth

                    if maxHealth > 0 then
                        local damage = lastHealth - newHealth
                        local percent = damage / maxHealth

                        if damage > 0
                            and percent >= HEALTH_DAMAGE_PERCENT
                            and (tick() - lastDamageTime) <= HEALTH_DAMAGE_WINDOW then

                            Notify(
                                "Crit Dame",
                                string.format(
                                    "-%.0f HP (%.1f%%)",
                                    damage,
                                    percent * 100
                                )
                            )
                        end

                        if damage > 0 then
                            lastDamageTime = tick()
                        end
                    end
                end

                lastHealth = newHealth
            end)
    end

    local status =
        Workspace:FindFirstChild("Characters")
        and Workspace.Characters:FindFirstChild(LocalPlayer.Name)
        and Workspace.Characters[LocalPlayer.Name]:FindFirstChild("Status")

    if status then
        local currentEnergy = status:FindFirstChild("CurrentEnergy")
        local maxEnergy = status:FindFirstChild("MaxEnergy")

        if currentEnergy and maxEnergy then

            if EnergyConnections[currentEnergy] then
                EnergyConnections[currentEnergy]:Disconnect()
            end

            local warned = false

            EnergyConnections[currentEnergy] =
                currentEnergy:GetPropertyChangedSignal("Value"):Connect(function()

                    if not Toggles.NotifyEnergy.Value then
                        warned = false
                        return
                    end

                    local max = tonumber(maxEnergy.Value) or 0
                    local current = tonumber(currentEnergy.Value) or 0

                    if max > 0 then
                        local percent = current / max

                        if percent <= ENERGY_PERCENT then
                            if not warned then
                                warned = true

                                Notify(
                                    "Energy",
                                    string.format(
                                        "Energy thấp: %.1f%%",
                                        percent * 100
                                    )
                                )
                            end
                        else
                            warned = false
                        end
                    end
                end)
        end
    end
end

if LocalPlayer.Character then
    task.spawn(function()
        SetupCharacter(LocalPlayer.Character)
    end)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    SetupCharacter(character)
end)

--==========================================================
-- HASTE TIME
--==========================================================

local ScriptStartTime = tick()

task.spawn(function()
    while task.wait(1) do
        if Toggles.NotifyHasteTime.Value then
            local elapsed = math.floor(tick() - ScriptStartTime)

            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60

            Notify(
                "Haste Time",
                string.format(
                    "Script đã chạy: %02d:%02d:%02d",
                    hours,
                    minutes,
                    seconds
                )
            )

            -- Chỉ notify mỗi 60 giây
            task.wait(59)
        end
    end
end)

--==========================================================
-- ESP SETTINGS BOX
--==========================================================

local ESPSettingsBox = Tab2:AddRightGroupbox("ESP", "eye")

local ESPMobsToggle
local ESPPlayersToggle
local ESPItemsToggle
local ESPOrbToggle
local ESPQuestToggle

--==========================================================
-- ESP OBJECT STORAGE
--==========================================================

local ESPObjects = {}

local function DestroyESP(instance)
    local data = ESPObjects[instance]

    if not data then
        return
    end

    if data.Highlight then
        data.Highlight:Destroy()
    end

    if data.Billboard then
        data.Billboard:Destroy()
    end

    ESPObjects[instance] = nil
end

local function GetESPColor(kind)
    if ESPSettings.Rainbow then
        return GetRainbowColor()
    end

    if kind == "Mobs" then
        return ESPSettings.MobColor
    elseif kind == "Players" then
        return ESPSettings.PlayerColor
    elseif kind == "Items" then
        return ESPSettings.ItemColor
    elseif kind == "Orb" then
        return ESPSettings.OrbColor
    elseif kind == "Quest" then
        return ESPSettings.QuestColor
    end

    return Color3.new(1, 1, 1)
end

local function CreateESP(instance, kind)
    if not instance or not instance.Parent then
        return
    end

    if ESPObjects[instance] then
        return
    end

    local root = GetRoot(instance)

    if not root then
        return
    end

    local color = GetESPColor(kind)

    local highlight = Instance.new("Highlight")
    highlight.Name = "AbyssallESP"
    highlight.Adornee = instance:IsA("Model") and instance or root
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = ESPSettings.FillTransparency
    highlight.OutlineTransparency = ESPSettings.OutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = root

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AbyssallESPText"
    billboard.Adornee = root
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.fromOffset(300, 60)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.MaxDistance = 10000
    billboard.Parent = root

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = ESPSettings.Font
    label.TextSize = ESPSettings.TextSize
    label.TextColor3 = color
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextTransparency = ESPSettings.TextTransparency
    label.TextStrokeTransparency = ESPSettings.TextOutlineTransparency
    label.Text = instance.Name
    label.Parent = billboard

    ESPObjects[instance] = {
        Highlight = highlight,
        Billboard = billboard,
        Label = label,
        Kind = kind,
    }
end

--==========================================================
-- ESP SCANNERS
--==========================================================

local function AddFolderESP(folder, kind)
    if not folder then
        return
    end

    for _, child in ipairs(folder:GetChildren()) do
        CreateESP(child, kind)
    end
end

local function RemoveInvalidESP()
    for instance in pairs(ESPObjects) do
        if not instance
            or not instance.Parent
            or not GetRoot(instance) then

            DestroyESP(instance)
        end
    end
end

--==========================================================
-- ESP TOGGLES
--==========================================================

ESPMobsToggle = ESPSettingsBox:AddToggle("ESPMobs", {
    Text = "Mobs",
    Default = false,
})

ESPPlayersToggle = ESPSettingsBox:AddToggle("ESPPlayers", {
    Text = "Players",
    Default = false,
})

ESPItemsToggle = ESPSettingsBox:AddToggle("ESPItems", {
    Text = "Items",
    Default = false,
})

ESPOrbToggle = ESPSettingsBox:AddToggle("ESPStardustOrb", {
    Text = "Stardust Orb",
    Default = false,
})

ESPQuestToggle = ESPSettingsBox:AddToggle("ESPQuestNPC", {
    Text = "Quest NPC",
    Default = false,
})

--==========================================================
-- ESP COLORS
--==========================================================

ESPMobsToggle:AddColorPicker("MobsESPColor", {
    Default = ESPSettings.MobColor,
    Title = "Mobs Color",

    Callback = function(Value)
        ESPSettings.MobColor = Value
    end,
})

ESPPlayersToggle:AddColorPicker("PlayersESPColor", {
    Default = ESPSettings.PlayerColor,
    Title = "Players Color",

    Callback = function(Value)
        ESPSettings.PlayerColor = Value
    end,
})

ESPItemsToggle:AddColorPicker("ItemsESPColor", {
    Default = ESPSettings.ItemColor,
    Title = "Items Color",

    Callback = function(Value)
        ESPSettings.ItemColor = Value
    end,
})

ESPOrbToggle:AddColorPicker("OrbESPColor", {
    Default = ESPSettings.OrbColor,
    Title = "Orb Color",

    Callback = function(Value)
        ESPSettings.OrbColor = Value
    end,
})

ESPQuestToggle:AddColorPicker("QuestESPColor", {
    Default = ESPSettings.QuestColor,
    Title = "Quest Color",

    Callback = function(Value)
        ESPSettings.QuestColor = Value
    end,
})

--==========================================================
-- ESP SETTINGS
--==========================================================

ESPSettingsBox:AddToggle("RainbowESP", {
    Text = "Rainbow Effect",
    Default = false,

    Callback = function(Value)
        ESPSettings.Rainbow = Value
    end,
})

ESPSettingsBox:AddToggle("ShowDistance", {
    Text = "Show Distance",
    Default = true,

    Callback = function(Value)
        ESPSettings.ShowDistance = Value
    end,
})

ESPSettingsBox:AddSlider("FillTransparency", {
    Text = "Fill Transparency",
    Default = 0.75,
    Min = 0,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        ESPSettings.FillTransparency = Value
    end,
})

ESPSettingsBox:AddSlider("OutlineTransparency", {
    Text = "Outline Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        ESPSettings.OutlineTransparency = Value
    end,
})

ESPSettingsBox:AddSlider("TextTransparency", {
    Text = "Text Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        ESPSettings.TextTransparency = Value
    end,
})

ESPSettingsBox:AddSlider("TextOutlineTransparency", {
    Text = "Text Outline Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 2,

    Callback = function(Value)
        ESPSettings.TextOutlineTransparency = Value
    end,
})

ESPSettingsBox:AddSlider("FadeTime", {
    Text = "Fade Time",
    Default = 0.25,
    Min = 0,
    Max = 2,
    Rounding = 2,

    Callback = function(Value)
        ESPSettings.FadeTime = Value
    end,
})

ESPSettingsBox:AddSlider("RenderLimit", {
    Text = "Render Limit",
    Default = 240,
    Min = 10,
    Max = 500,
    Rounding = 0,

    Callback = function(Value)
        ESPSettings.RenderLimit = Value
    end,
})

ESPSettingsBox:AddSlider("TextSize", {
    Text = "Text Size",
    Default = 20,
    Min = 8,
    Max = 32,
    Rounding = 0,

    Callback = function(Value)
        ESPSettings.TextSize = Value
    end,
})

ESPSettingsBox:AddDropdown("TextFont", {
    Values = {
        "Highway",
        "Gotham",
        "SourceSans",
        "Arial"
    },

    Default = "Highway",
    Text = "Text Font",

    Callback = function(Value)
        local fonts = {
            Highway = Enum.Font.Highway,
            Gotham = Enum.Font.Gotham,
            SourceSans = Enum.Font.SourceSans,
            Arial = Enum.Font.Arial,
        }

        ESPSettings.Font = fonts[Value] or Enum.Font.Highway
    end,
})

--==========================================================
-- ESP UPDATE
--==========================================================

local function ScanESP()
    -- MOBS
    if Toggles.ESPMobs.Value then
        local EventMobs =
            WorldMobs
            and WorldMobs:FindFirstChild("Event Mobs")

        if EventMobs then
            AddFolderESP(EventMobs, "Mobs")
        end
    end

    -- PLAYERS
    if Toggles.ESPPlayers.Value then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player.Character, "Players")
            end
        end
    end

    -- ITEMS
    if Toggles.ESPItems.Value then
        local PickItem = Workspace:FindFirstChild("PickItem")

        if PickItem then
            AddFolderESP(PickItem, "Items")
        end
    end

    -- STARDUST ORB
    if Toggles.ESPStardustOrb.Value then
        local OrbFolder =
            Workspace
            :FindFirstChild("Misc")
            and Workspace.Misc:FindFirstChild("DragonSphereSpawns")

        if OrbFolder then
            AddFolderESP(OrbFolder, "Orb")
        end
    end

    -- QUEST NPC
    if Toggles.ESPQuestNPC.Value then
        local QuestFolder =
            Workspace
            :FindFirstChild("Misc")
            and Workspace.Misc:FindFirstChild("NPC")
            and Workspace.Misc.NPC:FindFirstChild("Quests")

        if QuestFolder then
            AddFolderESP(QuestFolder, "Quest")
        end
    end

    -- UPDATE EXISTING
    local candidates = {}

    for instance, data in pairs(ESPObjects) do
        if instance.Parent then
            table.insert(candidates, {
                Instance = instance,
                Data = data,
                Distance = GetDistance(instance),
            })
        end
    end

    table.sort(candidates, function(a, b)
        return a.Distance < b.Distance
    end)

    for index, entry in ipairs(candidates) do
        local data = entry.Data
        local enabled = index <= ESPSettings.RenderLimit

        if data.Highlight then
            data.Highlight.Enabled = enabled

            local color = GetESPColor(data.Kind)

            data.Highlight.FillColor = color
            data.Highlight.OutlineColor = color
            data.Highlight.FillTransparency =
                ESPSettings.FillTransparency
            data.Highlight.OutlineTransparency =
                ESPSettings.OutlineTransparency
        end

        if data.Label then
            data.Label.Visible = enabled

            local color = GetESPColor(data.Kind)

            data.Label.TextColor3 = color
            data.Label.TextSize = ESPSettings.TextSize
            data.Label.Font = ESPSettings.Font
            data.Label.TextTransparency =
                ESPSettings.TextTransparency
            data.Label.TextStrokeTransparency =
                ESPSettings.TextOutlineTransparency

            if ESPSettings.ShowDistance then
                data.Label.Text =
                    string.format(
                        "%s\n[%d]",
                        entry.Instance.Name,
                        math.floor(entry.Distance)
                    )
            else
                data.Label.Text = entry.Instance.Name
            end
        end
    end

    RemoveInvalidESP()
end

--==========================================================
-- AUTO CLEAN / RESCAN
--==========================================================

task.spawn(function()
    while task.wait(ESP_UPDATE_RATE) do
        if Library.Unloaded then
            break
        end

        pcall(ScanESP)
    end
end)

--==========================================================
-- REFRESH ITEM DROPDOWN
--==========================================================

task.spawn(function()
    while task.wait(2) do
        if Library.Unloaded then
            break
        end

        pcall(function()
            local values = GetItemNames()

            if Options.ItemList then
                Options.ItemList:SetValues(values)
            end
        end)
    end
end)

--==========================================================
-- CLEANUP WHEN ESP IS TURNED OFF
--==========================================================

local function CleanupKind(kind)
    for instance, data in pairs(ESPObjects) do
        if data.Kind == kind then
            DestroyESP(instance)
        end
    end
end

ESPMobsToggle:OnChanged(function(Value)
    if not Value then
        CleanupKind("Mobs")
    end
end)

ESPPlayersToggle:OnChanged(function(Value)
    if not Value then
        CleanupKind("Players")
    end
end)

ESPItemsToggle:OnChanged(function(Value)
    if not Value then
        CleanupKind("Items")
    end
end)

ESPOrbToggle:OnChanged(function(Value)
    if not Value then
        CleanupKind("Orb")
    end
end)

ESPQuestToggle:OnChanged(function(Value)
    if not Value then
        CleanupKind("Quest")
    end
end)

--==========================================================
-- LIVE CHARACTER ESP REFRESH
--==========================================================

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)

        if Toggles.ESPPlayers.Value then
            CreateESP(player.Character, "Players")
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        DestroyESP(player.Character)
    end
end)

--==========================================================
-- AUTO WATCH NEW OBJECTS
--==========================================================

local function ConnectFolder(folder, kind)
    if not folder then
        return
    end

    folder.ChildAdded:Connect(function(child)
        task.wait()

        if kind == "Mobs" and Toggles.ESPMobs.Value then
            CreateESP(child, "Mobs")

        elseif kind == "Items" and Toggles.ESPItems.Value then
            CreateESP(child, "Items")

        elseif kind == "Orb" and Toggles.ESPStardustOrb.Value then
            CreateESP(child, "Orb")

        elseif kind == "Quest" and Toggles.ESPQuestNPC.Value then
            CreateESP(child, "Quest")
        end
    end)
end

ConnectFolder(
    WorldMobs and WorldMobs:FindFirstChild("Event Mobs"),
    "Mobs"
)

ConnectFolder(
    Workspace:FindFirstChild("PickItem"),
    "Items"
)

ConnectFolder(
    Workspace:FindFirstChild("Misc")
        and Workspace.Misc:FindFirstChild("DragonSphereSpawns"),
    "Orb"
)

ConnectFolder(
    Workspace:FindFirstChild("Misc")
        and Workspace.Misc:FindFirstChild("NPC")
        and Workspace.Misc.NPC:FindFirstChild("Quests"),
    "Quest"
)

print("[Abyssall] Visuals Tab 2 loaded.")
--==========================================================
-- TAB 3 : FLOORS
--==========================================================

local Tab3 = Window:AddTab("Floors", "globe")

local FloorsLeft = Tab3:AddLeftGroupbox("Visuals")
local FloorsBypass = Tab3:AddLeftGroupbox("Bypass")

local FloorsAuto = Tab3:AddRightGroupbox("Automation")
local FloorsCompletion = Tab3:AddRightGroupbox("Completion")

--==========================================================
-- SERVICES
--==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

local WorldMobs = workspace:FindFirstChild("World Mobs")
local CharactersFolder = workspace:FindFirstChild("Characters")

local SkillManagerRE =
    ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.4.7")
    :WaitForChild("knit")
    :WaitForChild("Services")
    :WaitForChild("SkillManager")
    :WaitForChild("RE")

local LockedOnChanged =
    SkillManagerRE:WaitForChild("LockedOnChanged")

local SkillRemote =
    ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("SkillRemote")

--==========================================================
-- HELPERS
--==========================================================

local function GetRoot(obj)
    if not obj then
        return nil
    end

    if obj:IsA("BasePart") then
        return obj
    end

    if obj:IsA("Model") then
        return obj:FindFirstChild("HumanoidRootPart")
            or obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart")
    end

    return obj:FindFirstChildWhichIsA("BasePart")
end

local function GetCharacterRoot()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetNearestTarget(range)
    local root = GetCharacterRoot()
    if not root then
        return nil, math.huge
    end

    local nearest = nil
    local nearestDistance = range

    -- MOBS
    local mobs = workspace:FindFirstChild("World Mobs")

    if mobs then
        for _, folder in ipairs(mobs:GetChildren()) do
            for _, mob in ipairs(folder:GetChildren()) do
                if mob:IsA("Model") then
                    local mobRoot = GetRoot(mob)

                    if mobRoot then
                        local distance =
                            (mobRoot.Position - root.Position).Magnitude

                        if distance <= nearestDistance then
                            nearest = mob
                            nearestDistance = distance
                        end
                    end
                end
            end
        end
    end

    -- PLAYERS
    local chars = workspace:FindFirstChild("Characters")

    if chars then
        for _, character in ipairs(chars:GetChildren()) do
            if character.Name ~= LP.Name then
                local charRoot = GetRoot(character)

                if charRoot then
                    local distance =
                        (charRoot.Position - root.Position).Magnitude

                    if distance <= nearestDistance then
                        nearest = character
                        nearestDistance = distance
                    end
                end
            end
        end
    end

    return nearest, nearestDistance
end

--==========================================================
-- LOCK ON AURA
--==========================================================

local LockRange = 40
local LockInterval = 0.05

local RangeParts = {}

local function DestroyRange()
    for _, part in ipairs(RangeParts) do
        if part then
            part:Destroy()
        end
    end

    table.clear(RangeParts)
end

local function CreateRange()
    DestroyRange()

    local segments = 48

    for i = 1, segments do
        local part = Instance.new("Part")
        part.Name = "LockOnRange"
        part.Anchored = true
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        part.Material = Enum.Material.Neon
        part.Transparency = 0.25
        part.Size = Vector3.new(
            0.18,
            0.08,
            (2 * math.pi * LockRange) / segments
        )

        part.Parent = workspace

        table.insert(RangeParts, part)
    end
end

local function UpdateRange()
    if #RangeParts == 0 then
        CreateRange()
    end

    local root = GetCharacterRoot()

    if not root then
        return
    end

    local segments = #RangeParts

    for i, part in ipairs(RangeParts) do
        local angle =
            ((i - 1) / segments) * math.pi * 2

        local pos =
            root.Position
            + Vector3.new(
                math.cos(angle) * LockRange,
                -2.5,
                math.sin(angle) * LockRange
            )

        part.CFrame =
            CFrame.new(pos)
            * CFrame.Angles(0, -angle, 0)
    end
end

FloorsLeft:AddToggle("LockOnAura", {
    Text = "Lock On Aura",
    Default = false,

    Callback = function(Value)

        if Value then
            CreateRange()

            task.spawn(function()
                while Library.Toggles.LockOnAura.Value do

                    local target =
                        GetNearestTarget(LockRange)

                    if target then
                        pcall(function()
                            LockedOnChanged:FireServer(target)
                        end)
                    end

                    task.wait(LockInterval)
                end
            end)

        else
            DestroyRange()
        end
    end,
})

FloorsLeft:AddSlider("LockRange", {
    Text = "Range",
    Default = 40,
    Min = 5,
    Max = 300,
    Rounding = 0,

    Callback = function(Value)
        LockRange = Value

        if Library.Toggles.LockOnAura
            and Library.Toggles.LockOnAura.Value then

            CreateRange()
        end
    end,
})

FloorsLeft:AddSlider("LockInterval", {
    Text = "Lock Interval",
    Default = 0.05,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",

    Callback = function(Value)
        LockInterval = Value
    end,
})

RunService.RenderStepped:Connect(function()
    if Library.Toggles.LockOnAura
        and Library.Toggles.LockOnAura.Value then

        UpdateRange()
    end
end)

--==========================================================
-- SHOW TIME DIE
--==========================================================

local TimeDieGui

local function RemoveTimeDie()
    if TimeDieGui then
        TimeDieGui:Destroy()
        TimeDieGui = nil
    end
end

local function CreateTimeDie()
    RemoveTimeDie()

    local root = GetCharacterRoot()
    if not root then
        return
    end

    TimeDieGui = Instance.new("BillboardGui")
    TimeDieGui.Name = "ShowTimeDie"
    TimeDieGui.AlwaysOnTop = true
    TimeDieGui.Size = UDim2.fromOffset(260, 60)
    TimeDieGui.StudsOffset = Vector3.new(0, 4, 0)
    TimeDieGui.Parent = root

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0
    label.Parent = TimeDieGui
end

FloorsLeft:AddToggle("ShowTimeDie", {
    Text = "Show Time Die",
    Default = false,

    Callback = function(Value)

        if not Value then
            RemoveTimeDie()
            return
        end

        CreateTimeDie()

        task.spawn(function()

            local lastHealth = nil
            local lastTime = nil
            local damagePerSecond = 0

            while Library.Toggles.ShowTimeDie.Value do

                local target = GetNearestTarget(99999)
                local hum =
                    target
                    and target:FindFirstChildOfClass("Humanoid")

                if hum then
                    local health = hum.Health
                    local now = tick()

                    if lastHealth
                        and lastTime
                        and health < lastHealth then

                        local damage =
                            lastHealth - health

                        local dt =
                            math.max(now - lastTime, 0.01)

                        damagePerSecond =
                            damage / dt
                    end

                    lastHealth = health
                    lastTime = now

                    if TimeDieGui
                        and TimeDieGui:FindFirstChildOfClass("TextLabel") then

                        local label =
                            TimeDieGui:FindFirstChildOfClass("TextLabel")

                        if damagePerSecond > 0 then
                            local seconds =
                                health / damagePerSecond

                            label.Text =
                                string.format(
                                    "%s\nHP: %.0f | ~%.1fs",
                                    target.Name,
                                    health,
                                    seconds
                                )
                        else
                            label.Text =
                                string.format(
                                    "%s\nHP: %.0f | --",
                                    target.Name,
                                    health
                                )
                        end
                    end
                end

                task.wait(0.1)
            end

            RemoveTimeDie()
        end)
    end,
})

--==========================================================
-- SHOW HIT
--==========================================================

local HitConnections = {}
local HitObjects = {}

local function HitColor(hit)
    local colors = {
        Color3.fromRGB(255,255,255),
        Color3.fromRGB(0,255,0),
        Color3.fromRGB(0,170,255),
        Color3.fromRGB(170,0,255),
        Color3.fromRGB(255,170,0),
        Color3.fromRGB(255,0,0),
    }

    return colors[
        math.clamp(hit, 1, #colors)
    ]
end

local function ShowHit(target, hit)
    local root = GetRoot(target)

    if not root then
        return
    end

    if HitObjects[target] then
        HitObjects[target]:Destroy()
    end

    local gui = Instance.new("BillboardGui")
    gui.Name = "HitCounter"
    gui.AlwaysOnTop = true
    gui.Size = UDim2.fromOffset(120, 50)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.Parent = root

    local text = Instance.new("TextLabel")
    text.BackgroundTransparency = 1
    text.Size = UDim2.fromScale(1, 1)
    text.Text = "-" .. tostring(hit)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextColor3 = HitColor(hit)
    text.TextStrokeTransparency = 0
    text.Parent = gui

    HitObjects[target] = gui

    task.delay(10, function()
        if HitObjects[target] == gui then
            HitObjects[target] = nil
            gui:Destroy()
        end
    end)
end

local function WatchTarget(target)
    if not target then
        return
    end

    local hum = target:FindFirstChildOfClass("Humanoid")

    if not hum then
        return
    end

    if HitConnections[hum] then
        return
    end

    local oldHealth = hum.Health
    local hitCount = 0

    HitConnections[hum] =
        hum.HealthChanged:Connect(function(newHealth)

            if newHealth < oldHealth then
                hitCount += 1

                if Library.Toggles.ShowHit.Value then
                    ShowHit(target, hitCount)
                end
            end

            oldHealth = newHealth
        end)
end

FloorsLeft:AddToggle("ShowHit", {
    Text = "Show Hit",
    Default = false,

    Callback = function(Value)

        if not Value then
            for _, gui in pairs(HitObjects) do
                if gui then
                    gui:Destroy()
                end
            end

            table.clear(HitObjects)
            return
        end

        task.spawn(function()

            while Library.Toggles.ShowHit.Value do

                local mobs = workspace:FindFirstChild("World Mobs")

                if mobs then
                    for _, folder in ipairs(mobs:GetChildren()) do
                        for _, mob in ipairs(folder:GetChildren()) do
                            WatchTarget(mob)
                        end
                    end
                end

                local chars =
                    workspace:FindFirstChild("Characters")

                if chars then
                    for _, char in ipairs(chars:GetChildren()) do
                        if char.Name ~= LP.Name then
                            WatchTarget(char)
                        end
                    end
                end

                task.wait(0.5)
            end
        end)
    end,
})

--==========================================================
-- AUTO RAID GODMODE [SLOW WIN]
--==========================================================

local RaidPosition =
    CFrame.new(
        -388.906708,
        1551.28235,
        51.3806343,
        1, 0, 0,
        0, 1, 0,
        0, 0, 1
    )

FloorsAuto:AddToggle("AutoRaidGodmode", {
    Text = "Auto Raid Godmode [Slow Win]",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                while Library.Toggles.AutoRaidGodmode.Value do

                    local root = GetCharacterRoot()

                    if root then
                        root.CFrame = RaidPosition
                        root.AssemblyLinearVelocity =
                            Vector3.zero
                    end

                    task.wait(0.15)
                end
            end)
        end
    end,
})

--==========================================================
-- AUTO DUNGEON [NORMAL]
--==========================================================

FloorsAuto:AddToggle("AutoDungeonNormal", {
    Text = "Auto Dungeon [Normal]",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                while Library.Toggles.AutoDungeonNormal.Value do

                    local root = GetCharacterRoot()

                    if root then

                        local target =
                            GetNearestTarget(99999)

                        local targetRoot =
                            target and GetRoot(target)

                        if targetRoot then

                            local targetPos =
                                targetRoot.Position

                            local above =
                                targetPos
                                + Vector3.new(0, 5, 0)

                            local targetCF =
                                CFrame.lookAt(
                                    above,
                                    targetPos
                                )

                            local distance =
                                (root.Position - above).Magnitude

                            local duration =
                                math.clamp(
                                    distance / 250,
                                    0.05,
                                    0.35
                                )

                            local tween =
                                TweenService:Create(
                                    root,
                                    TweenInfo.new(
                                        duration,
                                        Enum.EasingStyle.Linear
                                    ),
                                    {
                                        CFrame = targetCF
                                    }
                                )

                            tween:Play()
                            tween.Completed:Wait()

                            root.AssemblyLinearVelocity =
                                Vector3.zero
                        end
                    end

                    task.wait(0.03)
                end
            end)
        end
    end,
})

--==========================================================
-- HITBOX ATOM
--==========================================================

local AtomOriginalSize = nil

FloorsAuto:AddToggle("HitboxAtom", {
    Text = "Hitbox Atom",
    Default = false,

    Callback = function(Value)

        task.spawn(function()

            while Library.Toggles.HitboxAtom.Value do

                local eventMobs =
                    workspace:FindFirstChild("World Mobs")
                    and workspace["World Mobs"]
                        :FindFirstChild("Event Mobs")

                local atom =
                    eventMobs
                    and eventMobs:FindFirstChild("Atom Max")

                local root =
                    atom and GetRoot(atom)

                if root then

                    if not AtomOriginalSize then
                        AtomOriginalSize = root.Size
                    end

                    root.Size =
                        Vector3.new(40, 40, 40)

                    root.CanCollide = false
                    root.Massless = true
                end

                task.wait(0.1)
            end

            local eventMobs =
                workspace:FindFirstChild("World Mobs")
                and workspace["World Mobs"]
                    :FindFirstChild("Event Mobs")

            local atom =
                eventMobs
                and eventMobs:FindFirstChild("Atom Max")

            local root =
                atom and GetRoot(atom)

            if root and AtomOriginalSize then
                root.Size = AtomOriginalSize
            end

            AtomOriginalSize = nil
        end)
    end,
})

--==========================================================
-- AUTO ENERGY
--==========================================================

FloorsAuto:AddToggle("AutoEnergy", {
    Text = "Auto Energy",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                while Library.Toggles.AutoEnergy.Value do

                    local charFolder =
                        workspace:FindFirstChild("Characters")

                    local char =
                        charFolder
                        and charFolder:FindFirstChild(LP.Name)

                    local status =
                        char
                        and char:FindFirstChild("Status")

                    local current =
                        status
                        and status:FindFirstChild("CurrentEnergy")

                    local max =
                        status
                        and status:FindFirstChild("MaxEnergy")

                    local currentValue =
                        current and tonumber(current.Value)

                    local maxValue =
                        max and tonumber(max.Value)

                    if currentValue
                        and maxValue
                        and maxValue > 0 then

                        local percent =
                            currentValue / maxValue

                        if percent < 0.10 then

                            local root =
                                GetCharacterRoot()

                            if root then

                                local camera =
                                    workspace.CurrentCamera

                                local args = {
                                    [1] = {
                                        ["Camera"] =
                                            camera.CFrame,

                                        ["SkillId"] = "2",

                                        ["Began"] = true,

                                        ["CFrame"] =
                                            root.CFrame,

                                        ["Typ\208\181"] = 1,

                                        ["Aim"] =
                                            root.Position
                                            + camera.CFrame.LookVector * 100
                                    }
                                }

                                pcall(function()
                                    SkillRemote:FireServer(
                                        unpack(args)
                                    )
                                end)
                            end

                            task.wait(0.1)

                        elseif percent >= 1 then
                            task.wait(0.1)
                        else
                            task.wait(0.05)
                        end

                    else
                        task.wait(0.2)
                    end
                end
            end)
        end
    end,
})

--==========================================================
-- AUTO COLLECT STARDUST ORB
--==========================================================

FloorsBypass:AddToggle("AutoCollectStardust", {
    Text = "Auto Collect Stardust Orb",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                local index = 1

                while Library.Toggles.AutoCollectStardust.Value do

                    local folder =
                        workspace:FindFirstChild("Misc")
                        and workspace.Misc
                            :FindFirstChild("DragonSphereSpawns")

                    if folder then

                        local parts = {}

                        for _, obj in ipairs(folder:GetChildren()) do
                            if obj:IsA("BasePart") then
                                table.insert(parts, obj)
                            end
                        end

                        table.sort(parts, function(a, b)
                            return a.Name < b.Name
                        end)

                        if #parts > 0 then

                            if index > #parts then
                                index = 1
                            end

                            local root =
                                GetCharacterRoot()

                            if root then
                                root.CFrame =
                                    parts[index].CFrame
                                    + Vector3.new(0, 3, 0)

                                root.AssemblyLinearVelocity =
                                    Vector3.zero
                            end

                            index += 1
                        end
                    end

                    task.wait(10)
                end
            end)
        end
    end,
})

--==========================================================
-- REMOVE DIE [NOT DUNGEON]
--==========================================================

FloorsBypass:AddToggle("RemoveDie", {
    Text = "Remove Die [Not Dungeon]",
    Default = false,

    Callback = function(Value)

        if Value then
            task.spawn(function()

                while Library.Toggles.RemoveDie.Value do

                    local char = LP.Character
                    local hum =
                        char
                        and char:FindFirstChildOfClass("Humanoid")

                    local root =
                        char
                        and char:FindFirstChild("HumanoidRootPart")

                    if hum and root then

                        local isDungeon =
                            workspace:FindFirstChild("Dungeon")
                            or workspace:FindFirstChild("Dungeons")

                        if not isDungeon
                            and hum.MaxHealth > 0 then

                            local hp =
                                hum.Health / hum.MaxHealth

                            if hp <= 0.08 then

                                root.CFrame =
                                    root.CFrame
                                    + Vector3.new(0, 300, 0)

                                root.AssemblyLinearVelocity =
                                    Vector3.zero
                            end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end,
})

--==========================================================
-- REMOVE BARRIER
--==========================================================

FloorsBypass:AddToggle("RemoveBarrier", {
    Text = "Remove Barrier",
    Default = false,

    Callback = function(Value)

        local barriers =
            workspace:FindFirstChild("World Barriers")

        if not barriers then
            return
        end

        if Value then

            for _, obj in ipairs(barriers:GetDescendants()) do
                if obj:IsA("BasePart")
                    or obj:IsA("Model") then

                    pcall(function()
                        obj:Destroy()
                    end)
                end
            end

        end
    end,
})

--==========================================================
-- ANTI LAG
--==========================================================

local HiddenVisuals = {}

local function HideVisuals(container)
    if not container then
        return
    end

    for _, obj in ipairs(container:GetDescendants()) do

        if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")
            or obj:IsA("Smoke")
            or obj:IsA("Fire")
            or obj:IsA("Sparkles") then

            if HiddenVisuals[obj] == nil then
                HiddenVisuals[obj] = obj.Enabled
            end

            obj.Enabled = false
        end
    end
end

local function RestoreVisuals()

    for obj, oldValue in pairs(HiddenVisuals) do
        if obj and obj.Parent then
            obj.Enabled = oldValue
        end
    end

    table.clear(HiddenVisuals)
end

FloorsBypass:AddToggle("AntiLag", {
    Text = "Anti Lag",
    Default = false,

    Callback = function(Value)

        if Value then

            task.spawn(function()

                while Library.Toggles.AntiLag.Value do

                    HideVisuals(workspace:FindFirstChild("World Mobs"))
                    HideVisuals(LP.Character)

                    task.wait(1)
                end

                RestoreVisuals()
            end)

        else
            RestoreVisuals()
        end
    end,
})

--==========================================================
-- AUTO FORM
--==========================================================

FloorsCompletion:AddToggle("AutoForm", {
    Text = "Auto Form",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoForm.Value do

                local char =
                    workspace:FindFirstChild("Characters")
                    and workspace.Characters:FindFirstChild(LP.Name)

                local status =
                    char
                    and char:FindFirstChild("Status")

                local mode =
                    status
                    and status:FindFirstChild("Mode")

                -- đọc Mode hiện tại
                -- phần kích hoạt Form phụ thuộc remote của game
                -- nên không tự gọi remote chưa xác định.

                if mode then
                    local currentMode =
                        tostring(mode.Value)

                    if Library.Toggles.ShowTimeDie
                        and Library.Toggles.ShowTimeDie.Value then

                        -- giữ Mode được cập nhật liên tục
                        Library:Notify({
                            Title = "Auto Form",
                            Description =
                                "Mode: "
                                .. currentMode,
                            Time = 1
                        })
                    end
                end

                task.wait(1)
            end
        end)
    end,
})

--==========================================================
-- CLEANUP
--==========================================================

Library:OnUnload(function()

    DestroyRange()
    RemoveTimeDie()
    RestoreVisuals()

    for _, connection in pairs(HitConnections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(HitConnections)

    for _, gui in pairs(HitObjects) do
        if gui then
            gui:Destroy()
        end
    end

    table.clear(HitObjects)
end)

print("[Abyssall] Floors Tab 3 loaded.")
--==================================================
-- AUTO ENERGY
-- Automation box - Tab 3
--==================================================

Automation:AddToggle("AutoEnergy", {
    Text = "Auto Energy",
    Default = false,

    Callback = function(Value)
        if not Value then
            return
        end

        task.spawn(function()
            while Library.Toggles.AutoEnergy.Value do

                local Characters = workspace:FindFirstChild("Characters")
                local Character = Characters
                    and Characters:FindFirstChild(LocalPlayer.Name)

                local Status = Character
                    and Character:FindFirstChild("Status")

                local CurrentEnergy =
                    Status and Status:FindFirstChild("CurrentEnergy")

                local MaxEnergy =
                    Status and Status:FindFirstChild("MaxEnergy")

                local Current =
                    CurrentEnergy and tonumber(CurrentEnergy.Value)

                local Max =
                    MaxEnergy and tonumber(MaxEnergy.Value)

                if Current and Max and Max > 0 then

                    -- Chỉ kích hoạt khi trên 90%
                    if Current > (Max * 0.90) then

                        local Root =
                            LocalPlayer.Character
                            and LocalPlayer.Character:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        if Root then

                            local Camera =
                                workspace.CurrentCamera

                            local args = {
                                [1] = {
                                    ["Camera"] = Camera.CFrame,

                                    ["SkillId"] = "2",

                                    ["Began"] = false,

                                    ["CFrame"] =
                                        Root.CFrame,

                                    ["Typ\208\181"] = 1,

                                    ["Aim"] =
                                        Root.Position
                                        + Camera.CFrame.LookVector * 100
                                }
                            }

                            pcall(function()
                                ReplicatedStorage
                                    :WaitForChild("Remotes")
                                    :WaitForChild("SkillRemote")
                                    :FireServer(unpack(args))
                            end)
                        end

                        task.wait(0.05)

                    else
                        -- Dưới hoặc bằng 90%:
                        -- KHÔNG gửi false / không kích hoạt gì.
                        task.wait(0.1)
                    end

                else
                    task.wait(0.2)
                end
            end
        end)
    end,
})
--==================================================
-- AUTO SKILL 10
-- Automation
--==================================================

Automation:AddToggle("AutoSkill10", {
    Text = "Auto form work",
    Default = false,

    Callback = function(Value)
        if not Value then
            return
        end

        task.spawn(function()
            while Library.Toggles.AutoSkill10.Value do

                local characters = workspace:FindFirstChild("Characters")
                local character = characters
                    and characters:FindFirstChild(LocalPlayer.Name)

                -- Kiểm tra Mode có tồn tại hay không
                local mode = character
                    and character:FindFirstChild("Mode")

                -- Có Mode -> KHÔNG kích hoạt
                -- Không có Mode -> kích hoạt Skill 10
                if not mode then

                    local root = LocalPlayer.Character
                        and LocalPlayer.Character:FindFirstChild(
                            "HumanoidRootPart"
                        )

                    if root then
                        local camera = workspace.CurrentCamera

                        local args = {
                            [1] = {
                                ["Camera"] = camera.CFrame,
                                ["SkillId"] = "10",
                                ["Began"] = true,
                                ["CFrame"] = root.CFrame,
                                ["Typ\208\181"] = 1,
                                ["Aim"] =
                                    root.Position
                                    + camera.CFrame.LookVector * 100
                            }
                        }

                        pcall(function()
                            ReplicatedStorage
                                :WaitForChild("Remotes")
                                :WaitForChild("SkillRemote")
                                :FireServer(unpack(args))
                        end)
                    end
                end

                -- Check mỗi 1.5 giây
                task.wait(1.5)
            end
        end)
    end,
})
--==================================================
-- AUTO START + AUTO READY
-- Automation - Tab 3
--==================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

--==================================================
-- AUTO START
--==================================================

local StartDungeon =
    ReplicatedStorage
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.4.7")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("DungeonLobbyService")
        :WaitForChild("RF")
        :WaitForChild("StartDungeon")

local Bosses = {
    "Garriot",
    "Great Droid",
    "Atom Max",
    "Mecha Soldier"
}

local startedBosses = {}

Automation:AddToggle("AutoStart", {
    Text = "Auto Start",
    Default = false,

    Callback = function(Value)

        if not Value then
            table.clear(startedBosses)
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoStart.Value do

                local WorldMobs =
                    workspace:FindFirstChild("World Mobs")

                local EventMobs =
                    WorldMobs
                    and WorldMobs:FindFirstChild("Event Mobs")

                if EventMobs then

                    for _, BossName in ipairs(Bosses) do

                        if not Library.Toggles.AutoStart.Value then
                            break
                        end

                        local Boss =
                            EventMobs:FindFirstChild(BossName)

                        if Boss then

                            local Humanoid =
                                Boss:FindFirstChildOfClass("Humanoid")

                            if Humanoid then

                                -- Boss còn sống
                                if Humanoid.Health > 0 then
                                    startedBosses[BossName] = true
                                end

                                -- Boss chết
                                if Humanoid.Health <= 0
                                    and startedBosses[BossName] then

                                    startedBosses[BossName] = false

                                    -- Đợi 4.04 giây
                                    task.wait(4.04)

                                    if Library.Toggles.AutoStart.Value then
                                        pcall(function()
                                            StartDungeon:InvokeServer()
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end

                task.wait(0.15)
            end
        end)
    end,
})


--==================================================
-- AUTO READY
--==================================================

local EventMobs =
    workspace
        :WaitForChild("World Mobs")
        :WaitForChild("Event Mobs")

Automation:AddToggle("AutoReady", {
    Text = "Auto Ready",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoReady.Value do

                -- Event Mobs phải hoàn toàn trống
                if #EventMobs:GetChildren() == 0 then

                    local Dungeon =
                        workspace:FindFirstChild("Dungeon")

                    if Dungeon then

                        local Stages =
                            Dungeon:FindFirstChild("Stages")

                        local Stage0 =
                            Stages
                            and Stages:FindFirstChild("0")

                        local NextArea =
                            Stage0
                            and Stage0:FindFirstChild("NextArea")

                        -- Container bắt buộc tồn tại
                        local Container =
                            NextArea
                            and NextArea:FindFirstChild("Container")

                        if Container then

                            local Pad =
                                NextArea:FindFirstChild(
                                    "DungeonNextAreaPad"
                                )

                            local RE =
                                Pad
                                and Pad:FindFirstChild("RE")

                            local Interact =
                                RE
                                and RE:FindFirstChild("Interact")

                            if Interact then
                                pcall(function()
                                    Interact:FireServer()
                                end)
                            end
                        end
                    end
                end

                task.wait(0.15)
            end
        end)
    end,
})
--==================================================
-- TAB 4
--==================================================

local Tab4 = Window:AddTab("Misc", "sparkles")

local Miscellaneous = Tab4:AddLeftGroupbox("Miscellaneous")
local Automation4 = Tab4:AddLeftGroupbox("Automation")

local Notifiers = Tab4:AddRightGroupbox("Notifiers")
local Auras = Tab4:AddRightGroupbox("Auras")

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function GetRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- MISCELLANEOUS
--==================================================

-- Auto Proximity Prompt
Miscellaneous:AddToggle("InstantPrompt", {
    Text = "Instant Proximity Prompt",
    Default = false,

    Callback = function(Value)
        if not Value then return end

        task.spawn(function()
            while Library.Toggles.InstantPrompt.Value do

                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        pcall(function()
                            obj.HoldDuration = 0
                        end)
                    end
                end

                task.wait(1)
            end
        end)
    end,
})

-- Anti Void
Miscellaneous:AddToggle("AntiVoid", {
    Text = "Remove the roblox void",
    Default = false,

    Callback = function(Value)
        if not Value then return end

        task.spawn(function()
            while Library.Toggles.AntiVoid.Value do

                local root = GetRoot()

                if root and root.Position.Y < -50 then
                    root.CFrame =
                        root.CFrame + Vector3.new(0, 300, 0)
                end

                task.wait(0.1)
            end
        end)
    end,
})

-- Disable Cutscenes
Miscellaneous:AddToggle("DisableCutscenes", {
    Text = "Disable Cutscenes",
    Default = false,

    Callback = function(Value)
        if not Value then return end

        task.spawn(function()
            while Library.Toggles.DisableCutscenes.Value do

                local camera = workspace.CurrentCamera

                if camera then
                    camera.FieldOfView =
                        math.clamp(camera.FieldOfView, 50, 100)
                end

                task.wait(0.2)
            end
        end)
    end,
})

--==================================================
-- KILL MINI DROID
--==================================================

local SkillRemote =
    ReplicatedStorage
        :WaitForChild("Remotes")
        :WaitForChild("SkillRemote")

Miscellaneous:AddToggle("KillMiniDroid", {
    Text = "Kill Mini Droid",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.KillMiniDroid.Value do

                local EventMobs =
                    workspace:FindFirstChild("World Mobs")
                    and workspace["World Mobs"]:FindFirstChild("Event Mobs")

                local MiniDroid =
                    EventMobs
                    and EventMobs:FindFirstChild("CustomMob")

                if MiniDroid then

                    local root = GetRoot()

                    if root then

                        local camera =
                            workspace.CurrentCamera

                        local args = {
                            [1] = {
                                ["Camera"] = camera.CFrame,
                                ["SkillId"] = "116",
                                ["Began"] = true,
                                ["CFrame"] = root.CFrame,
                                ["Typ\208\181"] = 1,
                                ["Aim"] =
                                    root.Position
                                    + camera.CFrame.LookVector * 100
                            }
                        }

                        pcall(function()
                            SkillRemote:FireServer(unpack(args))
                        end)

                        task.wait(0.05)

                        args[1]["Began"] = false

                        pcall(function()
                            SkillRemote:FireServer(unpack(args))
                        end)
                    end
                end

                task.wait(0.1)
            end
        end)
    end,
})

--==================================================
-- AUTOMATION
--==================================================

-- Auto Lobby delay
Automation4:AddInput("AutoLobbyTime", {
    Default = "10",
    Numeric = true,
    Finished = false,
    Text = "Auto Lobby Time",
    Placeholder = "Seconds",
})

local ReturnToWorld =
    ReplicatedStorage
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.4.7")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("DungeonService")
        :WaitForChild("RF")
        :WaitForChild("ReturnToWorld")

Automation4:AddToggle("AutoLobby", {
    Text = "Auto Lobby",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            local delayTime =
                tonumber(Library.Options.AutoLobbyTime.Value)
                or 10

            task.wait(delayTime)

            if Library.Toggles.AutoLobby.Value then
                pcall(function()
                    ReturnToWorld:InvokeServer()
                end)
            end
        end)
    end,
})

--==================================================
-- SHOP BUY
--==================================================

local BuyItem =
    ReplicatedStorage
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.4.7")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("NPCShopService")
        :WaitForChild("RE")
        :WaitForChild("BuyItem")

local function BuyUpgrade(ID)

    pcall(function()
        BuyItem:FireServer(
            ID,
            "Ticket_Exchange",
            1,
            1
        )
    end)
end

-- +50% Damage
Automation4:AddToggle("AutoDamage", {
    Text = "Auto Buy +50% Dame",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()
            while Library.Toggles.AutoDamage.Value do
                BuyUpgrade(1)
                task.wait(0.15)
            end
        end)
    end,
})

-- +1 Lucky
Automation4:AddToggle("AutoLucky", {
    Text = "Auto Buy +1 Lucky",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()
            while Library.Toggles.AutoLucky.Value do
                BuyUpgrade(2)
                task.wait(0.15)
            end
        end)
    end,
})

-- +1 Drop
Automation4:AddToggle("AutoDrop", {
    Text = "Auto Buy +1 Drop",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()
            while Library.Toggles.AutoDrop.Value do
                BuyUpgrade(3)
                task.wait(0.15)
            end
        end)
    end,
})

-- Major Drop
Automation4:AddToggle("AutoMajorDrop", {
    Text = "Auto Buy Major Drop",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()
            while Library.Toggles.AutoMajorDrop.Value do
                BuyUpgrade(4)
                task.wait(0.15)
            end
        end)
    end,
})

--==================================================
-- AUTO JOIN DUNGEON
--==================================================

local DungeonLobbyService =
    ReplicatedStorage
        :WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_knit@1.4.7")
        :WaitForChild("knit")
        :WaitForChild("Services")
        :WaitForChild("DungeonLobbyService")

local CreateLobby =
    DungeonLobbyService.RF.CreateLobby

local StartDungeon =
    DungeonLobbyService.RF.StartDungeon

local DungeonIdSelected = 1
local Difficulty = 1

local ModeList = {
    Mecha = 1,
    Atom = 2,
    Droid = 3,
    Hideout = 4
}

local DifficultyList = {
    Easy = 1,
    Normal = 2,
    Hard = 3,
    Hell = 4
}

Notifiers:AddDropdown("ChooseMode4", {
    Values = {
        "Mecha",
        "Atom",
        "Droid",
        "Hideout"
    },

    Default = "Mecha",
    Multi = false,
    Text = "Choose Mode",

    Callback = function(Value)
        DungeonIdSelected =
            ModeList[Value] or 1
    end,
})

Notifiers:AddDropdown("ChooseDifficulty4", {
    Values = {
        "Easy",
        "Normal",
        "Hard",
        "Hell"
    },

    Default = "Easy",
    Multi = false,
    Text = "Difficulty",

    Callback = function(Value)
        Difficulty =
            DifficultyList[Value] or 1
    end,
})

local function JoinDungeon()

    local args = {
        [1] = {
            ["DungeonIdSelected"] =
                DungeonIdSelected,

            ["DungeonStats"] = {
                ["Difficulty"] =
                    Difficulty
            }
        }
    }

    pcall(function()
        CreateLobby:InvokeServer(unpack(args))
    end)

    task.wait(10)

    pcall(function()
        StartDungeon:InvokeServer(unpack(args))
    end)
end

-- Notification Sound -> Auto Join Dungeon
Notifiers:AddToggle("AutoJoinDungeon", {
    Text = "Auto Join Dungeon",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoJoinDungeon.Value do
                JoinDungeon()
                task.wait(11)
            end
        end)
    end,
})

-- Notify Entity -> Auto Join
Notifiers:AddToggle("AutoJoinEntity", {
    Text = "Auto Join",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoJoinEntity.Value do
                JoinDungeon()
                task.wait(11)
            end
        end)
    end,
})

--==================================================
-- CUSTOM AURAS
--==================================================

local function GetNearestPrompt(maxDistance)

    local root = GetRoot()

    if not root then
        return nil
    end

    local nearest = nil
    local distance = maxDistance

    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("ProximityPrompt") then

            local parent =
                obj.Parent

            local part =
                parent:IsA("BasePart")
                and parent
                or parent:FindFirstChildWhichIsA("BasePart")

            if part then

                local d =
                    (part.Position - root.Position).Magnitude

                if d <= distance then
                    nearest = obj
                    distance = d
                end
            end
        end
    end

    return nearest
end

-- Lever / Valve Aura
Auras:AddToggle("LeverValveAura", {
    Text = "Lever/Valve Aura",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()

            while Library.Toggles.LeverValveAura.Value do

                local prompt =
                    GetNearestPrompt(15)

                if prompt then
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                end

                task.wait(0.2)
            end
        end)
    end,
})

-- Loot Aura
Auras:AddToggle("LootAura", {
    Text = "Loot Aura",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()

            while Library.Toggles.LootAura.Value do

                local prompt =
                    GetNearestPrompt(12)

                if prompt then
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                end

                task.wait(0.2)
            end
        end)
    end,
})

-- Books / Breakers Aura
Auras:AddToggle("BooksBreakersAura", {
    Text = "Books/Breakers Aura",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()

            while Library.Toggles.BooksBreakersAura.Value do

                local prompt =
                    GetNearestPrompt(20)

                if prompt then
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                end

                task.wait(0.15)
            end
        end)
    end,
})

-- Locked Door Aura
Auras:AddToggle("LockedDoorAura", {
    Text = "Locked Door Aura",
    Default = false,

    Callback = function(Value)

        if not Value then return end

        task.spawn(function()

            while Library.Toggles.LockedDoorAura.Value do

                local prompt =
                    GetNearestPrompt(10)

                if prompt then
                    pcall(function()
                        fireproximityprompt(prompt)
                    end)
                end

                task.wait(0.25)
            end
        end)
    end,
})
--==================================================
-- TAB 5 - AUTOMATION
--==================================================

local Tab5 = Window:AddTab("Automation", "zap")

local Tab5Ladders = Tab5:AddLeftGroupbox("Ladders")
local Tab5Anticheat = Tab5:AddLeftGroupbox("Anticheat")
local Tab5Automation = Tab5:AddRightGroupbox("Automation")

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local SkillRemote = ReplicatedStorage
    :WaitForChild("Remotes")
    :WaitForChild("SkillRemote")

local Knit = ReplicatedStorage
    :WaitForChild("Packages")
    :WaitForChild("_Index")
    :WaitForChild("sleitnick_knit@1.4.7")
    :WaitForChild("knit")

--==================================================
-- LADDER
--==================================================

-- Auto 25% Dame SSJB
Tab5Ladders:AddToggle("Auto25DamageSSJB", {
    Text = "Auto 25% Dame SSJB",
    Default = false,

    Callback = function(Value)
        if not Value then
            return
        end

        task.spawn(function()
            while Library.Toggles.Auto25DamageSSJB.Value do

                pcall(function()
                    Knit
                        :WaitForChild("Services")
                        :WaitForChild("SkillManagerV2")
                        :WaitForChild("RE")
                        :WaitForChild("ExecuteSkill")
                        :FireServer(
                            "Weapons_14_2",
                            {},
                            1
                        )
                end)

                task.wait(0.1)
            end
        end)
    end,
})

-- Auto Claim Day Gift
Tab5Ladders:AddToggle("AutoClaimDayGift", {
    Text = "Auto Claim Day Gift",
    Default = false,

    Callback = function(Value)
        if not Value then
            return
        end

        task.spawn(function()

            local ClaimDay = Knit
                :WaitForChild("Services")
                :WaitForChild("LoginRewardsService")
                :WaitForChild("RF")
                :WaitForChild("ClaimDay")

            while Library.Toggles.AutoClaimDayGift.Value do

                pcall(function()
                    ClaimDay:InvokeServer()
                end)

                task.wait(2)
            end
        end)
    end,
})

--==================================================
-- ANTICHEAT
--==================================================

-- Anti Teleport
Tab5Anticheat:AddToggle("AntiTeleport", {
    Text = "Anti Teleport",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            local Character = LocalPlayer.Character
            local Root = Character
                and Character:FindFirstChild("HumanoidRootPart")

            if not Root then
                return
            end

            local LockedCFrame = Root.CFrame

            Library:Notify({
                Title = "Anti Teleport",
                Description = "Đã khóa vị trí hiện tại.",
                Time = 3
            })

            while Library.Toggles.AntiTeleport.Value do

                Character = LocalPlayer.Character
                Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root then
                    Root.CFrame = LockedCFrame
                    Root.AssemblyLinearVelocity = Vector3.zero
                    Root.AssemblyAngularVelocity = Vector3.zero
                end

                task.wait()
            end
        end)
    end,
})

--==================================================
-- BEAST
--==================================================

Tab5Anticheat:AddToggle("Beast", {
    Text = "Beast",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.Beast.Value do

                local Camera = workspace.CurrentCamera

                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root and Camera then

                    local args = {
                        [1] = {
                            ["Camera"] = Camera.CFrame,
                            ["SkillId"] = "8",
                            ["Began"] = true,
                            ["CFrame"] = Root.CFrame,
                            ["Typ\208\181"] = 1,
                            ["Aim"] =
                                Root.Position
                                + Camera.CFrame.LookVector * 100
                        }
                    }

                    pcall(function()
                        SkillRemote:FireServer(unpack(args))
                    end)
                end

                task.wait(0.1)
            end
        end)
    end,
})

--==================================================
-- AUTOMATION RIGHT
--==================================================

-- Fusion
Tab5Automation:AddToggle("Fusion", {
    Text = "Fusion",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.Fusion.Value do

                local Camera = workspace.CurrentCamera

                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root and Camera then

                    local args = {
                        [1] = {
                            ["Camera"] = Camera.CFrame,
                            ["SkillId"] = "9",
                            ["Toggle"] = true,
                            ["Began"] = true,
                            ["CFrame"] = Root.CFrame,
                            ["Typ\208\181"] = 1,
                            ["Aim"] =
                                Root.Position
                                + Camera.CFrame.LookVector * 100
                        }
                    }

                    pcall(function()
                        SkillRemote:FireServer(unpack(args))
                    end)
                end

                task.wait(2)
            end
        end)
    end,
})

--==================================================
-- GRAVITY
--==================================================

Tab5Automation:AddSlider("Gravity", {
    Text = "Gravity",
    Default = 196,
    Min = 0,
    Max = 500,
    Rounding = 0,

    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

--==================================================
-- JUMP POWER
--==================================================

Tab5Automation:AddSlider("JumpPower5", {
    Text = "JumpPower",
    Default = 50,
    Min = 0,
    Max = 300,
    Rounding = 0,

    Callback = function(Value)

        local Character = LocalPlayer.Character
        local Humanoid = Character
            and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Value
        end
    end,
})

--==================================================
-- AUTO FARM BLOCK
--==================================================

Tab5Automation:AddToggle("AutoFarmBlock", {
    Text = "Auto Farm Block",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoFarmBlock.Value do

                local Camera = workspace.CurrentCamera

                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root and Camera then

                    local args = {
                        [1] = {
                            ["Camera"] = Camera.CFrame,
                            ["SkillId"] = "6",
                            ["Began"] = true,
                            ["CFrame"] = Root.CFrame,
                            ["Typ\208\181"] = 1,
                            ["Aim"] =
                                Root.Position
                                + Camera.CFrame.LookVector * 50
                        }
                    }

                    pcall(function()
                        SkillRemote:FireServer(unpack(args))
                    end)
                end

                task.wait(0.1)
            end
        end)
    end,
})

--==================================================
-- USE KICK WARN
--==================================================

Tab5Automation:AddToggle("UseKickWarn", {
    Text = "Use Kick Warn",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            local LockedCFrame =
                CFrame.new(
                    1286.55933,
                    365.975159,
                    -2696.85645,
                    1, 0, 0,
                    0, 1, 0,
                    0, 0, 1
                )

            Library:Notify({
                Title = "Kick Warn",
                Description = "Đã khóa vị trí.",
                Time = 3
            })

            while Library.Toggles.UseKickWarn.Value do

                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Root then
                    Root.CFrame = LockedCFrame
                    Root.AssemblyLinearVelocity = Vector3.zero
                    Root.AssemblyAngularVelocity = Vector3.zero
                end

                task.wait()
            end
        end)
    end,
})

--==================================================
-- AUTO DON'T USE 😭 DUNGEON ATOM
--==================================================

local DungeonAtomStopped = false

Tab5Automation:AddToggle("DontUseDungeonAtom", {
    Text = "Auto don't use 😭 dungeon atom",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        if DungeonAtomStopped then
            Library.Toggles.DontUseDungeonAtom:SetValue(false)

            Library:Notify({
                Title = "Dungeon Atom",
                Description = "Đã dừng vĩnh viễn vì Atom Max đã biến mất.",
                Time = 4
            })

            return
        end

        task.spawn(function()

            while Library.Toggles.DontUseDungeonAtom.Value do

                local EventMobs =
                    workspace:FindFirstChild("World Mobs")
                    and workspace["World Mobs"]:FindFirstChild("Event Mobs")

                local AtomMax =
                    EventMobs
                    and EventMobs:FindFirstChild("Atom Max")

                -- Atom Max biến mất = DỪNG VĨNH VIỄN
                if not AtomMax then

                    DungeonAtomStopped = true

                    pcall(function()
                        Library.Toggles.DontUseDungeonAtom:SetValue(false)
                    end)

                    Library:Notify({
                        Title = "Dungeon Atom",
                        Description = "Atom Max đã biến mất → Auto đã dừng.",
                        Time = 4
                    })

                    break
                end

                -- Skill 116 BEGIN
                local Camera = workspace.CurrentCamera
                local Character = LocalPlayer.Character
                local Root = Character
                    and Character:FindFirstChild("HumanoidRootPart")

                if Camera and Root then

                    local argsBegin = {
                        [1] = {
                            ["Camera"] = Camera.CFrame,
                            ["SkillId"] = "116",
                            ["Began"] = true,
                            ["CFrame"] = Root.CFrame,
                            ["Typ\208\181"] = 1,
                            ["Aim"] =
                                Root.Position
                                + Camera.CFrame.LookVector * 100
                        }
                    }

                    pcall(function()
                        SkillRemote:FireServer(unpack(argsBegin))
                    end)

                    task.wait(0.05)

                    -- Skill 116 END
                    argsBegin[1]["Began"] = false

                    pcall(function()
                        SkillRemote:FireServer(unpack(argsBegin))
                    end)
                end

                -- Auto damage Atom Max
                pcall(function()

                    local Humanoid =
                        AtomMax:FindFirstChildOfClass("Humanoid")
                        or AtomMax:FindFirstChild("Humanoid")

                    if Humanoid and Humanoid.Health > 0 then
                        Humanoid.Health =
                            Humanoid.Health - 99999999999
                    end
                end)

                task.wait(1.6)
            end
        end)
    end,
})

--==================================================
-- RESET CHARACTER HANDLING
--==================================================

LocalPlayer.CharacterAdded:Connect(function(Character)

    task.wait(0.5)

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.UseJumpPower = true

        local JumpValue =
            Library.Options.JumpPower5
            and Library.Options.JumpPower5.Value

        if JumpValue then
            Humanoid.JumpPower = JumpValue
        end
    end
end)
--==================================================
-- TAB 6 - COLLECTION
--==================================================

local Tab6 = Window:AddTab("Collection", "gem")

local Tab6Collection = Tab6:AddLeftGroupbox("Collection")
local Tab6Automation = Tab6:AddLeftGroupbox("Automation")

local Tab6ESP = Tab6:AddRightGroupbox("ESP")
local Tab6Notifier = Tab6:AddRightGroupbox("Trình thông báo")

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function GetRoot()
    local Character = LocalPlayer.Character
    return Character
        and Character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- Z A J A / D E S T R O Y E R S
--==================================================

local CollectionMode = "Tween"
local CollectionRunning = false
local CollectionTween

Tab6Collection:AddDropdown("CollectionMode", {
    Values = {
        "Tween",
        "Teleport"
    },

    Default = "Tween",
    Multi = false,
    Text = "Mode",

    Callback = function(Value)
        CollectionMode = Value
    end,
})

local function GetArenaParts()

    local Result = {}

    local WorldMap = workspace:FindFirstChild("World Map")
    local SecretBossArea =
        WorldMap
        and WorldMap:FindFirstChild("SecretBossArea")

    if not SecretBossArea then
        return Result
    end

    for _, Object in ipairs(SecretBossArea:GetDescendants()) do

        if string.find(
            string.lower(Object.Name),
            "arena"
        ) then

            if Object:IsA("BasePart") then
                table.insert(Result, Object)

            elseif Object:IsA("Model") then

                local Part =
                    Object.PrimaryPart
                    or Object:FindFirstChildWhichIsA("BasePart")

                if Part then
                    table.insert(Result, Part)
                end
            end
        end
    end

    return Result
end

local function IsZajaOrDestroyerAlive()

    local WorldMobs =
        workspace:FindFirstChild("World Mobs")

    local EventMobs =
        WorldMobs
        and WorldMobs:FindFirstChild("Event Mobs")

    if not EventMobs then
        return false
    end

    -- Zaja
    if EventMobs:FindFirstChild("Zaja") then
        return true
    end

    -- Destroyer
    if EventMobs:FindFirstChild("Destroyer") then
        return true
    end

    -- Một số server có tên Destroyers
    if EventMobs:FindFirstChild("Destroyers") then
        return true
    end

    return false
end

Tab6Collection:AddToggle("ZajaDestroyersCollection", {
    Text = "Zaja Destorys [Collection]",
    Default = false,

    Callback = function(Value)

        CollectionRunning = Value

        -- OFF
        if not Value then

            if CollectionTween then
                pcall(function()
                    CollectionTween:Cancel()
                end)

                CollectionTween = nil
            end

            return
        end

        task.spawn(function()

            local ArenaIndex = 1

            while Library.Toggles.ZajaDestroyersCollection.Value
                and CollectionRunning do

                -- Zaja / Destroyer xuất hiện
                if IsZajaOrDestroyerAlive() then

                    if CollectionTween then
                        pcall(function()
                            CollectionTween:Cancel()
                        end)

                        CollectionTween = nil
                    end

                    task.wait(0.5)
                    continue
                end

                local Root = GetRoot()

                if Root then

                    local Arenas = GetArenaParts()

                    if #Arenas > 0 then

                        if ArenaIndex > #Arenas then
                            ArenaIndex = 1
                        end

                        local Target =
                            Arenas[ArenaIndex]

                        if Target
                            and Target.Parent then

                            -- Check lần nữa trước khi di chuyển
                            if not IsZajaOrDestroyerAlive() then

                                if CollectionMode == "Teleport" then

                                    Root.CFrame =
                                        Target.CFrame
                                        + Vector3.new(0, 3, 0)

                                else

                                    local Distance =
                                        (
                                            Target.Position
                                            - Root.Position
                                        ).Magnitude

                                    local Time =
                                        math.max(
                                            Distance / 300,
                                            0.05
                                        )

                                    CollectionTween =
                                        TweenService:Create(
                                            Root,
                                            TweenInfo.new(
                                                Time,
                                                Enum.EasingStyle.Linear
                                            ),
                                            {
                                                CFrame =
                                                    Target.CFrame
                                                    + Vector3.new(0, 3, 0)
                                            }
                                        )

                                    CollectionTween:Play()
                                    CollectionTween.Completed:Wait()

                                    CollectionTween = nil
                                end
                            end
                        end

                        ArenaIndex += 1
                    end
                end

                -- 10 giây sang Arena khác
                task.wait(10)
            end
        end)
    end,
})

--==================================================
-- AUTO COLLECT V2
--==================================================

local function FireNearbyPrompts(Range)

    local Root = GetRoot()

    if not Root then
        return
    end

    for _, Object in ipairs(workspace:GetDescendants()) do

        if Object:IsA("ProximityPrompt") then

            local Parent = Object.Parent

            local Part =
                Parent:IsA("BasePart")
                and Parent
                or Parent:FindFirstChildWhichIsA("BasePart")

            if Part then

                local Distance =
                    (Part.Position - Root.Position).Magnitude

                if Distance <= Range then

                    pcall(function()
                        fireproximityprompt(Object)
                    end)
                end
            end
        end
    end
end

Tab6Automation:AddToggle("AutoCollectV2", {
    Text = "Auto Collect v2",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoCollectV2.Value do

                FireNearbyPrompts(30)

                task.wait(1)
            end
        end)
    end,
})

--==================================================
-- AUTO SHOP
--==================================================

Tab6Automation:AddToggle("AutoShop", {
    Text = "Auto Shop",
    Default = false,

    Callback = function(Value)

        if not Value then
            return
        end

        task.spawn(function()

            while Library.Toggles.AutoShop.Value do

                -- Tìm ProximityPrompt của Shop
                for _, Object in ipairs(workspace:GetDescendants()) do

                    if Object:IsA("ProximityPrompt") then

                        local Name =
                            string.lower(Object:GetFullName())

                        if string.find(Name, "shop")
                            or string.find(Name, "npcshop") then

                            pcall(function()
                                fireproximityprompt(Object)
                            end)
                        end
                    end
                end

                -- Shop mỗi 3 phút
                task.wait(180)
            end
        end)
    end,
})

--==================================================
-- ANTI LAG
--==================================================

local AntiLagConnection

Tab6Automation:AddToggle("AntiLag", {
    Text = "Anti Lag",
    Default = false,

    Callback = function(Value)

        if AntiLagConnection then
            AntiLagConnection:Disconnect()
            AntiLagConnection = nil
        end

        if not Value then
            return
        end

        AntiLagConnection =
            workspace.DescendantAdded:Connect(function(Object)

                task.defer(function()

                    if not Library.Toggles.AntiLag.Value then
                        return
                    end

                    if Object:IsA("ParticleEmitter")
                        or Object:IsA("Trail")
                        or Object:IsA("Beam")
                        or Object:IsA("Smoke")
                        or Object:IsA("Fire")
                        or Object:IsA("Sparkles") then

                        pcall(function()
                            Object.Enabled = false
                        end)
                    end
                end)
            end)

        task.spawn(function()

            while Library.Toggles.AntiLag.Value do

                for _, Object in ipairs(workspace:GetDescendants()) do

                    if Object:IsA("ParticleEmitter")
                        or Object:IsA("Trail")
                        or Object:IsA("Beam")
                        or Object:IsA("Smoke")
                        or Object:IsA("Fire")
                        or Object:IsA("Sparkles") then

                        pcall(function()
                            Object.Enabled = false
                        end)
                    end
                end

                task.wait(2)
            end
        end)
    end,
})

--==================================================
-- ESP STARDUST ORB
--==================================================

local StardustColor = Color3.fromRGB(
    255,
    255,
    0
)

local StardustESP = {}

Tab6ESP:AddColorPicker("StardustColor", {
    Default = StardustColor,
    Title = "Stardust ESP Color",

    Callback = function(Value)

        StardustColor = Value

        for _, ESP in pairs(StardustESP) do

            if ESP and ESP.Parent then
                ESP.FillColor = Value
                ESP.OutlineColor = Value
            end
        end
    end,
})

Tab6ESP:AddToggle("ESPStardustOrb", {
    Text = "ESP Stardust Orb",
    Default = false,

    Callback = function(Value)

        if not Value then

            for Object, ESP in pairs(StardustESP) do

                if ESP then
                    ESP:Destroy()
                end

                StardustESP[Object] = nil
            end

            return
        end

        task.spawn(function()

            while Library.Toggles.ESPStardustOrb.Value do

                local Folder =
                    workspace:FindFirstChild("Misc")
                    and workspace.Misc:FindFirstChild(
                        "DragonSphereSpawns"
                    )

                if Folder then

                    for _, Part in ipairs(Folder:GetDescendants()) do

                        if Part:IsA("BasePart")
                            and Part:FindFirstChildWhichIsA(
                                "SpecialMesh"
                            )
                            or (
                                Part:IsA("MeshPart")
                            ) then

                            if not StardustESP[Part] then

                                local Highlight =
                                    Instance.new("Highlight")

                                Highlight.Name =
                                    "StardustESP"

                                Highlight.Adornee = Part
                                Highlight.FillColor =
                                    StardustColor

                                Highlight.OutlineColor =
                                    StardustColor

                                Highlight.FillTransparency =
                                    0.35

                                Highlight.OutlineTransparency =
                                    0

                                Highlight.Parent =
                                    Part

                                StardustESP[Part] =
                                    Highlight
                            end
                        end
                    end
                end

                task.wait(1)
            end
        end)
    end,
})

--==================================================
-- HP ESP
--==================================================

local HPMode = "Number"
local HPBillboards = {}

Tab6Notifier:AddDropdown("HPDisplayMode", {
    Values = {
        "Number",
        "Percent"
    },

    Default = "Number",
    Multi = false,
    Text = "HP Mode",

    Callback = function(Value)
        HPMode = Value
    end,
})

local function GetHumanoid(Object)

    if not Object then
        return nil
    end

    return Object:FindFirstChildOfClass("Humanoid")
        or Object:FindFirstChild("Humanoid")
end

local function CreateHPESP(Mob)

    if HPBillboards[Mob] then
        return
    end

    local Root =
        Mob:FindFirstChild("HumanoidRootPart")
        or Mob.PrimaryPart
        or Mob:FindFirstChildWhichIsA("BasePart")

    local Humanoid = GetHumanoid(Mob)

    if not Root or not Humanoid then
        return
    end

    local Billboard =
        Instance.new("BillboardGui")

    Billboard.Name = "HPESP"
    Billboard.Adornee = Root
    Billboard.Size =
        UDim2.new(0, 120, 0, 30)

    Billboard.StudsOffset =
        Vector3.new(0, 4, 0)

    Billboard.AlwaysOnTop = true
    Billboard.Parent = Root

    local Label =
        Instance.new("TextLabel")

    Label.BackgroundTransparency = 1
    Label.Size =
        UDim2.fromScale(1, 1)

    Label.TextColor3 =
        Color3.fromRGB(255, 80, 80)

    Label.TextStrokeTransparency = 0
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamBold
    Label.Parent = Billboard

    HPBillboards[Mob] = {
        Billboard = Billboard,
        Label = Label,
    }

    task.spawn(function()

        while Library.Toggles.ESPHP.Value
            and Mob.Parent
            and Billboard.Parent do

            if Humanoid then

                if HPMode == "Percent" then

                    local MaxHealth =
                        math.max(
                            Humanoid.MaxHealth,
                            1
                        )

                    local Percent =
                        math.floor(
                            (
                                Humanoid.Health
                                / MaxHealth
                            ) * 100
                        )

                    Label.Text =
                        "HP: " .. Percent .. "%"

                else

                    Label.Text =
                        "HP: "
                        .. math.floor(Humanoid.Health)
                        .. " / "
                        .. math.floor(Humanoid.MaxHealth)
                end
            end

            task.wait(0.1)
        end

        HPBillboards[Mob] = nil

        if Billboard then
            Billboard:Destroy()
        end
    end)
end

Tab6Notifier:AddToggle("ESPHP", {
    Text = "ESP HP",
    Default = false,

    Callback = function(Value)

        if not Value then

            for Mob, Data in pairs(HPBillboards) do

                if Data.Billboard then
                    Data.Billboard:Destroy()
                end

                HPBillboards[Mob] = nil
            end

            return
        end

        task.spawn(function()

            while Library.Toggles.ESPHP.Value do

                local WorldMobs =
                    workspace:FindFirstChild("World Mobs")

                if WorldMobs then

                    for _, Mob in ipairs(
                        WorldMobs:GetDescendants()
                    ) do

                        if Mob:IsA("Model")
                            and GetHumanoid(Mob) then

                            CreateHPESP(Mob)
                        end
                    end
                end

                task.wait(1)
            end
        end)
    end,
})

--==================================================
-- SHOW ENERGY
--==================================================

local EnergyESP = {}

Tab6Notifier:AddToggle("ShowEnergy", {
    Text = "Show Energy",
    Default = false,

    Callback = function(Value)

        if not Value then

            for Character, Billboard in pairs(EnergyESP) do

                if Billboard then
                    Billboard:Destroy()
                end

                EnergyESP[Character] = nil
            end

            return
        end

        task.spawn(function()

            while Library.Toggles.ShowEnergy.Value do

                local Characters =
                    workspace:FindFirstChild("Characters")

                if Characters then

                    for _, Character in ipairs(
                        Characters:GetChildren()
                    ) do

                        local Status =
                            Character:FindFirstChild("Status")

                        local CurrentEnergy =
                            Status
                            and Status:FindFirstChild(
                                "CurrentEnergy"
                            )

                        local MaxEnergy =
                            Status
                            and Status:FindFirstChild(
                                "MaxEnergy"
                            )

                        local Root =
                            Character:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        if CurrentEnergy
                            and MaxEnergy
                            and Root then

                            local Billboard =
                                EnergyESP[Character]

                            if not Billboard then

                                Billboard =
                                    Instance.new(
                                        "BillboardGui"
                                    )

                                Billboard.Name =
                                    "EnergyESP"

                                Billboard.Adornee =
                                    Root

                                Billboard.Size =
                                    UDim2.new(
                                        0, 120,
                                        0, 25
                                    )

                                Billboard.StudsOffset =
                                    Vector3.new(
                                        0, 5, 0
                                    )

                                Billboard.AlwaysOnTop =
                                    true

                                Billboard.Parent =
                                    Root

                                local Label =
                                    Instance.new(
                                        "TextLabel"
                                    )

                                Label.BackgroundTransparency =
                                    1

                                Label.Size =
                                    UDim2.fromScale(
                                        1, 1
                                    )

                                Label.TextColor3 =
                                    Color3.fromRGB(
                                        80, 220, 255
                                    )

                                Label.TextStrokeTransparency =
                                    0

                                Label.TextSize = 14
                                Label.Font =
                                    Enum.Font.GothamBold

                                Label.Parent =
                                    Billboard

                                EnergyESP[Character] =
                                    Billboard
                            end

                            local Label =
                                Billboard:FindFirstChild(
                                    "TextLabel"
                                )

                            if Label then
                                Label.Text =
                                    "Energy: "
                                    .. math.floor(
                                        CurrentEnergy.Value
                                    )
                                    .. " / "
                                    .. math.floor(
                                        MaxEnergy.Value
                                    )
                            end
                        end
                    end
                end

                task.wait(0.25)
            end
        end)
    end,
})

--==================================================
-- CLEAR DUNGEON COUNTER
--==================================================

local DungeonClearCount = 0
local PreviouslyHadMobs = false

local ClearDungeonLabel =
    Tab6Notifier:AddLabel(
        "Clear Dungeon: 0"
    )

task.spawn(function()

    while true do

        local WorldMobs =
            workspace:FindFirstChild("World Mobs")

        local EventMobs =
            WorldMobs
            and WorldMobs:FindFirstChild("Event Mobs")

        if EventMobs then

            local HasMobs =
                #EventMobs:GetChildren() > 0

            -- Có mobs
            if HasMobs then
                PreviouslyHadMobs = true
            end

            -- Mobs đã biến mất sau khi từng xuất hiện
            if PreviouslyHadMobs
                and not HasMobs then

                DungeonClearCount += 1
                PreviouslyHadMobs = false

                pcall(function()
                    ClearDungeonLabel:SetText(
                        "Clear Dungeon: "
                        .. DungeonClearCount
                    )
                end)
            end
        end

        task.wait(0.2)
    end
end)
--==================================================
-- AUTO DESTROY EVENT
--==================================================

local TweenService = game:GetService("TweenService")

local DestroyerNoclipConnection
local DestroyerTween

Tab5Automation:AddToggle("AutoDestroyEvent", {
    Text = "Auto desotry event",
    Default = false,

    Callback = function(Value)

        -- OFF
        if not Value then

            if DestroyerTween then
                pcall(function()
                    DestroyerTween:Cancel()
                end)
                DestroyerTween = nil
            end

            if DestroyerNoclipConnection then
                DestroyerNoclipConnection:Disconnect()
                DestroyerNoclipConnection = nil
            end

            -- Khôi phục CanCollide
            local Character = LocalPlayer.Character

            if Character then
                for _, Part in ipairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = true
                    end
                end
            end

            return
        end

        -- ON
        task.spawn(function()

            while Library.Toggles.AutoDestroyEvent.Value do

                local EventMobs =
                    workspace:FindFirstChild("World Mobs")
                    and workspace["World Mobs"]:FindFirstChild("Event Mobs")

                local Destroyer =
                    EventMobs
                    and EventMobs:FindFirstChild("Destroyer")

                if Destroyer then

                    local TargetRoot =
                        Destroyer:FindFirstChild("HumanoidRootPart")
                        or Destroyer.PrimaryPart
                        or Destroyer:FindFirstChildWhichIsA("BasePart")

                    local Character = LocalPlayer.Character
                    local Root =
                        Character
                        and Character:FindFirstChild("HumanoidRootPart")

                    if TargetRoot and Root then

                        --==================================================
                        -- NOCLIP
                        --==================================================

                        if DestroyerNoclipConnection then
                            DestroyerNoclipConnection:Disconnect()
                        end

                        DestroyerNoclipConnection =
                            RunService.Stepped:Connect(function()

                                if not Library.Toggles.AutoDestroyEvent.Value then
                                    return
                                end

                                local Char = LocalPlayer.Character

                                if Char then
                                    for _, Part in ipairs(Char:GetDescendants()) do
                                        if Part:IsA("BasePart") then
                                            Part.CanCollide = false
                                        end
                                    end
                                end
                            end)

                        --==================================================
                        -- TWEEN SPEED = 300
                        --==================================================

                        local Distance =
                            (TargetRoot.Position - Root.Position).Magnitude

                        local TweenTime =
                            math.max(Distance / 300, 0.05)

                        DestroyerTween =
                            TweenService:Create(
                                Root,
                                TweenInfo.new(
                                    TweenTime,
                                    Enum.EasingStyle.Linear
                                ),
                                {
                                    CFrame =
                                        TargetRoot.CFrame
                                        + Vector3.new(0, 5, 0)
                                }
                            )

                        DestroyerTween:Play()

                        DestroyerTween.Completed:Wait()

                        DestroyerTween = nil
                    end
                end

                task.wait(0.1)
            end
        end)
    end,
})
