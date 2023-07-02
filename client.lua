--// Add items to your database like cocaine, cocaine_packaged, weed, weed_packaged, meth, meth_packaged

local canCancel = false
local libCache = lib.onCache
local cachePed = cache.ped
local ox_inventory, ox_target = exports.ox_inventory, exports.ox_target

libCache('ped', function(ped)
    cachePed = ped
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setHiddenJob')
AddEventHandler('esx:setHiddenJob', function(hiddenjob)
	ESX.PlayerData.hiddenjob = hiddenjob
end)

local function CollectNaroctic(naroctic)
	if cache.vehicle then
		ESX.ShowNotification('You cant do that now!')
		canCancel = false
		return
	end

	if canCancel == false then
		canCancel = true
		Citizen.CreateThread(function()
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(cachePed, true)
			repeat
				local count = ox_inventory:Search('count', naroctic)

				if count >= 150 then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('You already have enough of the drug!')
					break
				end

				if cache.vehicle then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('You cant do that now!')
					return
				end

				if ox_inventory:GetPlayerWeight() >= 30000 then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('Have a full inventory!')
					return
				end

				if lib.progressCircle({
					duration = 30000,
					position = 'bottom',
					useWhileDead = false,
					canCancel = true,
					disable = {
						car = true,
						move = true,
						combat = true,
						mouse = false,
					},
					anim = {
						dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
						clip = 'machinic_loop_mechandplayer'
					},
					prop = {},
				}) 
				then
					if canCancel then
						TriggerServerEvent(GetCurrentResourceName() .. ':onCollectingDrugs', naroctic)
					end
				else 
					ESX.ShowNotification('Anulowano zbieranie.')
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
				end
				Citizen.Wait(1000)
			until (canCancel == false)
		end)
	end
end

local function ProcessNaroctic(naroctic, naroctic2)
	if cache.vehicle then
		ESX.ShowNotification('You cant do that now!')
		canCancel = false
		return
	end

	if canCancel == false then
		canCancel = true
		Citizen.CreateThread(function()
			ESX.UI.Menu.CloseAll()
			FreezeEntityPosition(cachePed, true)
			repeat
				local count = ox_inventory:Search('count', naroctic2..'_packaged')
				local countStart = ox_inventory:Search('count', naroctic)

				if countStart < 5 then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('You dont have enough drug to process!')
					break
				end

				if count >= 30 then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('You already have enough of the drug!')
					break
				end

				if cache.vehicle then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('You cant do that now!')
					return
				end

				if ox_inventory:GetPlayerWeight() >= 30000 then
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
					ESX.ShowNotification('Have a full inventory!')
					return
				end

				if lib.progressCircle({
					duration = 30000,
					position = 'bottom',
					useWhileDead = false,
					canCancel = true,
					disable = {
						car = true,
						move = true,
						combat = true,
						mouse = false,
					},
					anim = {
						dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
						clip = 'machinic_loop_mechandplayer'
					},
					prop = {},
				}) 
				then
					if canCancel then
						TriggerServerEvent(GetCurrentResourceName() .. ':onProcessDrugs', naroctic, naroctic2)
					end
				else 
					ESX.ShowNotification('Recasting cancelled.')
					canCancel = false
					TriggerServerEvent(GetCurrentResourceName() .. ':onStopDrugs')
					FreezeEntityPosition(cachePed, false)
				end
				Citizen.Wait(1000)
			until (canCancel == false)
		end)
	end
end

Citizen.CreateThread(function ()
	ox_target:addBoxZone({
		name = "collect_meth",
		coords = vec3(-2000.0, 2567.0, 3.0),
		size = vec3(6.0, 5.0, 5.0),
		rotation = 0.0,
		options = {
			{
				name = 'collect_meth',
				event = GetCurrentResourceName() .. ':collect_meth',
				icon = 'fas fa-box-open',
				label = 'Zbierz metamfetamine',
				onSelect = function ()
					if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' then
						ESX.ShowNotification('You cant do it!')
						return
					end
	
					CollectNaroctic('meth')
				end
			},
		},
	})

	ox_target:addBoxZone({
		name = "transfer_meth",
		coords = vec3(-435, 6341, 14.0),
		size = vec3(3.0, 4.0, 4),
		rotation = 35.0,
		options = {
			{
				name = 'transfer_meth',
				event = GetCurrentResourceName() .. ':transfer_meth',
				icon = 'fas fa-box-open',
				label = 'Przerób metamfetamine',
				onSelect = function ()
					if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' then
						ESX.ShowNotification('You cant do it!')
						return
					end
	
					local count = ox_inventory:Search('count', 'meth')
	
					if count >= 5 then
						ProcessNaroctic('meth', 'meth')
					else
						ESX.ShowNotification('There is not enough drug')
						return
					end
				end
			},
		},
	})

	ox_target:addBoxZone({
		name = "collect_cocaine",
		coords = vec3(2832, -746, 17.0),
		size = vec3(6.0, 6.0, 6.0),
		rotation = 0.0,
		options = {
			{
				name = 'collect_cocaine',
				event = GetCurrentResourceName() .. ':collect_cocaine',
				icon = 'fas fa-box-open',
				label = 'Zbierz kokaine',
				onSelect = function ()
					if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' then
						ESX.ShowNotification('You cant do it!')
						return
					end
	
					CollectNaroctic('cocaine')
				end
			},
		},
	})

	ox_target:addBoxZone({
		name = "transfer_cocaine",
		coords = vec3(2311, 4855, 42.0),
		size = vec3(4.0, 5.0, 5.0),
		rotation = 45.0,
		options = {
			{
				name = 'transfer_cocaine',
				event = GetCurrentResourceName() .. ':transfer_cocaine',
				icon = 'fas fa-box-open',
				label = 'Przerób kokaine',
				onSelect = function ()
					if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offpolice' or ESX.PlayerData.job.name == 'offambulance' then
						ESX.ShowNotification('You cant do it!')
						return
					end
	
					local count = ox_inventory:Search('count', 'cocaine')
	
					if count >= 5 then
						ProcessNaroctic('cocaine', 'cocaine')
					else
						ESX.ShowNotification('There is not enough drug')
						return
					end
				end
			},
		},
	})

	ox_target:addBoxZone({
		name = "collect_weed",
		coords = vec3(-1102.0, -1890.0, 8.0),
		size = vec3(7, 6.0, 5.0),
		rotation = 40.0,
		options = {
			{
				name = 'collect_weed',
				event = GetCurrentResourceName() .. ':collect_weed',
				icon = 'fas fa-box-open',
				label = 'Zbierz marihuane',
				onSelect = function ()
					if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offpolice' or ESX.PlayerData.job.name == 'offambulance' then
						ESX.ShowNotification('You cant do it!')
						return
					end
	
					CollectNaroctic('weed')
				end
			},
		},
	})

	ox_target:addBoxZone({
		name = "transfer_weed",
		coords = vec3(1060.0, -2443.0, 23.0),
		size = vec3(9.0, 8.0, 6.0),
		rotation = 0.0,
		options = {
			{
				name = 'transfer_weed',
				event = GetCurrentResourceName() .. ':transfer_weed',
				icon = 'fas fa-box-open',
				label = 'Przerób marihuane',
				onSelect = function ()
					if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' or ESX.PlayerData.job.name == 'offpolice' or ESX.PlayerData.job.name == 'offambulance' then
						ESX.ShowNotification('You cant do it!')
						return
					end
	
					local count = ox_inventory:Search('count', 'weed')
	
					if count >= 5 then
						ProcessNaroctic('weed', 'weed')
					else
						ESX.ShowNotification('There is not enough drug')
						return
					end
				end
			},
		},
	})
end)