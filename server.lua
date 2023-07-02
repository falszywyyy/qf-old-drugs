local PlayersHarvesting		   = {}

RegisterServerEvent('esx_drugs:onStopDrugs')
AddEventHandler('esx_drugs:onStopDrugs', function()
	local src = source
	PlayersHarvesting[src] = nil
end)

RegisterServerEvent(GetCurrentResourceName() .. ':onCollectingDrugs')
AddEventHandler(GetCurrentResourceName() .. ':onCollectingDrugs', function(name)
    local src = source

    PlayersHarvesting[src] = true

    if PlayersHarvesting[src] then
        local xPlayer  = ESX.GetPlayerFromId(src)
        local item = xPlayer.getInventoryItem(name)

		if item then
			if item.limit ~= -1 and item.count >= 141 then
				xPlayer.showNotification('You can no longer collect, your inventory is full')
			else
				PlayersHarvesting[src] = nil
				xPlayer.addInventoryItem(name, 10)
			end
		else
			PlayersHarvesting[src] = nil
		end
    else
        return
    end
end)

RegisterServerEvent(GetCurrentResourceName() .. ':onProcessDrugs')
AddEventHandler(GetCurrentResourceName() .. ':onProcessDrugs', function(name, name2)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if PlayersHarvesting[src] == nil then
		PlayersHarvesting[src] = true
		local pooch = xPlayer.getInventoryItem(name2..'_packaged')
		local itemQuantity = xPlayer.getInventoryItem(name).count
		local poochQuantity = xPlayer.getInventoryItem(name2..'_packaged').count
		
		if pooch and itemQuantity and poochQuantity then
			if itemQuantity < 5 then
				xPlayer.showNotification('You dont have enough drug to process it')
				PlayersHarvesting[src] = nil
			else
				xPlayer.removeInventoryItem(name, 5)
				xPlayer.addInventoryItem(name2 .. '_packaged', 1)
				PlayersHarvesting[src] = nil
			end
		end
	end
end)