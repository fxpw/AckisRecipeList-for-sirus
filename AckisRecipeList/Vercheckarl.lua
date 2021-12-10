
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local SendAddonMessage = SendAddonMessage
local GetNumPartyMembers = GetNumPartyMembers
local GetNumRaidMembers = GetNumRaidMembers
local CreateFrame = CreateFrame

local myname = UnitName("player")
versionARL = GetAddOnMetadata("Ackis Recipe List", "Version")

local spamt = 0
local timeneedtospam = 120
do
    local SendMessageWaitingARL
    local SendRecieveGroupSizeARL = 0
    function SendMessage_ARL()
        if GetNumRaidMembers() > 1 then
            local _, instanceType = IsInInstance()
            if instanceType == "pvp" then
                SendAddonMessage("ARLVC", versionARL, "BATTLEGROUND")
            else
                SendAddonMessage("ARLVC", versionARL, "RAID")
            end
        elseif GetNumPartyMembers() > 0 then
            SendAddonMessage("ARLVC", versionARL, "PARTY")
        elseif IsInGuild() then
            SendAddonMessage("ARLVC", versionARL, "GUILD")
        end
        SendMessageWaitingARL = nil
    end

    local function SendRecieve_ARL(_, event, prefix, message, _, sender)
        if event == "CHAT_MSG_ADDON" then
            -- print(argtime)
            if prefix ~= "ARLVC" then return end
            if not sender or sender == myname then return end

            local ver = tonumber(versionARL)
            message = tonumber(message)

            local  timenow = time()
            if message and (message > ver) then
                if timenow - spamt >= timeneedtospam then
                    print("|cff1784d1".."Ackis Recipe List".."|r".." (".."|cffff0000"..ver.."|r"..") устарел. Вы можете загрузить последнюю версию (".."|cff00ff00"..message.."|r"..") из ".."|cffffcc00".."https://github.com/fxpw/Ackis-Recipe-List-for-sirus".."|r")
                    -- spamt = time()
                    spamt = time()
                end
            end
        end


        if event == "PARTY_MEMBERS_CHANGED" or event == "RAID_ROSTER_UPDATE" then
            local numRaid = GetNumRaidMembers()
            local num = numRaid > 0 and numRaid or (GetNumPartyMembers() + 1)
            if num ~= SendRecieveGroupSizeARL then
                if num > 1 and num > SendRecieveGroupSizeARL then
                    if not SendMessageWaitingARL then
                        SendMessage_ARL()
                    end
                end
                SendRecieveGroupSizeRB = num
            end
        elseif event == "PLAYER_ENTERING_WORLD" then
                if not SendMessageWaitingARL then
                    SendMessage_ARL()
                end
            end
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("CHAT_MSG_ADDON")
    f:RegisterEvent("RAID_ROSTER_UPDATE")
    f:RegisterEvent("PARTY_MEMBERS_CHANGED")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:SetScript("OnEvent", SendRecieve_ARL)
end