--[[
NOTE:
Prepared statements only works with INSERT, UPDATE and other creation statements; it cannot retrieve data.

Example:
local stmt = CityMod.PreparedStatement.InsertCharInfo
stmt:setNumber(1,100)
stmt:setString(2,"test")
stmt:setNumber(3,123)
stmt:setNumber(4,12345)
stmt:start()
]]

-- Prepared statements
CityMod.PreparedStatement.InsertAccountDetail = "INSERT INTO account (`account_id`, `steam_id`, `name`, `staff_rank`, `money`, `max_inventory_size`, `max_inventory_weight`) VALUES(?, ?, ?, ?, ?, ?, ?)"
CityMod.PreparedStatement.UpdateDonationSetCompleted = "UPDATE donation SET completed = 1, completion_time = ? WHERE id = ?"