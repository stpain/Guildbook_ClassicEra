local _, addon = ...
local L = addon.Locales
local Database = addon.Database;
local Talents = addon.Talents;
local Tradeskills = addon.Tradeskills;
local Comms = addon.Comms;






--- basic button mixin
GuildbookButtonMixin = {}

function GuildbookButtonMixin:OnLoad()
    --self.anchor = AnchorUtil.CreateAnchor(self:GetPoint());

    --self.point, self.relativeTo, self.relativePoint, self.xOfs, self.yOfs = self:GetPoint()
end

function GuildbookButtonMixin:OnShow()
    --self.anchor:SetPoint(self);
    -- if self.point and self.relativeTo and self.relativePoint and self.xOfs and self.yOfs then
    --     self:SetPoint(self.point, self.relativeTo, self.relativePoint, self.xOfs, self.yOfs)
    -- end
end

function GuildbookButtonMixin:OnMouseDown()
    if self.disabled then
        return;
    end
    --self:AdjustPointsOffset(-1,-1)
end

function GuildbookButtonMixin:OnMouseUp()
    if self.disabled then
        return;
    end
    --self:AdjustPointsOffset(1,1)
    if self.func then
        --C_Timer.After(0, self.func)
        self.func(self)
    end
end

function GuildbookButtonMixin:OnEnter()
    if self.tooltipText and L[self.tooltipText] then
        GameTooltip:SetOwner(self, 'ANCHOR_TOP')
        GameTooltip:AddLine("|cffffffff"..L[self.tooltipText])
        GameTooltip:Show()
    elseif self.tooltipText and not L[self.tooltipText] then
        GameTooltip:SetOwner(self, 'ANCHOR_TOP')
        GameTooltip:AddLine(self.tooltipText)
        GameTooltip:Show()
    elseif self.link then
        GameTooltip:SetOwner(self, 'ANCHOR_TOP')
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    else
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end
end

function GuildbookButtonMixin:OnLeave()
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
end


--- basic button with an icon and text area
GuildbookListviewItemMixin = {}

function GuildbookListviewItemMixin:OnLoad()
    -- local _, size, flags = self.Text:GetFont()
    -- self.Text:SetFont([[Interface\Addons\Guildbook\Media\Fonts\Acme-Regular.ttf]], size+4, flags)
end

function GuildbookListviewItemMixin:ResetDataBinding()

end

function GuildbookListviewItemMixin:SetDataBinding(info, height)

    self:SetHeight(height)
    self.icon:SetSize(height-2, height-2)

    if info.atlas then
        self.icon:SetAtlas(info.atlas)
    elseif info.icon then
        self.icon:SetTexture(info.icon)
    end
    self.text:SetText(info.label)

    if info.showMask then
        self.mask:Show()
        -- local x, y = self.icon:GetSize()
        -- self.icon:SetSize(x + 2, y + 2)

    end

    if self.selected then
        if info.showSelected then
            self.selected:Show()
        else
            self.selected:Hide()
        end
    end

    self:SetScript("OnMouseDown", function()
        self:AdjustPointsOffset(-1,-1)
        if info.func then
            info.func()
        end
    end)
end

function GuildbookListviewItemMixin:OnMouseUp()
    self:AdjustPointsOffset(1,1)
end




GuildbookSearchListviewItemMixin = {}
function GuildbookSearchListviewItemMixin:OnLoad()

end

function GuildbookSearchListviewItemMixin:ResetDataBinding()

end

function GuildbookSearchListviewItemMixin:UpdateInfo(info)

end

function GuildbookSearchListviewItemMixin:SetDataBinding(binding)

    -- self.icon:SetAtlas(info.atlas)
    -- self.text:SetText(Ambiguate(info.label, "short"))

    -- if info.showMask then
    --     self.mask:Show()
    --     local x, y = self.icon:GetSize()
    --     self.icon:SetSize(x + 2, y + 2)
    -- end

    if binding.type == "tradeskillItem" then
        
        self.text:SetText(binding.data.itemLink)

    elseif binding.type == "character" then

        self.text:SetText(binding.data.data.name)

    elseif binding.type == "bankItem" then

        self.text:SetText(binding.data:GetItemLink())

    elseif binding.type == "inventory" then

        self.text:SetText(binding.data:GetItemLink())
        
    end

    self:SetScript("OnMouseDown", function()

    end)
end







GuildbookChatCharacterListviewItemMixin = {
    contextMenu = {},
}
function GuildbookChatCharacterListviewItemMixin:OnLoad()
    addon:RegisterCallback("Chat_OnMessageReceived", self.UpdateInfo, self)

    self.delete:SetScript("OnMouseDown", function()
        if self.characterName then
            addon:TriggerEvent("Chat_OnHistoryDeleted", self.characterName)
        end
    end)
end

function GuildbookChatCharacterListviewItemMixin:ResetDataBinding()
    self.info:SetText("")
    self.characterName = ""
end

function GuildbookChatCharacterListviewItemMixin:UpdateInfo(msg)
    --the chat view will run its update script which causes the listview to be repopulated making the self.characterName field == ""
    --wait to check the values
    C_Timer.After(0.5, function()
        if (msg.sender == self.characterName) and (msg.channel == "whisper") then
            self.info:SetText("new message")
        end
    end)
end

function GuildbookChatCharacterListviewItemMixin:SetDataBinding(info, height)

    if info.label == "Guild" then
        self.delete:Hide()
    end

    self.characterName = info.characterName
    self.icon:SetAtlas(info.atlas)
    self.text:SetText(Ambiguate(info.label, "short"))
    self.icon:SetSize(height-2, height-2)
    if info.showMask then
        self.mask:Show()
    end

    self.contextMenu = {
        {
            text = self.characterName,
            isTitle = true,
            notCheckable = true,
        },

    }
    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = "Invite",
        notCheckable = true,
        func = function()
            InviteUnit(info.characterName)
            print(info.characterName)
        end,
    })

    self:SetScript("OnMouseDown", function(_, button)
        if button == "RightButton" then
            EasyMenu(self.contextMenu, addon.contextMenu, "cursor", 0, 0, "MENU", 0.2)
        else
            self:AdjustPointsOffset(-1,-1)
            if info.func then
                info.func()
                self.info:SetText("")
            end
        end
    end)
end

function GuildbookChatCharacterListviewItemMixin:OnMouseUp()
    self:AdjustPointsOffset(1,1)
end







GuildbookGuildbankCharacterListviewItemMixin = {}
function GuildbookGuildbankCharacterListviewItemMixin:OnLoad()
    addon:RegisterCallback("Guildbank_StatusInfo", self.UpdateInfo, self)
end

function GuildbookGuildbankCharacterListviewItemMixin:ResetDataBinding()
    self.info:SetText("")
    self.characterName = ""
end

function GuildbookGuildbankCharacterListviewItemMixin:UpdateInfo(info)
    if info.characterName == self.characterName then
        self.info:SetText(info.status)
    end
end

function GuildbookGuildbankCharacterListviewItemMixin:SetDataBinding(binding, height)
    self.characterName = binding.label
    self.icon:SetAtlas(binding.atlas)

    local name, realm = strsplit("-", self.characterName)
    local _, thisRealm = strsplit("-", addon.thisCharacter)

    if realm ~= thisRealm then
        self.text:SetText(RED_FONT_COLOR:WrapTextInColorCode(binding.label))
    else
        self.text:SetText(GREEN_FONT_COLOR:WrapTextInColorCode(Ambiguate(binding.label, "short")))
    end

    self.icon:SetSize(height-2, height-2)
    if binding.showMask then
        self.mask:Show()
    end

    if binding.status then
        self.info:SetText(binding.status)
    end

    self:SetScript("OnMouseDown", function()
        self:AdjustPointsOffset(-1,-1)
        if binding.func then
            binding.func()
        end
    end)
end

function GuildbookGuildbankCharacterListviewItemMixin:OnMouseUp()
    self:AdjustPointsOffset(1,1)
end





GuildbookItemIconFrameMixin = {}

