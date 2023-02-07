-- 


local config = {
	
	cmdbar_keybind = Enum.KeyCode.RightAlt	

}

local cmdIndex = {
	["cmd"] = {
		func = function(args)
			
		end
	},
	
	["ru"] = { -- CMD EXAMPLE	
		func = function(args)	
			game.Players.LocalPlayer.Character.Head:FindFirstChildWhichIsA("BillboardGui"):Destroy()

		end		
	},
	["buy"] = {
		func = function(args)
			local choice = args[1]:lower()
			local choices = {
				["glock"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 1200)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Glock19(LEGAL)", 1200, "Cash")

				end},
				["ak"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 2500)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("AK47(LEGAL)", 2500, "Cash")

				end},
				["bfg"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 10000)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("BFG-50(LEGAL)", 10000, "Cash")

				end},
				["shotgun"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 5000)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Shotgun(LEGAL)", 5000, "Cash")

				end},
				["colt"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 1750)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("ColtPython(LEGAL)", 1750, "Cash")

				end},
				["knife"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 700)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Knife(ILLEGAL)", 700, "Cash")

				end},
				["vest"] = {buy = function()
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Vest", 3200, "Bank")

				end},
				["crowbar"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 700)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Knife(ILLEGAL)", 700, "Cash")

				end},
				["crowbar"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 600)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Crowbar", 600, "Cash")

				end},
				["hammer"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 500)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Hammer", 500, "Cash")

				end},
				["drill"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 500)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Drill", 500, "Cash")

				end},
				["gascan"] = {buy = function()
					game:GetService("ReplicatedStorage").ATMAction:FireServer("Withdraw", 250)
					workspace.DealersScript:WaitForChild("BuyItem"):InvokeServer("Gas Can", 250, "Cash")

				end}
				}
				choices[choice].buy()
		end
	},
	["killtires"] = {
		func = function(args)
			if not game.Loaded then
				game.Loaded:Wait()
				wait(3)
			end

			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local ReplicatedStorage = game:GetService("ReplicatedStorage")
			local LocalPlayer = Players.LocalPlayer

			local MoneyDataFolder = ReplicatedStorage:WaitForChild("MoneyData")
			local LocalPlayerCashValue = MoneyDataFolder:WaitForChild(LocalPlayer.Name).Cash
			local LocalPlayerBankValue = MoneyDataFolder:WaitForChild(LocalPlayer.Name).BankAccount
			local ATMAction = ReplicatedStorage:WaitForChild("ATMAction")



			local function GetGunObject()
				if LocalPlayer.Backpack:FindFirstChild("AK47(LEGAL)") then
					return LocalPlayer.Backpack["AK47(LEGAL)"]
				else
					local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
					if LocalCharacter:FindFirstChild("AK47(LEGAL)") then
						return LocalCharacter:FindFirstChild("AK47(LEGAL)")
					end
				end
				return nil
			end

			local function GetGunRemote()
				local GunModel = GetGunObject()
				if GunModel ~= nil then
					return GunModel:FindFirstChild("RemoteEvent") 
				end
			end

			local function EquipGun()
				local GunModel = GetGunObject()
				if GunModel ~= nil then
					local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
					LocalCharacter.Humanoid:EquipTool(GunModel)
				end
			end

			local function UnEquipGun()
				local GunModel = GetGunObject()
				if GunModel ~= nil then
					local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
					LocalCharacter.Humanoid:UnequipTools()
				end
			end

			local function FireAtObject(part)
				local GunRemote = GetGunRemote()
				local args = {
					[1] = "Fire",
					[2] = part.Position,
					[3] = part,
					[4] = "editbynsxfa",
					[5] = part.Position,
					[6] = Vector3.new(0,1,0),
					[7] = "noob"
				}
				GunRemote:FireServer(unpack(args))
			end

			local function GetRemainingAmmo()
				local GunModel = GetGunObject()
				if GunModel ~= nil then
					return GunModel:WaitForChild("GunControl").AmmoSettings.MagAmmo.Value 
				end
			end

			local function ReloadGun()
				local GunRemote = GetGunRemote()
				if GunRemote ~= nil then
					local args = {
						[1] = "Reload"
					}
					GunRemote:FireServer(unpack(args))
				end
			end


			local function KillPlayer(player)
				pcall(function()
					local TargetPlayerCharacter = player.Character
					if TargetPlayerCharacter ~= nil then
						local TargetPlayerHumanoid = TargetPlayerCharacter:FindFirstChild("Humanoid")
						if TargetPlayerHumanoid ~= nil then
							local attempts = 0
							while RunService.Heartbeat:Wait() do
								if TargetPlayerHumanoid.Health <= 0 or TargetPlayerHumanoid.Health >= 150 or TargetPlayerCharacter:FindFirstChild("ForceField") or attempts >= 34 or IsPlayerWhitelisted(player) then
									break 
								end
								FireAtObject(TargetPlayerCharacter.Head)
								attempts += 1
								if GetRemainingAmmo() <= 0 then
									ReloadGun() 
								end
								wait(0.05)
							end
						end
					end
				end)
			end

			local function shootTire(tire)
				pcall(function()
					FireAtObject(tire)
					if GetRemainingAmmo() <= 0 then
						ReloadGun() 
					end
					wait(0.05)
				end)
			end


			if not GetGunObject() ~= nil then
				if LocalPlayerCashValue.Value >= 2500 then
					local args = {
						[1] = "AK47(LEGAL)",
						[2] = 2500,
						[3] = "Cash"
					}

					workspace.DealersScript.BuyItem:InvokeServer(unpack(args))
				else
					if LocalPlayerCashValue.Value + LocalPlayerBankValue.Value >= 2500 then
						ATMAction:FireServer(
							"Withdraw",
							2500 - LocalPlayerCashValue.Value
						)
						wait(0.8)
						local args = {
							[1] = "AK47(LEGAL)",
							[2] = 2500,
							[3] = "Cash"
						}

						workspace.DealersScript.BuyItem:InvokeServer(unpack(args))
					end
				end
			end

			if GetGunObject() ~= nil then

				EquipGun()
				wait(1.5)
				UnEquipGun()

				while wait() do
					for _,v in pairs(game.Players:GetChildren()) do
						if(game.Workspace:FindFirstChild(v.Name))then
							if(v.Character:FindFirstChild("Vehicle"))then
								for i,part in pairs(v.Character.Vehicle:GetChildren())do

									if(part.Name == "Non-powered wheel" or part.Name == "Powered wheel" or  part.Name == "Wheel") then
									
											shootTire(part)
										
									end
								end
							end
						end


					end
				end
			end
		end
	},
	["notify"] = {
		func = function(args)
 Notify(args[1],args[2])
		end
	},
	["vfly"] = {
		func = function(args)
			local FlyKey = Enum.KeyCode.V
			local SpeedKey = Enum.KeyCode.LeftControl

			local SpeedKeyMultiplier = 3
			local FlightSpeed = 256
			local FlightAcceleration = 4
			local TurnSpeed = 16

			-- made by zeezy

			-- enjoy :3

			local UserInputService = game:GetService("UserInputService")
			local StarterGui = game:GetService("StarterGui")
			local RunService = game:GetService("RunService")
			local Players = game:GetService("Players")
			local User = Players.LocalPlayer
			local Camera = workspace.CurrentCamera
			local UserCharacter = nil
			local UserRootPart = nil
			local Connection = nil


			workspace.Changed:Connect(function()
				Camera = workspace.CurrentCamera
			end)

			local setCharacter = function(c)
				UserCharacter = c
				UserRootPart = c:WaitForChild("HumanoidRootPart")
			end

			User.CharacterAdded:Connect(setCharacter)
			if User.Character then
				setCharacter(User.Character)
			end

			local CurrentVelocity = Vector3.new(0,0,0)
			local Flight = function(delta)
				local BaseVelocity = Vector3.new(0,0,0)
				if not UserInputService:GetFocusedTextBox() then
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then
						BaseVelocity = BaseVelocity + (Camera.CFrame.LookVector * FlightSpeed)
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then
						BaseVelocity = BaseVelocity - (Camera.CFrame.RightVector * FlightSpeed)
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then
						BaseVelocity = BaseVelocity - (Camera.CFrame.LookVector * FlightSpeed)
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then
						BaseVelocity = BaseVelocity + (Camera.CFrame.RightVector * FlightSpeed)
					end
					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
						BaseVelocity = BaseVelocity + (Camera.CFrame.UpVector * FlightSpeed)
					end
					if UserInputService:IsKeyDown(SpeedKey) then
						BaseVelocity = BaseVelocity * SpeedKeyMultiplier
					end
				end
				if UserRootPart then
					local car = UserRootPart:GetRootPart()
					if car.Anchored then return end
					if not isnetworkowner(car) then return end
					CurrentVelocity = CurrentVelocity:Lerp(
						BaseVelocity,
						math.clamp(delta * FlightAcceleration, 0, 1)
					)
					car.Velocity = CurrentVelocity + Vector3.new(0,2,0)
					if car ~= UserRootPart then
						car.RotVelocity = Vector3.new(0,0,0)
						car.CFrame = car.CFrame:Lerp(CFrame.lookAt(
							car.Position,
							car.Position + CurrentVelocity + Camera.CFrame.LookVector
							), math.clamp(delta * TurnSpeed, 0, 1))
					end
				end
			end

			UserInputService.InputBegan:Connect(function(userInput,gameProcessed)
				if gameProcessed then return end
				if userInput.KeyCode == FlyKey then
					if Connection then
						
						Connection:Disconnect()
						Connection = nil
						Notify("VFly Enabled",3.5)
					else
					
						CurrentVelocity = UserRootPart.Velocity
						Connection = RunService.Heartbeat:Connect(Flight)
						Notify("VFly Enabled",3.5)
					end
				end
			end)

			Notify("VFly loaded.",3)
		end
	},
	["inviscar"] = {
		func = function(args)
			
			local car = game:GetService("Workspace")[game.Players.LocalPlayer.Name].Vehicle

local lightEvent = game:GetService("Players").LocalPlayer.PlayerGui.CarGui.Frame.LightsSirensEvent
local dEvent = game:GetService("Players").LocalPlayer.PlayerGui.CarGui.Frame.DestroyEvent

for i,v in pairs(car:GetDescendants()) do
if args[1]:lower() == "on" then
lightEvent:FireServer("Transparency",v,1)
elseif args[1]:lower() == "off" then
	lightEvent:FireServer("Transparency",v,1)


end
			
		end
	},
	["rgbcar"] = {
		func = function(args)
rgb()
		end
	}
}

