local name, addon = ...;

GuildbookGuildBankMixin = {
    name = "GuildBank",
}

function GuildbookGuildBankMixin:OnLoad()

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
                        self:LoadCharacterContainers(character.data.containers)
                    end,
                })
            end
        end        
    end

end

function GuildbookGuildBankMixin:LoadCharacterContainers(containers)
    
end