local UnitName = UnitName
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetBattlefieldScore = GetBattlefieldScore
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local GetBattlefieldWinner = GetBattlefieldWinner
local GetBattlefieldTeamInfo = GetBattlefieldTeamInfo
local SendChatMessage = SendChatMessage


local frame = CreateFrame("frame")


local function GetPlayerTeamID()
    local playerName = UnitName("player")
    local name,teamID,_
    for i = 1,GetNumBattlefieldScores() do
        name,_,_,_,_,teamID = GetBattlefieldScore(i)
        if name == playerName then
            return teamID
        end
    end
end

function frame:UPDATE_BATTLEFIELD_STATUS()
    if not (IsActiveBattlefieldArena() and GetBattlefieldWinner()) then return end

    local playerTeamID = GetPlayerTeamID()
    local name,lost,got,mmr
    local msg
    for i = 0,1 do
        name,lost,got,mmr = GetBattlefieldTeamInfo(i)
        
        if name:find("^Solo Team [1-2]$") then
            name = playerTeamID == i and "This team" or "Enemy team"
        end

        if got > 0 then
            msg = ("%q(%d) +%d"):format(name,mmr,got)
        elseif lost > 0 then
            msg = ("%q(%d) -%d"):format(name,mmr,lost)
        else
            msg = ("%q(%d) no changes"):format(name,mmr)
        end
        SendChatMessage(msg,"PARTY")
    end
end

function frame:OnEvent(event,...)
    self[event](self,...)
end


frame:SetScript("OnEvent",frame.OnEvent)
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")