local function getCMDNames()
	local cmdNamesTBL = {}
	for i,v in pairs(cmdIndex) do
		table.insert(cmdNamesTBL,i)
	end
	return cmdNamesTBL
end

local cmdNames = getCMDNames()

-- Instances:

local Cmdbar = Instance.new("ScreenGui")
local Base = Instance.new("Frame")
local Cmdbox = Instance.new("TextBox")
local ImageLabel = Instance.new("ImageLabel")


--Properties:

Cmdbar.Name = "Cmdbar"
Cmdbar.Parent = game.CoreGui
Cmdbar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Cmdbar.ResetOnSpawn = false

Base.Name = "Base"
Base.Parent = Cmdbar
Base.AnchorPoint = Vector2.new(0.5, 0.5)
Base.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Base.BackgroundTransparency = 1.000
Base.BorderSizePixel = 0
Base.Position = UDim2.new(0.5, 0, 0.800000012, 0)
Base.Size = UDim2.new(0, 0, 0, 30)

Cmdbox.Name = "Cmdbox"
Cmdbox.Parent = Base
Cmdbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Cmdbox.BackgroundTransparency = 1.000
Cmdbox.Position = UDim2.new(0, 0, 0.0666666701, 0)
Cmdbox.Size = UDim2.new(0, 374, 0, 28)
Cmdbox.Font = Enum.Font.SourceSans
Cmdbox.PlaceholderText = "Enter your command here."
Cmdbox.Text = ""
Cmdbox.TextColor3 = Color3.fromRGB(221, 221, 221)
Cmdbox.TextSize = 20.000
Cmdbox.TextTransparency = 1.000
Cmdbox.TextWrapped = true

