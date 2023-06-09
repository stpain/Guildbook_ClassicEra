local name, addon = ...;

local Tradeskills = addon.Tradeskills;
local Character = addon.Character;

GuildbookTradskillsMixin = {
    name = "Tradeskills",
}

function GuildbookTradskillsMixin:OnLoad()

    local tradeskills = {
        171,
        164,
        333,
        202,
        --773,
        --755,
        165,
        197,
        186,
        --182,
        --393,
        185,
        129,
        --356,
    }
    for k, id in ipairs(tradeskills) do
        local name = Tradeskills:GetLocaleNameFromID(id)
        local atlas = Tradeskills:TradeskillIDToAtlas(id)

        self.tradeskillsListview.DataProvider:Insert({
            atlas = atlas,
            label = name,
            func = function()
                self:LoadtradeskillRecipes(id)
                self.charactersListview.DataProvider:Flush()
            end,
        })
    end

    self.spellIdToTradeskillItemIndex = {}
    for k, v in ipairs(addon.itemData) do
        self.spellIdToTradeskillItemIndex[v.spellID] = k;
    end

    addon:RegisterCallback("Character_OnTradeskillSelected", self.OnCharacterTradeskillSelected, self)

    addon.AddView(self)

end

function GuildbookTradskillsMixin:LoadtradeskillRecipes(tradeskillID)

    self.recipesListview.DataProvider:Flush()
    self.charactersListview.DataProvider:Flush()

    local items = {}

    for k, v in ipairs(addon.itemData) do
        if v.professionID == tradeskillID then

            if tradeskillID == 333 then
                
                local name = GetSpellInfo(v.spellID)
                --local desc = GetSpellDescription(v.spellID)
                table.insert(items, {
                    itemName = name,
                    itemLink = v.itemLink,
                    spellID = v.spellID,
                    icon = v.icon,
                    itemID = v.itemID,
                    reagents = v.reagents,
                    inventorySlot = v.inventorySlot,
                    quality = v.quality,
                    professionID = v.professionID,

                    func = function()
                        self:LoadCharactersWithRecipe(v)
                    end
                })
            else
                table.insert(items, {
                    itemName = string.match(v.itemLink, "h%[(.*)%]|h"),
                    itemLink = v.itemLink,
                    spellID = v.spellID,
                    icon = v.icon,
                    itemID = v.itemID,
                    reagents = v.reagents,
                    inventorySlot = v.inventorySlot,
                    quality = v.quality,
                    professionID = v.professionID,

                    func = function()
                        self:LoadCharactersWithRecipe(v)
                    end
                })
            end
        end
    end

    table.sort(items, function(a, b)
        if a.quality == b.quality then
            return a.itemName < b.itemName;
        else
            return a.quality > b.quality;
        end
    end)
    self.recipesListview.DataProvider:InsertTable(items)
end

function GuildbookTradskillsMixin:LoadCharactersWithRecipe(item)

    self.charactersListview.DataProvider:Flush()
    
    for k, character in pairs(addon.characters) do
        -- DevTools_Dump({character:GetTradeskillRecipes(1)})
        -- DevTools_Dump({character:GetTradeskillRecipes(2)})
        if character:CanCraftItem(item) then
            self.charactersListview.DataProvider:Insert({
                label = character.data.name,
                atlas = character:GetProfileAvatar(),
                showMask = true,

                func = function()
                    addon:TriggerEvent("Character_OnProfileSelected", character)
                end,
            })
        end
    end
end

function GuildbookTradskillsMixin:OnCharacterTradeskillSelected(tradeskillID, recipes)
    self.recipesListview.DataProvider:Flush()
    self.charactersListview.DataProvider:Flush()
    if type(tradeskillID) == "number" and type(recipes) == "table" then
        local items = {}
        for k, spellId in ipairs(recipes) do
            local item = addon.itemData[self.spellIdToTradeskillItemIndex[spellId]];
            if tradeskillID == 333 then
                local name = GetSpellInfo(spellId)
                --local desc = GetSpellDescription(v.spellID)
                table.insert(items, {
                    itemName = name,
                    itemLink = item.itemLink,
                    spellID = item.spellID,
                    icon = item.icon,
                    itemID = item.itemID,
                    reagents = item.reagents,
                    inventorySlot = item.inventorySlot,
                    quality = item.quality,
                    professionID = item.professionID,
                })
            else
                table.insert(items, {
                    itemName = string.match(item.itemLink, "h%[(.*)%]|h"),
                    itemLink = item.itemLink,
                    spellID = item.spellID,
                    icon = item.icon,
                    itemID = item.itemID,
                    reagents = item.reagents,
                    inventorySlot = item.inventorySlot,
                    quality = item.quality,
                    professionID = item.professionID,
                })
            end
        end
        self.recipesListview.DataProvider:InsertTable(items)
        GuildbookUI:SelectView(self.name)
    end
end