function GuildbookItemIconFrameMixin:OnEnter()
    if self.link then
        GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    else
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end
end

function GuildbookItemIconFrameMixin:OnLeave()
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
end

function GuildbookItemIconFrameMixin:OnMouseDown()
    if self.link and IsShiftKeyDown() then
        HandleModifiedItemClick(self.link)
    end
end

function GuildbookItemIconFrameMixin:SetItem(itemID, count)
    local item = Item:CreateFromItemID(itemID)

    if item and item:GetItemID() and not item:IsItemEmpty() then
        item:ContinueOnItemLoad(function()
            self.link = item:GetItemLink()
            self.icon:SetTexture(item:GetItemIcon())
        end)
    end
    self.count:SetText(count)
end


--[[
    hijacked this template to use in the list gridview
    the gridview uses SetDataBinding when items are :Insert'd 
]]
function GuildbookItemIconFrameMixin:SetDataBinding(itemID, count)
    local item = Item:CreateFromItemID(itemID)
    self.itemID = itemID
    if item and item:GetItemID() and not item:IsItemEmpty() then
        item:ContinueOnItemLoad(function()
            self.link = item:GetItemLink()
            self.icon:SetTexture(item:GetItemIcon())

            local itemCount = GetItemCount(itemID)
            if itemCount > 0 then
                self.blur:Show()
                self.checkmark:Show()
            else
                self.checkmark:Hide()
                self.blur:Hide()
            end
        end)
    end

    self:SetScript("OnMouseDown", function(f, button)
        if button == "RightButton" then
            addon:TriggerEvent("Database_OnItemListItemRemoved", self)
        end
    end)
end

function GuildbookItemIconFrameMixin:ResetDataBinding()
    self.link = nil
    self.icon:SetTexture(nil)
    self.count:SetText("")
    self.itemID = nil
    self.checkmark:Hide()
    self.blur:Hide()
end



GuildbookCircleIconMixin = {}
function GuildbookCircleIconMixin:OnLoad()
    
end

function GuildbookCircleIconMixin:SetDataBinding()

end

--make this % based to be reusable
function GuildbookCircleIconMixin:OnEnter()
    self.selected:SetSize(120,120)
    self.border:SetSize(120,120)
    self.icon:SetSize(72,72)
    self.mask:SetSize(60,60)
end
function GuildbookCircleIconMixin:OnLeave()
    self.selected:SetSize(100,100)
    self.border:SetSize(100,100)
    self.icon:SetSize(60,60)
    self.mask:SetSize(50,50)
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
end



GuildbookProfileSummaryRowAvatarTemplateMixin = {}

function GuildbookProfileSummaryRowAvatarTemplateMixin:OnLoad()
    addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)
end
function GuildbookProfileSummaryRowAvatarTemplateMixin:Character_OnDataChanged(character)
    if self.character and (self.character.data.name == character.data.name) then
        self.avatar:SetAtlas(self.character:GetProfileAvatar())
    end
end

function GuildbookProfileSummaryRowAvatarTemplateMixin:SetCharacter(character)
    self.character = character;
    self.avatar:SetAtlas(self.character:GetProfileAvatar())
    self.name:SetText("|cffffffff"..Ambiguate(self.character.data.name, "short"))

    local _, class = GetClassInfo(self.character.data.class)
    local colour = RAID_CLASS_COLORS[class]
    self.border:SetVertexColor(colour:GetRGB())
end

function GuildbookProfileSummaryRowAvatarTemplateMixin:OnEnter()
    if self:IsVisible() then
        self.whirl:Show()
        self.anim:Play()
    else
        self.whirl:Hide()
        self.anim:Stop()
    end
    if self.showTooltip then
        
    end
end

function GuildbookProfileSummaryRowAvatarTemplateMixin:OnLeave()
    self.anim:Stop()
end

function GuildbookProfileSummaryRowAvatarTemplateMixin:OnMouseUp()
    if self.character then
        addon:TriggerEvent("Character_OnProfileSelected", self.character)
    end
end




GuildbookRecipeListviewItemMixin = {}

function GuildbookRecipeListviewItemMixin:OnLoad()

    for k = 1, 8 do
        self.reagentIcons[k]:Raise()
    end

    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)
    addon:RegisterCallback("Database_OnConfigChanged", self.Database_OnConfigChanged, self)
end

function GuildbookRecipeListviewItemMixin:UpdateLayout()

    local reagentWidth = self:GetWidth() - 200;

    if reagentWidth < 169 then
        for k, v in ipairs(self.reagentIcons) do
            v:Hide()
        end
    else
        for k, v in ipairs(self.reagentIcons) do
            v:Show()
        end
    end
end

function GuildbookRecipeListviewItemMixin:Database_OnConfigChanged()
    if self.item and not self.item:IsItemEmpty() then
        if Database:GetConfig("tradeskillsRecipesListviewShowItemID") then
            self.label:SetText(self.item:GetItemID().." "..self.item:GetItemLink())
        else
            self.label:SetText(self.item:GetItemLink())
        end
        self.anim:Play()
    end
end

function GuildbookRecipeListviewItemMixin:SetDataBinding(binding, height)
    self.icon:SetWidth(height - 2)
    self.icon:SetTexture(binding.icon)

    for k, v in ipairs(self.reagentIcons) do
        v:Hide()
    end

    self.item = nil;

    if binding.tradeskillID == 333 then

        self.spell = Spell:CreateFromSpellID(binding.spellID)
        if not self.spell:IsSpellEmpty() then
            self.spell:ContinueOnSpellLoad(function()
                self.label:SetText(self.spell:GetSpellName())
                self.anim:Play()

                self:SetScript("OnEnter", function()
                    if self.spell then
                        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                        GameTooltip:SetSpellByID(self.spell:GetSpellID())
                        GameTooltip:Show()
                    end
                end)
            end)
        end

    else
        self.item = Item:CreateFromItemID(binding.itemID)
        if not self.item:IsItemEmpty() then
            self.item:ContinueOnItemLoad(function()
                if Database:GetConfig("tradeskillsRecipesListviewShowItemID") then
                    self.label:SetText(binding.itemID.." "..self.item:GetItemLink())
                else
                    self.label:SetText(self.item:GetItemLink())
                end
                self.anim:Play()

                self:SetScript("OnEnter", function()
                    if self.item then
                        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                        GameTooltip:SetHyperlink(self.item:GetItemLink())
                        GameTooltip:Show()
                    end
                end)

            end)
        end
    end

    local i = 1;
    local reagents = {}
    for k, v in pairs(binding.reagents) do
        table.insert(reagents, {
            itemID = k,
            count = v
        })
    end
    table.sort(reagents, function(a, b)
        return a.count > b.count;
    end)
    for k, v in ipairs(reagents) do
        self.reagentIcons[k]:SetItem(v.itemID, v.count)
        self.reagentIcons[k]:Show()
    end

    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)

    self:SetScript("OnMouseDown", function()
        if IsLeftAltKeyDown() then
            if AuctionFrameBrowse and AuctionFrameBrowse:IsVisible() then
                BrowseName:SetText(string.format('"%s"', self.item:GetItemName()))
                BrowseSearchButton:Click()
            end
        else
            if binding.func then
                binding.func()
            end
        end

        if self.item then
            if IsControlKeyDown() then
                DressUpItemLink(self.item:GetItemLink())
            elseif IsShiftKeyDown() then
                HandleModifiedItemClick(self.item:GetItemLink())
            end
        end
        if self.spell then
            if IsShiftKeyDown() then
                HandleModifiedItemClick(GetSpellLink(self.spell:GetSpellID()))
            end
        end
    end)

end

function GuildbookRecipeListviewItemMixin:ResetDataBinding()
    for k, v in ipairs(self.reagentIcons) do
        v:Hide()
    end
    self.item = nil;
    self.label:SetText("")
    for i = 1, 8 do
        self.reagentIcons[i]:SetAlpha(0)
    end
    self:SetScript("OnEnter", nil)
end