ImageLabel.Parent = Cmdbar -- LOGO
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.Position = UDim2.new(0.0124754328, 0, 0.859477103, 0)
ImageLabel.Size = UDim2.new(0, 75, 0, 75)
ImageLabel.Image = "http://www.roblox.com/asset/?id=12404212224"

-- FUNCTIONS --

local function rgb()
	local lp = game.Players.LocalPlayer
	local remote = game:GetService("Players").LocalPlayer.PlayerGui.PaintshopGui["Paintshop GUI"].PaintshopEvent
	local guiGiver = game:GetService("Workspace").Stores["Soel's Paint shop"].PaintshopGuiGiver
	
	_G.enabled = true
	
		local lightEvent = game:GetService("Players").LocalPlayer.PlayerGui.CarGui.Frame.HeadlightsEvent
	
	local car = game:GetService("Workspace")[game.Players.LocalPlayer.Name].Vehicle
	for i,v in pairs(car:GetDescendants()) do
				  lightEvent:FireServer("SurfaceGuiBr",v,true)
	end
	
	game:GetService("Players").LocalPlayer.PlayerGui.PaintshopGui.Enabled = false
	while wait(.1) do
		remote:FireServer("ChangeCarPaint",BrickColor.Random())
	remote:FireServer("ChangeCarTint",BrickColor.Random())--creates a color using i
	
	
	end
