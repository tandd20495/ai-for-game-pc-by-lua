function da_hoc_nghe(id)
  local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("job_rec")
	for row = 0, rownum - 1 do
		local job_id = client_player:QueryRecord("job_rec", row, 0)
		if nx_string(job_id:lower()) == nx_string(id:lower()) then
			return true
		end
	end
	return false
end

function da_hoc_thuc_don(id)
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows("FormulaRec")
	for row = 0, rownum - 1 do
		local job_id = client_player:QueryRecord("FormulaRec", row, 1)
		if nx_string(job_id:lower()) == nx_string(id:lower()) then
			return true
		end
	end
	return false
end

--index_id lay trong faile E:\Program Files (x86)\CACK982017\autocack\unpack\ini.package.files\res\ini\scenes.ini tuong uong voi index section
function co_dam_pending_camdia(index_id, clevel)
	local CLONE_SAVE_REC = "clone_rec_save"
	local game_client = nx_value("game_client")
	local client_player = game_client:GetPlayer()
	local rownum = client_player:GetRecordRows(CLONE_SAVE_REC)
	for row = 0, rownum - 1 do
		local index = client_player:QueryRecord(CLONE_SAVE_REC, row, 0)
		local level = client_player:QueryRecord(CLONE_SAVE_REC, row, 6)
		if nx_string(index) == nx_string(index_id) and nx_string(level) == nx_string(clevel) then
			return true
		end
	end
	return false
end