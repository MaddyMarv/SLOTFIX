local mod = get_mod("SlotFix")

return {
	name = mod:localize("mod_name"),
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "debug_messages",
				type = "checkbox",
				default_value = false,
				title = "debug_messages_title",
				description = "debug_messages_desc",
			},
		},
	},
}