end

local function Notify(msg,timer)
	-- Instances:

	local Notification = Instance.new("ScreenGui")
	local Base = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Message = Instance.new("TextLabel")
	local TimeoutBar = Instance.new("Frame")

	--Properties:

	Notification.Name = "Notification"
	Notification.Parent = game.CoreGui
	Notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Notification.ResetOnSpawn = false

	Base.Name = "Base"
	Base.Parent = Notification
	Base.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Base.BackgroundTransparency = 1.000
	Base.BorderSizePixel = 0
	Base.Position = UDim2.new(0.439999998, 0, 1, 0)
	Base.Size = UDim2.new(0, 231, 0, 62)

	Title.Name = "Title"
	Title.Parent = Base
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.0649350584, 0, 0, 0)
	Title.Size = UDim2.new(0, 200, 0, 23)
	Title.Font = Enum.Font.SourceSansLight
	Title.Text = "LOLERN's ADMIN Notification"
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextSize = 18.000
	Title.TextTransparency = 1.000

	Message.Name = "Message"
	Message.Parent = Base
	Message.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Message.BackgroundTransparency = 1.000
	Message.Position = UDim2.new(0, 0, 0.418181807, 0)
	Message.Size = UDim2.new(0, 231, 0, 32)
	Message.Font = Enum.Font.SourceSansLight
	Message.Text = msg
	Message.TextColor3 = Color3.fromRGB(255, 255, 255)
	Message.TextSize = 16.000
	Message.TextTransparency = 1.000
	Message.TextWrapped = true

	TimeoutBar.Name = "TimeoutBar"
	TimeoutBar.Parent = Base
	TimeoutBar.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
	TimeoutBar.BackgroundTransparency = 1.000
	TimeoutBar.BorderSizePixel = 0
	TimeoutBar.Position = UDim2.new(0, 0, 0.93431139, 0)
	TimeoutBar.Size = UDim2.new(0, 231, 0, 4)

	local TweenService = game:GetService("TweenService")
	local timeoutVal = timer
	wait(.2)
	local function faintui()
		TweenService:Create(
			TimeoutBar,
			TweenInfo.new(0.7),
			{BackgroundTransparency = 0.1}
		):Play()
		TweenService:Create(
			Base,
			TweenInfo.new(0.7),
			{BackgroundTransparency = 0.1}
		):Play()
		TweenService:Create(
			Title,
			TweenInfo.new(0.7),
			{TextTransparency = 0}
		):Play()
		TweenService:Create(
			Message,
			TweenInfo.new(0.7),
			{TextTransparency = 0}
		):Play()
	end
	faintui()
	Base:TweenPosition(
		UDim2.new(0.44, 0,0.473, 0),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Linear,
		0.1
	)
	TimeoutBar:TweenSize(
		UDim2.new(0, 0,0, 3),
		Enum.EasingDirection.In,
		Enum.EasingStyle.Quad,
		timeoutVal
	)
	wait(timeoutVal)
	local function unfaintui()
		TweenService:Create(
			TimeoutBar,
			TweenInfo.new(0.7),
			{BackgroundTransparency = 1}
		):Play()
		TweenService:Create(
			Base,
			TweenInfo.new(0.7),
			{BackgroundTransparency = 1}
		):Play()
		TweenService:Create(
			Title,
			TweenInfo.new(0.7),
			{TextTransparency = 1}
		):Play()
		TweenService:Create(
			Message,
			TweenInfo.new(0.7),
			{TextTransparency = 1}
		):Play()
	end
	unfaintui()
	wait(0.8)
	-- so it doesnt lag p
	Notification:Destroy()