GuildbookRosterListviewItemMixin = {}
function GuildbookRosterListviewItemMixin:OnLoad()

    self.prof1:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession1, self.character.data.profession1Recipes)
        end
    end)
    self.prof2:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession2, self.character.data.profession2Recipes)
        end
    end)

    self.prof1:SetScript("OnEnter", function()
        if self.character and self.character.data.profession1Spec then
            GameTooltip:SetOwner(self.prof1, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(self.character.data.profession1Spec)
            GameTooltip:Show()
        end
    end)
    self.prof2:SetScript("OnEnter", function()
        if self.character and self.character.data.profession2Spec then
            GameTooltip:SetOwner(self.prof1, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(self.character.data.profession2Spec)
            GameTooltip:Show()
        end
    end)

    self.prof1:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)
    self.prof2:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)



    self.inviteToGroup:SetScript("OnMouseDown", function()
        if self.character then
            InviteUnit(self.character.data.name)
        end
    end)
    self.openProfile:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Character_OnProfileSelected", self.character)
        end
    end)
    self.openChat:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Chat_OnChatOpened", self.character.data.name)
        end
    end)

    self:SetScript("OnMouseDown", function(f, b)
        if b == "RightButton" then
            EasyMenu(self.contextMenu, addon.contextMenu, "cursor", 0, 0, "MENU", 0.2)
        end
    end)
    
    addon:RegisterCallback("UI_OnSizeChanged", self.UpdateLayout, self)
    addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)
end

function GuildbookRosterListviewItemMixin:SetDataBinding(binding, height)

    self.character = binding;

    local atlas, _ = self.character:GetClassSpecAtlasName()
    self.classIcon:SetAtlas(atlas)

    -- local r, g, b = RAID_CLASS_COLORS[select(2, GetClassInfo(self.character.data.class))]:GetRGB()
    -- self.background:SetColorTexture(r, g, b)

    if binding.showBackground == true then
        self.background:Show()
    else
        self.background:Hide()
    end

    self:Update()
end

function GuildbookRosterListviewItemMixin:UpdateLayout()
    local x, y = self:GetSize()

    if x > 850 then
        --self.name:SetWidth(160)
        -- self.rank:SetWidth(110)
        -- self.rank:Show()
        self.zone:SetWidth(110)
        self.zone:Show()
        self.publicNote:SetWidth(250)
        self.publicNote:Show()

    elseif x < 850 and x > 740 then
        --self.name:SetWidth(140)
        -- self.rank:SetWidth(1)
        -- self.rank:Hide()
        self.zone:SetWidth(110)
        self.zone:Show()
        self.publicNote:SetWidth(150)
        self.publicNote:Show()

    elseif x < 741 and x > 630 then
        --self.name:SetWidth(120)
        -- self.rank:SetWidth(1)
        -- self.rank:Hide()
        self.zone:SetWidth(1)
        self.zone:Hide()
        self.publicNote:SetWidth(150)
        self.publicNote:Show()

    elseif x < 631 then
        --self.name:SetWidth(110)
        self.publicNote:SetWidth(1)
        self.publicNote:Hide()
        -- self.rank:SetWidth(1)
        -- self.rank:Hide()
        self.zone:SetWidth(1)
        self.zone:Hide()
    end
end

function GuildbookRosterListviewItemMixin:Update()

    local main = self.character:GetMainCharacter()
    if type(main) == "string" then
        self.name:SetFontObject("GameFontNormalSmall")
        local name = self.character:GetName(true, "short")
        self.name:SetText(string.format("%s\n[%s]", name, Ambiguate(main, "short")))
    else
        self.name:SetFontObject("GameFontNormal")
        self.name:SetText(self.character:GetName(true, "short"))
    end

    self.level:SetText(self.character.data.level)
    self.zone:SetText(self.character.data.onlineStatus.zone)
    self.rank:SetText(GuildControlGetRankName(self.character.data.rank + 1))

    self.prof1.icon:SetAtlas(self.character:GetTradeskillIcon(1))

    self.prof2.icon:SetAtlas(self.character:GetTradeskillIcon(2))

    local ilvl = self.character:GetItemLevel()
    self.ilvl:SetText(string.format("ilvl: %0.2f", ilvl or 0))

    self.ilvlData = {}
    for name, _ in pairs(self.character.data.inventory) do
        local ilvl = self.character:GetItemLevel(name)
        self.ilvlData[name] = ilvl
    end
    self.ilvl:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)
    self.ilvl:SetScript("OnEnter", function()
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip_SetTitle(GameTooltip, "Equipment Sets")
        for name, ilvl in pairs(self.ilvlData) do
            GameTooltip_AddColoredLine(GameTooltip, string.format("%s ilvl: %0.2f", name, ilvl), BLUE_FONT_COLOR)
        end
        GameTooltip:Show()
    end)

    
    if self.character.data.mainSpec == false then
        self.mainSpecIcon:Hide()
        self.mainSpec:SetText("|cff7f7f7f".."No Spec")
    else
        local atlas, _ = self.character:GetClassSpecAtlasName("primary")
        self.mainSpecIcon:SetAtlas(atlas)
        self.mainSpecIcon:Show()
        local localeName, engName, Id = self.character:GetSpec("primary")
        self.mainSpec:SetText(engName)
    end

    --self.publicNote:SetText(BLUE_FONT_COLOR:WrapTextInColorCode(self.character.data.publicNote))
    self.publicNote:SetText(self.character.data.publicNote)
    self.openProfile.background:SetAtlas(self.character:GetProfileAvatar())

    self.joined:SetText(self.character:GetDateJoined(true))

    if self.character.data.onlineStatus.isOnline == true then
        self.name:SetTextColor(1,1,1)
        self.level:SetTextColor(1,1,1)
        self.mainSpec:SetTextColor(1,1,1)
        self.zone:SetTextColor(1,1,1)
        self.ilvl:SetTextColor(1,1,1)
        self.publicNote:SetTextColor(1,1,1)
    else
        self.name:SetTextColor(0.5,0.5,0.5)
        self.level:SetTextColor(0.5,0.5,0.5)
        self.mainSpec:SetTextColor(0.5,0.5,0.5)
        self.zone:SetTextColor(0.5,0.5,0.5)
        self.ilvl:SetTextColor(0.5,0.5,0.5)
        self.publicNote:SetTextColor(0.5,0.5,0.5)
    end

    local editPublicNote = CanEditPublicNote()
    self.contextMenu = {
        {
            text = self.character:GetName(true),
            isTitle = true,
            notCheckable = true,
        },
        {
            text = PUBLIC_NOTE,
            notCheckable = true,
            func = function()
                local rosterIndex = addon.api.getGuildRosterIndex(self.character.data.name)
                if type(rosterIndex) == "number" then
                    SetGuildRosterSelection(rosterIndex)
                    StaticPopup_Show("SET_GUILDPLAYERNOTE");
                end
            end,
            --disabled = not editPublicNote,
        },
    }
    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = "Export",
        isTitle = true,
        notCheckable = true,
    })

    local specInfo = self.character:GetSpecInfo()

    if specInfo then

        --local primarySpec, secondarySpec = specInfo.primary[1].id, specInfo.secondary[1].id
        local primarySpec, secondarySpec = self.character.data.mainSpec, self.character.data.offSpec

        local exportEquipMenu1 = {{
            text = "Select Gear",
            isTitle = true,
            notCheckable = true,
        },}
        local exportEquipMenu2 = {{
            text = "Select Gear",
            isTitle = true,
            notCheckable = true,
        },}
        for setname, info in pairs(self.character.data.inventory) do
            table.insert(exportEquipMenu1, {
                text = setname,
                notCheckable = true,
                func = function()
                    addon:TriggerEvent("Character_ExportEquipment", self.character, setname, "primary")
                end,
            })
            table.insert(exportEquipMenu2, {
                text = setname,
                notCheckable = true,
                func = function()
                    addon:TriggerEvent("Character_ExportEquipment", self.character, setname, "secondary")
                end,
            })
        end
    
        if primarySpec then
            local atlas, spec = self.character:GetClassSpecAtlasName(primarySpec)
            table.insert(self.contextMenu, {
                text = string.format("%s %s", CreateAtlasMarkup(atlas, 16, 16), spec),
                notCheckable = true,
                hasArrow = true,
                menuList = exportEquipMenu1,
    
            })
        end
        if secondarySpec then
            local atlas, spec = self.character:GetClassSpecAtlasName(secondarySpec)
            table.insert(self.contextMenu, {
                text = string.format("%s %s", CreateAtlasMarkup(atlas, 16, 16), spec),
                notCheckable = true,
                hasArrow = true,
                menuList = exportEquipMenu2,
    
            })
        end

    end

    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = "Reset",
        isTitle = true,
        notCheckable = true,
    })
    local profMenu = {
        {
            text = Tradeskills:GetLocaleNameFromID(self.character.data.profession1) or "Profession 1",
            notCheckable = true,
            func = function()
                self.character.data.profession1 = "-"
                self.character.data.profession1Recipes = {}
                self.character.data.profession1Level = 0
                addon:TriggerEvent("Character_OnDataChanged", self.character)
            end,
        },
        {
            text = Tradeskills:GetLocaleNameFromID(self.character.data.profession2) or "Profession 2",
            notCheckable = true,
            func = function()
                self.character.data.profession2 = "-"
                self.character.data.profession2Recipes = {}
                self.character.data.profession2Level = 0
                addon:TriggerEvent("Character_OnDataChanged", self.character)
            end,
        },
    }
    table.insert(self.contextMenu, {
        text = TRADESKILLS,
        notCheckable = true,
        hasArrow = true,
        menuList = profMenu,

    })

    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = "Request Data",
        isTitle = true,
        notCheckable = true,
    })
    local profMenu = {
        {
            text = Tradeskills:GetLocaleNameFromID(self.character.data.profession1) or "Profession 1",
            notCheckable = true,
            func = function()
                Comms:RequestCharacterData(self.character.data.name, "profession1")
                C_Timer.After(0.5, function()
                    Comms:RequestCharacterData(self.character.data.name, "profession1Level")
                end)
                C_Timer.After(1.0, function()
                    Comms:RequestCharacterData(self.character.data.name, "profession1Recipes")
                end)
                C_Timer.After(1.5, function()
                    Comms:RequestCharacterData(self.character.data.name, "profession1Spec")
                end)
            end,
        },
        {
            text = Tradeskills:GetLocaleNameFromID(self.character.data.profession2) or "Profession 2",
            notCheckable = true,
            func = function()
                Comms:RequestCharacterData(self.character.data.name, "profession2")
                C_Timer.After(0.5, function()
                    Comms:RequestCharacterData(self.character.data.name, "profession2Level")
                end)
                C_Timer.After(1.0, function()
                    Comms:RequestCharacterData(self.character.data.name, "profession2Recipes")
                end)
                C_Timer.After(1.5, function()
                    Comms:RequestCharacterData(self.character.data.name, "profession2Spec")
                end)
            end,
        },
    }
    table.insert(self.contextMenu, {
        text = TRADESKILLS,
        notCheckable = true,
        hasArrow = true,
        menuList = profMenu,
    })
    table.insert(self.contextMenu, {
        text = SPECIALIZATION,
        notCheckable = true,
        hasArrow = true,
        menuList = {
            {
                text = PRIMARY,
                notCheckable = true,
                func = function()
                    Comms:RequestCharacterData(self.character.data.name, "mainSpec")
                    C_Timer.After(0.5, function()
                        Comms:RequestCharacterData(self.character.data.name, "talents.primary")
                    end)
                    C_Timer.After(1.0, function()
                        Comms:RequestCharacterData(self.character.data.name, "glyphs.primary")
                    end)
                end,
            },
            {
                text = SECONDARY,
                notCheckable = true,
                func = function()
                    Comms:RequestCharacterData(self.character.data.name, "offSpec")
                    C_Timer.After(0.5, function()
                        Comms:RequestCharacterData(self.character.data.name, "talents.secondary")
                    end)
                    C_Timer.After(1.0, function()
                        Comms:RequestCharacterData(self.character.data.name, "glyphs.secondary")
                    end)
                end,
            },
        },
    })

    -- self:SetScript("OnMouseDown", function()
    --     local recipe = C_GuildInfo.QueryGuildMemberRecipes(self.character.data.guid, self.character.data.profession1)
    --     DevTools_Dump(recipe)
    -- end)

