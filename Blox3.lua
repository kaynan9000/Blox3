-- [[ KA HUB | FIX HTTP 404 - VERSÃO ESTÁVEL ]]
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source'))()
end)

if not success or not Rayfield then
    warn("Erro crítico: Não foi possível carregar a biblioteca UI. Verifique sua internet.")
    return
end

-- // CONFIGURAÇÕES GLOBAIS
_G.AutoFarm = false
_G.Weapon = "Melee"

local Window = Rayfield:CreateWindow({
   Name = "KA HUB | FIX EDITION",
   LoadingTitle = "Carregando Sea 1...",
   ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Auto Farm")

Tab:CreateToggle({
   Name = "ATIVAR FARM",
   CurrentValue = false,
   Callback = function(v) _G.AutoFarm = v end,
})

Tab:CreateDropdown({
   Name = "Escolher Arma",
   Options = {"Melee", "Sword", "Fruit"},
   CurrentOption = "Melee",
   Callback = function(v) _G.Weapon = v end,
})

-- // LOOP DE FARM OTIMIZADO
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local LP = game.Players.LocalPlayer
                local level = LP.Data.Level.Value
                local RS = game:GetService("ReplicatedStorage")
                
                -- Sistema Automático de Nível (Início)
                local qName, qLvl, mName, qPos
                if level < 10 then
                    qName = "BanditQuest1"; qLvl = 1; mName = "Bandit"; qPos = CFrame.new(1059, 15, 1550)
                else
                    qName = "JungleQuest"; qLvl = 1; mName = "Monkey"; qPos = CFrame.new(-1598, 35, 153)
                end

                if not LP.PlayerGui.Main.Quest.Visible then
                    LP.Character.HumanoidRootPart.CFrame = qPos
                    RS.Remotes.CommF_:InvokeServer("StartQuest", qName, qLvl)
                else
                    local target = workspace.Enemies:FindFirstChild(mName)
                    if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                        -- Equipar Arma
                        local tool = LP.Backpack:FindFirstChild(_G.Weapon) or LP.Character:FindFirstChild(_G.Weapon)
                        if tool then LP.Character.Humanoid:EquipTool(tool) end
                        
                        -- Atacar
                        LP.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, true, game, 0)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(500, 500, 0, false, game, 0)
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({Title = "KA HUB", Content = "Script Carregado!", Duration = 5})