end

local function processCMD(input) -- process_cmd
	
	local input2 = input:lower()
		local sep = " "
	local splitInput = string.split(input,sep)
	local cmdArgs = {}
	
	for i=2,#splitInput do
		
		table.insert(cmdArgs,splitInput[i])
		
	end
	
	local cmd = splitInput[1]:lower()
	if table.find(cmdNames,cmd) then
		
		cmdIndex[cmd].func(cmdArgs)
		
	else
		
	print("Invalid INPUT")
		return;
		
	end
end
	
local function handleCMDBar(input) -- handle_cmdbar
		if input.KeyCode == config.cmdbar_keybind then
			Base:TweenSize(
				UDim2.new(0, 374,0, 30),
				Enum.EasingDirection.In,
				Enum.EasingStyle.Linear,
				0.2
			)
			local TweenService = game:GetService('TweenService')
			TweenService:Create(
				Base,
				TweenInfo.new(0.3),
				{BackgroundTransparency = 0.1}
			):Play()
			wait(0.3)
			TweenService:Create(
				Cmdbox,
				TweenInfo.new(0.2),
				{TextTransparency = 0}
			):Play()
			wait(.0001)
			Cmdbox:CaptureFocus()
			Cmdbox.FocusLost:Connect(function()
				TweenService:Create(
					Cmdbox,
					TweenInfo.new(0.2),
					{TextTransparency = 1}
				):Play()
				wait(0.2)
				TweenService:Create(
					Base,
					TweenInfo.new(0.3),
					{BackgroundTransparency = 1}
				):Play()
				Base:TweenSize(
					UDim2.new(0, 0,0, 30),
					Enum.EasingDirection.In,
					Enum.EasingStyle.Linear,
					0.2
			)
			   -- process the Command
			local cmdText = Cmdbox.Text
			processCMD(cmdText)
				-- Reset text
				Cmdbox.Text = ""
			end)
		end
	end	
-- EVENTS --

game:GetService("UserInputService").InputBegan:Connect(handleCMDBar)

game.Players.LocalPlayer.CharacterAppearanceLoaded:Connect(function()
	
	game.Players.LocalPlayer.Character.ChildAdded:Connect(function(child)
		if child.Name == "Vehicle" then
			
			game:GetService("Workspace").Stores["Soel's Paint shop"].PaintshopGuiGiver.Position = game.Players.LocalPlayer.Character.Torso.Position
			wait(3)
			local paintshopgui = game.Players.LocalPlayer.PlayerGui.PaintshopGui["Paintshop GUI"]
			paintshopgui.Visible = false
		end
	end)
	
	end) 
	
	
	Notify("LOLERN's Mano ADMIN Loaded",3.5)
