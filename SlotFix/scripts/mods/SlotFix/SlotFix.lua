local mod = get_mod("SlotFix")
local UISettings = require("scripts/settings/ui/ui_settings")

mod:hook_safe("PlayerManager", "remove_player", function(self, peer_id, local_player_id)
    local game_mode_name = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
    if not game_mode_name or string.find(game_mode_name, "hub") then
        return
    end

    local players = self:players()
    local occupied_slots = {}
    local players_to_reassign = {}

    for unique_id, player in pairs(players) do
        local slot = player:slot()
        if slot then
            if slot <= 4 then
                occupied_slots[slot] = true
            else
                table.insert(players_to_reassign, player)
            end
        end
    end

    local fixed_any = false
    for _, player in ipairs(players_to_reassign) do
        local old_slot = player:slot()
        for i = 1, 4 do
            if not occupied_slots[i] then
                player:set_slot(i)
                occupied_slots[i] = true
                fixed_any = true

                if mod:get("debug_messages") then
                    mod:echo("FOUND BROKEN SLOT: Changed player from slot %s to slot %s", tostring(old_slot), tostring(i))
                end

                if UISettings then
                    UISettings._colors_revision = (UISettings._colors_revision or 0) + 1
                end
                break
            end
        end
    end

    if not fixed_any and mod:get("debug_messages") then
        mod:echo("No broken slots found.")
    end
end)
