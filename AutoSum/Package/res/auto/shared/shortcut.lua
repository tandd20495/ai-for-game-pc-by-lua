function set_skill_short_cut(skill_id, index)
	nx_execute("custom_sender", "custom_set_shortcut", index, "skill", skill_id)
end

function set_item_short_cut(unique_id, index)
	nx_execute("custom_sender", "custom_set_shortcut", index, "item", unique_id)
end