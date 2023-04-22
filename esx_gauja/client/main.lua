local CurrentActionData, handcuffTimer, dragStatus, blipsCops, currentTask = {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, isHandcuffed, hasAlreadyJoined, playerInService = false, false, false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
dragStatus.isDragged, isInShopMenu = false, false
ESX = nil

local DaroAnimacija = false
local ArrestAnim = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function cleanPlayer(playerPed)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
end

function setUniform(uniform, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		local uniformObject

		if skin.sex == 0 then
			uniformObject = Config.Uniforms[uniform].male
		else
			uniformObject = Config.Uniforms[uniform].female
		end

		if uniformObject then
			TriggerEvent('skinchanger:loadClothes', skin, uniformObject)

			if uniform == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			ESX.ShowNotification(_U('no_outfit'))
		end
	end)
end

function OpenCloakroomMenu()
	local playerPed = PlayerPedId()
	local grade = ESX.PlayerData.job.grade_name

	local elements = {
		{label = _U('citizen_wear'), value = 'citizen_wear'},
		{label = _U('gauja_wear', '1'), uniform = 'gauja_wear'},
		{label = _U('gauja_wear', '2'), uniform = 'gauja_wear2'}
	}

	if Config.EnableCustomPeds then
		for k,v in ipairs(Config.CustomPeds.shared) do
			table.insert(elements, {label = v.label, value = 'freemode_ped', maleModel = v.maleModel, femaleModel = v.femaleModel})
		end

		for k,v in ipairs(Config.CustomPeds[grade]) do
			table.insert(elements, {label = v.label, value = 'freemode_ped', maleModel = v.maleModel, femaleModel = v.femaleModel})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
		title    = _U('cloakroom'),
		align    = 'right',
		elements = elements
	}, function(data, menu)
		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			TriggerEvent('hl-armour:stopSyncing', 6000)
			exports['progressBar']:drawBar(5000, 'Nusirengiate darbinę uniformą')
			ESX.Streaming.RequestAnimDict('clothingtie', function()
				local playerPed = PlayerPedId()
				TaskPlayAnim(playerPed, 'clothingtie', 'try_tie_negative_a', 4.0, 2.0, 5000, 48, 0.0, false, false, false)
			end)
			Citizen.Wait(5000)
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
			Citizen.Wait(5000)
		end

		if data.current.uniform then
			TriggerEvent('hl-armour:stopSyncing', 6000)
			exports['progressBar']:drawBar(5000, 'Rengiates darbinę uniformą')
			ESX.Streaming.RequestAnimDict('clothingtie', function()
				local playerPed = PlayerPedId()
				TaskPlayAnim(playerPed, 'clothingtie', 'try_tie_negative_a', 4.0, 2.0, 5000, 48, 0.0, false, false, false)
			end)
			Citizen.Wait(5000)
			setUniform(data.current.uniform, playerPed)
			Citizen.Wait(5000)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	end)
end

function OpenGaujaActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gauja_actions', {
		title    = 'Gaujos meniu',
		align    = 'right',
		elements = {
			{label = _U('search'), value = 'search'},
			{label = _U('handcuff'), value = 'handcuff'},
			{label = _U('uncuff'), value = 'uncuff'},
			{label = _U('drag'), value = 'drag'},
			{label = _U('put_in_vehicle'), value = 'put_in_vehicle'},
			{label = _U('out_the_vehicle'), value = 'out_the_vehicle'}
	}}, function(data, menu)
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		if closestPlayer ~= -1 and closestDistance <= 3.0 then
			local action = data.current.value

			if action == 'search' then
				TriggerServerEvent('3drp:shareDisplay', '~r~*~s~ Apieško asmeni ~r~*~s~', 'me')
				ESX.TriggerServerCallback('inventory:getSecret', function(serverSecret)
					TriggerEvent('inventory:openPlayerInventory', GetPlayerServerId(closestPlayer))
				end)
			elseif action == 'handcuff' then
				local playerPed = PlayerPedId()
				local target, distance = ESX.Game.GetClosestPlayer()
				playerheading = GetEntityHeading(playerPed)
				playerlocation = GetEntityForwardVector(playerPed)
				playerCoords = GetEntityCoords(playerPed)
				local target_id = GetPlayerServerId(target)
				TriggerServerEvent('3drp:shareDisplay', '~r~*~s~ Suriša asmeniui rankas ~r~*~s~', 'me')
				TriggerServerEvent('esx_gauja:requestarrest', target_id, playerheading, playerCoords, playerlocation)
				Citizen.Wait(1000)
			elseif action == 'uncuff' then
				local playerPed = PlayerPedId()
				local target, distance = ESX.Game.GetClosestPlayer()
				playerheading = GetEntityHeading(playerPed)
				playerlocation = GetEntityForwardVector(playerPed)
				playerCoords = GetEntityCoords(playerPed)
				local target_id = GetPlayerServerId(target)
				TriggerServerEvent('3drp:shareDisplay', '~r~*~s~ Atriša asmeniui rankas ~r~*~s~', 'me')
				TriggerServerEvent('esx_gauja:requestrelease', target_id, playerheading, playerCoords, playerlocation)
				Citizen.Wait(1000)
			elseif action == 'drag' then
				TriggerServerEvent('3drp:shareDisplay', '~r~*~s~ Paiima/paleidžia vedamą pilieti ~r~*~s~', 'me')
				TriggerServerEvent('esx_gauja:drag', GetPlayerServerId(closestPlayer))
				Citizen.Wait(1000)
			elseif action == 'put_in_vehicle' then
				TriggerServerEvent('esx_gauja:putInVehicle', GetPlayerServerId(closestPlayer))
				TriggerServerEvent('3drp:shareDisplay', '~r~*~s~ Isodina asmeni i tr. priemone ~r~*~s~', 'me')
				Citizen.Wait(1000)
			elseif action == 'out_the_vehicle' then
				TriggerServerEvent('esx_gauja:OutVehicle', GetPlayerServerId(closestPlayer))
				TriggerServerEvent('3drp:shareDisplay', '~r~*~s~ Išlaipina asmeni iš tr. priemones ~r~*~s~', 'me')
			end
		else
			ESX.ShowNotification(_U('no_players_nearby'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	Citizen.Wait(5000)
	TriggerServerEvent('esx_gauja:forceBlip')
end)

AddEventHandler('esx_gauja:hasEnteredMarker', function(station, part, partNum)
	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = _U('open_cloackroom')
		CurrentActionData = {}
	elseif part == 'Armory' then
		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = _U('open_armory')
		CurrentActionData = {station = station}
	elseif part == 'Vehicles' then
		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('garage_prompt')
		CurrentActionData = {station = station, part = part, partNum = partNum}
	elseif part == 'BossActions' then
		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = _U('open_bossmenu')
		CurrentActionData = {}
	end
end)

AddEventHandler('esx_gauja:hasExitedMarker', function(station, part, partNum)
	if not isInShopMenu then
		ESX.UI.Menu.CloseAll()
	end

	CurrentAction = nil
end)

RegisterNetEvent('esx_gauja:handcuff')
AddEventHandler('esx_gauja:handcuff', function()
	local playerPed = PlayerPedId()

	if isHandcuffed then
		if Config.EnableHandcuffTimer then
			if handcuffTimer.active then
				ESX.ClearTimeout(handcuffTimer.task)
			end

			exports['progressBar']:drawBar(Config.HandcuffTimer, 'Virvė')
			StartHandcuffTimer()
		end
	else
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			exports['progressBar']:closeBar()
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

RegisterNetEvent('esx_gauja:unrestrain')
AddEventHandler('esx_gauja:unrestrain', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		isHandcuffed = false

		ClearPedSecondaryTask(playerPed)
		SetEnableHandcuffs(playerPed, false)
		DisablePlayerFiring(playerPed, false)
		SetPedCanPlayGestureAnims(playerPed, true)
		FreezeEntityPosition(playerPed, false)
		DisplayRadar(true)

		-- end timer
		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

RegisterNetEvent('esx_gauja:drag')
AddEventHandler('esx_gauja:drag', function(copId)
	if isHandcuffed then
		dragStatus.isDragged = not dragStatus.isDragged
		dragStatus.CopId = copId
	end
end)

Citizen.CreateThread(function()
	local wasDragged

	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if isHandcuffed and dragStatus.isDragged then
			local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.CopId))

			if DoesEntityExist(targetPed) and IsPedOnFoot(targetPed) and not IsPedDeadOrDying(targetPed, true) then
				if not wasDragged then
					AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
					wasDragged = true
				else
					Citizen.Wait(1000)
				end
			else
				wasDragged = false
				dragStatus.isDragged = false
				DetachEntity(playerPed, true, false)
			end
		elseif wasDragged then
			wasDragged = false
			DetachEntity(playerPed, true, false)
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('esx_gauja:putInVehicle')
AddEventHandler('esx_gauja:putInVehicle', function()
	if isHandcuffed then
		local playerPed = PlayerPedId()
		local vehicle, distance = ESX.Game.GetClosestVehicle()

		if vehicle and distance < 5 then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i= maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				dragStatus.isDragged = false
			end
		end
	end
end)

RegisterNetEvent('esx_gauja:OutVehicle')
AddEventHandler('esx_gauja:OutVehicle', function()
	local playerPed = PlayerPedId()

	if IsPedSittingInAnyVehicle(playerPed) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		TaskLeaveVehicle(playerPed, vehicle, 64)
	end
end)

RegisterNetEvent('esx_gauja:getarrested')
AddEventHandler('esx_gauja:getarrested', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	ArrestAnim = true
	FreezeEntityPosition(playerPed, true)
	SetEntityCoords(playerPed, x, y, z-1.0)
	SetEntityHeading(playerPed, playerheading)
	Citizen.Wait(250)
	ESX.Streaming.RequestAnimDict('mp_arresting', function()
		TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	end)
	Citizen.Wait(4500)
	isHandcuffed = true
	ClearPedTasks(playerPed)
	TriggerEvent('esx_gauja:handcuff')
	FreezeEntityPosition(playerPed, false)
	ArrestAnim = false
end)

RegisterNetEvent('esx_gauja:doarrested')
AddEventHandler('esx_gauja:doarrested', function()
	local playerPed = PlayerPedId()
	Citizen.Wait(250)
	ESX.Streaming.RequestAnimDict('mp_arresting', function()
		TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	end)
	Citizen.Wait(5500)
	ClearPedTasks(playerPed)
end) 

RegisterNetEvent('esx_gauja:douncuffing')
AddEventHandler('esx_gauja:douncuffing', function()
	local playerPed = PlayerPedId()
	Citizen.Wait(250)
	ESX.Streaming.RequestAnimDict('mp_arresting', function()
		TaskPlayAnim(playerPed, 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	end)
	Citizen.Wait(5500)
	ClearPedTasks(playerPed)
end)

RegisterNetEvent('esx_gauja:getuncuffed')
AddEventHandler('esx_gauja:getuncuffed', function(playerheading, playercoords, playerlocation)
	local playerPed = PlayerPedId()
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	ArrestAnim = true
	FreezeEntityPosition(playerPed, true)
	SetEntityCoords(playerPed, x, y, z-1.0)
	SetEntityHeading(playerPed, playerheading)
	Citizen.Wait(250)
	ESX.Streaming.RequestAnimDict('mp_arresting', function()
		TaskPlayAnim(playerPed, 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	end)
	Citizen.Wait(5500)
	isHandcuffed = false
	TriggerEvent('esx_gauja:handcuff')
	ClearPedTasks(playerPed)
	FreezeEntityPosition(playerPed, false)
	ArrestAnim = false
end)

-- Handcuff
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if ArrestAnim then
			DisableAllControlActions(0)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
		end

		if isHandcuffed then
			--DisableControlAction(0, 1, true) -- Disable pan
			--DisableControlAction(0, 2, true) -- Disable tilt
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 257, true) -- Attack 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Attack 1
			--DisableControlAction(0, 32, true) -- W
			--DisableControlAction(0, 34, true) -- A
			--DisableControlAction(0, 31, true) -- S
			--DisableControlAction(0, 30, true) -- D

			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
			DisableControlAction(0, 303, true) -- Disable radgoll
			DisableControlAction(0, 21, true) -- Disable sprinting

			DisableControlAction(0, 0, true) -- Disable changing view
			DisableControlAction(0, 26, true) -- Disable looking behind
			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'mp_arresting', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('mp_arresting', function()
					TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		end
	end
end)

-- Draw markers and more
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gauja' then
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local isInMarker, hasExited, letSleep = false, false, true
			local currentStation, currentPart, currentPartNum

			for k,v in pairs(Config.GaujaStations) do
				for i=1, #v.Cloakrooms, 1 do
					local distance = #(playerCoords - v.Cloakrooms[i])

					if distance < Config.DrawDistance then
						DrawMarker(Config.CloakroomsMarker.Type, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CloakroomsMarker.Size.x, Config.CloakroomsMarker.Size.y, Config.CloakroomsMarker.Size.z, Config.CloakroomsMarker.Color.r, Config.CloakroomsMarker.Color.g, Config.CloakroomsMarker.Color.b, 100, false, true, 2, false, false, false, false)
						DrawMarker(Config.CloakroomsMarker.Type2, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CloakroomsMarker.Size2.x, Config.CloakroomsMarker.Size2.y, Config.CloakroomsMarker.Size2.z, Config.CloakroomsMarker.Color2.r, Config.CloakroomsMarker.Color2.g, Config.CloakroomsMarker.Color2.b, 100, false, true, 2, false, false, false, false)
						letSleep = false

						if distance < Config.CloakroomsMarker.Size.x * 1.5 then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
						end
					end
				end

				for i=1, #v.Armories, 1 do
					local distance = #(playerCoords - v.Armories[i])

					if distance < Config.DrawDistance then
						DrawMarker(Config.ArmoriesMarker.Type, v.Armories[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ArmoriesMarker.Size.x, Config.ArmoriesMarker.Size.y, Config.ArmoriesMarker.Size.z, Config.ArmoriesMarker.Color.r, Config.ArmoriesMarker.Color.g, Config.ArmoriesMarker.Color.b, 100, false, true, 2, false, false, false, false)
						DrawMarker(Config.ArmoriesMarker.Type2, v.Armories[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ArmoriesMarker.Size2.x, Config.ArmoriesMarker.Size2.y, Config.ArmoriesMarker.Size2.z, Config.ArmoriesMarker.Color2.r, Config.ArmoriesMarker.Color2.g, Config.ArmoriesMarker.Color2.b, 100, false, true, 2, false, false, false, false)
						letSleep = false

						if distance < Config.ArmoriesMarker.Size.x * 1.5 then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Armory', i
						end
					end
				end

				for i=1, #v.Vehicles, 1 do
					local distance = #(playerCoords - v.Vehicles[i].Spawner)

					if distance < Config.DrawDistance then
						DrawMarker(Config.VehiclesMarker.Type, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.VehiclesMarker.Size.x, Config.VehiclesMarker.Size.y, Config.VehiclesMarker.Size.z, Config.VehiclesMarker.Color.r, Config.VehiclesMarker.Color.g, Config.VehiclesMarker.Color.b, 100, false, true, 2, false, false, false, false)
						DrawMarker(Config.VehiclesMarker.Type2, v.Vehicles[i].Spawner, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.VehiclesMarker.Size2.x, Config.VehiclesMarker.Size2.y, Config.VehiclesMarker.Size2.z, Config.VehiclesMarker.Color2.r, Config.VehiclesMarker.Color2.g, Config.VehiclesMarker.Color2.b, 100, false, true, 2, false, false, false, false)
						letSleep = false

						if distance < Config.VehiclesMarker.Size.x * 1.5 then
							isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Vehicles', i
						end
					end
				end

				if Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'boss' or  Config.EnablePlayerManagement and ESX.PlayerData.job.grade_name == 'pavaduotojas' then
					for i=1, #v.BossActions, 1 do
						local distance = #(playerCoords - v.BossActions[i])

						if distance < Config.DrawDistance then
							DrawMarker(Config.BossActionsMarker.Type, v.BossActions[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.BossActionsMarker.Size.x, Config.BossActionsMarker.Size.y, Config.BossActionsMarker.Size.z, Config.BossActionsMarker.Color.r, Config.BossActionsMarker.Color.g, Config.BossActionsMarker.Color.b, 100, false, true, 2, false, false, false, false)
							DrawMarker(Config.BossActionsMarker.Type2, v.BossActions[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.BossActionsMarker.Size2.x, Config.BossActionsMarker.Size2.y, Config.BossActionsMarker.Size2.z, Config.BossActionsMarker.Color2.r, Config.BossActionsMarker.Color2.g, Config.BossActionsMarker.Color2.b, 100, false, true, 2, false, false, false, false)
							letSleep = false

							if distance < Config.BossActionsMarker.Size.x * 1.5 then
								isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
							end
						end
					end
				end
			end

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_gauja:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_gauja:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_gauja:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

			if letSleep then
				Citizen.Wait(1000)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)
RegisterNetEvent('gl-ambulance:revivePlayer')
AddEventHandler('gl-ambulance:revivePlayer', function(bool)
	isDead = false
end)


-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)
			
			if IsControlJustReleased(0, 38) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'gauja' then

				if CurrentAction == 'menu_cloakroom' then
					OpenCloakroomMenu()
				elseif CurrentAction == 'menu_armory' then
					TriggerEvent('esx_inventoryhud:openStorageInventory', 'society_gauja', securityToken, 'esx_gauja')
				elseif CurrentAction == 'menu_vehicle_spawner' then
					if not Config.EnableESXService then
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					elseif playerInService then
						OpenVehicleSpawnerMenu('car', CurrentActionData.station, CurrentActionData.part, CurrentActionData.partNum)
					else
						ESX.ShowNotification(_U('service_not'))
					end
				elseif CurrentAction == 'delete_vehicle' then
					ESX.Game.DeleteVehicle(CurrentActionData.vehicle)
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', 'gauja', function(data, menu)
						menu.close()

						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = _U('open_bossmenu')
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end

				CurrentAction = nil
			end
		end



		if IsControlJustReleased(0, 167) and not isDead and ESX.PlayerData.job and ESX.PlayerData.job.name == 'gauja' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'gauja_actions') then
			if not Config.EnableESXService then
				OpenGaujaActionsMenu()
			elseif playerInService then
				OpenGaujaActionsMenu()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		end

		if IsControlJustReleased(0, 38) and currentTask.busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(currentTask.task)
			ClearPedTasks(PlayerPedId())

			currentTask.busy = false
		end
	end
end)

-- Create blip for colleagues
function createBlip(id)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)

	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		SetBlipNameToPlayerName(blip, id) -- update blip name
		SetBlipScale(blip, 0.6) -- set scale
		SetBlipAsShortRange(blip, true)

		table.insert(blipsCops, blip) -- add blip to array so we can remove it later
	end
end

RegisterNetEvent('esx_gauja:updateBlip')
AddEventHandler('esx_gauja:updateBlip', function()
	-- Refresh all blips
	for k, existingBlip in pairs(blipsCops) do
		RemoveBlip(existingBlip)
	end

	-- Clean the blip table
	blipsCops = {}

	-- Enable blip?
	if Config.EnableESXService and not playerInService then
		return
	end

	if not Config.EnableJobBlip then
		return
	end

	-- Is the player a cop? In that case show all the blips for other cops
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gauja' then
		ESX.TriggerServerCallback('esx_society:getOnlinePlayers', function(players)
			for i=1, #players, 1 do
				if players[i].job.name == 'gauja' then
					local id = GetPlayerFromServerId(players[i].source)
					if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
						createBlip(id)
					end
				end
			end
		end)
	end

end)

AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	TriggerEvent('esx_gauja:unrestrain')

	if not hasAlreadyJoined then
		TriggerServerEvent('esx_gauja:spawned')
	end
	hasAlreadyJoined = true
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_gauja:unrestrain')
		TriggerEvent('esx_phone:removeSpecialContact', 'gauja')

		if Config.EnableESXService then
			TriggerServerEvent('esx_service:disableService', 'gauja')
		end

		if Config.EnableHandcuffTimer and handcuffTimer.active then
			ESX.ClearTimeout(handcuffTimer.task)
		end
	end
end)

function StartHandcuffTimer()
	if Config.EnableHandcuffTimer and handcuffTimer.active then
		ESX.ClearTimeout(handcuffTimer.task)
	end

	handcuffTimer.active = true
	handcuffTimer.task = ESX.SetTimeout(Config.HandcuffTimer, function()
		ESX.ShowNotification(_U('unrestrained_timer'))
		TriggerEvent('esx_gauja:unrestrain')
		handcuffTimer.active = false
	end)
end