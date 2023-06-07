local name, addon = ...;

GuildbookGuildBankMixin = {
    name = "GuildBank",
    selectedCharacter = "",
    banks = {},
}

function GuildbookGuildBankMixin:OnLoad()

    addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)
    addon:RegisterCallback("Guildbank_OnTimestampsReceived", self.Guildbank_OnTimestampsReceived, self)
    addon:RegisterCallback("Guildbank_OnDataReceived", self.Guildbank_OnDataReceived, self)

    addon.AddView(self)
end

function GuildbookGuildBankMixin:OnShow()

    self.charactersListview.DataProvider:Flush()

    self.banks = {}

    if addon.characters then
        for k, character in pairs(addon.characters) do
            if character.data.publicNote:lower() == "guildbank" then

                table.insert(self.banks, {
                    characterName = character.data.name,
                    lastUpdateTime = 0,
                })

                self.charactersListview.DataProvider:Insert({
                    label = character.data.name,
                    atlas = character:GetProfileAvatar(),
                    showMask = true,
    
                    func = function()
                        self.selectedCharacter = character.data.name;
                        self:LoadCharacterContainers(character.data.name, character.data.containers)
                    end,
                })
            end
        end

        local requestDelay = 1.25
        for k, v in ipairs(self.banks) do
            C_Timer.After((k - 1) * requestDelay, function()
                addon:TriggerEvent("Guildbank_TimeStampRequest", v.characterName)
                addon:TriggerEvent("LogDebugMessage", "bank", string.format("requesting timestamps for bank [%s]", v.characterName))
                addon:TriggerEvent("Guildbank_StatusInfo", {
                    characterName = v.characterName,
                    status = "requesting timestamps"
                })
            end)
        end

        C_Timer.After((#self.banks * requestDelay) + 1, function()
            for k, v in ipairs(self.banks) do
                if v.lastUpdateTime > 0 then
                    addon:TriggerEvent("Guildbank_DataRequest", v.source, v.characterName)
                    addon:TriggerEvent("LogDebugMessage", "bank", string.format("requesting data for bank [%s]", v.characterName))
                    addon:TriggerEvent("Guildbank_StatusInfo", {
                        characterName = v.characterName,
                        status = string.format("requesting data from %s", v.source)
                    })
                end
            end
        end)


    end

end

function GuildbookGuildBankMixin:Guildbank_OnTimestampsReceived(sender, message)

    addon:TriggerEvent("LogDebugMessage", "bank", string.format("received bank timestamps from [%s]", sender))

    for k, v in ipairs(self.banks) do
        if message.payload[v.characterName] then
            addon:TriggerEvent("Guildbank_StatusInfo", {
                characterName = v.characterName,
                status = string.format("timestamp from %s", sender)
            })
            if message.payload[v.characterName] > v.lastUpdateTime then
                v.lastUpdateTime = message.payload[v.characterName]
                v.source = sender
            end
        end
    end
end

function GuildbookGuildBankMixin:Guildbank_OnDataReceived(sender, message)
    addon:TriggerEvent("LogDebugMessage", "bank", string.format("received bank data from [%s]", sender))
    addon:TriggerEvent("Guildbank_StatusInfo", {
        characterName = message.payload.bank,
        status = string.format("received data from %s", sender)
    })

    --set this to the characters for future requests
    if addon.characters[message.payload.bank] then
        addon.characters[message.payload.bank]:SetContainers(message.payload.containers)
    end


    self.guildBankInfo:SetText(string.format("%d Banks %d slots (%d used %d free) Gold: %s"))
end

function GuildbookGuildBankMixin:Character_OnDataChanged(character)
    if self.selectedCharacter == character.data.name then
        self:LoadCharacterContainers(self.selectedCharacter, character.data.containers)
    end
end

function GuildbookGuildBankMixin:LoadCharacterContainers(name, containers)

    self.containerInfo.itemsListview.DataProvider:Flush()

    if not containers.bags then
        self.containerInfo.characterInfo:SetText(string.format("No data for %s", name))
        return;
    end
    
    self.containerInfo.characterInfo:SetText(string.format("[%s] %d slots (%d used %d free) Gold: %s",
        name,
        containers.slotsUsed + containers.slotsFree,
        containers.slotsUsed,
        containers.slotsFree,
        GetCoinTextureString(containers.copper)
    ))

    self.containerInfo.itemsListview.DataProvider:InsertTable(containers.bags)
end