end

function GuildbookRosterListviewItemMixin:Character_OnDataChanged(character)
    if self.character.data.guid == character.data.guid then
        self:Update()
    end
end

function GuildbookRosterListviewItemMixin:ResetDataBinding()
    
end


function GuildbookRosterListviewItemMixin:OnEnter()


        -- i contacted the author of attune to check it was ok to add their addon data 
        if Attune_DB and Attune_DB.toons[self.character.data.name] then

            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L["attunements"])
    
            local db = Attune_DB.toons[self.character.data.name]
    
            if db then
                for _, instance in ipairs(Attune_Data.attunes) do
                    if db.attuned[instance.ID] and (instance.FACTION == "Both" or instance.FACTION == self.character.data.faction) then
                        local formatPercent = db.attuned[instance.ID] < 100 and "|cffff0000"..db.attuned[instance.ID].."%" or "|cff00ff00"..db.attuned[instance.ID].."%"
                        GameTooltip:AddDoubleLine("|cffffffff"..instance.NAME, formatPercent)
                    end
                end

                GameTooltip:Show()
            end
        end


end


function GuildbookRosterListviewItemMixin:OnLeave()
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
end












GuildbookAltsListviewTemplateMixin = {}

function GuildbookAltsListviewTemplateMixin:OnLoad()

    self.prof1:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession1, self.character.data.profession1Recipes)
        end
    end)
    self.prof2:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Character_OnTradeskillSelected", self.character.data.profession2, self.character.data.profession2Recipes)
        end
    end)

    if self.cooking then
        self.cooking.icon:SetAtlas("Mobile-Cooking")
        self.cooking.icon:SetRotation(-0.261)
        self.cooking:SetScript("OnMouseDown", function()
            if self.character then
                addon:TriggerEvent("Character_OnTradeskillSelected", 185, self.character.data.cookingRecipes)
            end
        end)
    end
    if self.firstAid then
        self.firstAid.icon:SetAtlas("Mobile-FirstAid")
        self.firstAid:SetScript("OnMouseDown", function()
            if self.character then
                addon:TriggerEvent("Character_OnTradeskillSelected", 129, self.character.data.firstAidRecipes)
            end
        end)
    end
    if self.fishing then
        self.fishing.icon:SetAtlas("Mobile-Fishing")
        self.fishing:SetScript("OnMouseDown", function()
            if self.character then
                addon:TriggerEvent("Character_OnTradeskillSelected", 356, self.character.data.fishingRecipes)
            end
        end)
    end


    self.openProfile:SetScript("OnMouseDown", function()
        if self.character then
            addon:TriggerEvent("Character_OnProfileSelected", self.character)
        end
    end)

    self:SetScript("OnMouseDown", function(f, b)
        if b == "RightButton" then
            EasyMenu(self.contextMenu, addon.contextMenu, "cursor", 0, 0, "MENU", 0.2)
        end
    end)


    addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)

end

function GuildbookAltsListviewTemplateMixin:Character_OnDataChanged(character)
    if self.character.data.guid == character.data.guid then
        self:Update()
    end
end

function GuildbookAltsListviewTemplateMixin:SetDataBinding(character)
    
    self.character = character;

    local _, class = GetClassInfo(self.character.data.class)

    self.classIcon:SetAtlas(string.format("classicon-%s", class):lower())
    self.name:SetText(Ambiguate(self.character.data.name, "short"))

    self:Update()
end

function GuildbookAltsListviewTemplateMixin:ResetDataBinding()
    
end

