local name, addon = ...;

GuildbookChatMixin = {
    name = "Chat",
}

function GuildbookChatMixin:OnLoad()

    addon.AddView(self)
end
