local name, addon = ...;

GuildbookGuildBankMixin = {
    name = "GuildBank",
    selectedCharacter = "",
    banks = {},
}

function GuildbookGuildBankMixin:OnLoad()

    addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)
    addon:RegisterCallback("Guildbank_OnTimestampsReceived", self.Guildbank_OnTimestampsReceived, self)

    addon.AddView(self)
end

function GuildbookGuildBankMixin:OnShow()

    self.charactersListview.DataProvider:Flush()

    if addon.characters then
        local i = 0;
        for k, character in pairs(addon.characters) do
            if character.data.publicNote:lower() == "guildbank" then

                i = i + 1;
                C_Timer.After(i * 0.5, function()
                    addon:TriggerEvent("Guildbank_TimeStampRequest", character.data.name)
                end)

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
    end

end

function GuildbookGuildBankMixin:Guildbank_OnTimestampsReceived(sender, data)

    if not self.banks[data.payload.bank] then
        self.banks[data.payload.bank] = {}
    end
    table.insert(self.banks[data.payload.bank], {
        timestamp = data.payload.timestamp,
        sender = sender,
    })

    --table.sort()
    -- for character, timestamp in pairs(data) do
    --     if not self.banks[character] then
    --         self.banks[character] = {};
    --     end
    --     table.insert(self.banks[character], {
    --         sender = sender,
    --         timestamp = timestamp,
    --     })
    -- end
    -- for character, info in pairs(self.banks) do
    --     table.sort(info, function(a, b)
    --         return a.timestamp > b.timestamp;
    --     end)
    -- end
    -- for character, info in pairs(self.banks) do
    --     local latestBankData = info[1];
    --     addon:TriggerEvent("Guildbank_DataRequest", latestBankData.sender, character)
    -- end

end

function GuildbookGuildBankMixin:Character_OnDataChanged(character)
    if self.selectedCharacter == character.data.name then
        self:LoadCharacterContainers(self.selectedCharacter, character.data.containers)
    end
end

function GuildbookGuildBankMixin:LoadCharacterContainers(name, containers)

    -- local containers = {
    --     bags = {},
    --     slotsUsed = 0,
    --     slotsFree = 0,
    --     copper = GetMoney(),
    -- }

    --DevTools_Dump(containers)

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