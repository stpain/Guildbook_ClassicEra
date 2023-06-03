local name, addon = ...;

local Talents = addon.Talents;
local Tradeskills = addon.Tradeskills;
local Character = addon.Character;

GuildbookProfileMixin = {
    name = "Profile",
}

function GuildbookProfileMixin:OnLoad()
    
    addon.AddView(self)

    addon:RegisterCallback("Character_OnProfileSelected", self.LoadCharacter, self)
    addon:RegisterCallback("Character_OnDataChanged", self.Update, self)

    self.sidePane.prof1.icon:SetWidth(self.sidePane.prof1:GetHeight())
    self.sidePane.prof2.icon:SetWidth(self.sidePane.prof2:GetHeight())
    self.sidePane.fishing.icon:SetWidth(self.sidePane.fishing:GetHeight())
    self.sidePane.cooking.icon:SetWidth(self.sidePane.cooking:GetHeight())
    self.sidePane.firstAid.icon:SetWidth(self.sidePane.firstAid:GetHeight())


    self.contentPane.scrollChild:SetSize(650, 480)

end

function GuildbookProfileMixin:Character_OnDataChanged(character)
    if self.character and (self.character.data.guid == character.data.guid) then
        self:Update()
    end
end

function GuildbookProfileMixin:LoadCharacter(character)
    self.character = character;
    self.sidePane.background:SetAtlas(string.format("transmog-background-race-%s", self.character:GetRace().clientFileString:lower()))
    self.sidePane.prof1:SetScript("OnMouseDown", function()
        addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession1, self.character.data.profession1Recipes)
    end)
    self.sidePane.prof2:SetScript("OnMouseDown", function()
        addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession2, self.character.data.profession2Recipes)
    end)
    self.sidePane.cooking:SetScript("OnMouseDown", function()
        addon:TriggerEvent("Character_OnTradeskillSelected", 185, self.character.data.cookingRecipes)
    end)
    self.sidePane.firstAid:SetScript("OnMouseDown", function()
        addon:TriggerEvent("Character_OnTradeskillSelected", 129, self.character.data.firstAidRecipes)
    end)
    self:Update()
    GuildbookUI:SelectView(self.name)
end

function GuildbookProfileMixin:Update()

    if not self.character then
        return
    end

    self.sidePane.name:SetText(self.character.data.name)
    self.sidePane.mainSpec:SetText(self.character.data.mainSpec)

    if type(self.character.data.profession1) == "number" then
        self.sidePane.prof1.icon:SetAtlas(Tradeskills:TradeskillIDToAtlas(self.character.data.profession1))
        self.sidePane.prof1.label:SetText(string.format("%s [%d]", 
            Tradeskills:GetLocaleNameFromID(self.character.data.profession1), 
            self.character.data.profession1Level
        ))
    end

    if type(self.character.data.profession2) == "number" then
        self.sidePane.prof2.icon:SetAtlas(Tradeskills:TradeskillIDToAtlas(self.character.data.profession2))
        self.sidePane.prof2.label:SetText(string.format("%s [%d]", 
            Tradeskills:GetLocaleNameFromID(self.character.data.profession2), 
            self.character.data.profession2Level
        ))
    end

    self.sidePane.cooking.icon:SetAtlas(Tradeskills:TradeskillIDToAtlas(185))
    self.sidePane.cooking.label:SetText(string.format("%s [%d]", 
        Tradeskills:GetLocaleNameFromID(185), 
        self.character.data.cookingLevel
    ))

    self.sidePane.fishing.icon:SetAtlas(Tradeskills:TradeskillIDToAtlas(356))
    self.sidePane.fishing.label:SetText(string.format("%s [%d]", 
        Tradeskills:GetLocaleNameFromID(356), 
        self.character.data.fishingLevel
    ))

    self.sidePane.firstAid.icon:SetAtlas(Tradeskills:TradeskillIDToAtlas(129))
    self.sidePane.firstAid.label:SetText(string.format("%s [%d]", 
        Tradeskills:GetLocaleNameFromID(129), 
        self.character.data.firstAidLevel
    ))


end