function GuildbookAltsListviewTemplateMixin:Update()

    self.level:SetText(self.character.data.level)

    self.prof1.icon:SetAtlas(self.character:GetTradeskillIcon(1))
    self.prof1.label:SetText(self.character.data.profession1Level)

    self.prof2.icon:SetAtlas(self.character:GetTradeskillIcon(2))
    self.prof2.label:SetText(self.character.data.profession2Level)

    self.cooking.label:SetText(self.character.data.cookingLevel)
    self.firstAid.label:SetText(self.character.data.firstAidLevel)
    self.fishing.label:SetText(self.character.data.fishingLevel)

    local copper = self.character.data.containers.copper or 0
    self.gold:SetText(GetCoinTextureString(copper))
    
    local atlas, _ = self.character:GetClassSpecAtlasName("primary")
    self.mainSpec.icon:SetAtlas(atlas)

    local atlas, _ = self.character:GetClassSpecAtlasName("secondary")
    self.offSpec.icon:SetAtlas(atlas)

    self.openProfile.background:SetAtlas(self.character:GetProfileAvatar())

    local specMenu1, specMenu2 = {}, {}
    for k, spec in ipairs(self.character:GetSpecializations()) do
        table.insert(specMenu1, {
            text = spec,
            isNotRadio = true,
            checked = function()
                return self.character.data.mainSpec == k and true or false;
            end,
            func = function()
                self.character:SetSpec("primary", k, true)
            end,
        })
        table.insert(specMenu2, {
            text = spec,
            isNotRadio = true,
            checked = function()
                return self.character.data.offSpec == k and true or false;
            end,
            func = function()
                self.character:SetSpec("secondary", k, true)
            end,
        })
    end

    local deleteEquipMenu, exportEquipMenu = {}, {}
    for setname, info in pairs(self.character.data.inventory) do
        table.insert(deleteEquipMenu, {
            text = setname,
            notCheckable = true,
            func = function()
                self.character.data.inventory[setname] = nil;
                addon:TriggerEvent("Character_OnDataChanged", self.character)
            end,
        })
        table.insert(exportEquipMenu, {
            text = setname,
            notCheckable = true,
            func = function()
                addon:TriggerEvent("Character_ExportEquipment", self.character, setname)
            end,
        })
    end

    self.contextMenu = {
        {
            text = self.character:GetName(true),
            isTitle = true,
            notCheckable = true,
        }
    }
    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = "Specializations",
        isTitle = true,
        notCheckable = true,
    })
    table.insert(self.contextMenu, {
        text = "Main",
        hasArrow = true,
        menuList = specMenu1,
        notCheckable = true,
    })
    table.insert(self.contextMenu, {
        text = "Off",
        hasArrow = true,
        menuList = specMenu2,
        notCheckable = true,
    })
    table.insert(self.contextMenu, {
        text = "Reset All",
        func = function()
            self.character:SetSpec("primary", false)
            self.character:SetSpec("secondary", false)
            addon:TriggerEvent("Character_OnDataChanged", self.character)
        end,
        notCheckable = true,
    })
    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = "Equipment",
        isTitle = true,
        notCheckable = true,
    })
    -- table.insert(self.contextMenu, {
    --     text = "Export",
    --     hasArrow = true,
    --     menuList = exportEquipMenu,
    --     notCheckable = true,
    -- })
    table.insert(self.contextMenu, {
        text = "Delete",
        hasArrow = true,
        menuList = deleteEquipMenu,
        notCheckable = true,
    })
    if Database.db.debug then
        table.insert(self.contextMenu, addon.contextMenuSeparator)
        table.insert(self.contextMenu, {
            text = "Debug",
            isTitle = true,
            notCheckable = true,
        })
        for k, v in pairs(self.character.data) do
            local subMenu = {
                {
                    text = "Dump",
                    notCheckable = true,
                    func = function()
                        DevTools_Dump(v)
                    end,
                },
                {
                    text = "Reset",
                    notCheckable = true,
                    func = function()
                        if addon.characterDefaults[k] then
                            self.character.data[k] = addon.characterDefaults[k] --WARNING - this will not trigger a data changed
                        end
                    end,
                },

            }
            table.insert(self.contextMenu, {
                text = k,
                notCheckable = true,
                hasArrow = true,
                menuList = subMenu,
            })
        end

    end
    table.insert(self.contextMenu, addon.contextMenuSeparator)
    table.insert(self.contextMenu, {
        text = DELETE,
        notCheckable = true,
        func = function()
            StaticPopup_Show("GuildbookDeleteCharacter", self.character.data.name, nil, self.character.data.name)
        end,
    })


end


function GuildbookAltsListviewTemplateMixin:OnEnter()

end

function GuildbookAltsListviewTemplateMixin:OnLeave()
    GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
end















-- this function needs to be cleaned up, its using a nasty set of variables
-- function GuildbookRosterListviewItemMixin:SetCharacter(member)
--     self.guid = member.guid
--     self.character = gb:GetCharacterFromCache(member.guid)

--     self.ClassIcon:SetAtlas(string.format("GarrMission_ClassIcon-%s", self.character.Class))
--     self.ClassIcon:Show()
--     --self.Name:SetText(character.isOnline and self.character.Name or "|cffB1B3AB"..self.character.Name)
--     self.Name:SetText(self.character.Name)
--     self.Level:SetText(self.character.Level)
--     local mainSpec = false;
--     if self.character.MainSpec == "Bear" then
--         mainSpec = "Guardian"
--     elseif self.character.MainSpec == "Cat" then
--         mainSpec = "Feral"
--     elseif self.character.MainSpec == "Beast Master" or self.character.MainSpec == "BeastMaster" then
--         mainSpec = "BeastMastery"
--     elseif self.character.MainSpec == "Combat" then
--         mainSpec = "Outlaw"
--     end
--     if self.character.MainSpec and self.character.MainSpec ~= "-" then
--         --print(mainSpec, self.character.MainSpec, self.character.Name)
--         self.MainSpecIcon:SetAtlas(string.format("GarrMission_ClassIcon-%s-%s", self.character.Class, mainSpec and mainSpec or self.character.MainSpec))
--         self.MainSpecIcon:Show()
--         self.MainSpec:SetText(L[self.character.MainSpec])
--     else
--         self.MainSpecIcon:Hide()
--     end
--     local prof1 = false;
--     if self.character.Profession1 == "Engineering" then -- blizz has a spelling error on this atlasname
--         prof1 = "Enginnering";
--     end
--     if self.character.Profession1 ~= "-" then
--         local prof = prof1 and prof1 or self.character.Profession1
--         self.Prof1.icon:SetAtlas(string.format("Mobile-%s", prof))
--         if self.character.Profession1Spec then
--             --local profSpec = GetSpellDescription(self.character.Profession1Spec)
--             local profSpec = GetSpellInfo(self.character.Profession1Spec)
--             self.Prof1.tooltipText = gb:GetLocaleProf(prof).." |cffffffff"..profSpec
--         else
--             self.Prof1.tooltipText = gb:GetLocaleProf(prof)
--         end
--         self.Prof1.func = function()
--             loadGuildMemberTradeskills(self.guid, prof)
--         end
--         self.Prof1:Show()
--     else
--         self.Prof1:Hide()
--     end
--     local prof2 = false;
--     if self.character.Profession2 == "Engineering" then -- blizz has a spelling error on this atlasname
--         prof2 = "Enginnering";
--     end
--     if self.character.Profession2 ~= "-" then
--         local prof = prof2 and prof2 or self.character.Profession2
--         self.Prof2.icon:SetAtlas(string.format("Mobile-%s", prof))
--         if self.character.Profession2Spec then
--             --local profSpec = GetSpellDescription(self.character.Profession2Spec)
--             local profSpec = GetSpellInfo(self.character.Profession2Spec)
--             self.Prof2.tooltipText = gb:GetLocaleProf(prof).." |cffffffff"..profSpec
--         else
--             self.Prof2.tooltipText = gb:GetLocaleProf(prof)
--         end
--         self.Prof2.func = function()
--             loadGuildMemberTradeskills(self.guid, prof)
--         end
--         self.Prof2:Show()
--     else
--         self.Prof2:Hide()
--     end
--     self.Location:SetText(member.location)
--     self.Rank:SetText(member.rankName)
--     self.PublicNote:SetText(member.publicNote)

