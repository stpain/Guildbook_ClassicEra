local name, addon = ...;

local Database = addon.Database;

GuildbookChatMixin = {
    name = "Chat",
}

function GuildbookChatMixin:OnLoad()

    addon:RegisterCallback("Database_OnInitialised", self.Database_OnInitialised, self)
    addon:RegisterCallback("Chat_OnMessageReceived", self.Chat_OnMessageReceived, self)

    addon.AddView(self)
end

function GuildbookChatMixin:OnShow()
    
end

function GuildbookChatMixin:Database_OnInitialised()
    self.chats = Database.db.chats;

    self:Update()
end

function GuildbookChatMixin:Update()


    local chatList = {
        {
            label = GUILD,
            atlas = "GarrMission_MissionIcon-Logistics",
            showMask = false,

            func = function()
                self:SetChatHistory(self.chats.guild, GUILD)
            end,
        },
    }
    
    local t = {}
    for name, chat in pairs(self.chats) do
        if name ~= "guild" then
            table.insert(t, {
                name = name,
                lastActive = chat.lastActive
            })
        end
    end

    if #t > 0 then
        table.sort(t, function(a, b)
            return a.lastActive > b.lastActive
        end)
        for k, v in ipairs(t) do
            local x = self.chats[v.name]
            table.insert(chatList, {
                label = v.name,
                atlas = "GarrMission_MissionIcon-Recruit",
                showMask = false,

                func = function()
                    self:SetChatHistory(x.history, v.name)
                end,
            })
        end
    end

    local dp = CreateDataProvider(chatList)
    self.charactersListview.scrollView:SetDataProvider(dp)
end

function GuildbookChatMixin:SetChatHistory(history, player)
    local dp = CreateDataProvider(history)
    self.chatHistory.scrollView:SetDataProvider(dp)

    self.chatInfo:SetText(player)
end

function GuildbookChatMixin:Chat_OnMessageReceived(data)
    
    if type(data) == "table" then

        local now = time();

        if data.channel == "guild" then
            table.insert(self.chats.guild, {
                sender = data.sender,
                message = data.message,
            })
        else
            if not self.chats[data.sender] then
                self.chats[data.sender] = {
                    lastActive = now,
                    history = {},
                }
            end

            self.chats[data.sender].lastActive = now;
            table.insert(self.chats[data.sender].history, {
                sender = data.sender,
                message = data.message,
            })
        end
    end

    self:Update()
end