local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sidhsksjsjsh/VAPE-UI-MODDED/main/.lua"))()
local wndw = lib:Window("VIP Turtle Hub V4")
local T1 = wndw:Tab("Main")
local T2 = wndw:Tab("Sherrif")
local T3 = wndw:Tab("Monster")
local T4 = wndw:Tab("Crate")
local T5 = wndw:Tab("Vote")

local workspace = game:GetService("Workspace")
local player = {
  self = game:GetService("Players").LocalPlayer,
  server = game:GetService("Players")
}

local var = {
  spin = false,
  coin1 = false,
  coin2 = false,
  sher = false,
  mons = false,
  monspower = false,
  crate = {
    table = {},
    toggle = false,
    name = "null"
  },
  map = {
    table = {"1","2","3"},
    name = "1",
    toggle = false
  },
  safep = false,
  tp = false
}

lib:AddTable(game:GetService("ReplicatedStorage").Storage.Crates,var.crate.table)

local function getEquippedTool(plr)
    local char = plr.Character
    local polvus = char and char:FindFirstChildWhichIsA("Tool")
    
    if polvus ~= nil then
        return polvus.Name
    end
end

local function getBackpackTool(plr)
    local char = plr.Backpack
    local polvus = char and char:FindFirstChildWhichIsA("Tool")
    
    if polvus ~= nil then
        return polvus.Name
    end
end

local function asyncChildren(path,funct)
  for i,v in pairs(path:GetChildren()) do
    funct(v)
  end
end

local function getPlayer(funct)
  for i,v in pairs(player.server:GetPlayers()) do
    funct(v)
  end
end

local function getBackpack(funct)
  getPlayer(function(v)
      asyncChildren(v.Backpack,function(array)
          funct(array,v)
      end)
  end)
end

local function getSelfToolFromBackpack(name)
  asyncChildren(player.self.Backpack,function(array)
      if array.Name == name then
        return true
      end
  end)
end
--lib:TeleportMethod(mthd,str)

local function makeESP()
  getBackpack(function(tool,v)
      asyncChildren(v.Character,function(i)
        if i.Name == "X-RAY" then
            i:Destroy()
        end
      end)
    
      if tool.Name == "Monster" or getEquippedTool(v) == "Monster" then
        local esp = Instance.new("Highlight")
        esp.Name = "X-RAY"
        esp.FillColor = Color3.new(1,0,0)
        esp.OutlineColor = Color3.new(1,1,1)
        esp.FillTransparency = 0
        esp.OutlineTransparency = 1
        esp.Adornee = v.Character
        esp.Parent = v.Character
        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      end
      if tool.Name == "Gun" or getEquippedTool(v) == "Gun" then
        local esp = Instance.new("Highlight")
        esp.Name = "X-RAY"
        esp.FillColor = Color3.new(0,0,1)
        esp.OutlineColor = Color3.new(1,1,1)
        esp.FillTransparency = 0
        esp.OutlineTransparency = 1
        esp.Adornee = v.Character
        esp.Parent = v.Character
        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      end
      if tool.Name ~= "Gun" or getEquippedTool(v) ~= "Gun" or tool.Name ~= "Monster" or getEquippedTool(v) ~= "Monster" then
        local esp = Instance.new("Highlight")
        esp.Name = "X-RAY"
        esp.FillColor = Color3.new(0,1,0)
        esp.OutlineColor = Color3.new(1,1,1)
        esp.FillTransparency = 0
        esp.OutlineTransparency = 1
        esp.Adornee = v.Character
        esp.Parent = v.Character
        esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      end
  end)
end

T1:Toggle("Auto tp to safe place [ Innocent ]",false,function(value)
    var.safep = value
    while wait() do
      if var.safep == false then break end
      if getSelfToolFromBackpack("Gun") == false or getSelfToolFromBackpack("Monster") == false or getSelfToolFromBackpack("Gun") ~= true or getSelfToolFromBackpack("Monster") ~= true then
        lib:TeleportMethod("tp",CFrame.new(-362,47,-9219))
      end
    end
end)

