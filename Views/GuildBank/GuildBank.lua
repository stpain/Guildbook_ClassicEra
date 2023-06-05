local name, addon = ...;

GuildbookGuildBankMixin = {
    name = "GuildBank",
    selectedCharacter = "",
}

function GuildbookGuildBankMixin:OnLoad()

    addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)

    addon.AddView(self)
end

function GuildbookGuildBankMixin:OnShow()

    self.charactersListview.DataProvider:Flush()

    if addon.characters then
        for k, character in pairs(addon.characters) do
            if character.data.publicNote:lower() == "guildbank" then
                self.charactersListview.DataProvider:Insert({
                    label = character:GetName(),
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