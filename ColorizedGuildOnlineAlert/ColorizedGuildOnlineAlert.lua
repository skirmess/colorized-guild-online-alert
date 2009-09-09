
-- Copyright (c) 2009, Sven Kirmess

local Version = 1
local Loaded = false

local Friends = { }
local FriendsDirty = true

local pattern_ERR_FRIEND_ONLINE_SS
local pattern_ERR_FRIEND_OFFLINE_S

local function IsFriend(name)

	if ( FriendsDirty ) then

		-- load friend list from server
		local numFriends = GetNumFriends()
		Friends = { }

		local i
		for i = numFriends, 1, -1 do
			local currentFriend = GetFriendInfo(i)

			if ( currentFriend ) then
				Friends[string.lower(currentFriend)] = 1
			else
				-- friend list not loaded from server.
				-- for now, everyone is a friend.
				return true
			end
		end

		FriendsDirty = false
	end

	local lname = string.lower(name)
	if ( ( Friends[lname] ~= nil ) and ( Friends[lname] == 1 ) ) then
		return true
	end

	return false
end

local function SetFriendsListDirty(...)

	FriendsDirty = true
end

-- local
function ColorizedGuildOnlineAlert_ColorizedString(s, r, g, b)
	return string.format("|cff%02x%02x%02x%s|r", math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), s)
end

function ColorizedGuildOnlineAlert_Chat(self, event, ...)

	local arg1 = ...

	if ( arg1 == nil or arg1 == "" ) then
		return false
	end

	local _, _, player = string.find(arg1, pattern_ERR_FRIEND_ONLINE_SS)
	if ( player ~= nil ) then
		if ( IsFriend(player) ) then
			return false
		end

		local color = ChatTypeInfo["GUILD"]
		local colorSYSTEM = ChatTypeInfo["SYSTEM"]
		DEFAULT_CHAT_FRAME:AddMessage(string.format(ERR_FRIEND_ONLINE_SS, player, ColorizedGuildOnlineAlert_ColorizedString(player, color.r, color.g, color.b)), colorSYSTEM.r, colorSYSTEM.g, colorSYSTEM.b)

		return true
	end

	_, _, player = string.find(arg1, pattern_ERR_FRIEND_OFFLINE_S)
	if ( player ~= nil ) then
		if ( IsFriend(player) ) then
			return false
		end

		local color = ChatTypeInfo["GUILD"]
		local colorSYSTEM = ChatTypeInfo["SYSTEM"]
		DEFAULT_CHAT_FRAME:AddMessage(string.format(ERR_FRIEND_OFFLINE_S, ColorizedGuildOnlineAlert_ColorizedString(player, color.r, color.g, color.b)), colorSYSTEM.r, colorSYSTEM.g, colorSYSTEM.b)

		return true
	end

	return false
end

function ColorizedGuildOnlineAlert_OnEvent(event, ...)

	if ( event == "PLAYER_ENTERING_WORLD" ) then

		if ( not Loaded ) then
			DEFAULT_CHAT_FRAME:AddMessage(string.format("ColorizedGuildOnlineAlert %i loaded.", Version))
			Loaded = true

			pattern_ERR_FRIEND_ONLINE_SS = "^"..string.gsub(string.gsub(string.gsub(ERR_FRIEND_ONLINE_SS, "%%s", "(.+)", 1), "%%s", "(.+)%%", 1), "%[", "%%%[").."$"
			pattern_ERR_FRIEND_OFFLINE_S = "^"..string.gsub(ERR_FRIEND_OFFLINE_S, "%%s", "(.+)", 1).."$"

			-- If something changes in the friend list, mark our cache dirty.
			hooksecurefunc("AddFriend", SetFriendsListDirty)
			hooksecurefunc("RemoveFriend", SetFriendsListDirty)

			ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ColorizedGuildOnlineAlert_Chat)
		end
	end
end

