ESX = nil

CreateThread(function()
	ESX = exports["es_extended"]:getSharedObject()
	while ESX.GetPlayerData().job == nil do Wait(100) end
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true

	if Config.Postal then
		local playerID = "ID: "..GetPlayerServerId(PlayerId()).." | PLZ: "..exports.nearest_postal:getPostal()
		SendNUIMessage({action = "setValue", key = "id", value = playerID})
	else
		local playerID = "ID: "..GetPlayerServerId(PlayerId())
		SendNUIMessage({action = "setValue", key = "id", value = playerID})
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  ESX.PlayerData.job = job
end)

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, 
    ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, 
    ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, 
    ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, 
    ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
            TriggerEvent("fex_hud:toggle", false)
		else
            TriggerEvent("fex_hud:toggle", true)
		end
	end
end)

RegisterNetEvent('fex_hud:toggle')
AddEventHandler('fex_hud:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

		--car
		-- if IsPedInAnyVehicle(ped, false) then
		-- 	local speed = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
        --     local health = GetVehicleEngineHealth(vehicle)
        --     local fuel = GetVehicleFuelLevel(vehicle)
		-- 	SendNUIMessage({action = 'toggle_car', show = true})
		-- 	SendNUIMessage({action = 'setValue', key = 'car_speed', value = math.floor(speed) .. ' KM&#47;H'})
		-- 	SendNUIMessage({action = 'setValue', key = 'car_fuel', value = math.floor(fuel) .. ' %'})
		-- else
		-- 	SendNUIMessage({action = 'toggle_car', show = false})
		-- end

		--User
		ESX = exports["es_extended"]:getSharedObject()
		
		if Config.Postal then
			local playerID = "ID: "..GetPlayerServerId(PlayerId()).." | PLZ: "..exports.nearest_postal:getPostal()
			SendNUIMessage({action = "setValue", key = "id", value = playerID})
		else
			local playerID = "ID: "..GetPlayerServerId(PlayerId())
			SendNUIMessage({action = "setValue", key = "id", value = playerID})
		end

		if ESX.PlayerData.job then
			local job
			local blackMoney
			local bank
			local money

			if ESX.PlayerData.job.label == ESX.PlayerData.job.grade_label then
				job = ESX.PlayerData.job.grade_label
			else
				job = ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label
			end


			for i=1, #ESX.PlayerData.accounts, 1 do
				if ESX.PlayerData.accounts[i].name == 'money' then
					money = ESX.PlayerData.accounts[i].money
				end
			end

			SendNUIMessage({action = "setValue", key = "job", value = job})
			SendNUIMessage({action = "setValue", key = "money", value = money..Config.Currency})

            local hunger
            local thirst
            local stamina = Round(100 - GetPlayerSprintStaminaRemaining(PlayerId()))
            local health = Round(GetEntityHealth(PlayerPedId()) / 2)
            local armor = GetPedArmour(GetPlayerPed(-1))

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                hunger = Round(status.getPercent())
            end)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                thirst = Round(status.getPercent())
            end)

            SendNUIMessage({action = "setProgress", key = "hunger", value = hunger})
            SendNUIMessage({action = "setProgress", key = "thirst", value = thirst})
            SendNUIMessage({action = "setProgress", key = "stamina", value = stamina})
            SendNUIMessage({action = "setProgress", key = "health", value = health})
            SendNUIMessage({action = "setProgress", key = "armor", value = armor})
		end
  	end
end)