--     if self.character and self.character.profile and self.character.profile.avatar then
--         self.openProfile.background:SetTexture(self.character.profile.avatar)
--     else
--         self.openProfile.background:SetAtlas(string.format("raceicon-%s-%s", self.character.Race:lower(), self.character.Gender:lower()))
--     end

-- end



---this template can do many things
--you can set the icon byt fileID or an atlas
--you can add a mask
--you can set tex coords
--set a background rgb and alpha
GuildbookSimpleIconLabelMixin = {}
function GuildbookSimpleIconLabelMixin:OnLoad()

end
function GuildbookSimpleIconLabelMixin:SetDataBinding(binding, height)

    if binding.backgroundAlpha then
        self.background:SetAlpha(binding.backgroundAlpha)
    else
        self.background:SetAlpha(0)
    end
    if binding.backgroundAtlas then
        self.background:SetAtlas(binding.backgroundAtlas)
        self.background:SetAlpha(1)
    else
        if binding.backgroundRGB then
            self.background:SetColorTexture(binding.backgroundRGB.r, binding.backgroundRGB.g, binding.backgroundRGB.b)
         else
             self.background:SetColorTexture(0,0,0)
         end
    end

    if binding.label then
        self.label:SetText(binding.label)
    end
    if binding.labelRight then
        self.labelRight:SetText(binding.labelRight)
    end

    if binding.fontObject then
        self.label:SetFontObject(binding.fontObject)
        self.labelRight:SetFontObject(binding.fontObject)
    else
        self.label:SetFontObject(GameFontWhite)
        self.labelRight:SetFontObject(GameFontWhite)
    end

    if binding.atlas then
        self.icon:SetAtlas(binding.atlas)
    elseif binding.icon then
        self.icon:SetTexture(binding.icon)
    end

    if binding.iconCoords then
        self.icon:SetTexCoord(binding.iconCoords[1], binding.iconCoords[2], binding.iconCoords[3], binding.iconCoords[4])
    else
        self.icon:SetTexCoord(0,1,0,1)
    end

    if not binding.icon and not binding.atlas then
        self.icon:SetSize(1, height-4)
    else
        self.icon:SetSize(height-4, height-4)
    end

    if binding.showMask then
        self.mask:Show()
        local x, y = self.icon:GetSize()
        self.icon:SetSize(x + 6, y + 6)
        self.icon:ClearAllPoints()
        self.icon:SetPoint("LEFT", 3, 0)
    else
        self.mask:Hide()
        -- local x, y = self.icon:GetSize()
        -- self.icon:SetSize(x - 2, y - 2)
    end

    if binding.onMouseDown then
        self:SetScript("OnMouseDown", binding.onMouseDown)
        self:EnableMouse(true)
    end
    if binding.onUpdate then
        self:SetScript("OnUpdate", binding.onUpdate)
        self:EnableMouse(true)
    end

    if binding.onMouseEnter then
        self:SetScript("OnEnter", binding.onMouseEnter)
        self:EnableMouse(true)
    end
    if binding.onMouseLeave then
        self:SetScript("OnLeave", binding.onMouseLeave)
    else
        self:SetScript("OnLeave", function()
            GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        end)
    end


    if binding.link then
        self:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self, "ANCHOR_LEFT")
            GameTooltip:SetHyperlink(binding.link)
            GameTooltip:Show()
        end)
        -- self:SetScript("OnLeave", function()
        --     GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
        -- end)
    end

    if binding.getItemInfoFromID then
        if binding.itemID then
            local item = Item:CreateFromItemID(binding.itemID)
            if not item:IsItemEmpty() then
                item:ContinueOnItemLoad(function()
                    local link = item:GetItemLink()
                    self.label:SetText(link)
                    self:EnableMouse(true)
                    self:SetScript("OnEnter", function()
                        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                        GameTooltip:SetHyperlink(link)
                        GameTooltip:Show()
                    end)
                    -- self:SetScript("OnLeave", function()
                    --     GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
                    -- end)
                    self:SetScript("OnMouseDown", function()
                        if IsControlKeyDown() then
							DressUpItemLink(link)
						elseif IsShiftKeyDown() then
							HandleModifiedItemClick(link)
						end
                        if binding.onMouseDown then
                            binding.onMouseDown()
                        end
                    end)

                    addon:TriggerEvent("Profile_OnItemDataLoaded")
                end)
            end
        end
    end

    --self.anim:Play()
end
function GuildbookSimpleIconLabelMixin:ResetDataBinding()
    self:SetScript("OnMouseDown", nil)
    self:SetScript("OnEnter", nil)
    self:SetScript("OnLeave", nil)
    self:SetScript("OnUpdate", nil)
    self:EnableMouse(false)
    self.icon:SetTexture(nil)
    self.label:SetText("")
    self.labelRight:SetText("")
end


GuildbookStatsGroupMixin = {}
function GuildbookStatsGroupMixin:OnLoad()

end
function GuildbookStatsGroupMixin:SetDataBinding(binding, height)

    self:SetHeight(height)

    self.label:SetText(binding.label)
    self.background:SetTexture(nil)

    if binding.isHeader then
        self.background:SetAtlas("UI-Character-Info-Title")
        self.background:SetAlpha(1)
        self.background:SetHeight(height * 1.4)
        --self:EnableMouse(false)
    else
        if binding.showBounce then
            self.background:SetAtlas("UI-Character-Info-Line-Bounce")
            self.background:SetAlpha(0.6)
            self.background:SetHeight(height * 1.1)
            --self:EnableMouse(false)
        end
    end

end
function GuildbookStatsGroupMixin:ResetDataBinding()

end


GuildbookResistanceFrameMixin = {}
function GuildbookResistanceFrameMixin:OnLoad()
    --addon:RegisterCallback("Character_OnDataChanged", self.Character_OnDataChanged, self)
    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)
end
-- function GuildbookResistanceFrameMixin:Character_OnDataChanged()
    
-- end
function GuildbookResistanceFrameMixin:SetDataBinding(binding)
    if binding.textureId then
        self.icon:SetTexture(binding.textureId)
    else

    end
    self.label:SetText(binding.label)

    --reusing this for auras so check if this is a res binding
    if binding.type == "resistance" then
        self.resistanceId = binding.resistanceId;
        self.resistanceName = binding.resistanceName;
    end

    if binding.onEnter then
        self:SetScript("OnEnter", binding.onEnter)
    end
end
function GuildbookResistanceFrameMixin:ResetDataBinding()
    
end




GuildbookTalentIconFrameMixin = {}
function GuildbookTalentIconFrameMixin:OnLoad()
    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)

    self.pointsBackground:SetTexture(136960)
    self.pointsLabel:SetText(1)
end
function GuildbookTalentIconFrameMixin:SetDataBinding(binding)

    --this func is only called once and is used to set some frame attribute and scripts
    if binding.rowId then
        self.rowId = binding.rowId
    end
    if binding.colId then
        self.colId = binding.colId
    end

    self:SetScript("OnEnter", function()
        if self.talent and (type(self.talent.spellId) == "number") then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetSpellByID(self.talent.spellId)
            GameTooltip:Show()
        end
    end)

end
function GuildbookTalentIconFrameMixin:UpdateLayout()
    local x, y = self:GetSize()
    self.pointsBackground:SetSize(x*0.3, x*0.3)
    self.pointsLabel:SetSize(x*0.3, x*0.3)
end
function GuildbookTalentIconFrameMixin:ResetDataBinding()
    