T1:Toggle("Auto spin",false,function(value)
    var.spin = value
    while wait() do
      if var.spin == false then break end
        game:GetService("ReplicatedStorage")["Remotes"]["SpinWheel"]:InvokeServer()
    end
end)

T1:Toggle("Auto collect coins",false,function(value)
    var.coin1 = value
    while wait() do
      if var.coin1 == false then break end
      asyncChildren(workspace.CoinHolder,function(a)
          asyncChildren(a,function(v)
              game:GetService("ReplicatedStorage")["Remotes"]["CollectCoin"]:FireServer(v.Name,a.Name)
          end)
      end)
    end
end)

T1:Button("ESP",function()
    makeESP()
end)
--[[
Players.Abc_veryxyz.Backpack.Gun
Players.hainakira.Backpack.Monster
Players.Rivanda_Cheater.Backpack.Emotes
]]

T2:Toggle("Auto shoot monster",false,function(value)
    var.sher = value
    while wait() do
      if var.sher == false then break end
      if getEquippedTool(player.self) == "Gun" then
          getBackpack(function(tool,plr)
              if tool.Name == "Gun" then
                game:GetService("ReplicatedStorage")["Remotes"]["ShootGun"]:FireServer(plr.Character.HumanoidRootPart.Position,player.self.Character.HumanoidRootPart.Position)
              end
          end)
      else
        lib:notify(lib:ColorFonts("Cant shoot, no gun detected. Missing-Role : Sherrif","Red"),10)
        var.sher = false
      end
    end
end)

T3:Toggle("Teleport to all players",false,function(value)
    var.tp = value
    while wait() do
      if var.tp == false then break end
      getPlayer(function(v)
          lib:TeleportMethod("tp",v.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1.5))
      end)
    end
end)

T3:Toggle("Monster transform",false,function(value)
    if getSelfToolFromBackpack("Monster") == true or getEquippedTool(player.self) == "Monster" then
      game:GetService("ReplicatedStorage")["Remotes"]["MorphToMonster"]:FireServer(value)
    else
      lib:notify(lib:ColorFonts("Cannot transform, no monster tool detected. Missing-Role : Monster","Red"),10)
    end
end)

T3:Toggle("Auto throw claw",false,function(value)
    var.mons = value
    while wait() do
      if var.sher == false then break end
      if getSelfToolFromBackpack("Monster") == true or getEquippedTool(player.self) == "Monster" then
          getBackpack(function(tool,plr)
              if tool.Name == "Monster" then
                game:GetService("ReplicatedStorage")["Remotes"]["MonsterClawThrow"]:FireServer(plr.Character.HumanoidRootPart.Position,player.self.Character.HumanoidRootPart.Position)
              end
          end)
      else
        lib:notify(lib:ColorFonts("Cannot throw claws, no monster tool detected. Missing-Role : Monster","Red"),10)
        var.mons = false
      end
    end
end)

T3:Toggle("Auto use power",false,function(value)
    var.monspower = value
    while wait() do
      if var.monspower == false then break end
      if getSelfToolFromBackpack("Monster") == true then
        game:GetService("ReplicatedStorage")["Remotes"]["UsePower"]:FireServer()
      else
        lib:notify(lib:ColorFonts("Cannot use power, no monster tool detected. Missing-Role : Monster","Red"),10)
        var.monspower = false
      end
    end
end)

T4:Dropdown("Choose crate",var.crate.table,function(value)
    var.crate.name = value
end)

T4:Toggle("Auto open crate",false,function(value)
    var.crate.toggle = value
    while wait() do
      if var.crate.toggle == false then break end
      if var.crate.name ~= "null" then
        game:GetService("ReplicatedStorage")["Remotes"]["OpenCrate"]:InvokeServer(var.crate.name)
      else
        lib:notify(lib:ColorFonts("Choose crate.","Red"),10)
        var.crate.toggle = false
      end
    end
end)

T5:Dropdown("Choose map ID",var.map.table,function(value)
    var.map.name = value
end)

T5:Toggle("Auto vote",false,function(value)
    var.map.toggle = value
    while wait() do
      if var.map.toggle == false then break end
      game:GetService("ReplicatedStorage")["Remotes"]["CastVote"]:FireServer(var.map.name)
    end
end)