end
function GuildbookTalentIconFrameMixin:SetTalent(talent)
    self.talent = talent;
    --local name, _, icon = C_Spell.GetSpellInfo(self.talent.spellId)
    if self.talent.spellId then
        local iconID, originalIconID = C_Spell.GetSpellTexture(self.talent.spellId)
        self.icon:SetTexture(iconID)
        self.icon:SetDesaturation(0)
        self.icon:Show()
        self.border:Show()
        self.pointsBackground:Show()
        self.pointsLabel:Show()
        self.pointsLabel:SetText(self.talent.rank)

        if self.talent.rank == self.talent.maxRank then
            self.border:SetAtlas("orderhalltalents-spellborder-yellow")
        elseif self.talent.rank == 0 then
            self.border:SetAtlas("orderhalltalents-spellborder")
            self.icon:SetDesaturation(1)
        else
            self.border:SetAtlas("orderhalltalents-spellborder-green")
        end
    end
end
function GuildbookTalentIconFrameMixin:ClearTalent()
    self.talent = nil
    self.border:Hide()
    self.pointsBackground:Hide()
    self.pointsLabel:Hide()
    self.icon:Hide()
end






GuildbookGuildBankListviewItemMixin = {}
function GuildbookGuildBankListviewItemMixin:OnLoad()
    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)
end
function GuildbookGuildBankListviewItemMixin:SetDataBinding(binding, height)
    
    self:SetHeight(height)

    local item = Item:CreateFromItemID(binding.id)
    if not item:IsItemEmpty() then
        item:ContinueOnItemLoad(function()
            self.icon:SetTexture(item:GetItemIcon())
            self.link:SetText(item:GetItemLink())
        end)
    end

    local y = self:GetHeight()
    self.icon:SetSize(y-2, y-2)

    self.info:SetText(string.format("[%d]", binding.count))
end
function GuildbookGuildBankListviewItemMixin:ResetDataBinding()
    self.icon:SetTexture(nil)
    self.link:SetText(nil)
end


local avatarOffsets = {
    [1] = 0,
    [2] = -50,
    [3] = -100,
    [4] = -150,
    [5] = -200,
    [6] = -250,
    [7] = -300,
    [8] = -350,
    [9] = -400,
    [10] = -450,
}
GuildbookProfilesRowMixin = {}
function GuildbookProfilesRowMixin:OnLoad()

end

function GuildbookProfilesRowMixin:SetDataBinding(binding)
    if binding.showHeader then
        self.header:Show()
        self.headerBackground:Show()
        self.header:SetText(binding.header)
    else
        self.header:Hide()
        self.headerBackground:Hide()
    end

    local numCharacters = #binding.characters;
    self.avatar1:ClearAllPoints()
    self.avatar1:SetPoint("BOTTOM", avatarOffsets[numCharacters], 10)

    for i = 1, 10 do
        self["avatar"..i]:Hide()
        if binding.characters[i] then
            self["avatar"..i]:Show()
            self["avatar"..i]:SetCharacter(binding.characters[i])
        end
    end
end
function GuildbookProfilesRowMixin:ResetDataBinding()

end







GuildbookBankCharactersListviewItemMixin = {}
function GuildbookBankCharactersListviewItemMixin:OnLoad()
    addon:RegisterCallback("Character_OnDataChanged", self.Update, self)

    self.shareBank.label:SetText("Banks")
    self.shareBank:SetScript("OnClick", function(cb)
        if self.character then
            if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].bankRules[self.character.data.name] then
                addon.guilds[addon.thisGuild].bankRules[self.character.data.name].shareBank = cb:GetChecked()
            end
        end
    end)

    self.shareBags.label:SetText("Bags")
    self.shareBags:SetScript("OnClick", function(cb)
        if self.character then
            if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].bankRules[self.character.data.name] then
                addon.guilds[addon.thisGuild].bankRules[self.character.data.name].shareBags = cb:GetChecked()
            end
        end
    end)

    self.shareCopper.label:SetText("Gold")
    self.shareCopper:SetScript("OnClick", function(cb)
        if self.character then
            if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].bankRules[self.character.data.name] then
                addon.guilds[addon.thisGuild].bankRules[self.character.data.name].shareCopper = cb:GetChecked()
            end
        end
    end)

end
function GuildbookBankCharactersListviewItemMixin:SetDataBinding(binding, height)
    self.character = binding.character
    self:Update(self.character)
    self:SetHeight(height)

end
function GuildbookBankCharactersListviewItemMixin:ResetDataBinding()
    self.shareBank:SetChecked(false)
    self.shareBags:SetChecked(false)
    self.shareCopper:SetChecked(false)
end
function GuildbookBankCharactersListviewItemMixin:Update(character)
    --print("update called")
    if self.character.data.guid == character.data.guid then
        
        --print("got character")

        self.text:SetText(self.character.data.name)
        self.icon:SetAtlas(self.character:GetProfileAvatar())

        -- if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].bankRules then
        --     if not addon.guilds[addon.thisGuild].bankRules[self.character.data.name] then
        --         addon.guilds[addon.thisGuild].bankRules[self.character.data.name] = 
        --     end
        -- end

        if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].bankRules[self.character.data.name] then
            local rules = addon.guilds[addon.thisGuild].bankRules[self.character.data.name];
            self.shareBank:SetChecked(rules.shareBank)
            self.shareBags:SetChecked(rules.shareBags)
            self.shareCopper:SetChecked(rules.shareCopper)
            self.ranks:SetText((rules.shareRank and GuildControlGetRankName(rules.shareRank + 1)) or "-")

            --DevTools_Dump(rules)
        end

        --1 and GuildControlGetNumRanks() GuildControlGetRankName(index)
        --use this here as ranks can change
        local ranks = {}
        local numRanks = GuildControlGetNumRanks()
        --print(numRanks)
        for i = 1, numRanks do
            local rankName = GuildControlGetRankName(i)
            table.insert(ranks, {
                text = string.format("[%d] %s", (i-1), rankName),
                func = function ()
                    if self.character then
                        if addon.guilds and addon.guilds[addon.thisGuild] and addon.guilds[addon.thisGuild].bankRules[self.character.data.name] then
                            addon.guilds[addon.thisGuild].bankRules[self.character.data.name].shareRank = (i-1)
                        end
                    end
                end,
            })
        end
        self.ranks:SetMenu(ranks)
    end

    if addon.api.characterIsMine(self.character.data.name) then
        self.shareBank:Enable()
        self.shareBags:Enable()
        self.shareCopper:Enable()
        self.ranks:EnableMouse(true)
    else
        self.shareBank:Disable()
        self.shareBags:Disable()
        self.shareCopper:Disable()
        self.ranks:EnableMouse(false)
    end

end



GuildbookChatBubbleMixin = {}
function GuildbookChatBubbleMixin:OnLoad()
    
end
function GuildbookChatBubbleMixin:SetDataBinding(binding)

    --date("%T", binding.timestamp)

    local dateString = ""
    if binding.timestamp then
        dateString = tostring(date("%c", binding.timestamp))
        dateString = dateString:sub(1, (#dateString - 5))
    end

    if addon.api.characterIsMine(binding.sender) then
        self.message:SetJustifyH("RIGHT")

        if Database.db.characterDirectory[binding.sender] then
            local _, class = GetClassInfo(Database.db.characterDirectory[binding.sender].class)
            if class then
                local r, g, b, hex = GetClassColor(class)
                self.message:SetText(string.format("|c%s%s|r [%s]\n%s", hex, binding.sender, dateString, binding.message))
            else
                self.message:SetText(string.format("%s [%s]\n%s", binding.sender, dateString, binding.message))
            end
        else
            self.message:SetText(string.format("%s [%s]\n%s", binding.sender, dateString, binding.message))
        end

    else
        self.message:SetJustifyH("LEFT")

        if Database.db.characterDirectory[binding.sender] then
            local _, class = GetClassInfo(Database.db.characterDirectory[binding.sender].class)
            if class then
                local r, g, b, hex = GetClassColor(class)
                self.message:SetText(string.format("[%s] |c%s%s|r\n%s", dateString, hex, binding.sender, binding.message))
            else
                self.message:SetText(string.format("[%s] %s\n%s", dateString, binding.sender, binding.message))
            end
        else
            self.message:SetText(string.format("[%s] %s\n%s", dateString, binding.sender, binding.message))
        end
    end
end
function GuildbookChatBubbleMixin:ResetDataBinding()
    
end





---this template is used to display the search results and coudl be passed in a character, tradeskill item, general item from bank or inventory
---@param binding any
function GuildbookSearchListviewItemMixin:SetDataBinding(binding)

    -- self.icon:SetAtlas(info.atlas)
    -- self.text:SetText(Ambiguate(info.label, "short"))

    -- if info.showMask then
    --     self.mask:Show()
    --     local x, y = self.icon:GetSize()
    --     self.icon:SetSize(x + 2, y + 2)
    -- end

    if binding.type == "tradeskillItem" then
        
        self.text:SetText(binding.data.itemLink)

        self.icon:SetTexture(binding.data.icon)

    elseif binding.type == "character" then

        self.text:SetText(binding.data.data.name)

        self.icon:SetAtlas(binding.data:GetProfileAvatar())

    elseif binding.type == "bankItem" then

        self.text:SetText(binding.data:GetItemLink())

        self.icon:SetTexture(binding.data:GetItemIcon())

    elseif binding.type == "inventory" then

        self.text:SetText(binding.data:GetItemLink())

        self.icon:SetTexture(binding.data:GetItemIcon())
        
    end

    if type(binding.location) == "string" then
        self.location:SetText(binding.location)
        self:SetScript("OnEnter", nil)
    else
        self.location:SetText("mulitple locations")

        self:SetScript("OnEnter", function()
            GameTooltip:SetOwner(self, 'ANCHOR_LEFT')

            for name, count in pairs(binding.location) do
                GameTooltip:AddDoubleLine(name, count)
            end

            GameTooltip:Show()
        end)
    end

    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)

    if binding.onMouseDown then
        self:SetScript("OnMouseDown", binding.onMouseDown)
    else
        self:SetScript("OnMouseDown", nil)
    end
end






GuildbookClassicEraRecruitmentMixin = {}
function GuildbookClassicEraRecruitmentMixin:OnLoad()
    
end

function GuildbookClassicEraRecruitmentMixin:SetDataBinding(binding, height)
    
    if binding.backgroundAlpha then
        self.background:SetAlpha(binding.backgroundAlpha)
    else
        self.background:SetAlpha(0)
    end
    if binding.backgroundAtlas then
        self.background:SetAtlas(binding.backgroundAtlas)
        self.background:SetAlpha(1)
    else
        if binding.backgroundRGB then
            self.background:SetColorTexture(binding.backgroundRGB.r, binding.backgroundRGB.g, binding.backgroundRGB.b)
         else
             self.background:SetColorTexture(0,0,0)
         end
    end

    self.character = binding.character

    if type(self.character.class) == "number" then

        local c, class, cid = GetClassInfo(self.character.class)

        local specs;
        if RAID_CLASS_COLORS[class] then
            specs = addon.api.getClassSpecialization(class)

            self.contextMenu = {
                {
                    text = RAID_CLASS_COLORS[class]:WrapTextInColorCode(self.character.name),
                    isTitle = true,
                    notCheckable = true,
                },
        
            }
            table.insert(self.contextMenu, addon.contextMenuSeparator)
        end

        if specs then
            local specMenu = {}
            for k, v in ipairs(specs) do
                table.insert(specMenu, {
                    text = L[v],
                    func = function()
                        self.character.spec = v;
                        self:Update()
                    end,
                    notCheckable = true,
                })
            end
            table.insert(self.contextMenu, {
                text = "Set Spec",
                notCheckable = true,
                menuList = specMenu,
                hasArrow = true,
            })
        end
    else

        self.contextMenu = {
            {
                text = self.character.name,
                isTitle = true,
                notCheckable = true,
            },
    
        }
        table.insert(self.contextMenu, addon.contextMenuSeparator)

        local classMenu = {}
        for i = 1, 12 do
            local lc, gc, id = GetClassInfo(i)
            if lc then
                local specMenu = {}
                local specs = addon.api.getClassSpecialization(gc)
                if specs then
                    for k, v in ipairs(specs) do
                        table.insert(specMenu, {
                            text = L[v],
                            func = function()
                                self.character.spec = v;
                                self.character.class = id
                                self:Update()
                            end,
                            notCheckable = true,
                        })
                    end
                    table.insert(classMenu, {
                        text = RAID_CLASS_COLORS[gc]:WrapTextInColorCode(lc),
                        notCheckable = true,
                        hasArrow = true,
                        menuList = specMenu,
                    })
                end
            end
        end
        table.insert(self.contextMenu, {
            text = "Set Class",
            notCheckable = true,
            hasArrow = true,
            menuList = classMenu,
        })
    end

    local statusMenu = {}
    for i = 0, #addon.recruitment.statusIDs do
        table.insert(statusMenu, {
            text = addon.recruitment.statusIDs[i],
            func = function()
                self.character.status = i;
                table.insert(self.character.notes,
                {
                    user = addon.thisCharacter,
                    note = string.format("Set status to %s", addon.recruitment.statusIDs[i]),
                    timestamp = time(),
                })
                self:Update()
            end,
            notCheckable = true,
        })
    end
    table.insert(self.contextMenu, {
        text = "Set Status",
        notCheckable = true,
        menuList = statusMenu,
        hasArrow = true,
    })
    table.insert(self.contextMenu, {
        text = "Add note",
        func = function()
            StaticPopup_Show("GuildbookRecruitment_AddNote", self.character.name, nil, { character = self.character})
        end,
        notCheckable = true,
    })

    self:Update()

    self:SetScript("OnMouseDown", function(f, b)
        if b == "RightButton" then
            EasyMenu(self.contextMenu, addon.contextMenu, "cursor", 0, 0, "MENU", 1)
        end
    end)

    self.select:SetScript("OnClick", function()
        self.character.isSelected = not self.character.isSelected;
    end)

    -- if binding.onUpdate then
    --     self:SetScript("OnUpdate", binding.onUpdate)
    -- end

    -- if binding.onMouseDown then
    --     self:SetScript("OnMouseDown", binding.onMouseDown)
    -- end
    -- if binding.onMouseUp then
    --     self:SetScript("OnMouseUp", binding.onMouseUp)
    -- end

    -- if binding.onMouseEnter then
    --     self:SetScript("OnEnter", binding.onMouseEnter)
    -- end

    -- if binding.onMouseLeave then
    --     self:SetScript("OnLeave", binding.onMouseLeave)
    -- end

    self:SetScript("OnLeave", function()
        GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
    end)

    if binding.init then
        binding.init(self)
    end
end

--addon.recruitment

function GuildbookClassicEraRecruitmentMixin:Update()

    if self.character.class then
        local loClass, class, cid = GetClassInfo(self.character.class)

        for k, v in pairs(self.character) do
            if self[k] then
                if k == "status" then
                    self[k]:SetText(addon.recruitment.statusIDs[tonumber(v)])
                else
                    if k == "name" then
                        if RAID_CLASS_COLORS[class] then
                            self[k]:SetText(RAID_CLASS_COLORS[class]:WrapTextInColorCode(v))
                        else
                            self[k]:SetText(v)
                        end
                    elseif k == "class" then
                        self[k]:SetText(loClass)
                    else
                        self[k]:SetText(v)
                    end
                end
            end
        end

    else
        for k, v in pairs(self.character) do
            if self[k] then
                if k == "status" then
                    self[k]:SetText(addon.recruitment.statusIDs[tonumber(v)])
                else
                    self[k]:SetText(v)
                end
            end
        end
    end

    self.select:SetChecked(self.character.isSelected)


    self:SetScript("OnEnter", function()
        if self.character then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.character.name)

            if self.character.notes then
                GameTooltip:AddLine("Notes")
                GameTooltip:AddDoubleLine(self.character.notes[#self.character.notes].note, self.character.notes[#self.character.notes].user)
            end

            GameTooltip:Show()
        end
    end)
end

function GuildbookClassicEraRecruitmentMixin:ResetDataBinding()
    self.name:SetText("")
    self.class:SetText("")
    self.spec:SetText("")
    self.level:SetText("")
    self.race:SetText("")
    self.select:SetChecked(false)
end