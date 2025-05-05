--#region! ================================================ PRINT
--print("LOCAL Move ID: ", getLocalOldMethodMoveID())
--print("OPP Move ID: ", getOpponentOldMethodMoveID())
--print("LOCAL Prev Move ID: ", getLocalOldMethodLastMoveID())
--print("OppStun State: ", getOpponentStunnedStateBeta())
--print("Combo Count: ", getLocalComboCounter())
--print(getOpponentIsBeingCounterPunish())
--print(getOpponentDistance())
--print(getLocalGettingThrownByte())
print(getOpponentIsThrowing())
--print(getLocalAnimationID())
--print(getOpponentAnimationID())
--print(getLocalStockInteger())
--print(getOpponentTotalFrames())
--print(getLocalMoveTimer())    
--print(getOpponentMoveTimer())
--print(getOpponentStartUpEndFrame())
--print(getOpponentIsAttacking()   )

--#region input fix
if DetectIsKeyPressed(0x08)
then
EnableGameInput()
RDown()
RUp()
RToward()
RBack()
RLight()
RMedium()
RHeavy()
RSpecial()
RAssist()
ReleaseInputModernSpecialMove()
RParry()
end
--#endregion

--#region Print Stats
if DetectIsKeyPressed(0x30)
then
print("Distance: ", getOpponentDistance())
print("OPP Move ID: ", getOpponentOldMethodMoveID())
OS(2000)
end
--#endregion

--#endregion! ============================================= PRINT

--#region! ================================================ BASE FUNCTIONS 

--#region Probability
ACTION_PROBABILITY = 40  -- Set this between 0 and 100

function PROBABILITY()
    return math.random(100) <= ACTION_PROBABILITY
end
--#endregion

--#region Drive Impact (DI) Animations - Format {AnimationID, isKickDI} 
DI_AnimationIDS = {
    [1]  = {110, 854, false},  -- Ryu (MoveID 110, AnimationID 854, Not a Kick DI)
    [2]  = {118, 855, false},  -- Luke
    [3]  = {140, nil, false},  -- Kim
    [4]  = {178, nil, false},  -- Chun-Li
    [5]  = {139, nil, false},  -- Manon
    [6]  = {124, 854, false},  -- Zangief
    [7]  = {101, 855, false},  -- JP
    [8]  = {152, 854, false},  -- Dhalsim
    [9]  = {134, nil, false},  -- Cammy 
    [10] = {136, 855, false},  -- Ken
    [11] = {106, nil, false},  -- Dee Jay
    [12] = {110, 855, false},  -- Lily
    [13] = {101, 855, false},  -- Aki
    [14] = {102, nil, false},  -- Rashid
    [15] = {167, nil, false},  -- Blanka
    [16] = {118, nil, false},  -- Juri
    [17] = {161, 855, false},  -- Marisa
    [18] = {128, nil, false},  -- Guile
    [19] = {119, 855, false},  -- Ed
    [20] = {127, 855, false},  -- Honda
    [21] = {157, 858, false},  -- Jamie
    [21] = {157, 860, false},  -- Jamie
    [22] = {115, 854, false},  -- Akuma
    [26] = {nil, nil, false},  -- Bison
    [27] = {nil, nil, false},  -- Terry
    [28] = {nil, nil, false},  -- Mai
    [29] = {nil, nil, false},  -- Elena
    [30] = {55, 858, false},   -- Jamie Avatar
    [31] = {47, 855, false},   -- Luke Avatar
    [32] = {38, 855, false},   -- Manon Avatar
    [33] = {46, 855, false},   -- Kim/Ken  Avatar
    [34] = {49, 855, false},   -- Marisa Avatar
    [35] = {44, 855, false},   -- Lily/Cammy/Aki Avatar
    [36] = {45, 855, false},   -- JP/Terry Avatar
    [37] = {40, 855, false},   -- Juri Avatar
    [38] = {54, 855, false},   -- Dee Jay Avatar
    [39] = {47, 854, false},   -- Ryu/Dhalsim Avatar
    [40] = {37, 855, false},   -- Honda/Blanka Avatar
    [41] = {87, 855, false},   -- Guile Avatar
    [42] = {96, 854, false},   -- Chun-Li Avatar
    [43] = {45, 854, false},   -- Zangief Avatar
    [44] = {59, 855, false},   -- Rashid Avatar
    [45] = {61, 855, false},   -- Ed Avatar
    [46] = {44, 854, false},   -- Akuma Avatar
    [47] = {43, 855, false},   -- Bison Avatar
    [48] = {52, 854, false},   -- Mai Avatar
            }
--#endregion

--#region Check if Doing DI
function isOpponentAnimationDI()
    local opponentAnimation = getOpponentAnimationID()
    for _, di in pairs(DI_AnimationIDS) do
    if di[2] ~= nil and di[2] == opponentAnimation then
            return "Yes"
    end
    end
    return "No"
end
--#endregion        

--#region Local Definitions

-- Control Type
Modern  = (GetControlType() == 1)
Classic = (GetControlType() == 0)

-- Button Presses (M)
local PAssist  = PressInputModernAssistButton
local RAssist  = ReleaseInputHardKick
local PSpecial = PressInputModernSpecialMove
local RSpecial = ReleaseInputModernSpecialMove
local PLight   = PressInputModernLightAttack
local RLight   = ReleaseInputModernLightAttack 
local PMedium  = PressInputModernMediumAttack
local RMedium  = ReleaseInputModernMediumAttack
local PHeavy   = PressInputModernHeavyAttack
local RHeavy   = ReleaseInputModernHeavyAttack

-- Button Presses (C)
local PLP      = PressInputLightPunch
local RLP      = ReleaseInputLightPunch
local PMP      = PressInputMediumPunch
local RMP      = ReleaseInputMediumPunch
local PHP      = PressInputHardPunch
local RHP      = ReleaseInputHardPunch
local PLK      = PressInputLightKick
local RLK      = ReleaseInputLightKick
local PMK      = PressInputMediumKick
local RMK      = ReleaseInputMediumKick
local PHK      = PressInputHardKick
local RHK      = ReleaseInputHardKick


-- Button Presses (Both)
local PParry   = PressInputParryButton
local RParry   = ReleaseInputParryButton
local PToward  = PressInputRightButton
local RToward  = ReleaseInputRightButton
local PDown    = PressInputDownButton
local RDown    = ReleaseInputDownButton
local PBack    = PressInputLeftButton
local RBack    = ReleaseInputLeftButton
local PUp      = PressInputUpButton
local RUp      = ReleaseInputUpButton

-- API Calls
local opponentDistance     = getOpponentDistance()
local OpponentAnimationID  = getOpponentAnimationID()
local LocalAnimationID     = getLocalAnimationID()
local OS                   = OwlSleep 
local OSF                  = OwlSleepFrames
local opponentHealth       = getOpponentHealthMeter() 
local opponentID           = getOpponentCharacterID
local opponentAnim         = OpponentAnimationID
local opponentMove         = getOpponentOldMethodMoveID

--#endregion

--#region (local_ready) - Is Local in Ready Animation

local localAnimation = getLocalAnimationID()
local invalidLocalAnimations = {
    [17] = true, [18] = true, [162] = true, [176] = true, [181] = true,
    [232] = true, [480] = true, [481] = true, [482] = true, [483] = true,
    [484] = true, [485] = true, [341] = true, [331] = true, [340] = true,
    [182] = true, [183] = true, [160] = true, [161] = true, [155] = true,
    [153] = true, [163] = true, [174] = true, [175] = true
}
local_ready = not invalidLocalAnimations[localAnimation]

--#endregion

--#region Chance Functions
function chance(percentage)
return math.random(1, 100) <= percentage
end
--#endregion

--#region (isCounterReady) - Is local ready to Counter
function isCounterReady(minDistance, maxDistance)
    local inAir = getLocalInAirByte()
    local distance = getOpponentDistance()

    return getOpponentStunnedStateBeta() == 0
        and getLocalStunnedStateBeta() == 0
        and getLocalOldMethodMoveID() == 0
        and (inAir == 0 or inAir == 1)
        and distance >= minDistance
        and distance <= maxDistance
        -- and getOpponentMoveTimer() == 1
        and local_ready
        and not getOpponentIsProjectileOnScreen()
end
--#endregion

--#region (PunCond) - Checks if a move is Punishable

function PunCond(charID, moveID, startup, minDistance, maxDistance, label)
    if getOpponentCharacterID() == charID
        and getOpponentOldMethodMoveID() == moveID
        and (startup == nil or getOpponentStartUpEndFrame() >= startup)
        and getOpponentDistance() >= minDistance
        and getOpponentDistance() <= maxDistance 
        and getLocalInAirByte() ~= 2
        and getLocalStunnedStateBeta() == 0
        and getOpponentMoveTimer() <= 10
        then

        print(label)
        print("PunCond Distance: ", getOpponentDistance())
        
        return true
    end

    return false
    
end
--#endregion

--#region (Health) - Checks if Opponent health is between a certain value
function Health(min, max)
    local health = getOpponentHealthMeter()
    if health >= min and health < max then
        return true
    else
        return false
    end
end
--#endregion

--#region (Meter) - Checks if Meter is greater than a certain value
function SAMeter(threshold)
    threshold = threshold or 0
    return getLocalSAMeter() >= threshold
end
--#endregion

--#region (Parry) - Presses Parry with delays
function Parry(waitBeforeP, waitBetween, waitAfter)
    DisableGameInput()
    setOpponentOldMethodMoveID(0)
    PDown()
    PBack()
    OS(waitBeforeP)
    RDown()
    PParry()
    OS(waitBetween)
    RBack()
    RParry()
    EnableGameInput()
    setOpponentOldMethodMoveID(0)
    OS(waitAfter)
end
--#endregion

--#region (BlockHigh) - Presses Block High with delays
function BlockHigh(waitBeforeP, waitBetween, waitAfter)
    DisableGameInput()
    setOpponentOldMethodMoveID(0)
    --PDown()
    PBack()
    OS(waitBeforeP)
    --RDown()
    --PParry()
    OS(waitBetween)
    RBack()
    --RParry()
    EnableGameInput()
    setOpponentOldMethodMoveID(0)
    OS(waitAfter)
end
--#endregion

--#region (HitConfirm) - Checks if Move has landed
function HitConfirm(MoveID, Distance, DriveMeter, HitType, Label)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch = true

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    end

    local condition = getLocalOldMethodMoveID() == MoveID
        and getLocalComboCounter() >= 1
        and getOpponentStunnedStateBeta() ~= 0 
        and getOpponentInAirByte() ~= 2 
        and getLocalInAirByte() ~= 2
        and getOpponentDistance() <= Distance
        --and getLocalStunnedStateBeta() == 0
        and getLocalDriveMeter() >= DriveMeter
        and isOpponentAnimationDI() == "No"
        and hitTypeMatch

    if condition and Label then
        print("===================================== " .. Label)
        print("Distance: ", getOpponentDistance())
        print("OppAnim: ", getOpponentAnimationID())
    end

    return condition
end
--#endregion

--#region (HitConfirmAirOpp) - Checks if Move has landed
function HitConfirmAirOpp(MoveID, Distance, DriveMeter, HitType, Label)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch = true

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    end

    local condition = getLocalOldMethodMoveID() == MoveID
        and getOpponentStunnedStateBeta() ~= 0 
        and getOpponentInAirByte() == 2 
        and getLocalInAirByte() ~= 2
        and getOpponentDistance() <= Distance
        and getLocalStunnedStateBeta() == 0
        and getLocalDriveMeter() >= DriveMeter
        and hitTypeMatch

    if condition and Label then
        print("===================================== " .. Label)
    end

    return condition
end
--#endregion

--#region (HitConfirmAirOpp) - Checks if Move has landed
function HitConfirmAirLoc(MoveID, Distance, DriveMeter, HitType, Label)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch = true

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    end

    local condition = getLocalOldMethodMoveID() == MoveID
        and getOpponentStunnedStateBeta() ~= 0 
        --and getOpponentInAirByte() == 2 
        and getLocalInAirByte() == 2
        and getOpponentDistance() <= Distance
        and getLocalStunnedStateBeta() == 0
        and getLocalDriveMeter() >= DriveMeter
        and hitTypeMatch

    if condition and Label then
        print("===================================== " .. Label)
    end

    return condition
end
--#endregion

--#region (DIHitConfirm)        - Checks if Move has landed into DI
function DIHitConfirm(MoveID, Distance, SAMeter, DriveMeter)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0
    SAMeter = SAMeter or 0

    return  getLocalOldMethodMoveID() == MoveID
    and getOpponentStunnedStateBeta() ~= 0
    and getOpponentDistance() <= Distance
    and getLocalStunnedStateBeta() == 0          
    and getLocalActionFlags() ~= 0
    and getLocalInAirByte() ~= 2             --if we is on the ground
    and getOpponentInAirByte() ~= 2
    and getOpponentInAirByte() ~= 3          -- not knocked down
    and getLocalSAMeter() >= SAMeter
    and getLocalDriveMeter() >= DriveMeter
    and isOpponentAnimationDI() == "Yes"
end
--#endregion

--#region (BlockString)         - Performs Blockstring on Blocked Attacks
function BlockString(MoveID, Distance, DriveMeter, SAMeter)
    Distance   = Distance   or 200
    DriveMeter = DriveMeter or 0
    SAMeter = SAMeter or 0

    return  getLocalOldMethodMoveID() == MoveID
    and getLocalComboCounter() == 0
    and getOpponentDistance() <= Distance
    and getLocalStunnedStateBeta() == 0
    and getLocalActionFlags() ~= 0
    and getOpponentAttackingByte() ~= 30    -- bad drive rush check
    and getOpponentAttackingByte() ~= 32    -- not hit by attack
    and getOpponentAttackingByte() == 27    -- blocking
    and getLocalInAirByte() ~= 2            --if we is on the ground
    and getOpponentInAirByte() ~= 2
    and getOpponentInAirByte() ~= 3         -- not knocked down
    and getLocalDriveMeter() >= DriveMeter
    and getLocalSAMeter() >= SAMeter
end
--#endregion

--#region (AAReady) - Checks Can be AA
function AAReady(MinDistance, MaxDistance, AnimID, Label)
    MinDistance = MinDistance or 0
    MaxDistance = MaxDistance or 300
    AnimID = AnimID

    local condition = 
        getOpponentStunnedStateBeta() == 0 
        and getOpponentInAirByte() == 2 
        and getLocalInAirByte() ~= 2
        and getOpponentAnimationID() == AnimID
        and getOpponentDistance() <= MaxDistance
        and getOpponentDistance() >= MinDistance
        and getLocalStunnedStateBeta() == 0
        --and getOpponentMoveTimer()==0 
        --and getLocalAnimationID()<=19 
        and getOpponentIsProjectileOnScreen()==false
        --and (getOpponentAnimationID() == 33 or getOpponentAnimationID() == 34)

    if condition and Label then
        print("===================================== " .. Label)
    end

    return condition
end
--#endregion

--#region (Conditions) - Conditions that must be met.
function Conditions(MinDistance, MaxDistance, DriveMeter, HitType, StunState, Label)
    MinDistance = MinDistance or 0
    MaxDistance = MaxDistance or 300
    DriveMeter  = DriveMeter  or 0

    local stunCheck
    if StunState == nil then
        -- Default: check that opponent stun state is not equal to 0.
        stunCheck = (getOpponentStunnedStateBeta() ~= 0)
    else
        stunCheck = (getOpponentStunnedStateBeta() == StunState)
    end

    local isCounterHit = getOpponentIsBeingCounterHit()
    local isPunishHit  = getOpponentIsBeingCounterPunish()
    local hitTypeMatch

    if HitType == "Counter" then
        hitTypeMatch = isCounterHit
    elseif HitType == "Punish" then
        hitTypeMatch = isPunishHit
    elseif HitType == "Both" then
        hitTypeMatch = isCounterHit or isPunishHit
    elseif HitType == "None" then
        -- If "None" is specified, ensure both are false.
        hitTypeMatch = (not isCounterHit and not isPunishHit)
    else
        hitTypeMatch = true
    end

    local result = stunCheck
           and getOpponentInAirByte() ~= 2 
           and getLocalInAirByte() ~= 2
           and getOpponentDistance() >= MinDistance
           and getOpponentDistance() <= MaxDistance
           and getLocalStunnedStateBeta() == 0
           and getLocalDriveMeter() >= DriveMeter
           and hitTypeMatch

    if result and Label then
        print("*** " .. Label)
    end

    return result
end
--#endregion

--#region (ifStun) - If Opponent is Stunned
function ifStun(action)
    if getOpponentStunnedStateBeta() ~= 0 then
        action()
        return true
    else
        EnableGameInput()
        EnableGameInput()
        RDown()
        RUp()
        RToward()
        RBack()
        RLight()
        RMedium()
        RHeavy()
        RSpecial()
        RAssist()
        ReleaseInputModernSpecialMove()
        print("Stopped! Opponent not stunned. " .. action)
        return false
    end
end
--#endregion

--#region (ifBlock)             - If Opponent is Stunned
function ifBlock(action)
    if getOpponentAttackingByte() == 27 and getOpponentStunnedStateBeta() == 0 then
    action()
    return true
    else
    EnableGameInput()
    return false
    end
end
--#endregion

--#region (notStun) - If Opponent is NOT Stunned
function notStun(action)
    if getOpponentStunnedStateBeta() ~= 0 then
        EnableGameInput()
        EnableGameInput()
        RDown()
        RUp()
        RToward()
        RBack()
        RLight()
        RMedium()
        RHeavy()
        RSpecial()
        RAssist()
        ReleaseInputModernSpecialMove()
        print("Stopped! Opponent stunned. " .. tostring(action))
        return false
        
    else
        action()
        return true
    end
end
--#endregion

--#region (MoveTimer) - Checks to see if move hits normally or meaty
function MoveTimer(target, baseValue)
    local currentTimer = getLocalMoveTimer()
    local waitTime = baseValue

    if currentTimer < target then
        print("Timer < Target: Timer=" .. currentTimer .. " Target=" .. target .. " Base=" .. baseValue .. " OS=" .. baseValue - ((currentTimer - target) * 20))
        waitTime = baseValue + ((target - currentTimer) * 20)
    elseif currentTimer > target then
        print("Timer > Target: Timer=" .. currentTimer .. " Target=" .. target .. " Base=" .. baseValue .. " OS=" .. baseValue - ((currentTimer - target) * 20))
        waitTime = baseValue - ((currentTimer - target) * 20)
    else
        waitTime = baseValue  -- When target equals currentTimer, output the base value.
    end

    if waitTime <= 0 then
        waitTime = 1
    end

    print("Calculated wait time: " .. waitTime)
    --print("Current Timer: " .. currentTimer)
    OwlSleep(waitTime)
end
--#endregion

--#region (KillCheck) - Checks what super could Kill 
function KillCheck(lvl1, lvl2, lvl3)
    local health = getOpponentHealthMeter()
    if health <= lvl1 then
        KillCombo_LVL1()
    elseif health <= lvl2 then
        KillCombo_LVL2()
    elseif health <= lvl3 then
        KillCombo_LVL3()
    end
end
--#endregion

--#endregion! ============================================= BASE FUNCTIONS

--#region! ================================================ CHARACTERS

--#region= ================================= 01 - Ryu
if getLocalCharacterID() == 1 then
-----------------------------------------------    

---- Code Here


-----------------------------------------------
end ------ END OF CHARACTER -------------------
--#endregion= ============================== 01 - Ryu

--#region= ================================= 02 - Luke
if getLocalCharacterID() == 2 then
--------------------------------------------    

--- Code goes here

--------------------------------------------
end ---- END OF CHARACTER ------------------
--#endregion= ============================== 01 - Luke
    
--#region= ================================= 07 - JP
if getLocalCharacterID() == 7 then
--------------------------------------------    

--#region! ================================================ CHARACTER MOVES / ACTIONS

--#region* Standard Actions / Buttons / Controller Motions --------------------

--#region Standing LP
function Do_StLP()
    DisableGameInput()

    if Classic then
        PLP()
        OS(40)
        RLP()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LP
function Do_CrLP()
    DisableGameInput()

    if Classic then
        PDown()
        PLP()
        OS(40)
        RLP()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MP
function Do_StMP()
    DisableGameInput()

    if Classic then
        PMP()
        OS(40)
        RMP()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MP
function Do_CrMP()
    DisableGameInput()

    if Classic then
        PDown()
        PMP()
        OS(40)
        RMP()
        RDown()
        
    elseif Modern then
        PAssist()
        PMedium()
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HP
function Do_StHP()
    DisableGameInput()

    if Classic then
        PHP()
        OS(40)
        RHP()
        
    elseif Modern then
        PAssist()
        PHeavy()
        OS(40)
        RAssist()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HP
function Do_CrHP()
    DisableGameInput()

    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RDown()
        RToward()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Standing LK
function Do_StLK()
    DisableGameInput()

    if Classic then
        PLK()
        OS(40)
        RLK()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LK
function Do_CrLK()
    DisableGameInput()

    if Classic then
        PDown()
        PLK()
        OS(40)
        RLK()
        RDown()
        
    elseif Modern then
        PAssist()
        PLight()
        OS(40)
        RLight()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MK
function Do_StMK()
    DisableGameInput()

    if Classic then
        PMK()
        OS(40)
        RMK()
        
    elseif Modern then
        PMedium()
        OS(40)
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MK
function Do_CrMK()
    DisableGameInput()

    if Classic then
        PDown()
        PMK()
        OS(40)
        RMK()
        RDown()
        
    elseif Modern then
        PDown()
        PMedium()
        OS(40)
        RMedium()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HK
function Do_StHK()
    DisableGameInput()

    if Classic then
        PHK()
        OS(40)
        RHK()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HK
function Do_CrHK()
    DisableGameInput()

    if Classic then
        PDown()
        PHK()
        OS(40)
        RHK()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RHeavy()
        RDown()
        RToward()
    end

    EnableGameInput()
end
--#endregion

--#region Block High
function BlockHigh()
    PBack()
    OS(60)
    RBack()
end 
--#endregion

--#region Block Low
function BlockLow()
    PDown()
    PBack()
    OS(80)
    RDown()
    RBack()
end 
--#endregion

--#region Throw
function Throw()
    DisableGameInput()

    if Classic then
        PLP()
        PLK()
        OS(40)
        RLP()
        RLK()
        
    elseif Modern then
        PLight()
        PMedium()
        OS(40)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region QCF 
function QCF()
    PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	OS(30)
	RToward()
end
--#endregion

--#region QCB 
function QCB()
    PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	OS(30)
	RBack()
end
--#endregion

--#endregion* -------------------------------------------------------

--#region* Special Move Functions ------------------------------------

--#region Ryuuenbu (QCB + Button) ---------------------------------

--#region Ryuuenbu (LP)
function Do_ryuuenbu_LP()
    DisableGameInput()
	QCB()
	PLight()
	OS(20)
	RLight()
    EnableGameInput()
end
--#endregion

--#region Ryuuenbu (MP)
function Do_ryuuenbu_MP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	PMedium()
	OS(20)
	RBack()
	RMedium()
end
--#endregion

--#region Ryuuenbu (HP)
function Do_ryuuenbu_HP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	PHeavy()
	OS(20)
	RBack()
	RHeavy()
end
--#endregion

--#region Ryuuenbu (OD)
function Do_ryuuenbu_OD()
    DisableGameInput()

    if Classic then
        QCB()
        PLP()
        PMP()
        OS(20)
        RLP()
        RMP()
        
    elseif Modern then
        QCB()
        PLight()
        PMedium()
        OS(20)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#endregion -------------------------------------------------------

--#region Kachousen (QCF + Button) ---------------------------------

--#region Kachousen (LP) 
function Do_fireball_LP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PLight()
	OS(30)
	RToward()
	RLight()
end
--#endregion

--#region Kachousen (MP) 
function Do_fireball_MP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PMedium()
	OS(30)
	RToward()
	RMedium()
end
--#endregion

--#region Kachousen (HP) 
function Do_fireball_HP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PHeavy()
	OS(30)
	RToward()
	RHeavy()
end
--#endregion

--#endregion -------------------------------------------------------

--#region Hishou Ryuuenjin (DP + Button) ---------------------------

--- Hishou Ryuuenjin (LK)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PLight()
    OS(20)
    RToward()
    RLight()
end

--- Hishou Ryuuenjin (MK)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PMedium()
    OS(20)
    RToward()
    RMedium()
end

--- Hishou Ryuuenjin (HK)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PHeavy()
    OS(20)
    RToward()
    RHeavy()
end

--- Hishou Ryuuenjin (OD)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PLight()
    PMedium()
    OS(20)
    RToward()
    RLight()
    RMedium()
end

--#endregion

--#region Hissatsu (Down + Special) ---------------------------------

--#region Hissatsu (LK)
function Do_hissatsu_LK()
    DisableGameInput()

    if Classic then
        QCF()
	    PLK()
	    OS(30)
	    RLK()
        
    elseif Modern then
        PDown()
        PSpecial()
        OS(20)
        RDown()
        RSpecial()
    end

    EnableGameInput()
end
--#endregion

--#region Hissatsu (MK)
function Do_hissatsu_MK()
    DisableGameInput()

    if Classic then
        QCF()
        PMK()
	    OS(30)
        RMK()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Hissatsu (HK)
function Do_hissatsu_HK()
    DisableGameInput()

    if Classic then
        QCF()
	    PHK()
	    OS(30)
        RHK()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Hissatsu (OD)
function Do_hissatsu_OD()
    DisableGameInput()

    if Classic then
        QCF()
	    PLK()
        PMK()
	    OS(30)
	    RLK()
        RMK()
        
    elseif Modern then
        PAssist()
        PDown()
        PSpecial()
        OS(20)
        RDown()
        RSpecial()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#endregion -------------------------------------------------------

--#endregion* -------------------------------------------------------


--#endregion! ============================================= CHARACTER MOVES / ACTIONS

--#region! ================================================ LIGHT PUNCH

--#region Standing LP
if HitConfirm(3, 200) then
    DisableGameInput()
    
    if Classic then
        PBack() -- Stops Unwanted DP If pressing forward
        OS(40)
        RBack() -- Stops Unwanted DP If pressing forward
        Do_hissatsu_LK()
    elseif Modern then
        -- NA 
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching LP
if HitConfirm(13, 200) then
    DisableGameInput()
    
    if Classic then
        PBack() -- Stops Unwanted DP If pressing forward
        OS(40)
        RBack() -- Stops Unwanted DP If pressing forward
        Do_hissatsu_LK()
    elseif Modern then
        PDown()
        PSpecial()
        OS(20)
        RDown()
        RSpecial()
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT PUNCH

--#region! ================================================ MEDIUM PUNCH

--#region Crouching MP
if HitConfirm(15, 200)  
then
    DisableGameInput() 
    
    if Classic then
        MoveTimer(14, 0)
        Do_ryuuenbu_OD()
    elseif Modern then
        MoveTimer(14, 0)
        ifStun(PAssist)
        ifStun(PMedium)
        OS(20)
        RAssist()
        RMedium()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP
if HitConfirm(7, 200)  
then
    DisableGameInput() 
    
    if Classic then
        Do_ryuuenbu_OD()
    elseif Modern then
        PAssist()
        PMedium()
        OS(20)
        RAssist()
        RMedium()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM PUNCH

--#region! ================================================ HEAVY PUNCH

--#region Standing HP >=35001 Need Buff
--[[if   getLocalOldMethodMoveID() == 9 
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getLocalInAirByte() ~= 2
and getOpponentDistance() <= 190
and getLocalStunnedStateBeta() == 0
and getOpponentIsBeingCounterHit() == false
and getOpponentIsBeingCounterPunish() == true
and getLocalDriveMeter()>=35001
then
    DisableGameInput()  -- Commented out for debugging	
    
    PDown() -- Start Fireball OD
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PHeavy()
    PMedium()
	OS(600)
	RToward()
    RMedium()
	RHeavy() -- End Fireball


	PAssist()
    PHeavy()
    OS(20)
    RAssist()
    RHeavy()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end--]]
--#endregion

--#region Standing HP 
if HitConfirm(9, 190) then
    DisableGameInput()

    if Classic then
        Do_hissatsu_OD()
        
    elseif Modern then
        Do_hissatsu_OD()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching HP - Incomplete
if HitConfirm(17, 190) then
    DisableGameInput()

    if Classic then
        OS(600) -- timing is good need to work on the combo
        PDown()
        PLP()
        OS(20)
        RDown()
        RLP()
        
    elseif Modern then
        Do_hissatsu_OD()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================ HEAVY PUNCH

--#region! ================================================ LIGHT KICK

-- Nothing Yet

--#endregion! ============================================= LIGHT KICK

--#region! ================================================ MEDIUM KICK

--#region Standing MK (Punish)
if HitConfirm(8, 220, 0, "Punish") then
    DisableGameInput()

    if Classic then
        OS(60)
        Do_CrMK()
        
    elseif Modern then
        OS(60)
        Do_CrMK()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MK 
if HitConfirm(16, 220) then
    DisableGameInput()

    if Classic then
        Do_hissatsu_LK()
        
    elseif Modern then
        Do_hissatsu_LK()
        Do_hissatsu_LK() -- Modern Mash
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM KICK

--#region! ================================================ HEAVY KICK

--#region Standing HK (Punish)
if HitConfirm(10, 220, 0, "Punish") then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        -- Nothing Yet
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= HEAVY KICK

--#region!  =============================================== COMBOS

function Combo1()
    DisableGameInput()

    if Classic then
        Do_StLP()
        Do_CrLP()
        Do_StMP()
        Do_CrMP()
        Do_ryuuenbu_LP()
        Do_hissatsu_LK()
        
    elseif Modern then
        PParry()
        OS(20)
        RParry()
        OS(20)
        PParry()
        OS(20)
        RParry()
        OS(300)
        Do_StHK()
        
        Do_ryuuenbu_LP()
        Do_hissatsu_LK()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end

--#endregion! ============================================= COMBOS

--#region! ================================================ SHIMMY

--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 200 
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
OS(60)
Do_StHK()
EnableGameInput()
OS(500)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= SHIMMY

--#region! ================================================ REACTIONS

--#region Wakeup OD DP -- Needs Work its messy

local function getODDPMode()
    if getLocalDriveMeter() >= 1 and getOpponentHealthMeter() <= 1600 and getLocalSAMeter() <= 19999 then
        return "burnoutKill"  -- OD DP that puts in Burnout but kills
    elseif getLocalDriveMeter() >= 20050 and getOpponentHealthMeter() >= 3001 and getLocalSAMeter() >= 20000 then
        return "highDrive"  -- Safe OD DP with high Drive Meter
    end
    return nil
end

local function shouldAutoODDP(mode)
    if getOpponentOldMethodMoveID() == 0 or getOpponentDistance() > 200 then
        return false
    end

    local opponentID = getOpponentCharacterID()
    local moveID = getOpponentOldMethodMoveID()

    -- **Ordered by Character ID**
    local validMoves = {
        [1]  = {90},                    -- Ryu
        [2]  = {104},                   -- Luke
        [3]  = {116},                   -- Kim
        [4]  = {155},                   -- Chun
        [5]  = {119},                   -- Manon
        [6]  = {107, 93, 94, 95, 158},  -- Zangief (Multiple Moves)
        [7]  = {91},                    -- JP
        [8]  = {131},                   -- Dhalsim
        [9]  = {117},                   -- Cammy
        [10] = {118},                   -- Ken
        [11] = {94},                    -- Dee Jay
        [12] = {92},                    -- Lily
        [13] = {95},                    -- AKI
        [14] = {97},                    -- Rashid
        [15] = {156},                   -- Blanka
        [16] = {109},                   -- Juri
        [17] = {149, 124, 188},         -- Marisa (Multiple Moves)
        [18] = {107},                   -- Guile
        [19] = {105},                   -- Ed
        [20] = {101},                   -- Honda
        [21] = {147},                   -- Jamie
        [22] = {101},                   -- Akuma
        [26] = {78},                    -- Bison
        [27] = {43},                      -- Terry (Hammer Punch)
        [28] = {37},                    -- Mai
        [29] = {}                       -- Elena
    }

    -- Check if opponent's move is in the valid move list
    local isValidMove = false
    if validMoves[opponentID] then
        for _, id in ipairs(validMoves[opponentID]) do
            if moveID == id then
                isValidMove = true
                break
            end
        end
    end

    if isValidMove then
        return false
    end

    -- Ensure general wakeup conditions
    return getOpponentInAirByte() ~= 2
        and getLocalInAirByte() == 0
        and (getLocalAnimationID() == 340 or getLocalAnimationID() == 341)
        and getOpponentStartUpEndFrame() >= 9
end

--  Determine OD DP mode automatically
local mode = getODDPMode()
if mode and shouldAutoODDP(mode) then
    DisableGameInput()
    OwlSleep(20)
    
    -- Execute OD DP Motion
    PressInputRightButton()
    OwlSleep(20)
    ReleaseInputRightButton()

    PressInputDownButton()
    PressInputRightButton()
    OwlSleep(20)

    ReleaseInputDownButton()
    PLight()  -- OD DP uses both punches
    PMedium()
    OwlSleep(20)

    ReleaseInputRightButton()
    RLight()
    RMedium()

    EnableGameInput()
    OwlSleep(100)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region Backdash Punish
if getOpponentStunnedStateBeta() == 0 
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getOpponentDistance() <= 160
and getLocalStunnedStateBeta() == 0
and getOpponentOldMethodMoveID() == 1 --102
and getOpponentMoveTimer()==0 
and getLocalOldMethodMoveID()==0
and getLocalAnimationID() ~= 174
and getLocalAnimationID() ~= 176
and getLocalAnimationID() ~= 175
and PROBABILITY()
then
DisableGameInput()
Do_CrHK()
OwlSleep(200)
EnableGameInput()
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Auto Super Art 3 on Wake Up if Can Kill -- Needs Work
if getOpponentOldMethodMoveID() ~= 0 
and getOpponentDistance() <= 200  
and 
(
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() ~= 101) or --22 akuma 	
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() ~= 90) or --1: Ryu 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() ~= 104) or --2: Luke 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() ~= 116) or --3: Kim 
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() ~= 155 and getOpponentOldMethodMoveID()~= 34) or --4: Chun 	
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() ~= 119) or --5: Manon 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() ~= 107 and getOpponentOldMethodMoveID()~= 93 and getOpponentOldMethodMoveID()~= 94 and getOpponentOldMethodMoveID()~= 95 and getOpponentOldMethodMoveID()~= 158) or --6: Gief 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() ~= 91) or --7: JP 
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() ~= 131) or --8: Sim 	
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() ~= 117) or --9: Cammy 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() ~= 118) or --10: Ken 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() ~= 94) or --11: DJ 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() ~= 92) or --12: Lily 	
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() ~= 95) or --13: AKI 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() ~= 97) or --14: Rashid 
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() ~= 156) or --15: Blanka 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() ~= 109) or --16: Juri 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() ~= 149) or --17: Marisa 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() ~= 107) or --18: Guile 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() ~= 105) or --19: Ed 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() ~= 147) or --21: Jamie 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() ~= 101)  --20: Honda  
)
    and ((getLocalHealthMeter()>=2251 and getOpponentHealthMeter()<=4000 and getLocalSAMeter()==30000) or (getLocalHealthMeter()<=2250 and getOpponentHealthMeter()<=4500 and getLocalSAMeter()==30000))
    and getOpponentInAirByte() ~= 2 
    and getLocalInAirByte() == 0
	and (getLocalAnimationID() == 341 or getLocalAnimationID() == 340 or getLocalAnimationID() == 341)
	and getOpponentStartUpEndFrame()>= 12
    then
	-- DisableGameInput()  -- Commented out for debugging
	PressInputDownButton()
        OwlSleep(20)
        ReleaseInputDownButton()
        PressInputDownButton()
        PressInputRightButton()
	    OwlSleep(20)
	    ReleaseInputDownButton()
	    OwlSleep(20)
        ReleaseInputRightButton()
	    PressInputDownButton()
        OwlSleep(20)
        ReleaseInputDownButton()
        PressInputDownButton()
        PressInputRightButton()
	    OwlSleep(20)
	    ReleaseInputDownButton()
	    PHeavy()
	    OwlSleep(20)
        ReleaseInputRightButton()
        RHeavy()
EnableGameInput()
OwlSleep(500)
setOpponentOldMethodMoveID(0)
 end
--#endregion

--#region Anti Drive Reversal
if opponentDistance >= 70 
and opponentDistance <= 220 
and getOpponentMoveTimer() == 1 
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID() == 0
and not getOpponentIsProjectileOnScreen()
then
    local opponentID = getOpponentCharacterID()
    local moveID = getOpponentOldMethodMoveID()

    -- Check if opponent's move is a valid Drive Reversal move
    if driveReversalMoves[opponentID] then
        for _, validMoveID in ipairs(driveReversalMoves[opponentID]) do
            if moveID == validMoveID then
                -- Drive Reversal Detected
                PParry()
                OwlSleep(250)
                RParry()
                EnableGameInput()
                OwlSleep(400)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Drive Rush Check with Crouching MK
if getOpponentStunnedStateBeta() == 0
and getOpponentDistance() <= 250
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and local_ready
and getOpponentMoveTimer() == 2
and getLocalOldMethodMoveID() == 0
and PROBABILITY()
and not getOpponentIsProjectileOnScreen()
and driveRushMoves[getOpponentCharacterID()] ~= nil
then
    for _, validMoveID in ipairs(driveRushMoves[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            Do_CrMK()
            EnableGameInput()
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Block Unsafe Move +4
if getLocalAttackingByte() == 27 and getOpponentDistance() <= 140
and minus4onBlock[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(minus4onBlock[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            print("Blocked a -4 move! Executing Auto-Confirm")
            OS(80)
            DisableGameInput()
            Do_CrLP()
            EnableGameInput()

            break
        end
    end
end
--#endregion

--#region Block Unsafe Move +6
if getLocalAttackingByte() == 27
and getOpponentDistance() <= 161
and minus6onBlock[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(minus6onBlock[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            print("Blocked a -6 move! Executing Auto-Confirm")
            OS(80)
            DisableGameInput()
            Do_CrMP()
            EnableGameInput()
            break
        end
    end
end
--#endregion


--#endregion! ============================================= REACTIONS

--#region! ================================================ THROW LOOP

if getLocalIsThrowing() and getOpponentIsThrowing() == false then
    DisableGameInput()
    OS(500)
    if getOpponentDistance() > 250 then EnableGameInput() end
    OS(1500)

    local randomChoice = math.random(4)

if randomChoice == 1 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Meaty MP
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(340)
    Do_CrMP()

elseif (randomChoice == 2 or randomChoice == 4) and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Throw Loop
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(360)

    -- Backdash check
    if getOpponentStunnedStateBeta() == 0 
    and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
    and getOpponentDistance() <= 160
    and getLocalStunnedStateBeta() == 0
    and getOpponentOldMethodMoveID() == 1 --102
    and getOpponentMoveTimer()==0 
    and getLocalOldMethodMoveID()==0
    and getLocalAnimationID() ~= 174
    and getLocalAnimationID() ~= 176
    and getLocalAnimationID() ~= 175 
    
    then -- Doing BackDash?
        Do_StHP()
    else
        Throw()
    end

elseif randomChoice == 3 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Shimmy
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(300)
    PBack()
    OS(200)
    RBack()
    Do_StHP()
end

    EnableGameInput()
end
--#endregion! ============================================= THROW LOOP

--#region! ================================================ STARTUP PUNISH

--#region Startup Punish (18F)
if isCounterReady(220) then
    local StartupPunish_18F = {
        [1]  = {8, 9, 65, 66, 74, 73, 75, 156, 157},   -- Ryu
        [2]  = {25},                                    -- Luke
        [3]  = {27, 28, 80, 181, 76},                  -- Kim
        [4]  = {167, 126, 33, 67},                     -- Chun-Li
        [5]  = {95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 
                105, 106, 107, 108, 109, 59, 169},      -- Manon
        [6]  = {31},                                   -- Zangief
        [7]  = {26, 66, 67, 137},                      -- JP
        [8]  = {82, 84, 209},                          -- Dhalsim
        [9]  = {27, 69, 70, 71},                       -- Cammy
        [10] = {54, 112, 66, 101, 102, 103},           -- Ken
        [11] = {26, 68, 163, 59, 158},                 -- Dee Jay
        [12] = {28, 24, 51, 52, 140},                  -- Lily
        [13] = {40},                                   -- AKI
        [14] = {42, 83, 84, 79, 81, 127},              -- Rashid
        [15] = {26, 30, 208, 66},                      -- Blanka
        [16] = {50, 70, 81, 82, 166, 87, 86, 165},     -- Juri
        [17] = {43, 117, 118, 119, 187},               -- Marisa
        [18] = {26},                                   -- Guile
        [19] = {9000},                                 -- Ed
        [20] = {28, 52, 53, 163},                      -- Honda
        [21] = {9, 19, 10, 20, 76, 110, 111, 184, 137, 
                138, 118, 119, 186, 190},              -- Jamie
        [22] = {8},                                    -- Akuma
        [26] = {7, 27},                                -- Bison
        [27] = {43},                                     -- Terry (Hammer Punch)    
        [28] = {},                                     -- Mai
        [29] = {}                                      -- Elena
    }

    if StartupPunish_18F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_18F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                DisableGameInput()
                Do_StHP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (14-17F)
if isCounterReady(220) then
    local StartupPunish_14to17F = {
        [1]  = {12, 64, 153},                -- Ryu
        [2]  = {32, 27, 142},                -- Luke (?, Double Impact, ?)
        [3]  = {75, 175},                    -- Kim
        [4]  = {8, 30, 66},                  -- Chun-Li
        [5]  = {8, 92, 57, 58},              -- Manon
        [6]  = {6, 29, 33, 41},              -- Zangief
        [7]  = {27, 9000},                   -- JP
        [8]  = {80},                         -- Dhalsim
        [9]  = {9000},                       -- Cammy
        [10] = {9000, 111, 65},              -- Ken
        [11] = {15, 71, 60},                 -- Dee Jay
        [12] = {8, 27},                      -- Lily
        [13] = {18, 19},                     -- AKI
        [14] = {70, 43, 82, 78},             -- Rashid
        [15] = {14},                         -- Blanka
        [16] = {14, 48, 73},                 -- Juri
        [17] = {14, 38, 127, 125, 9000},     -- Marisa
        [18] = {30, 31},                     -- Guile
        [19] = {27, 54, 71, 72, 73},         -- Ed
        [20] = {27, 85},                     -- Honda
        [21] = {8, 13, 14, 71, 109},         -- Jamie
        [22] = {},                           -- Akuma (No values yet)
        [26] = {},                           -- Bison (No values yet)
        [27] = {},                           -- Terry (No values yet)
        [28] = {},                           -- Mai (No values yet)
        [29] = {}                            -- Elena (No values yet)
    }

    if StartupPunish_14to17F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_14to17F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                DisableGameInput()
                Do_CrMP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (12-13F)
if isCounterReady(200) then
    -- Define valid counter punish moves per character
    local StartupPunish_12to13F = {
        [1]  = {7, 72, 73},                     -- Ryu
        [2]  = {30, 78, 77, 65},                -- Luke (Outlaw Kick, ?, ?, ?)
        [3]  = {8},                             -- Kim
        [4]  = {7},                             -- Chun-Li
        [5]  = {9000},                          -- Manon
        [6]  = {7, 15},                         -- Zangief
        [7]  = {5, 7, 8},                       -- JP
        [8]  = {28},                            -- Dhalsim
        [9]  = {9000},                          -- Cammy
        [10] = {8, 110, 64, 166, 174},          -- Ken
        [11] = {7, 69, 58},                     -- Dee Jay
        [12] = {9000},                          -- Lily
        [13] = {8},                             -- AKI
        [14] = {8, 14},                         -- Rashid
        [15] = {32, 65},                        -- Blanka
        [16] = {69, 158},                       -- Juri
        [17] = {12},                            -- Marisa
        [18] = {8},                             -- Guile
        [19] = {16, 69, 70},                    -- Ed
        [20] = {51},                            -- Honda
        [21] = {66, 182},                       -- Jamie
        [22] = {10, 11, 7},                     -- Akuma
        [26] = {8},                             -- Bison
        [27] = {8},                             -- Terry (St.HK)
        [28] = {},                              -- Mai (No values yet)
        [29] = {}                               -- Elena (No values yet)
    }

    -- Check if the opponent's move is in the StartupPunish_12to13F table
    if StartupPunish_12to13F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_12to13F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                print("Starting 12f - 13f punish") -- Debug
                DisableGameInput()
                Do_CrMP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (11F)
if isCounterReady(220) then
    -- Define valid counter punish moves per character
    local StartupPunish_11F = {
        [1]  = {1444},                           -- Ryu
        [2]  = {},                    -- Luke
        [3]  = {32},                             -- Kim
        [4]  = {15, 125},                        -- Chun-Li
        [5]  = {15, 39, 91},                     -- Manon
        [6]  = {14},                             -- Zangief
        [7]  = {28},                             -- JP
        [8]  = {},                               -- Dhalsim (No values yet)
        [9]  = {8},                              -- Cammy
        [10] = {178, 9000},                      -- Ken
        [11] = {9000},                           -- Dee Jay
        [12] = {7, 15},                          -- Lily
        [13] = {92},                             -- AKI
        [14] = {9000},                           -- Rashid
        [15] = {15},                             -- Blanka
        [16] = {9000},                           -- Juri
        [17] = {10, 22},                         -- Marisa
        [18] = {28},                             -- Guile
        [19] = {68, 86, 82},                     -- Ed
        [20] = {14, 15},                         -- Honda
        [21] = {9000},                           -- Jamie
        [22] = {},                               -- Akuma (No values yet)
        [26] = {15},                             -- Bison
        [27] = {60},                               -- Terry (Round Wave)
        [28] = {},                               -- Mai (No values yet)
        [29] = {}                                -- Elena (No values yet)
    }

    -- Check if the opponent's move is in the StartupPunish_11F table
    if StartupPunish_11F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_11F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                DisableGameInput()
                Do_CrMP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (8F)
if isCounterReady(190) then
    -- Define valid counter punish moves per character
    local StartupPunish_8F = {
        [1]  = {18},                                   -- Ryu
        [2]  = {6, 13},                                -- Luke (St.MK, ?)
        [3]  = {6, 14, 15},                            -- Kim
        [4]  = {127, 129, 32, 65, 211},                -- Chun-Li
        [5]  = {13, 32, 67, 68, 69, 70, 71, 172, 173, 174, 175, 176, 182}, -- Manon
        [6]  = {12, 19},                               -- Zangief
        [7]  = {6, 25},                                -- JP
        [8]  = {35, 26},                               -- Dhalsim
        [9]  = {7, 6, 13, 15},                         -- Cammy
        [10] = {6, 14, 15},                            -- Ken
        [11] = {14, 13},                               -- Dee Jay
        [12] = {12},                                   -- Lily
        [13] = {6, 30},                                -- AKI
        [14] = {6, 69, 41},                            -- Rashid
        [15] = {6, 13, 52},                            -- Blanka
        [16] = {25, 23},                               -- Juri
        [17] = {19, 41},                               -- Marisa
        [18] = {13},                                   -- Guile
        [19] = {13},                                   -- Ed
        [20] = {9000, 12, 8},                          -- Honda
        [21] = {5},                                    -- Jamie
        [22] = {18, 19},                               -- Akuma
        [26] = {5, 13},                                -- Bison
        [27] = {13, 7},                                 -- Terry (Cr.MK)
        [28] = {},                                     -- Mai
        [29] = {}                                      -- Elena
    }

    -- Directly check opponent data without storing in variables
    if StartupPunish_8F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_8F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                print("Starting 8f punish") -- Debug
                DisableGameInput()  
                Do_CrLP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion 

--#region Startup Punish (9-10F) 
if isCounterReady(190) then
    -- Define valid counter punish moves per character
    local StartupPunish_9to10F = {
        [1]  = {10, 6, 5, 19, 20},               -- Ryu
        [2]  = {5, 7, 8, 15},                    -- Luke (?, St.HP, St.HK, ?)
        [3]  = {7, 74},                          -- Kim
        [4]  = {16, 128},                        -- Chun-Li
        [5]  = {7, 6, 14, 27, 62, 63, 64, 65, 66, 90}, -- Manon
        [6]  = {5, 13, 35},                      -- Zangief
        [7]  = {14, 13, 15},                     -- JP
        [8]  = {33, 37},                         -- Dhalsim
        [9]  = {14, 25},                         -- Cammy
        [10] = {7},                              -- Ken
        [11] = {6, 5},                           -- Dee Jay
        [12] = {5, 14, 13},                      -- Lily
        [13] = {10, 34, 36},                     -- AKI
        [14] = {7, 15},                          -- Rashid
        [15] = {5, 7, 12, 27, 29, 103, 217, 64}, -- Blanka
        [16] = {10, 27, 52, 68},                 -- Juri
        [17] = {21, 20, 34},                     -- Marisa
        [18] = {14, 15, 29, 32},                 -- Guile
        [19] = {7, 6, 9, 15, 14},                -- Ed
        [20] = {5, 13, 83, 84, 87, 88, 89, 6},   -- Honda
        [21] = {6, 29, 30, 47},                  -- Jamie
        [22] = {9, 6},                           -- Akuma
        [26] = {6, 29},                          -- Bison
        [27] = {7, 66},                              -- Terry (?, Quick Burn)
        [28] = {},                               -- Mai (No values yet)
        [29] = {}                                -- Elena (No values yet)
    }

    -- Check if the opponent's move is in the StartupPunish_9to10F table
    if StartupPunish_9to10F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_9to10F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                print("Starting 9f - 10f punish") -- Debug
                DisableGameInput()  
                Do_CrLP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion 

--#endregion! ============================================= STARTUP PUNISH

--#region! ================================================ WHIFF PUNISH

--#region Function: Check if Whiff Punish is Ready
function isWhiffReady(minDistance, maxDistance)
    return getOpponentStunnedStateBeta() == 0
        and getLocalStunnedStateBeta() == 0
        and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
        and (getOpponentDistance() >= minDistance and getOpponentDistance() <= maxDistance)
        and getOpponentMoveTimer() == 0
        and local_ready
        and getLocalOldMethodMoveID() == 0
        and not getOpponentIsProjectileOnScreen()
        
end
--#endregion

--#region Whiff Punish with Crouching MP

local validWhiffPunish_CrMP = {
    [1]  = {},  -- Ryu
    [2]  = {},  -- Luke
    [3]  = {},  -- Kimberly
    [4]  = {},  -- Juri
    [5]  = { [12] = 9 },  -- Manon
    [6]  = {},  -- Marisa
    [7]  = { [3] = 8 },  -- JP
    [8]  = {},  -- Zangief
    [9]  = {},  -- Dhalsim
    [10] = { [4] = 6 },  -- Ken
    [11] = { [12] = 9, [4] = 9 },  -- Dee Jay
    [12] = { [3] = 7 },  -- Lily
    [13] = { [4] = 10 },  -- A.K.I.
    [14] = { [3] = 5 },  -- Rashid
    [15] = { [11] = 6, [3] = 7 },  -- Blanka
    [16] = {},  -- Cammy
    [17] = {},  -- Guile
    [18] = {},  -- Chun-Li
    [19] = {},  -- Ed
    [20] = {},  -- E. Honda
    [21] = { [3] = 7 },  -- Jamie
    [22] = { [17] = 8 },  -- Akuma
    [23] = {},  -- Bison
    [24] = { [5] = 9, [10] = 6 },  -- Terry (St.MP, )
    [25] = {},  -- Mai
    [26] = {}   -- Elena
}

if isWhiffReady(179, 240) 
and validWhiffPunish_CrMP[getOpponentCharacterID()]
and validWhiffPunish_CrMP[getOpponentCharacterID()][getOpponentOldMethodMoveID()] == getOpponentStartUpEndFrame()
then
    DisableGameInput()
    OwlSleep(25)
    Do_CrMP()
    EnableGameInput()
    OwlSleep(100)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region Whiff Punish with Crouching MP (5 frames)

whiffPunish5f = {
    [1]  = {15},       -- Ryu
    [2]  = {10},       -- Luke
    [3]  = {},         -- Kimberly
    [4]  = {},         -- Juri
    [5]  = {10},       -- Manon
    [6]  = {},         -- Marisa
    [7]  = {10},       -- JP
    [8]  = {},         -- Zangief
    [9]  = {10},       -- Cammy
    [10] = {10},       -- Ken
    [11] = {},         -- Dee Jay
    [12] = {},         -- Lily
    [13] = {26},       -- A.K.I.
    [14] = {},         -- Rashid
    [15] = {},         -- Blanka
    [16] = {},         -- Guile
    [17] = {17},       -- Marisa
    [18] = {},         -- Chun-Li
    [19] = {},         -- Ed
    [20] = {},         -- E. Honda
    [21] = {25},       -- Jamie
    [22] = {15},       -- Akuma
    [23] = {4, 10},    -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {}          -- Elena
}

if isWhiffReady(170, 190)
and getOpponentStartUpEndFrame() == 5
and whiffPunish5f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish5f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            OwlSleep(25)
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Crouching MP (6 frames)

whiffPunish6f = {
    [1]  = {},         -- Ryu
    [2]  = {},         -- Luke
    [3]  = {10},       -- Kimberly
    [4]  = {11},       -- Juri
    [5]  = {},         -- Manon
    [6]  = {},         -- Marisa
    [7]  = {},         -- JP
    [8]  = {},         -- Zangief
    [9]  = {},         -- Cammy
    [10] = {},         -- Ken
    [11] = {},         -- Dee Jay
    [12] = {},         -- Lily
    [13] = {},         -- A.K.I.
    [14] = {},         -- Rashid
    [15] = {},         -- Blanka
    [16] = {17},       -- Guile
    [17] = {},         -- Marisa
    [18] = {10},       -- Chun-Li
    [19] = {11},       -- Ed
    [20] = {10},       -- E. Honda
    [21] = {},         -- Jamie
    [22] = {2, 16},    -- Akuma
    [23] = {},         -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {11}        -- Elena
}

if isWhiffReady(169, 185)
and getOpponentStartUpEndFrame() == 6
and whiffPunish6f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish6f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            OwlSleep(35)
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Crouching MP (7 frames)

whiffPunish7f = {
    [1]  = {},         -- Ryu
    [2]  = {},         -- Luke
    [3]  = {},         -- Kimberly
    [4]  = {},         -- Juri
    [5]  = {},         -- Manon
    [6]  = {},         -- Marisa
    [7]  = {},         -- JP
    [8]  = {10},       -- Zangief
    [9]  = {},         -- Cammy
    [10] = {},         -- Ken
    [11] = {10},       -- Dee Jay
    [12] = {},         -- Lily
    [13] = {},         -- A.K.I.
    [14] = {10},       -- Rashid
    [15] = {},         -- Blanka
    [16] = {},         -- Guile
    [17] = {},         -- Marisa
    [18] = {},         -- Chun-Li
    [19] = {},         -- Ed
    [20] = {},         -- E. Honda
    [21] = {},         -- Jamie
    [22] = {},         -- Akuma
    [23] = {},         -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {3}         -- Elena (original comment said Bison, but 26 = Elena per your table)
}

if isWhiffReady(175, 190)
and getOpponentStartUpEndFrame() == 7
and whiffPunish7f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish7f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Crouching MP (8 frames)

whiffPunish8f = {
    [1]  = {},         -- Ryu
    [2]  = {},         -- Luke
    [3]  = {},         -- Kimberly
    [4]  = {},         -- Juri
    [5]  = {},         -- Manon
    [6]  = {},         -- Marisa
    [7]  = {},         -- JP
    [8]  = {},         -- Zangief
    [9]  = {},         -- Cammy
    [10] = {},         -- Ken
    [11] = {},         -- Dee Jay
    [12] = {10},       -- Lily
    [13] = {},         -- A.K.I.
    [14] = {},         -- Rashid
    [15] = {10},       -- Blanka
    [16] = {},         -- Guile
    [17] = {},         -- Marisa
    [18] = {},         -- Chun-Li
    [19] = {},         -- Ed
    [20] = {},         -- E. Honda
    [21] = {},         -- Jamie
    [22] = {},         -- Akuma
    [23] = {},         -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {}          -- Elena
}

if isWhiffReady(170, 190)
and getOpponentStartUpEndFrame() == 8
and whiffPunish8f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish8f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            OwlSleep(20)
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Standing HK  (8 frames)

whiffPunish_StHK_8f = {
    [1]  = {4, 11, 17},       -- Ryu
    [2]  = {},                -- Luke
    [3]  = {5},               -- Kimberly
    [4]  = {6},               -- Juri
    [5]  = {},                -- Manon
    [6]  = {},                -- Marisa
    [7]  = {},                -- JP
    [8]  = {26},              -- Zangief
    [9]  = {5, 25, 26},       -- Cammy
    [10] = {5, 12},           -- Ken
    [11] = {},                -- Dee Jay
    [12] = {},                -- Lily
    [13] = {},                -- A.K.I.
    [14] = {5, 12},           -- Rashid
    [15] = {},                -- Blanka
    [16] = {6, 21},           -- Guile
    [17] = {},                -- Marisa
    [18] = {5},               -- Chun-Li
    [19] = {5},               -- Ed
    [20] = {},                -- E. Honda
    [21] = {5, 27},           -- Jamie
    [22] = {},                -- Akuma
    [23] = {},                -- Bison
    [24] = {},                -- Terry
    [25] = {},                -- Mai
    [26] = {3}                -- Elena
}

if isWhiffReady(170, 200)
and getOpponentStartUpEndFrame() == 8
and whiffPunish_StHK_8f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish_StHK_8f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            Do_StHK()
            break
        end
    end
end
--#endregion

--#region Whiff Punish with HK - All Far
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 205 and getOpponentDistance() <= 222)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 26 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 10 ) or  --bison
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 13 ) or --22 akuma 
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 10 ) or --8: Sim 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 29 and getOpponentStartUpEndFrame()== 11 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 9 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --18: Guile 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 41 ) or --17: Marisa 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 19 and getOpponentStartUpEndFrame()== 10 ) or --17: Marisa 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 10 ) or --17: Marisa 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 14 ) or --14: Rashid 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 11 ) or --14: Rashid 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --14: Rashid 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 13 ) or --12: Lily 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 12 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 9 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 11 ) or  --11: DJ 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 15 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 13 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 25 and getOpponentStartUpEndFrame()== 10 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --7: JP 
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 15 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 16 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 13 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 12 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --15: Blanka
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 39 and getOpponentStartUpEndFrame()== 9 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 10 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 12 ) or --6: Gief 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 15 ) or --3: Kim 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 11 ) or --3: Kim 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 7) or --19: Ed 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 13 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 12 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 10 ) or --5: Manon 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 68 and getOpponentStartUpEndFrame()== 9 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 69 and getOpponentStartUpEndFrame()== 9 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 70 and getOpponentStartUpEndFrame()== 9 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 10 and getOpponentStartUpEndFrame()== 12 ) or
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 10 ) or
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 10 and getOpponentStartUpEndFrame()== 12 ) or --13: AKI
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 30 and getOpponentStartUpEndFrame()== 10 ) or --13: AKI
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 10 ) or --13: AKI   
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 14 ) or --10: Ken 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 14 ) or --21: Jamie
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 12 ) or --21: Jamie
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 10 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 11 ) or --9: Cammy 
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 18 and getOpponentStartUpEndFrame()== 10 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 11 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 14 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 19 and getOpponentStartUpEndFrame()== 12 ) or   --1: Ryu
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 11 ) or  --20: Honda 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 13 ) or  --20: Honda 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 14 ) or  --20: Honda 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 14 )  --20: Honda 
)
then
Do_StHK()
end
--#endregion

--#region Whiff Punish With HK Replacement - ALL more far
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 230 and getOpponentDistance() <= 270)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 12 ) or --12: Lily 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 13 ) or --6: Gief 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 9 and getOpponentStartUpEndFrame()== 12 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 16 and getOpponentStartUpEndFrame()== 13 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 11 ) or --19: Ed 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 12 ) or --2: Luke
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 12 ) or --2: Luke
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 13 )  --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(100)
Do_StHK()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with MK - (270 - 300) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 235 and getOpponentDistance() <= 240)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --luke
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 23 and getOpponentStartUpEndFrame()== 10 ) or --juri
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 10 and getOpponentStartUpEndFrame()== 14 ) or --17: Marisa 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 14 ) or --7: JP 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 33 and getOpponentStartUpEndFrame()== 18 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 16 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 14 ) or --6: Gief 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 18 ) or --2: Luke
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 18 ) or --2: Luke
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 13 ) or --5: Manon 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 17 ) or --21: Jamie
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 9000 and getOpponentStartUpEndFrame()== 9000 )  --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(100)
PMedium()
OwlSleep(40)
RMedium()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with HK Replacement - (270 - 300) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 270 and getOpponentDistance() <= 300)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 20 ) or --juri
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 13 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 18 ) or --21: Jamie
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 9000 and getOpponentStartUpEndFrame()== 9000 )  --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(180)
Do_StHK()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching MP - (180 - 190) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 180 and getOpponentDistance() <= 190)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 26 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or  --bison
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or --3: Kim 
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 8 ) or --4: Chun
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 9 )   --22 akuma 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(15)
Do_CrMP()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Standing MP - (170 - 190) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 170 and getOpponentDistance() <= 190)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --8: Sim 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --14: Rashid 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --14: Rashid 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --12: Lily 	
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --12: Lily 	
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or  --11: DJ 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --19: Ed 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --2: Luke
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --5: Manon 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 7 ) or --16: Juri 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 19 and getOpponentStartUpEndFrame()== 7 ) or --juri
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --13: AKI 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --13: AKI 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --10: Ken 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 26 and getOpponentStartUpEndFrame()== 6 ) or --21: Jamie
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --21: Jamie
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --21: Jamie
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 26 and getOpponentStartUpEndFrame()== 9 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --9: Cammy 
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 ) or --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 16 and getOpponentStartUpEndFrame()== 6 ) or --1: Ryu
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 5 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --4: Chun
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 ) or  --22 akuma 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 )   --20: Honda 
)
then
DisableGameInput()  -- Commented out for debugging
OwlSleep(45)
Do_StMP()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion
 
--#region Whiff Punish with Crouching MP - (210 - 240) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 210 and getOpponentDistance() <= 240)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 39 and getOpponentStartUpEndFrame()== 7 ) or --8: Sim 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 ) or --18: Guile 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or  --11: DJ 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --7: JP 
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --15: Blanka
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --3: Kim 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --3: Kim 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 7 ) or --2: Luke
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --2: Luke 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 28 and getOpponentStartUpEndFrame()== 7 ) or --13: AKI 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 5 )   --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(45)
Do_CrMP()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching MP - (196 - 230) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 196 and getOpponentDistance() <= 230)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --luke
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 8 ) or --17: Marisa 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --6: Gief 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --5: Manon 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 )   --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(50)
Do_CrMP()
EnableGameInput()
OwlSleep(400)
setOpponentOldMethodMoveID(0)
end
--#endregion
 
--#region Whiff Punish with Crouching HK
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 201 and getOpponentDistance() <= 245)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 35 and getOpponentStartUpEndFrame()== 10 ) or --8: Sim 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or --18: Guile 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 18 and getOpponentStartUpEndFrame()== 7 ) or --17: Marisa 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 7 ) or --17: Marisa 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --14: Rashid 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 9 ) or --12: Lily 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --12: Lily 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 10 ) or --12: Lily 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 10 ) or --7: JP 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --19: Ed 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 8 ) or --2: Luke 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 13 ) or --5: Manon 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 9 ) or --13: AKI
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 28 and getOpponentStartUpEndFrame()== 9 ) or --21: Jamie
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 9 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 13 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 and getOpponentDistance() >= 230  ) or --9: Cammy 
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 29 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 31 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 13 ) or --4: Chun
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 9 ) or  --22 akuma 
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 20 and getOpponentStartUpEndFrame()== 11 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 15 )    --1: Ryu
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(40)
PDown()
PToward()
PHeavy()
OS(40)
RDown()
RToward()
RHeavy()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching HK - (215 - 280) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 215 and getOpponentDistance() <= 280)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
 --hard more delay cr.hk
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 18 and getOpponentStartUpEndFrame()== 10 ) or  --22 akuma 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 10 ) or --3: Kim 
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 33 and getOpponentStartUpEndFrame()== 13 ) or --8: Sim 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 20 and getOpponentStartUpEndFrame()== 11 ) or --17: Marisa 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 12 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --7: JP 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 10 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --19: Ed  
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 12 ) or --juri
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 13 and getOpponentDistance() >= 270 ) or --9: Cammy 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --13: AKI
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 )   --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(80)
PDown()
PToward()
PHeavy()
OwlSleep(40)
RDown()
RToward()
RHeavy()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching MK
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 170 and getOpponentDistance() <= 200)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 6 )  --19: Ed 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(120)
PressInputDownButton()
PMedium()
OwlSleep(40)
ReleaseInputDownButton()
RMedium()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end 
--#endregion

--#endregion! ============================================== WHIFF PUNISH

--#region! ================================================ ANTI CHARACTERS

--

--#endregion! ============================================= ANTI CHARACTERS


--------------------------------------------
end ---- END OF CHARACTER ------------------
--#endregion= ============================== 07 - JP

--#region= ================================= 18 - Guile
if getLocalCharacterID() == 18 then
    --------------------------------------------    

function OwlSleepFrame(frames)
    OwlSleep(frames * 20)
    --print(frames * 20)
end

    --#region AA Flash Kick Tutorial    
if (getLocalAnimationID()==14 or getLocalAnimationID()==4) -- Do I have charge?
and getOpponentDistance() <= 200 -- Is the opponent in range?
and getOpponentAnimationID() == 37 -- Is the Opponent Jumping toward me.  36 is Neutral jump 37 is forward jump and 38 is back jump
then -- what we will do
    DisableGameInput() -- so you dont mess up the input
    PressInputLightKick() -- Press the light kick button
    PressInputUpButton() -- Press the up button 
    OwlSleep(40) -- wait time ie how long you are holding the button.  20 = 1 frame so 40 would be 2 frames etc
    ReleaseInputLightKick() -- realease the light kick button
    ReleaseInputUpButton() -- realease the up button 
    EnableGameInput() -- re-enable the input so you can play again
end
--#endregion 

--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 220
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
OwlSleepFrame(3)
PressInputHardPunch()
OwlSleepFrame(2)
ReleaseInputHardPunch() 
EnableGameInput()
setOpponentOldMethodMoveID(0)
setOpponentAnimationID(1)
OwlSleep(300)
end
--#endregion

--------------------------------------------
end ---- END OF CHARACTER ------------------
--#endregion= ============================== 18 - Guile

--#region= ================================= 20 - Honda
if getLocalCharacterID() == 20 then
--------------------------------------------    

--#region! ================================================ BUTTONS

--#region Standing LP
function Do_StLP()
    DisableGameInput()

    if Classic then
        PLP()
        OS(40)
        RLP()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LP
function Do_CrLP()
    DisableGameInput()

    if Classic then
        PDown()
        PLP()
        OS(40)
        RLP()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MP
function Do_StMP()
    DisableGameInput()

    if Classic then
        PMP()
        OS(40)
        RMP()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MP
function Do_CrMP()
    DisableGameInput()

    if Classic then
        PDown()
        PMP()
        OS(40)
        RMP()
        RDown()
        
    elseif Modern then
        PAssist()
        PMedium()
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HP
function Do_StHP()
    DisableGameInput()

    if Classic then
        PHP()
        OS(40)
        RHP()
        
    elseif Modern then
        print(getLocalMoveTimer())
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HP
function Do_CrHP()
    DisableGameInput()

    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RDown()
        RToward()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Standing LK
function Do_StLK()
    DisableGameInput()

    if Classic then
        PLK()
        OS(40)
        RLK()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LK
function Do_CrLK()
    DisableGameInput()

    if Classic then
        PDown()
        PLK()
        OS(40)
        RLK()
        RDown()
        
    elseif Modern then
        PAssist()
        PLight()
        OS(40)
        RLight()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MK
function Do_StMK()
    DisableGameInput()

    if Classic then
        PMK()
        OS(40)
        RMK()
        
    elseif Modern then
        PMedium()
        OS(40)
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MK
function Do_CrMK()
    DisableGameInput()

    if Classic then
        PDown()
        PMK()
        OS(40)
        RMK()
        RDown()
        
    elseif Modern then
        PDown()
        PMedium()
        OS(40)
        RMedium()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HK
function Do_StHK()
    DisableGameInput()

    if Classic then
        PHK()
        OS(40)
        RHK()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HK
function Do_CrHK()
    DisableGameInput()

    if Classic then
        PDown()
        PHK()
        OS(40)
        RHK()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RHeavy()
        RDown()
        RToward()
    end

    EnableGameInput()
end
--#endregion

--#region Block High
function BlockHigh()
    PBack()
    OS(math.random(80, 120))
    RBack()
    EnableGameInput()
end 
--#endregion

--#region Block Low
function BlockLow()
    PDown()
    PBack()
    OS(math.random(60, 120))
    RDown()
    RBack()
    OS(200)
    EnableGameInput()
end 
--#endregion

--#region Drive Rush
function DriveRush()
    PParry()
    OS(40)
    PToward()
    OS(20)
    RToward()
    OS(20)
    PToward()
    OS(20)
    RToward()
    RParry()
end
--#endregion

--#region Throw
function Throw()
    DisableGameInput()

    if Classic then
        PLP()
        PLK()
        OS(40)
        RLP()
        RLK()
        
    elseif Modern then
        PLight()
        PMedium()
        OS(40)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region QCF 
function QCF()
    PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	OS(30)
	RToward()
end
--#endregion

--#region QCB 
function QCB()
    PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	OS(30)
	RBack()
end
--#endregion

--#endregion! ============================================= MOVE FUNCTIONS

--#region! ================================================ LIGHT PUNCH

--#region Standing LP
if HitConfirm(3, 200) then
    DisableGameInput()
    
    if Classic then
        --NA
    elseif Modern then
        ifStun(PLight)
        OS(60)
        RLight()
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching LP
if HitConfirm(10, 200) then
    DisableGameInput()
    
    if Classic then
        --NA
    elseif Modern then
        DisableGameInput()
        ifStun(PDown)
        ifStun(PLight)
        OS(80)
        RLight()
        OS(60)
        RDown()
        ifStun(PUp)
        ifStun(PToward)
        ifStun(PLight)
        OS(20)
        RLight()
        RUp()
        RToward()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT PUNCH

--#region! ================================================ MEDIUM PUNCH

--#region Standing MP - Kill Combo LVL 1
if HitConfirm(5, 200, 30001)  and getOpponentHealthMeter() <= 3015 and getLocalSAMeter() >= 10000
then
    --print(getLocalMoveTimer())
    DisableGameInput() 
    MoveTimer(9, 0)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP - Kill Combo LVL 2
if HitConfirm(5, 200, 30001)  and getOpponentHealthMeter() <= 3535 and getLocalSAMeter() >= 20000
then
    DisableGameInput() 
    MoveTimer(9, 0)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP - Kill Combo LVL 3 Max Damage CA + Buff
if HitConfirm(5, 200, 30001)  and getOpponentHealthMeter() <= 5190 and getLocalSAMeter() == 30000
and getLocalStockInteger() ==1 and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(9, 0)
    KillCombo_LVL3_Max()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP - Kill Combo LVL 3 With CA
if HitConfirm(5, 200, 30001)  and getOpponentHealthMeter() <= 5070 and getLocalSAMeter() == 30000
and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(9, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP - Kill Combo LVL 3
if HitConfirm(5, 200, 30001)  and getOpponentHealthMeter() <= 4820 and getLocalSAMeter() == 30000
then
    DisableGameInput() 
    MoveTimer(9, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP (with Meter)
if HitConfirm(5, 200, 40001) then
    print("------------------- Standing MP (Confirm) (with Meter) --------------")
    DisableGameInput() 
    
    if Classic then
        -- NA
        
    elseif Modern then
        MoveTimer(9, 0)
        ifStun(PParry)
        OS(320)
        RParry()
        OS(100)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(580)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(200) -- Second Loop if can Kill
        ifStun(PToward) -- Start launcher
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown() -- End of Launcher
        MoveTimer(8, 0)
        ifStun(function() OS(1300) end) -- Wait time after launcher
        
        if getLocalStockInteger() == 1 then
            ifStun(QCB) -- HP Hands Start
            OS(40)
            ifStun(PHeavy)
            OS(20)
            RHeavy() -- HP Hands End
            
            if getLocalStockInteger() == 1 then
                ifStun(function() OS(900) end) -- Hands Wait Time
                ifStun(function() OS(900) end) -- Buff Wait Time
                ifStun(PSpecial)
                OS(20)
                RSpecial()
                EnableGameInput()
            end
        else
            --MoveTimer(38, 0)
            ifStun(GetBuff_Combo)
        end
        
        EnableGameInput()
    end  

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
    print("---------------------------------------------------------------------")
end
--#endregion

--#region Standing MP
if HitConfirm(5, 200)  
then
    DisableGameInput() 
    
    if Classic then
        --NA
    elseif Modern then
        MoveTimer(9, 0)
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP - Kill Combo LVL 1
if HitConfirm(12, 200, 30001) and getOpponentHealthMeter() <= 3015 and getLocalSAMeter() >= 10000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP - Kill Combo LVL 2
if HitConfirm(12, 200, 30001) and getOpponentHealthMeter() <= 3535 and getLocalSAMeter() >= 20000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP - Kill Combo LVL 3 Max Damage CA + Buff
if HitConfirm(12, 200, 30001)  and getOpponentHealthMeter() <= 5190 and getLocalSAMeter() == 30000
and getLocalStockInteger() ==1 and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3_Max()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP - Kill Combo LVL 3 With CA
if HitConfirm(12, 200, 30001)  and getOpponentHealthMeter() <= 5070 and getLocalSAMeter() == 30000
and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP - Kill Combo LVL 3
if HitConfirm(12, 200, 30001) and getOpponentHealthMeter() <= 4820 and getLocalSAMeter() >= 30000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP
if HitConfirm(12, 200)  
then
    DisableGameInput() 
    
    if Classic then
        --NA
    elseif Modern then
        MoveTimer(7, 0)
        QCB()
        PHeavy()
        OS(20)
        RHeavy()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Target Combo MP with Buff
if  getLocalOldMethodMoveID() == 37 
and getOpponentStunnedStateBeta() ~= 0 
and getLocalInAirByte() ~= 2
and getOpponentDistance() <= 200
and getLocalStunnedStateBeta() == 0
and getLocalStockInteger() ==1
then
    DisableGameInput() 
    
    if Classic then
        --NA
    elseif Modern then
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(function() OS(900) end) -- Hands Wait Time
        ifStun(function() OS(1000) end)-- Buff Wait Time
        ifStun(PSpecial)
        OS(20)
        RSpecial()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Target Combo MP
if  getLocalOldMethodMoveID() == 37 
and getOpponentStunnedStateBeta() ~= 0 
and getLocalInAirByte() ~= 2
and getOpponentDistance() <= 200
and getLocalStunnedStateBeta() == 0
then
    DisableGameInput() 
    
    if Classic then
        --NA
    elseif Modern then
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--[[#region Target Combo Overhead is Blocked
if   getLocalOldMethodMoveID() == 5 
and getOpponentStunnedStateBeta() == 0 
--and getOpponentInAirByte() ~= 2 
and getLocalInAirByte() ~= 2
and getOpponentDistance() <= 90
and getLocalStunnedStateBeta() == 0
and PROBABILITY()
then
    DisableGameInput() 
    
    if Classic then
        --NA
    elseif Modern then
        OS(40)
        PDown()
        PToward()
        PMedium()
        OS(40)
        RDown()
        RToward()
        RMedium()
        OS(480)
        PDown()
        PSpecial()
        OS(20)
        RSpecial()
        RDown()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion
--]]
--#endregion! ============================================= MEDIUM PUNCH

--#region! ================================================ HEAVY PUNCH


--#region Punish Counter Delay Far - Kill Combo LVL 1
if HitConfirm(7, 200, 30001) and getOpponentIsBeingCounterPunish() == true 
and getOpponentHealthMeter() <= 3330 and getLocalSAMeter() >= 10000
then
    print("Punish Counter St HP - Juggle Kill Combo LVL 1")
    DisableGameInput()
    MoveTimer(10, 700)
    DriveRush()
    OS(200)
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    OS(250)
    ifStun(KillCombo_LVL1_Juggle)
    EnableGameInput()
end
--#endregion

--#region Punish Counter Delay Far - Kill Combo LVL 3
if HitConfirm(7, 200, 30001) and getOpponentIsBeingCounterPunish() == true 
and getOpponentHealthMeter() <= 4730 and getLocalSAMeter() >= 30000
then
    print("Punish Counter St HP - Juggle Kill Combo LVL 3")
    DisableGameInput()
    MoveTimer(10, 700)
    DriveRush()
    OS(200)
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    OS(250)
    ifStun(KillCombo_LVL3_Juggle)
    EnableGameInput()
end
--#endregion

--#region Punish Counter St HP - Juggle
if HitConfirm(7, 200) and getOpponentDistance() <= 130 and getOpponentIsBeingCounterPunish() == true
then
    print("Punish Counter St HP - Juggle")
    DisableGameInput()
    MoveTimer(10, 700)
    --OS(700)
    ifStun(DriveRush)
    OS(200)
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    OS(250)
    ifStun(PToward)
    ifStun(PSpecial)
    OS(40)
    RSpecial()
    RToward()
    ifStun(function() OS(300) end)
    ifStun(PDown)
    ifStun(PSpecial)
    OS(20)
    RSpecial()
    ifStun(function() OS(1400) end) -- Wait time for launcher
    RDown()
    ifStun(PUp)
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    RUp()
    EnableGameInput()
end
--#endregion

--#region Standing HP - Kill Combo LVL 1
if HitConfirm(7, 200, 30001)  and getOpponentHealthMeter() <= 3015 and getLocalSAMeter() >= 10000
then
    print(getLocalMoveTimer())
    MoveTimer(7, 0)
    --OS(100)
    DisableGameInput() 
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP - Kill Combo LVL 2
if HitConfirm(7, 200, 30001)  and getOpponentHealthMeter() <= 3535 and getLocalSAMeter() >= 20000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP - Kill Combo LVL 3 Max Damage CA + Buff
if HitConfirm(7, 200, 30001)  and getOpponentHealthMeter() <= 5190 and getLocalSAMeter() == 30000
and getLocalStockInteger() ==1 and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3_Max()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP - Kill Combo LVL 3 With CA
if HitConfirm(7, 200, 30001)  and getOpponentHealthMeter() <= 5070 and getLocalSAMeter() == 30000
and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP - Kill Combo LVL 3
if HitConfirm(7, 200, 30001)  and getOpponentHealthMeter() <= 4820 and getLocalSAMeter() == 30000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP 
if HitConfirm(7, 131) then  -- and getOpponentIsBeingCounterPunish() == false 
    print("------------------- Standing HP (Confirm) ---------------------------") 
    DisableGameInput()

    if Classic then
        --NA
        
    elseif Modern then
        DisableGameInput()
        MoveTimer(7, 0)
        ifStun(PToward)
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown()
        MoveTimer(8, 0)
        ifStun(function() OS(1300) end) -- Wait time after launcher
        if getLocalStockInteger() == 1 then
            ifStun(QCB) -- HP Hands Start
            OS(40)
            ifStun(PHeavy)
            OS(20)
            RHeavy() -- HP Hands End
            if getLocalStockInteger() == 1 then
                ifStun(function() OS(900) end) -- Hands Wait Time
                ifStun(function() OS(900) end) -- Buff Wait Time
                ifStun(PSpecial)
                OS(20)
                RSpecial()
                EnableGameInput()
            end
        else
            --MoveTimer(38, 0)
            ifStun(GetBuff_Combo)
        end
        
        EnableGameInput()
    end

    EnableGameInput()
    --OwlSleep(300)
    setOpponentOldMethodMoveID(0)
    print("---------------------------------------------------------------------")
end
--#endregion

--#endregion! ============================================ HEAVY PUNCH

--#region! ================================================ LIGHT KICK

-- Nothing Yet

--#endregion! ============================================= LIGHT KICK

--#region! ================================================ MEDIUM KICK

--#region Crouching MK - Counter / Punish 
if HitConfirm(13, 140, 0, "Both") 
then
    DisableGameInput()

    if Classic then
        --NA
        
    elseif Modern then
        DisableGameInput()
        OS(400)
        ifStun(PAssist)
        ifStun(PMedium)
        OS(20)
        RMedium()
        RAssist()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MK
if HitConfirm(13, 106)
then
    DisableGameInput()

    if Classic then
        --NA
        
    elseif Modern then
        DisableGameInput()
        OS(420)
        ifStun(PLight)
        OS(20)
        RLight()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM KICK

--#region! ================================================ HEAVY KICK

--#region Max Range Standing HK on Punish Counter with Meter
if HitConfirm(8, 200, 30001) and getOpponentDistance() > 131 and getOpponentIsBeingCounterPunish() == true
then
    OS(100)
end
--#endregion

--#region Standing HK - Kill Combo LVL 1
if HitConfirm(8, 200, 30001)  and getOpponentHealthMeter() <= 3015 and getLocalSAMeter() >= 10000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK - Kill Combo LVL 2
if HitConfirm(8, 131, 30001)  and getOpponentHealthMeter() <= 3535 and getLocalSAMeter() >= 20000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK - Kill Combo LVL 3 Max Damage CA + Buff
if HitConfirm(8, 131, 30001)  and getOpponentHealthMeter() <= 5190 and getLocalSAMeter() == 30000
and getLocalStockInteger() ==1 and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3_Max()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK - Kill Combo LVL 3 With CA
if HitConfirm(8, 131, 30001)  and getOpponentHealthMeter() <= 5070 and getLocalSAMeter() == 30000
and getLocalHealthMeter() <= 2500
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK - Kill Combo LVL 3
if HitConfirm(8, 131, 30001)  and getOpponentHealthMeter() <= 4820 and getLocalSAMeter() == 30000
then
    DisableGameInput() 
    MoveTimer(7, 0)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK 
if HitConfirm(8, 200) and getOpponentDistance() >131 and getOpponentIsBeingCounterPunish() == false and getOpponentIsBeingCounterHit() == false 
then
    DisableGameInput()

    if Classic then
        --NA
        
    elseif Modern then
        DisableGameInput()
        MoveTimer(7, 0)
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK on Counter and Close Regular
if HitConfirm(8, 131) and getOpponentIsBeingCounterPunish() == false -- and getOpponentIsBeingCounterHit() == true 
then
    DisableGameInput()

    if Classic then
        --NA
        
    elseif Modern then
        DisableGameInput()
        ifStun(PToward)
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        OS(300)
        ifStun(PDown)
        PSpecial()
        OS(20)
        RSpecial()
        RDown()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Max Range Standing HK on Punish Counter without Meter
if  getLocalOldMethodMoveID() == 8 
and getOpponentStunnedStateBeta() ~= 0 
and getLocalInAirByte() ~= 2
and getOpponentDistance() >= 200
and getLocalStunnedStateBeta() == 0
--and getLocalSAMeter() < 30000
and getOpponentIsBeingCounterPunish() == true
then
    DisableGameInput() 
    
    if Classic then
        --NA
    elseif Modern then
        PLight()
        PSpecial()
        OS(20)
        RSpecial()
        ifStun(QCB)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RLight()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region You mashed HK and OD Hands Came out
if HitConfirm(163, 200)
then
    EnableGameInput()
end
--#endregion

--#endregion! ============================================= HEAVY KICK

--#region! ================================================ OVERHEAD

--#region Overhead (Punish)
if HitConfirm(38, 220) then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        PLight()
        OS(20)
        RLight()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= OVERHEAD

--#region! ================================================ HANDS

--#region LP Hands Extension With Buff
if HitConfirm(55, 220)  
then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        DisableGameInput()
        ifStun(PDown)
        ifStun(function() OS(900) end)  -- Hands Wait Time 
        ifStun(PLight)
        ifStun(function() OS(60) end)
        RLight()
        ifStun(function() OS(40) end)
        RDown()
        ifStun(function() OS(20) end)
        ifStun(PUp)
        ifStun(PToward)
        ifStun(PLight)
        ifStun(function() OS(1000) end) -- Splash wait time
        RLight()
        RUp()
        RToward()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region MP Hands Extension With Buff
if HitConfirm(56, 220)  
then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        DisableGameInput()
        ifStun(PDown)
        ifStun(function() OS(1200) end)  -- Hands Wait Time 
        ifStun(PLight)
        ifStun(function() OS(60) end)
        RLight()
        ifStun(function() OS(40) end)
        RDown()
        ifStun(function() OS(20) end)
        ifStun(PUp)
        ifStun(PToward)
        ifStun(PLight)
        ifStun(function() OS(1000) end) -- Splash wait time
        RLight()
        RUp()
        RToward()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region HP Hands Extension With Buff
if HitConfirm(57, 220)  
then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        DisableGameInput()
        ifStun(PDown)
        ifStun(function() OS(1400) end)  -- Hands Wait Time 
        ifStun(PLight)
        ifStun(function() OS(60) end)
        RLight()
        ifStun(function() OS(40) end)
        RDown()
        ifStun(function() OS(20) end)
        ifStun(PUp)
        ifStun(PToward)
        ifStun(PLight)
        ifStun(function() OS(1000) end) -- Splash wait time
        RLight()
        RUp()
        RToward()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region OD Hands Extension With Buff
if HitConfirm(164, 220, 999999)  -- Disabled for now. 
then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        DisableGameInput()
        ifStun(PDown)
        ifStun(function() OS(1300) end)  -- Hands Wait Time 
        PAssist()
        ifStun(PLight)
        ifStun(function() OS(60) end)
        RAssist()
        RLight()
        ifStun(function() OS(40) end)
        RDown()
        ifStun(function() OS(20) end)
        PDown()
        OS(20)
        RDown()
        OS(80)
        PDown()
        PLight()
        OS(20)
        RLight()
        RDown()
        EnableGameInput()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#endregion! ============================================= HANDS

--#region! ================================================ SUMO SPIRIT

--#region Get Buff After Wall Splat
if getOpponentAnimationID() == 331 and getOpponentDistance() >= 400 and getLocalStockInteger() == 0
then
    print("Get Buff After Far Wall Splat")
    print("Animation ID: " .. getOpponentAnimationID() .. " Distance: " .. getOpponentDistance()) 
    DisableGameInput()
    --OS(700)
    PDown()
    OS(20)
    RDown()
    OS(20)
    PDown()
    PHeavy()
    OS(20)
    RDown()
    OS(20)
    RHeavy()
    PDown()
    OS(20)
    RDown()
    OS(20)
    PDown()
    PHeavy()
    OS(20)
    RDown()
    OS(20)
    RHeavy()
    OS(200)
    EnableGameInput()
end
--#endregion

--#region Get Buff After Normal Knockdowns
if getOpponentAnimationID() == 253 and getOpponentDistance() >= 117 and getLocalStockInteger() == 0
then
    print("Get Buff After Normal Knockdowns")
    print("Animation ID: " .. getOpponentAnimationID() .. " Distance: " .. getOpponentDistance()) 
    DisableGameInput()
    OS(600)
    PDown()
    OS(20)
    RDown()
    OS(20)
    PDown()
    PHeavy()
    OS(20)
    RDown()
    OS(20)
    RHeavy()
    PDown()
    OS(20)
    RDown()
    OS(20)
    PDown()
    PHeavy()
    OS(20)
    RDown()
    OS(20)
    RHeavy()
    PBack()
    OS(1000) -- Block Time
    RBack()
    EnableGameInput()
end
--#endregion

--#region Get Buff After Close HeadButt
if getOpponentAnimationID() == 246 and getOpponentDistance() >= 75 and getLocalStockInteger() == 0
then
    print("Get Buff After Close HeadButt")
    print("Animation ID: " .. getOpponentAnimationID() .. " Distance: " .. getOpponentDistance()) 
    DisableGameInput()
    OS(600)
    PDown()
    OS(20)
    RDown()
    OS(20)
    PDown()
    PHeavy()
    OS(20)
    RDown()
    OS(20)
    RHeavy()
    PDown()
    OS(20)
    RDown()
    OS(20)
    PDown()
    PHeavy()
    OS(20)
    RDown()
    OS(20)
    RHeavy()
    PBack()
    OS(1000) -- Block Time
    RBack()
    EnableGameInput()
end
--#endregion



--#endregion! ============================================= SUMO SPIRIT

--#region! ================================================ COMBOS

--#region Kill Combo LVL 1
function KillCombo_LVL1()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PParry)
        OS(320)
        RParry()
        OS(100)
        ifStun(PMedium)
        OS(20)
        RMedium()
        MoveTimer(15, 580) -- Fix Combo Timing
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        --MoveTimer(15, 300) -- Test Timer --- orig 300
        OS(300) -- Second Loop if can Kill
        ifStun(PParry)
        OS(20)
        RParry()
        OS(200)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(750)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- End of Loop
        OS(200)
        ifStun(PToward) -- Start launcher
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown() -- End of Launcher
        ifStun(function() OS(1400) end) -- Wait time after launcher
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(20)
        RSpecial()
        RHeavy()
    end
end
--#endregion

--#region Kill Combo LVL 1 - Juggle
function KillCombo_LVL1_Juggle()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PToward)
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        OS(300)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        ifStun(function() OS(1400) end) -- Wait time for launcher
        RDown()
        ifStun(DriveRush)
        OS(200)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(250)
        ifStun(PParry)
        OS(20)
        RParry()
        OS(300)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(PToward)
        OS(420) --- lvl 1 timing
        RToward()
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(function() OS(1600) end) -- Hands wait time
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        RSpecial()
    end
end
--#endregion

--#region Kill Combo LVL 2
function KillCombo_LVL2()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PParry)
        ifStun(function() OS(320) end)
        RParry()
        OS(100)
        ifStun(PMedium)
        OS(20)
        RMedium()
        MoveTimer(15, 580) -- Fix Combo Timing
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(300) -- Second Loop if can Kill
        ifStun(PParry)
        OS(20)
        RParry()
        OS(200)
        ifStun(PMedium)
        OS(20)
        RMedium()
        ifStun(function() OS(750) end)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- End of Loop
        ifStun(function() OS(200) end)
        ifStun(PToward) -- Start launcher
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown() -- End of Launcher
        ifStun(PBack)
        ifStun(function() OS(1400) end) -- Wait time after launcher
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(80)
        RSpecial()
        RHeavy()
        RBack()
    end
end
--#endregion

--#region Kill Combo LVL 3
function KillCombo_LVL3()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PParry)
        OS(320)
        RParry()
        OS(100)
        ifStun(PMedium)
        OS(20)
        RMedium()
        MoveTimer(14, 580) -- Fix Combo Timing
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(300) -- Second Loop if can Kill
        ifStun(PParry)
        OS(20)
        RParry()
        OS(200)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(750)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- End of Loop
        OS(200)
        ifStun(PToward) -- Start launcher
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown() -- End of Launcher
        ifStun(function() OS(1300) end) -- Wait time after launcher
        ifStun(QCB) -- HP Hands Start
        OS(40)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- HP Hands End
        ifStun(function() OS(900) end) -- Hands Wait Time
        ifStun(PDown)
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(90)
        RSpecial()
        RHeavy()
        RDown()
    end
end
--#endregion

--#region Kill Combo LVL 3 - Juggle
function KillCombo_LVL3_Juggle()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PToward)
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        OS(300)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        ifStun(function() OS(1400) end) -- Wait time for launcher
        RDown()
        ifStun(DriveRush)
        OS(200)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(250)
        ifStun(PParry)
        OS(20)
        RParry()
        OS(300)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(PToward)
        OS(420) --- lvl 1 timing
        RToward()
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(PBack)
        ifStun(function() OS(1000) end) -- Hands wait time
        ifStun(function() OS(460) end) -- Micro Walk
        RBack()
        ifStun(PDown)
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        RSpecial()
        RDown()
        ifStun(PDown) -- Mash Super for Corner Timing
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        RSpecial()
        RDown()
    end
end
--#endregion

--#region Kill Combo LVL 3 Max Damage  CA + Buff
function KillCombo_LVL3_Max()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PParry)
        OS(320)
        RParry()
        OS(100)
        ifStun(PMedium)
        OS(20)
        RMedium()
        MoveTimer(14, 580) -- Fix Combo Timing
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(300) -- Second Loop if can Kill
        ifStun(PParry)
        OS(20)
        RParry()
        OS(200)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(750)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- End of Loop
        OS(200)
        ifStun(PToward) -- Start launcher
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown() -- End of Launcher
        ifStun(function() OS(1300) end) -- Wait time after launcher
        ifStun(QCB) -- HP Hands Start
        OS(40)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- HP Hands End
        --PBack()
        ifStun(function() OS(900) end) -- Hands Wait Time
        ifStun(function() OS(900) end)-- Buff Wait Time
        --RBack()
        --PToward()
        ifStun(PSpecial)
        OS(20)
        --RToward()
        RSpecial()
        ifStun(function() OS(340) end)
        ifStun(PDown)
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(90)
        RSpecial()
        RHeavy()
        RDown()
    end
end
--#endregion

--#region Dizzy Combo

if getOpponentAnimationID() == 353 -- Dizzy
then
    DisableGameInput()
    ifStun(function() OS(400) end)
    ifStun(PDown)
    OS(20)
    RDown()
    OS(20)
    ifStun(PDown)
    OS(20)
    RDown()
    OS(20)
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    OS(800)
    ifStun(PToward)
    ifStun(PUp)
    OS(600) -- Jump Time
    RUp()
    RToward()
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    ifStun(function() OS(400) end)  -- Wait time for St HP
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    EnableGameInput()
end


--#endregion

--#region Get Buff Combo Extension 

function GetBuff_Combo()

    if Classic then
        --NA
    elseif Modern then
        print("----- Starting Buff Combo) -----") 
        ifStun(DriveRush)
        ifStun(function() OS(300) end)
        ifStun(PToward)
        ifStun(PMedium)
        OS(20)
        RMedium()
        RToward()
        OS(80)
        ifStun(PDown)
        ifStun(PToward)
        ifStun(PMedium)
        OS(40)
        RDown()
        RToward()
        RMedium()
        ifStun(function() OS(920) end) -- Wait Time for Buff Cancel
        ifStun(PDown)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(20)
        ifStun(PMedium)
        OS(20)
        RMedium()
        RDown()
        EnableGameInput()
    end
end

--#endregion


--#endregion! ============================================= COMBOS

--#region! ================================================ PUNISH AREA

--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 220  
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
PToward()  
OS(60)
RToward()
PMedium()
OS(20)  
RMedium()
EnableGameInput()
setOpponentOldMethodMoveID(0)
setOpponentAnimationID(1)
OS(300)
end
--#endregion

--#endregion! ============================================= PUNISH AREA

--------------------------------------------
end -- END OF CHARACTER 
--#endregion= ============================== 20 - Honda
    
--#region= ================================= 22 - Akuma
if getLocalCharacterID() == 22 then
    --------------------------------------------    

--#region! ================================================ BUTTONS

--#region Standing LP
function Do_StLP()
    DisableGameInput()

    if Classic then
        PLP()
        OS(40)
        RLP()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LP
function Do_CrLP()
    DisableGameInput()

    if Classic then
        PDown()
        PLP()
        OS(40)
        RLP()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MP
function Do_StMP()
    DisableGameInput()

    if Classic then
        PMP()
        OS(40)
        RMP()
        
    elseif Modern then
        PAssist()
        PMedium()
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MP
function Do_CrMP()
    DisableGameInput()

    if Classic then
        PDown()
        PMP()
        OS(40)
        RMP()
        RDown()
        
    elseif Modern then
        ifStun(PAssist)
        ifStun(PMedium)
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HP
function Do_StHP()
    DisableGameInput()

    if Classic then
        PHP()
        OS(40)
        RHP()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HP
function Do_CrHP()
    DisableGameInput()

    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RDown()
        RToward()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Standing LK
function Do_StLK()
    DisableGameInput()

    if Classic then
        PLK()
        OS(40)
        RLK()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LK
function Do_CrLK()
    DisableGameInput()

    if Classic then
        PDown()
        PLK()
        OS(40)
        RLK()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RAssist()
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MK
function Do_StMK()
    DisableGameInput()

    if Classic then
        PMK()
        OS(40)
        RMK()
        
    elseif Modern then
        PMedium()
        OS(40)
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MK
function Do_CrMK()
    DisableGameInput()

    if Classic then
        PDown()
        PMK()
        OS(40)
        RMK()
        RDown()
        
    elseif Modern then
        PDown()
        PMedium()
        OS(40)
        RMedium()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HK
function Do_StHK()
    DisableGameInput()

    if Classic then
        PHK()
        OS(40)
        RHK()
        
    elseif Modern then
        PAssist()
        PHeavy()
        OS(40)
        RHeavy()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HK
function Do_CrHK()
    DisableGameInput()

    if Classic then
        PDown()
        PHK()
        OS(40)
        RHK()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RHeavy()
        RDown()
        RToward()
    end

    EnableGameInput()
end
--#endregion

--#region SA1
function Do_LVL1()
    DisableGameInput()
    if Classic then
        -- Missing
    elseif Modern then
        QCF()
        QCF()
        PLight()
        OS(40)
        RLight()
    end
    EnableGameInput()
end
--#endregion

--#region SA2
function Do_LVL2()
    DisableGameInput()
    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
    elseif Modern then
        QCB()
        QCB()
        PMedium()
        OS(40)
        RMedium()
    end
    EnableGameInput()
end
--#endregion

--#region SA3
function Do_LVL3()
    DisableGameInput()
    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
    elseif Modern then
        QCF()
        QCF()
        PHeavy()
        OS(40)
        RHeavy()
    end
    EnableGameInput()
end
--#endregion

--#region Block High
function BlockHigh()
    PBack()
    OS(math.random(80, 120))
    RBack()
    EnableGameInput()
end 
--#endregion

--#region Block Low
function BlockLow()
    PDown()
    PBack()
    OS(math.random(60, 120))
    RDown()
    RBack()
    OS(200)
    EnableGameInput()
end 
--#endregion

--#region Drive Rush
function DriveRush()
    PParry()
    OS(40)
    PToward()
    OS(20)
    RToward()
    OS(20)
    PToward()
    OS(20)
    RToward()
    RParry()
end
--#endregion

--#region Throw
function Throw()
    DisableGameInput()

    if Classic then
        PLP()
        PLK()
        OS(40)
        RLP()
        RLK()
        
    elseif Modern then
        PLight()
        PMedium()
        OS(40)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region QCF 
function QCF()
    PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	OS(30)
	RToward()
end
--#endregion

--#region QCB 
function QCB()
    PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	OS(30)
	RBack()
end
--#endregion

--#endregion! ============================================= BUTTONS

--#region! ================================================ CHARACTER MOVES / ACTIONS

--#region MP AdFlame 
function AdFlameMP()
    DisableGameInput()
	PBack()
    PSpecial()
    OS(20)
    RBack()
    RSpecial()
    EnableGameInput()
end
--#endregion 

--#region MP AdFlame 
function AdFlameOD()
    DisableGameInput()
    PAssist()
	PBack()
    PSpecial()
    OS(20)
    RBack()
    RSpecial()
    RAssist()
    EnableGameInput()
end
--#endregion 

--#region Teleport
function Teleport()
    DisableGameInput()
    PToward()
    PLight()
    PMedium()
    PHeavy()
    OS(20)
    RToward()
    RLight()
    RMedium()
    RHeavy()
    EnableGameInput()
end
--#endregion

--#region OD Shoryuken 
function ShoryukenOD()
    DisableGameInput()
	PToward()
    PAssist()
    PSpecial()
    OS(20)
    RToward()
    RAssist()
    RSpecial()
    EnableGameInput()
end
--#endregion 

--#region LP Shoryuken 
function ShoryukenLP()
    DisableGameInput()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PLight()
    OS(20)
    RToward()
    RLight()
    EnableGameInput()
end
--#endregion 

--#region MP Shoryuken 
function ShoryukenMP()
    DisableGameInput()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PMedium()
    OS(20)
    RToward()
    RMedium()
    EnableGameInput()
end
--#endregion 

--#region HP Shoryuken 
function ShoryukenHP()
    DisableGameInput()
	PToward()
    PSpecial()
    OS(20)
    RToward()
    RSpecial()
    EnableGameInput()
end
--#endregion 

--#region LK Tatsu 
function TatsuLK()
    DisableGameInput()
	QCB()
    PLight()
    OS(20)
    RLight()
    EnableGameInput()
end
--#endregion 

--#region MK Tatsu 
function TatsuMK()
    DisableGameInput()
	QCB()
    PMedium()
    OS(20)
    RMedium()
    EnableGameInput()
end
--#endregion 

--#region HK Tatsu 
function TatsuHK()
    DisableGameInput()
	QCB()
    PHeavy()
    OS(20)
    RHeavy()
    EnableGameInput()
end
--#endregion 

--#endregion! ================================================ CHARACTER MOVES / ACTIONS

--#region! ================================================ LIGHT PUNCH

--#region Standing Light Punch
if HitConfirm(2, 150, 0, 0, "St LP") then
    DisableGameInput()
    OwlSleep(40)

    -- Counter Hit
    if getOpponentDistance() <= 150 
    and getOpponentStunnedStateBeta() ~= 0 
    and getOpponentIsBeingCounterHit() == true 
    and getOpponentIsBeingCounterPunish() == false 
    and getOpponentInAirByte() ~= 2 then

        MoveTimer(3, 20)
        --OS(100)
        if getOpponentDistance() <=130 then Do_StMP() end
        if getOpponentDistance() >=131 then PSpecial() OS(20) RSpecial() end
        
    end

    -- Punish Counter
    if getOpponentDistance() <= 150 
    and getOpponentStunnedStateBeta() ~= 0 
    and getOpponentIsBeingCounterHit() == false 
    and getOpponentIsBeingCounterPunish() == true 
    and getOpponentInAirByte() ~= 2 then

        MoveTimer(3, 150)
        ifStun(PDown)
        ifStun(PMedium)
        OS(40)
        RMedium()
        RDown()
        OS(200)
        ifStun(AdFlameMP)
        OS(1000)
        Do_StMK()
    
    end

    -- Normal Hit
    if getOpponentDistance() <= 100 
    and getOpponentStunnedStateBeta() ~= 0 
    and (getOpponentAnimationID() == 200 or getOpponentAnimationID() == 204)
    and getOpponentIsBeingCounterHit() == false 
    and getOpponentIsBeingCounterPunish() == false 
    and getOpponentInAirByte() == 0 then

        ifStun(PLight)
        OS(40)
        RLight()
        ifStun(function() OS(100) end)
        ifStun(TatsuLK)
        ifStun(function() MoveTimer(12, 280) end)
    end

    if getOpponentDistance() >= 101 
    and getOpponentStunnedStateBeta() ~= 0 
    and (getOpponentAnimationID() == 200 or getOpponentAnimationID() == 204)
    and getOpponentIsBeingCounterHit() == false 
    and getOpponentIsBeingCounterPunish() == false 
    and getOpponentInAirByte() == 0 then

        ifStun(TatsuLK)
        ifStun(function() MoveTimer(12, 280) end)
    end

    EnableGameInput()
    OwlSleep(100)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching LP (After Cr LK)
if HitConfirm(42, 200, 0, 0, "Crouching LP") then 
    DisableGameInput()
    ifStun(function() OS(100)  end)
    ifStun(PToward)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RToward()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion


--#endregion! ============================================= LIGHT PUNCH

--#region! ================================================ MEDIUM PUNCH

--#region Standing MP SA1 Kill Combo 
if HitConfirm(4, 200, 30000, 0, "Standing MP SA1 Kill Combo") and SAMeter(5000) and Health(0, 2583) then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MP SA2 Kill Combo 
if HitConfirm(4, 200, 30000, 0, "Standing MP SA2 Kill Combo") and SAMeter(15000) and Health(2584, 3043) then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MP SA3 Kill Combo 
if HitConfirm(4, 200, 30000, 0, "Standing MP SA3 Kill Combo") and SAMeter(25000) and Health(3044, 3959) then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MP  
if HitConfirm(4, 200, 30000, 0, "Standing MP")  then 
    DisableGameInput()
    ifStun(function() OS(80)  end)
    PAssist()
    PMedium()
    OS(40)
    RAssist()
    RMedium()
    ifStun(function() OS(120)  end)
    MoveTimer(8, 100)
    ifStun(PBack)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RBack()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 


--#endregion! ============================================= MEDIUM PUNCH

--#region! ================================================ HEAVY PUNCH

--#region Standing HP SA1 Kill Combo 
if HitConfirm(6, 260, 30000, 0, "Standing HP SA1 Kill Combo") and SAMeter(5000) and Health(0, 3136) then 
    DisableGameInput()
    MoveTimer(8, 160)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP SA2 Kill Combo 
if HitConfirm(6, 200, 30000, 0, "Standing HP SA2 Kill Combo") and SAMeter(15000) and Health(3137, 3595) then 
    DisableGameInput()
    MoveTimer(8, 160)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP SA3 Kill Combo 
if HitConfirm(6, 200, 30000, 0, "Standing HP SA3 Kill Combo") and SAMeter(25000) and Health(3596, 4595) then 
    DisableGameInput()
    MoveTimer(8, 160)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP  
if HitConfirm(6, 200, 0, 0, "Standing HP")  then 
    DisableGameInput()
    if getOpponentAnimationID() == 276 then  MoveTimer(8, 20) TatsuHK() end
    --if getOpponentAnimationID() == 202 then  OS(100) ifStun(TatsuLK) end
    MoveTimer(8, 160)
    ifStun(QCB)
    ifStun(PLight)
    ifStun(function() OS(20)  end)
    RLight()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing HP Block String
if BlockString(6, 200, 0, 0) then 
    DisableGameInput()
    OS(160)
    

    local randomChoice = math.random(2)

    if randomChoice == 1 then 
        PDown() 
        PSpecial() 
        OS(20) 
        RDown() 
        RSpecial() 
        --OS(940)
        --if getOpponentOldMethodMoveID() == 4 then ShoryukenOD() end

    elseif randomChoice == 2 then 
        ifBlock(QCF) 
        ifBlock(PLight) 
        ifBlock(function() OS(20)  end)  
        RLight()
    end
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Forward HP
if HitConfirm(10, 200, 0, 0, "Forward HP") then 
    DisableGameInput()
    MoveTimer(8, 160)
    PHeavy()
    OS(40)
    RHeavy()
    ifStun(function() OS(220)  end)
    PHeavy()
    OS(40)
    RHeavy()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= HEAVY PUNCH

--#region! ================================================ LIGHT KICK

--#region Crouching LK 
if HitConfirm(16, 200, 0, 0, "Crouching LK") then 
    DisableGameInput()
    ifStun(PDown) 
    ifStun(function() OS(100)  end)
    ifStun(PLight) 
    ifStun(function() OS(100)  end)
    RLight()
    RDown()
    ifStun(function() OS(100)  end)
    ifStun(PToward)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RToward()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT KICK

--#region! ================================================ MEDIUM KICK

--#region Standing MK SA1 Kill Combo 
if HitConfirm(5, 200, 30000, 0, "Standing MK SA1 Kill Combo") and SAMeter(5000) and Health(0, 3136) then 
    DisableGameInput()
    MoveTimer(6, 100)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MK SA2 Kill Combo 
if HitConfirm(5, 200, 30000, 0, "Standing MK SA2 Kill Combo") and SAMeter(15000) and Health(3137, 3595) then 
    DisableGameInput()
    MoveTimer(6, 100)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MK SA3 Kill Combo 
if HitConfirm(5, 200, 30000, 0, "Standing MK SA3 Kill Combo") and SAMeter(25000) and Health(3596, 4595) then 
    DisableGameInput()
    MoveTimer(6, 100)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Standing MK  
if HitConfirm(5, 200, 30000, 0, "Standing MK") then 
    DisableGameInput()
    MoveTimer(6, 100)
    ifStun(QCB)
    ifStun(PLight)
    ifStun(function() OS(20)  end)
    RLight()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK SA1 Kill Combo 
if HitConfirm(18, 200, 30000, "Both", "Crouching MK SA1 Kill Combo") and SAMeter(5000) and Health(0, 3136) then 
    DisableGameInput()
    MoveTimer(7, 100)
    KillCombo_LVL1()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK SA2 Kill Combo 
if HitConfirm(18, 200, 30000, "Both", "Crouching MK SA2 Kill Combo") and SAMeter(15000) and Health(3137, 3595) then 
    DisableGameInput()
    MoveTimer(7, 100)
    KillCombo_LVL2()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK SA3 Kill Combo 
if HitConfirm(18, 200, 30000, "Both", "Crouching MK SA3 Kill Combo") and SAMeter(25000) and Health(3596, 4595) then 
    DisableGameInput()
    MoveTimer(7, 100)
    KillCombo_LVL3()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region Crouching MK  
if HitConfirm(18, 200, 30000, 0, "Crouching MK") then 
    DisableGameInput()
    ifStun(PBack)
    ifStun(PSpecial)
    ifStun(function() OS(20)  end)
    RBack()
    RSpecial()
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= MEDIUM KICK

--#region! ================================================ HEAVY KICK

if HitConfirm(7, 200, 0, 0, "Heavy Kick") then 
    DisableGameInput()
    if getOpponentAnimationID() == 276 then  MoveTimer(12, 640) TatsuHK() end
    --if getOpponentAnimationID() == 202 then  MoveTimer(12, 640) TatsuHK() end
    MoveTimer(12, 640)
    ifStun(function() OS(80)  end)
    --PAssist()
    PMedium()
    OS(40)
    --RAssist()
    RMedium()
    TatsuLK()
    EnableGameInput()
    --OwlSleep(600)
    setOpponentOldMethodMoveID(0)
end

--#endregion! ============================================= HEAVY KICK

--#region! ================================================ OVERHEAD

--#region Overhead (Punish)
if HitConfirm(38, 220) then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        PLight()
        OS(20)
        RLight()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= OVERHEAD

--#region! ================================================ THROW LOOP
if getLocalAnimationID()==720 then EnableGameInput() return end 

if getLocalIsThrowing() then
    DisableGameInput()
    -- if getLocalAnimationID()==720 then EnableGameInput() end -- In case of throw break
    OS(2000)
    
    local randomChoice = math.random(3)

if randomChoice == 1 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Meaty MK
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(280)
    --PAssist()
    PMedium()
    OS(60)
    --RAssist()
    RMedium()

elseif randomChoice == 2 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Throw Loop
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(300)
    PLight()
    PMedium()
    OS(40)
    RLight()
    RMedium()
    OS(40)
    --ShoryukenLP()
    print(getOpponentAnimationID())
    --JumpOKI()


elseif randomChoice == 3 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Shimmy
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(300)
    PBack()
    OS(300)
    RBack()
    --JumpOKI()
    
end
    ::ThrowLoopEnd::
    EnableGameInput()
end
--#endregion! ============================================= THROW LOOP

--#region! ================================================ ADFLAME

--#region AdFlame
if HitConfirm(84, 300, 0, "Punish", "AdFlame MP") then 
    DisableGameInput()
    MoveTimer(18, 340)
    ifStun(Do_StHP)
    MoveTimer(8, 140)
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region AdFlame
if HitConfirm(84, 300, 0, "Counter", "AdFlame MP") then 
    DisableGameInput()
    MoveTimer(18, 140)
    PToward()
    PHeavy()
    OS(40)
    RHeavy()
    RToward()
    MoveTimer(18, 800)
    PDown()
    PSpecial()
    OS(20)
    RDown()
    RSpecial()
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#region OD AdFlame
if HitConfirm(155, 300, 0, nil, "AdFlame OD") then 
    DisableGameInput()
    MoveTimer(18, 140)
    PToward()
    PHeavy()
    OS(40)
    RHeavy()
    RToward()
    MoveTimer(18, 1000)
    Teleport()
    OS(1000)
    if getOpponentDistance() > 113 then Do_StHP() end
    if getOpponentDistance() < 114 then PBack() OS(20) RBack() end
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= ADFLAME

--#region! ================================================ TATSU

--#region Tatsu LK
if HitConfirmAirLoc(76, 300, 0, 0, "Tatsu LK") then 
    DisableGameInput()
    MoveTimer(12, 280)
    OKI_TatsuLK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0)
end
--#endregion 

--#endregion! ============================================= TATSU

--#region! ================================================ COMBOS


--#region Kill Combo LVL 1
function KillCombo_LVL1()
    print("*** KillCombo_LVL1 ***")
    if Classic then
        --NA
    elseif Modern then
    DisableGameInput()
    ifStun(PParry)
    ifStun(function() OS(20)  end)
    RParry()
    ifStun(function() OS(100) end)
    ifStun(PToward)
    ifStun(PHeavy)
    ifStun(function() OS(720) end)
    RHeavy()
    RToward()
    ifStun(PDown)
    ifStun(function() OS(260) end)
    ifStun(PHeavy)
    ifStun(function() OS(20)  end)
    RHeavy()
    RDown()
    ifStun(function() OS(160) end)
    ifStun(PParry) -- Loop
    ifStun(function() OS(20)  end)
    RParry()
    ifStun(function() OS(240) end)-- DRC waitTime
    ifStun(PToward)
    ifStun(PHeavy)
    ifStun(function() OS(720) end)
    RHeavy()
    RToward() ------
    ifStun(PDown)
    ifStun(function() OS(300) end)
    ifStun(PHeavy)
    ifStun(function() OS(20)  end)
    RHeavy()
    RDown()
    ifStun(function() OS(100) end)
    ifStun(QCB) -- Start Tatsu
    ifStun(PLight)
    ifStun(function() OS(20)  end)
    RLight() -- End Tatsu
    ifStun(function() OS(920) end) -- Tatsu waitTime
    ifStun(PSpecial) -- Start SA1
    ifStun(PHeavy)
    ifStun(function() OS(40)  end)
    RSpecial()
    RHeavy() -- End SA1
    EnableGameInput()
    OwlSleep(600)
    setOpponentOldMethodMoveID(0)
    end
end
--#endregion

--#region Kill Combo LVL 2
function KillCombo_LVL2()
    if Classic then
        --NA
    elseif Modern then
        DisableGameInput()
        ifStun(PParry)
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(100) end)
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward()
        ifStun(PDown)
        ifStun(function() OS(260) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(160) end)
        ifStun(PParry) -- Loop
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(240) end)-- DRC waitTime
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward() ------
        ifStun(PDown)
        ifStun(function() OS(300) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(100) end)
        ifStun(QCB) -- Start Tatsu
        ifStun(PLight)
        ifStun(function() OS(20)  end)
        RLight() -- End Tatsu
        ifStun(function() OS(920) end) -- Tatsu waitTime
        ifStun(PBack) -- Start SA2
        ifStun(PHeavy)
        ifStun(PSpecial)
        ifStun(function() OS(40)  end)
        RSpecial()
        RHeavy() 
        RBack() -- End SA2
        EnableGameInput()
        OwlSleep(600)
        setOpponentOldMethodMoveID(0)
    end
end
--#endregion

--#region Kill Combo LVL 3
function KillCombo_LVL3()
    if Classic then
        --NA
    elseif Modern then
        DisableGameInput()
        ifStun(PParry)
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(100) end)
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward()
        ifStun(PDown)
        ifStun(function() OS(260) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(160) end)
        ifStun(PParry) -- Loop
        ifStun(function() OS(20)  end)
        RParry()
        ifStun(function() OS(240) end)-- DRC waitTime
        ifStun(PToward)
        ifStun(PHeavy)
        ifStun(function() OS(720) end)
        RHeavy()
        RToward() ------
        ifStun(PDown)
        ifStun(function() OS(300) end)
        ifStun(PHeavy)
        ifStun(function() OS(20)  end)
        RHeavy()
        RDown()
        ifStun(function() OS(100) end)
        ifStun(QCB) -- Start Tatsu
        ifStun(PLight)
        ifStun(function() OS(20)  end)
        RLight() -- End Tatsu
        ifStun(function() OS(920) end) -- Tatsu waitTime
        ifStun(PToward) -- Start DP
        ifStun(PSpecial)
        ifStun(function() OS(20)  end)
        RSpecial()
        RToward()
        ifStun(function() OS(100) end)
        ifStun(PDown) -- Start SA3
        ifStun(PHeavy)
        ifStun(PSpecial)
        ifStun(function() OS(40)  end)
        RSpecial()
        RHeavy() 
        RDown() -- End SA3
        EnableGameInput()
        OwlSleep(600)
        setOpponentOldMethodMoveID(0)
    end
end
--#endregion

--#region Dizzy Combo

if getOpponentAnimationID() == 353 -- Dizzy
then
    --DisableGameInput()

    --EnableGameInput()
end

--#endregion

--#region DI Combo
if  getOpponentAnimationID() == 276 then Do_StHK() end
--#endregion 

--#endregion! ============================================= COMBOS

--#region! ================================================ PUNISH AREA


--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 220  
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
OS(60)
PHeavy()
OS(20)  
RHeavy()
EnableGameInput()
setOpponentOldMethodMoveID(0)
setOpponentAnimationID(1)
OS(300)
end
--#endregion

--[[--#region Anti Fireball
local fireballMoves = {
    [1] = {53, 54, 55, 56, 82, 83, 84, 85},   -- Ryu
    [2] = {96, 57, 58, 59},                   -- Luke
    [3] = {68, 69, 70},                       -- Kim
    [4] = {77, 79, 81},                       -- Chun
    [7] = {69, 70, 71},                       -- JP
    [8] = {62, 63, 64},                       -- Sim
    [10] = {58, 59, 60},                      -- Ken
    [11] = {74, 75},                          -- DJ
    [13] = {70},                              -- AKI
    [14] = {75},                              -- Rashid
    [16] = {73, 74},                          -- Juri
    [18] = {70, 71, 72, 73, 74, 75},          -- Guile
    [19] = {56, 58, 61},                      -- Ed
    [22] = {49, 50, 51}                       -- Akuma
}

-- Helper Function: Check if a move ID is a fireball
local function isFireballMove(characterID, moveID)
    local moves = fireballMoves[characterID]
    if not moves then return false end
    return isValueInTable(moveID, moves)
end

-- Fireball Reaction Logic
if  getLocalStunnedStateBeta() == 0           -- Ensure neutral state
    and getLocalInAirByte() ~= 2                  -- Ensure not in the air
    and getOpponentDistance() > 290 and getOpponentDistance() < 320 -- Define distance range
    and isFireballMove(getOpponentCharacterID(), getOpponentOldMethodMoveID()) then
    print("Executing Mtatsu - Opponent Distance: " .. getOpponentDistance()) -- Debugging distance before executing
    DisableGameInput()
    QCB()
    PMedium()
    OS(20)
    RMedium()
    OS(20)
    EnableGameInput()
end
--#endregion 
]]--


--#endregion! ============================================= PUNISH AREA

--#region! ================================================ OKI

--#region LK Tatsu OKI
function OKI_TatsuLK()
    DisableGameInput()

    local randomChoice = math.random(7)

    if randomChoice == 1 or randomChoice == 5 then --Throw
        Do_CrHK()
        OS(640)  
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(340) -- Wait between dashes
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(300) -- Wait between dashes
        PLight()
        PMedium()
        OS(20)
        RLight()
        RMedium()
        --JumpOKI()

    elseif randomChoice == 2 then --Strike
        Do_CrHK()
        OS(640)  
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(340) -- Wait between dashes
        PToward()
        OS(20)
        RToward()
        OS(40)
        PToward()
        OS(20)
        RToward()
        OS(300) -- Wait between dashes
        PLight()
        OS(20)
        RLight()

    elseif randomChoice == 3 then -- Shroryuken with Meaty HP After
        --Do_CrHK()
        PToward()
        OS(80)  
        RToward()
        ShoryukenHP()

    elseif randomChoice == 4 then -- OD Flip
        Do_CrHK()
        OS(760)
        PDown()
        PAssist()
        PSpecial()
        OS(20)
        RDown()
        RAssist()
        RSpecial()
        OS(480) -- Wait time for Flip
        PHeavy()
        OS(20)
        RHeavy()
        OS(700) -- Wait time for Dive Kick
        if isOpponentAnimationDI() == "Yes" then PLight() PMedium() OS(20) RLight() RMedium() end
        if isOpponentAnimationDI() == "No" then ifStun(Do_StLP) end
        if isOpponentAnimationDI() == "No" then ifStun(TatsuLK) end 
        ifStun(function() OS(400) end)
        PLight()
        PMedium()
        OS(20)  
        RLight()
        RMedium()
    elseif randomChoice == 6 then -- Teleport Grab
        Do_CrHK()
        MoveTimer(31, 720)
        Teleport()
        MoveTimer(28,660) 
        PLight()
        PMedium()
        OS(20)
        RLight()
        RMedium()
    elseif randomChoice == 7 then -- Teleport 
        Do_CrHK()
        MoveTimer(31, 720)
        Teleport()
        --OS(900)
        MoveTimer(28,900)
        --print(getOpponentAnimationID())
        if getOpponentAnimationID() == 38 then PToward() OS(60) RToward() ifStun(Do_StHK) ifStun(function() OS(860) end) ifStun(TatsuHK) end  
        if getOpponentAnimationID() == 37 then PToward() OS(120) RToward() ifStun(Do_StHK) ifStun(function()OS(860) end) TatsuHK() end  
        if getOpponentAnimationID() == 36 then PDown() PBack() OS(300) RDown() PHeavy() OS(20) RBack() RHeavy() end 
        PBack()
        OS(40)
        RBack()
        ifStun(PSpecial)
        --print(getOpponentDistance())
        ifStun(function() OS(880) end)
        RSpecial()
        MoveTimer(28, 540)
        ifStun(DriveRush)
        --print(getLocalMoveTimer())
        --print(getOpponentDistance())
        if getLocalMoveTimer() == 34 then MoveTimer(34, 160) end
        if getLocalMoveTimer() ~= 34 then MoveTimer(0, 160) end
        ifStun(Do_StHP)
        OS(100)
        ifStun(TatsuMK)
        ifStun(function() MoveTimer(4, 1600) end)
        ifStun(ShoryukenLP)
    end
    EnableGameInput()
    OwlSleep(20)
    setOpponentOldMethodMoveID(0)
    EnableGameInput()
end
--#endregion

--#region Jump OKI
if getLocalAnimationID() == 715 and getLocalMoveTimer() == 29 then -- function JumpOKI()
    DisableGameInput()
    OS(10)
    print("Jump OKI: ", getOpponentAnimationID())
    print(getLocalMoveTimer())
    --Do_StHK()
    --ShoryukenLP()
    if getOpponentAnimationID() == 38 then PToward() OS(10) RToward() Do_StHK() ifStun(function() OS(960) end) TatsuHK() end  
    if getOpponentAnimationID() == 37 then PToward() OS(120) RToward() ifStun(Do_StHK) ifStun(function()OS(860) end) TatsuHK() end  
    if getOpponentAnimationID() == 36 then PDown() PBack() OS(10) RDown() PHeavy() OS(20) RBack() RHeavy() ShoryukenLP() end 
        
    EnableGameInput()
end 

--#endregion

--#endregion! ============================================= OKI

--#region! ================================================ ANTI CHARACTER
-- PunCon(charID, moveID, startup, minDistance, maxDistance, label)

--#region Anti Ryu

--#region Punches
--StartUP
if PunCond(1,  6, 9,   0, 200, "St HP")             then Do_StMP() end
--Whiff 
if PunCond(1,  4,  nil,  130, 288, "St MP")           then OS(100) Do_StHP() TatsuMK()  end
if PunCond(1,  6,  9,  221, 288, "St HP")           then AdFlameMP() end
--#endregion

--#region Kicks
--StartUP
if PunCond(1, 18, 9,   0, 199, "Cr MK")             then Do_StLP() PSpecial() OS(20) RSpecial() end
if PunCond(1,  7, 9,   0, 200, "St HK")             then Do_CrMK() AdFlameMP() end
--Whiff
if PunCond(1, 18,  9,  200, 288, "Cr MK")           then AdFlameMP() end
if PunCond(1, 20,  9,  209, 290, "Cr HK")           then AdFlameMP() end
--Block
if PunCond(1,  5, 9,   0, 300, "St MK")             then PBack() OS(200) RBack() end
--#endregion

--#region Unique Attacks
if PunCond(1, 12, nil, 0  , 130, "Whirl Kick")      then Do_StMP() OS(60) Do_StMP() OS(300) AdFlameMP() end
if PunCond(1, 12, nil, 131, 230, "Whirl Kick")      then PBack() OS(300) RBack() end
if PunCond(1, 12, nil, 231, 400, "Whirl Kick")      then PBack() OS(200) RBack() AdFlameMP() end
if PunCond(1,  9, nil,   0, 240, "SoloPlex")        then ShoryukenHP() end
if PunCond(1,  9, nil, 241, 440, "SoloPlex")        then OS(160) AdFlameMP() end
if PunCond(1,  8, nil,   0, 200, "Overhead")        then ShoryukenOD() end
--#endregion

--#region Anit-Air
-- if PunCond(1, 69, nil, 00, 230, "Air Tatsu")    then OS(200) ShoryukenHP() end
-- if AAReady(0,   200, 37, "F.Jump - Close AA")   then DisableGameInput() OS(500) ShoryukenLP() EnableGameInput() OS(1000) end
-- if AAReady(200, 260, 37, "F.Jump - Mid AA")     then DisableGameInput() OS(260) ShoryukenMP() EnableGameInput() OS(2000) end
-- if AAReady(0,   160, 36, "Neutral AA")          then DisableGameInput() OS(260) ShoryukenLP() EnableGameInput() OS(2000) end
--#endregion

--#region DriveRush
if PunCond(1, 92, nil, 120, 220, "DR") then Do_StMK()   end
if PunCond(1, 92, nil, 220, 300, "DR") then Do_StHK()   end
if PunCond(1, 92, nil, 300, 600, "DR") then PSpecial() OS(20) RSpecial()   end
--#endregion

--#region Fireballs 
--Far
-- if PunCond(1, 53, nil, 250, 350, "Fireball LP") then BlockHigh(400, 1300, 400) end --Parry(400, 300, 400) end
-- if PunCond(1, 82, nil, 250, 350, "Fireball LP") then BlockHigh(400, 1300, 400) end --Parry(400, 300, 400) end
-- if PunCond(1, 54, nil, 250, 350, "Fireball MP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 400) end
-- if PunCond(1, 83, nil, 250, 350, "Fireball MP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 400) end
-- if PunCond(1, 55, nil, 253, 400, "Fireball HP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 600) end
-- if PunCond(1, 84, nil, 253, 400, "Fireball HP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 600) end
-- if PunCond(1, 56, nil, 250, 350, "Denjin Fireball") then BlockHigh(400, 1400, 400) end --Parry(200, 300, 400) end
--Close
-- if PunCond(1, 53, nil, 75, 249, "Fireball LP") then Parry(180, 20, 300) Do_StHP() end
-- if PunCond(1, 82, nil, 75, 249, "Fireball LP") then Parry(180, 20, 300) Do_StHP() end
-- if PunCond(1, 54, nil, 75, 249, "Fireball MP") then Parry(160, 20, 300) Do_StHP() end -- 160 is way too strong
-- if PunCond(1, 83, nil, 75, 249, "Fireball MP") then Parry(160, 20, 300) Do_StHP() end -- 160 is way too strong
-- if PunCond(1, 55, nil, 75, 252, "Fireball HP") then Parry(120, 20, 300) Do_StHP() end
-- if PunCond(1, 84, nil, 75, 252, "Fireball HP") then Parry(120, 20, 300) Do_StHP() end
-- if PunCond(1, 56, nil, 75, 249, "Denjin Fireball") then Parry(120, 20, 300) Do_StHP() end
--#endregion

--#region Denjin Charge
if PunCond(1, 48, nil, 300, 500, "Denjin Charge LP") then DisableGameInput() PSpecial() OS(20) RSpecial() OS(400) EnableGameInput() end
--#endregion

--#region Hashogeki
--StartUP
if PunCond(1, 73, nil,   0, 250, "Hashogeki MP")    then Do_StHP() end -- this can be beat.. maybe EXDP?
if PunCond(1, 74, nil,   0, 160, "Hashogeki HP")    then Do_StHP() end
--Whiff 
if PunCond(1, 72, nil, 160, 300, "Hashogeki LP")    then AdFlameMP() end
if PunCond(1, 73, nil, 250, 300, "Hashogeki MP")    then OS(160) AdFlameMP() end
if PunCond(1, 74, nil, 160, 300, "Hashogeki HP")    then AdFlameMP() end
--#endregion

--#region Blade Kick

--Startup 
if PunCond(1, 64, nil, 0, 200, "Blade Kick LK")     then Do_StHP() end
if PunCond(1, 65, nil, 0, 200, "Blade Kick MK")     then Do_StHP() end
if PunCond(1, 66, nil, 0, 160, "Blade Kick HK")     then Do_StHP() end
--MidRange
if PunCond(1, 64, nil, 201, 250, "Blade Kick LK")     then Parry(100, 20, 300) Do_StHP() end
if PunCond(1, 65, nil, 201, 270, "Blade Kick MK")     then Parry(100, 20, 300) Do_StHP() end
if PunCond(1, 66, nil, 161, 270, "Blade Kick HK")     then Parry(300, 20, 300) Do_StHP() end
--Whiff 
if PunCond(1, 64, nil, 250, 350, "Blade Kick LK")   then OS(80)  AdFlameMP() end
if PunCond(1, 65, nil, 271, 350, "Blade Kick MK")   then OS(240) AdFlameMP() end
if PunCond(1, 66, nil, 271, 450, "Blade Kick HK")   then OS(340) AdFlameMP() end

--#endregion

--#region Tatsu LK
--Whiff
if PunCond(1, 59, nil, 236, 400, "Tatsu LK")  then 
    PBack() 
    OS(200) 
    RBack() 
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 59, nil, 0, 230, "Tatsu LK")  then 
    DisableGameInput()
    PBack() 
    OS(200) 
    RBack() 
    OS(500)
    Do_StHK() 
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#region Tatsu MK
--Whiff
if PunCond(1, 60, nil, 301, 400, "Tatsu MK")  then 
    PBack() 
    OS(200) 
    RBack() 
    OS(200)
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 60, nil, 0, 300, "Tatsu MK")  then 
    DisableGameInput()
    PBack() 
    OS(200) 
    RBack() 
    OS(1000)
    Do_StHK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#region Tatsu HK
--Whiff
if PunCond(1, 61, nil, 301, 400, "Tatsu HK")  then 
    PBack() 
    OS(800) 
    RBack() 
    OS(200)
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 61, nil, 0, 300, "Tatsu HK")  then 
    DisableGameInput()
    PBack() 
    OS(800) 
    RBack() 
    OS(1000)
    Do_StHK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#endregion Anti Ryu
--#endregion! ============================================= ANTI CHARACTER

--------------------------------------------
end
--#endregion= ============================== 22 - Akuma

--#region= ================================= 26 - M. Bison
if getLocalCharacterID() == 26 then
--------------------------------------------    

--#region! ================================================ BUTTONS

--#region Standing LP
function Do_StLP()
    DisableGameInput()

    if Classic then
        PLP()
        OS(40)
        RLP()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LP
function Do_CrLP()
    DisableGameInput()

    if Classic then
        PDown()
        PLP()
        OS(40)
        RLP()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MP
function Do_StMP()
    DisableGameInput()

    if Classic then
        PMP()
        OS(40)
        RMP()
        
    elseif Modern then
        PAssist()
        PHeavy()
        OS(40)
        RAssist()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MP
function Do_CrMP()
    DisableGameInput()

    if Classic then
        PDown()
        PMP()
        OS(40)
        RMP()
        RDown()
        
    elseif Modern then
        ifStun(PAssist)
        ifStun(PMedium)
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HP
function Do_StHP()
    DisableGameInput()

    if Classic then
        PHP()
        OS(40)
        RHP()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HP
function Do_CrHP()
    DisableGameInput()

    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RDown()
        RToward()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Standing LK
function Do_StLK()
    DisableGameInput()

    if Classic then
        PLK()
        OS(40)
        RLK()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LK
function Do_CrLK()
    DisableGameInput()

    if Classic then
        PDown()
        PLK()
        OS(40)
        RLK()
        RDown()
        
    elseif Modern then
        PAssist()
        PLight()
        OS(40)
        RAssist()
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MK
function Do_StMK()
    DisableGameInput()

    if Classic then
        PMK()
        OS(40)
        RMK()
        
    elseif Modern then
        PMedium()
        OS(40)
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MK
function Do_CrMK()
    DisableGameInput()

    if Classic then
        PDown()
        PMK()
        OS(40)
        RMK()
        RDown()
        
    elseif Modern then
        PDown()
        PMedium()
        OS(40)
        RMedium()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HK
function Do_StHK()
    DisableGameInput()

    if Classic then
        PHK()
        OS(40)
        RHK()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HK
function Do_CrHK()
    DisableGameInput()

    if Classic then
        PDown()
        PHK()
        OS(40)
        RHK()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RHeavy()
        RDown()
        RToward()
    end

    EnableGameInput()
end
--#endregion

--#region SA1
function Do_LVL1()
    DisableGameInput()
    if Classic then
        -- Missing
    elseif Modern then
        QCF()
        QCF()
        PLight()
        OS(40)
        RLight()
    end
    EnableGameInput()
end
--#endregion

--#region SA2
function Do_LVL2()
    DisableGameInput()
    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
    elseif Modern then
        QCB()
        QCB()
        PMedium()
        OS(40)
        RMedium()
    end
    EnableGameInput()
end
--#endregion

--#region SA3
function Do_LVL3()
    DisableGameInput()
    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
    elseif Modern then
        QCF()
        QCF()
        PHeavy()
        OS(40)
        RHeavy()
    end
    EnableGameInput()
end
--#endregion

--#region Block High
function BlockHigh()
    PBack()
    OS(math.random(80, 120))
    RBack()
    EnableGameInput()
end 
--#endregion

--#region Block Low
function BlockLow()
    PDown()
    PBack()
    OS(math.random(60, 120))
    RDown()
    RBack()
    OS(200)
    EnableGameInput()
end 
--#endregion

--#region Drive Rush
function DriveRush()
    PParry()
    OS(40)
    PToward()
    OS(20)
    RToward()
    OS(20)
    PToward()
    OS(20)
    RToward()
    RParry()
end
--#endregion

--#region Throw
function Throw()
    DisableGameInput()

    if Classic then
        PLP()
        PLK()
        OS(40)
        RLP()
        RLK()
        
    elseif Modern then
        PLight()
        PMedium()
        OS(40)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region QCF 
function QCF()
    PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	OS(30)
	RToward()
end
--#endregion

--#region QCB 
function QCB()
    PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	OS(30)
	RBack()
end
--#endregion

--#endregion! ============================================= MOVE FUNCTIONS

--#region! ================================================ CHARACTER MOVES / ACTIONS

--#region Special Move Functions

--#region LP Bomb
function Do_bombLP()
	PressInputDownButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	PressInputDownButton()
	PressInputLeftButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	ReleaseInputLeftButton()
	PressInputLeftButton()
	PLight()
	OwlSleep(20)
	ReleaseInputLeftButton()
	RLight()
end
--#endregion 

--#region MP Bomb
function Do_bombMP()
    DisableGameInput()
	PressInputDownButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	PressInputDownButton()
	PressInputLeftButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	ReleaseInputLeftButton()
	PressInputLeftButton()
	PMedium()
	OwlSleep(20)
	ReleaseInputLeftButton()
	RMedium()
    EnableGameInput()
end
--#endregion

--#region HP Bomb
function Do_bombHP()
	PressInputDownButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	PressInputDownButton()
	PressInputLeftButton()
	OS(20)
	ReleaseInputDownButton()
	ReleaseInputLeftButton()
	PressInputLeftButton()
	PHeavy()
	OS(20)
	ReleaseInputLeftButton()
	RHeavy()
end
--#endregion

--#region OD Bomb
function Do_bombOD()
	PressInputDownButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	PressInputDownButton()
	PressInputLeftButton()
	OwlSleep(20)
	ReleaseInputDownButton()
	ReleaseInputLeftButton()
	PressInputLeftButton()
	PMedium()
	PHeavy()
	OwlSleep(20)
	ReleaseInputLeftButton()
	RMedium()
	RHeavy()
end
--#endregion

--#region Scissor Kick LK
function Do_scissorLK()
    if Classic then
        ifStun(QCF)
        ifStun(PLP)
        OS(20)
        RLP()
        
    elseif Modern then
        ifStun(QCF)
        ifStun(PLight)
        OS(20)
        RLight()
    end	
end
--#endregion 

--#region OD Scissor
function Do_scissorOD()
    if Classic then
        ifStun(QCF)
        ifStun(PLP)
        ifStun(PMP)
        OS(20)
        RLP()
        RMP()
        
    elseif Modern then
        ifStun(QCF)
        ifStun(PLight)
        ifStun(PMedium)
        OS(20)
        RLight()
        RMedium()
        MoveTimer(16, 0)
    end	
end
--#endregion

--#endregion Special Move Functions

--#region Crouching LK on Modern
function Do_CrLK()
    PAssist()
    PLight()
    OS(40)
    RAssist()
    RLight()
end
--#endregion

--#region Standing HK Replacement Move
function Do_HKreplacement()
    PBack()
    PHeavy()
    OS(40)
    RBack()
    RHeavy()
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ================================================ CHARACTER MOVES / ACTIONS

--#region! ================================================ LIGHT PUNCH


--#region Standing LP & Crouching LP
if   HitConfirm(3, 360, 35001, 0, "(Confirm) St. LP With Meter") or HitConfirm(10, 360, 35001, 0, "(Confirm) Cr. LP With Meter") or HitConfirm(35, 360, 35001) then
    DisableGameInput()
    
    if Classic then
        
        
        -- Missing


    elseif Modern then
        if Conditions(0, 90, 0, "Counter", nil, "Counter Hit" ) 
		then
        MoveTimer(5, 200)
        ifStun(PDown)
        ifStun(PAssist)
        ifStun(PMedium)
        ifStun(function() OS(40) end)
        RDown()
        RMedium()
        RAssist()
        ifStun(function() OS(40) end)
        ifStun(Do_bombMP) 
		elseif Conditions(91, 300, 0, "Counter", 1 , "Counter Hit Far") 
        then
        MoveTimer(4, 0)
        ifStun(Do_bombMP)
		end
		-------------	
		if Conditions(0, 90, 0, "Punish", nil, "Punish Counter Hit")
		then 
        MoveTimer(3, 0)
        ifStun(PDown)
        ifStun(PAssist)
        ifStun(PMedium)
        ifStun(function() OS(40) end)
        RDown()
        RMedium()
        RAssist()
        ifStun(function() OS(40) end)
        ifStun(Do_bombMP)
		elseif Conditions(91, 300, 0, "Punish", 1 , "Punish Counter Hit Far") 
        then 
        MoveTimer(4, 0)
        ifStun(Do_scissorLk)
		end	
		-------------
		if Conditions(0, 90, 0, "None", nil, "Normal Hit")
		then
        MoveTimer(4, 0)     
        ifStun(PLight)
        ifStun(function() OS(40) end)
        RLight()
        ifStun(function() OS(40) end)
        ifStun(Do_bombLP)
	    elseif Conditions(91, 160, 0, "None", 1 , "Normal Hit Far") 
        then
        MoveTimer(4, 0)
        ifStun(Do_scissorLk)
		end
    end
    EnableGameInput()
    OwlSleep(260)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing LP & Crouching LP  <=35001
if   HitConfirm(3, 360, 0, 0, "(Confirm) St. LP") or HitConfirm(10, 360, 0, 0, "(Confirm) Cr. LP With Meter") or HitConfirm(35, 360, 0) then
    DisableGameInput()
    
    if Classic then
        
        -- Missing

    elseif Modern then
        DisableGameInput()
		MoveTimer(4, 100)
        
        ifStun(PToward)
        ifStun(PSpecial)
        OS(20)  
        RSpecial()
        RToward()
		EnableGameInput()
    end
    EnableGameInput()
    OwlSleep(260)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT PUNCH

--#region! ================================================ MEDIUM PUNCH

--#region Standing MP <= 35000
if  HitConfirm(5, 250, 0, 0, "(Confirm) St MP") and getLocalDriveMeter() <= 35000
then
DisableGameInput()

    if Classic then
        
        --Missing

    elseif Modern then
        if Conditions(101, 250, 0, 0, nil, "Far")
        then	
        MoveTimer(7, 100)
        ifStun(Do_bombMP)
        end
        ------
        if Conditions(0, 99, 0, 0, nil, "Close")
        then 
        MoveTimer(7, 400)
        ifStun(Do_CrMP)		
        if getLocalIsProjectileOnScreen()==false
        then
        ifStun(function() OS(200) end)
        ifStun(Do_bombMP)
        end		
        if getLocalIsProjectileOnScreen()==true
        then
        ifStun(function() OS(200) end)	
        ifStun(Do_bombOD)
        end		
    end
end
EnableGameInput()
OwlSleep(200)
end
--#endregion

--#region Standing MP >= 35001 
if HitConfirm(5, 250, 35000, 0, "(Confirm) St MP With Meter") then
    DisableGameInput()

    if Classic then
        -- Classic: Put Classic code here if needed.

    elseif Modern then
        -- Far condition: Opponent distance between 101 and 250.
        if Conditions(101, 250, 0, 0, nil, "Far") then
            MoveTimer(7, 100)
            ifStun(Do_scissorOD)
            ifStun(function() KillCheck(2500, 3060, 3560) end)
        end

        -- Close condition: Opponent distance 0 to 99.
        if Conditions(0, 99, 0, 0, nil, "Close") then
            MoveTimer(7, 400)
            ifStun(Do_CrMP)
            if getLocalIsProjectileOnScreen() == false then
                OwlSleep(200)
                ifStun(Do_scissorOD)
                ifStun(function() KillCheck(2500, 3060, 3560) end)
            elseif getLocalIsProjectileOnScreen() == true then
                OwlSleep(200)
                ifStun(Do_bombOD)
            end
        end
    end

    EnableGameInput()
    OwlSleep(200)
end
--#endregion

--#region Crouching MP <= 35000
if HitConfirm(12, 200, 0, 0, "(Confirm) Cr MP") and getLocalDriveMeter() <= 35000 then
    DisableGameInput()

    if Classic then
        -- Classic: Insert Classic combo code here if needed.
    
    elseif Modern then
        -- Branch 1: Opponent is not being counter hit or punished ("None")
        if Conditions(0, 200, 0, "None", nil, "No Counter") then
            OwlSleep(100)
            ifStun(Do_bombMP)
        end

        -- Branch 2: Opponent is between 70 and 120 pixels away and is being counter hit or punished ("Both")
        if Conditions(70, 120, 0, "Both", nil, "Close Counter") then
            OwlSleep(400)
            ifStun(Do_CrMP)
            OwlSleep(40)
            ifStun(Do_bombMP)
        -- Branch 3: Opponent is 121 or more pixels away and is being counter hit ("Counter")
        elseif Conditions(121, 200, 0, "Both", nil, "Far Counter") then
            ifStun(Do_bombMP)
        end
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MP >=35001
if HitConfirm(12, 200, 35001, 0, "(Confirm) Cr MP With Meter") then
    DisableGameInput()

    if Classic then
        -- Classic: Insert Classic code here if needed.

    elseif Modern then
        -- Branch 1: Opponent is not being counter hit or punished ("None")
        if Conditions(0, 200, 0, "None", nil, "No Counter") then
            MoveTimer(5, 0)
            ifStun(Do_scissorOD)
        end
        
        -- Branch 2: Opponent distance between 70 and 120 and is being counter hit or punished ("Both")
        if Conditions(70, 120, 0, "Both", nil, "Close Counter") then
            MoveTimer(5, 340)
            --ifStun(Do_CrMP)
            ifStun(PAssist)
            ifStun(PMedium)
            OS(20)
            RAssist()
            RMedium()
            OS(40)
            ifStun(Do_scissorOD)
        
        -- Branch 3: Opponent distance 121 to 200 and is being counter hit ("Counter")
        elseif Conditions(121, 200, 0, "Both", nil, "Far Counter") then
            MoveTimer(5, 0)
            ifStun(Do_scissorOD)
        end
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM PUNCH

--#region! ================================================ HEAVY PUNCH

--#region Standing HP <=35000
if HitConfirm(7, 190, 0, 0, "(Confirm) St HP") and getLocalDriveMeter() <= 35000 then
    DisableGameInput()

    if Classic then
        -- Classic: Insert Classic combo code here if needed.
    elseif Modern then
        -- Branch 1: Opponent is not being counter hit or punished ("None") and distance is 0 to 130.
        if Conditions(0, 130, 0, "None", nil, "No Counter") then
            OwlSleep(25)
            ifStun(PDown)
            ifStun(PLight)
            OwlSleep(20)
            ifStun(RDown)
            ifStun(RLight)
            OwlSleep(40)
            ifStun(Do_bombLP)
        end

        -- Branch 2: Opponent is being counter hit (and assumed not punished) and distance is 0 to 150.
        if Conditions(0, 150, 0, "Counter", nil, "Counter Hit") then
            OwlSleep(30)
            ifStun(PDown)
            ifStun(PLight)
            OwlSleep(20)
            ifStun(RDown)
            ifStun(RLight)
            OwlSleep(40)
            ifStun(Do_bombLP)
        end
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP >=35001
if   getLocalOldMethodMoveID() == 7 
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getLocalInAirByte() ~= 2
and getOpponentDistance() <= 190
and getLocalStunnedStateBeta() == 0
and getLocalDriveMeter()>=35001
    then
        DisableGameInput()	
		if (getOpponentIsBeingCounterHit() == false and getOpponentIsBeingCounterPunish()== false)
		and getOpponentDistance() <= 130
		then 	
		OwlSleep(25)
		PDown()
        PLight()
		OwlSleep(20)
		RDown()
		RLight()
		OwlSleep(40)
		Do_bombLP()
		end	
		if (getOpponentIsBeingCounterHit() == true and getOpponentIsBeingCounterPunish()== false)
		and getOpponentDistance() <= 150
		then 	
		OwlSleep(30)
		PDown()
		PLight()
		OwlSleep(40)
		RDown()
		RLight()
		OS(40)
		Do_bombLP()
		end	
		
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching HP <=35000
if HitConfirm(14, 140, 0, 0, "(Confirm) Cr HP") and getLocalDriveMeter() <= 35000 then
    DisableGameInput()
    
    if Classic then
        OwlSleep(80)
        ifStun(Do_bombHP)
        
    elseif Modern then
        OwlSleep(80)
        ifStun(Do_bombHP)
    end

    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching HP >=35001
if HitConfirm(14, 140, 35001, 0, "(Confirm) Cr HP With Meter") then
    DisableGameInput()
    
    if Classic then
        OwlSleep(80)
        ifStun(Do_scissorOD)
        
    elseif Modern then
        OwlSleep(80)
        ifStun(Do_scissorOD)
    end
    
    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HP on AirBorn Opp
if HitConfirmAirOpp(79999, 140, 0, 0, "(Confirm) St HP on AirBorn Opp") then
    DisableGameInput()
    
    if Classic then
        OwlSleep(80)
        ifStun(Do_scissorOD)
        
    elseif Modern then
        OwlSleep(80)
        KillCheck(9999, 4000, 5000)
    end
    
    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping HP <=35000 (Not on Modern)
if   getLocalOldMethodMoveID() == 21
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getOpponentDistance() <= 120
and getLocalStunnedStateBeta() == 0
and getLocalDriveMeter()<=35000
    then
        DisableGameInput()
		OwlSleep(200)		
		PressInputMediumPunch()
		OwlSleep(40)		
		ReleaseInputMediumPunch()
		OwlSleep(40)	
		PressInputDownButton()
		PressInputMediumPunch()
		OwlSleep(40)
		ReleaseInputDownButton()
		ReleaseInputMediumPunch()
		OwlSleep(100)
		Do_bombMP()
        EnableGameInput()
       OwlSleep(400)
       setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping HP >=35001 (Not on Modern)
if   getLocalOldMethodMoveID() == 21
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getOpponentDistance() <= 120
and getLocalStunnedStateBeta() == 0
and getLocalDriveMeter()>=35001
    then
        DisableGameInput()
		OwlSleep(200)		
		PressInputMediumPunch()
		OwlSleep(40)		
		ReleaseInputMediumPunch()
		OwlSleep(40)				
		PressInputDownButton()
		PressInputMediumPunch()
		OwlSleep(40)
		ReleaseInputDownButton()
		ReleaseInputMediumPunch()
		OwlSleep(100)
		Do_scissorOD()
        EnableGameInput()
       OwlSleep(400)
       setOpponentOldMethodMoveID(0)
end
--#endregion


--#endregion! ============================================ HEAVY PUNCH

--#region! ================================================ LIGHT KICK

--#region Standing LK 
if   getLocalOldMethodMoveID() == 4
and getOpponentStunnedStateBeta() ~= 0 
and getLocalInAirByte() ~= 2 
and getOpponentInAirByte() ~= 2 
and getOpponentDistance() <= 160
and getLocalStunnedStateBeta() == 0
    then
	DisableGameInput()
		OwlSleep(20)
        Do_bombLP()
	EnableGameInput()
	OwlSleep(200)
	end
--#endregion

--#region Crouching LK <=35000
if HitConfirm(11, 125, 0, "None", "(Confirm) Cr LK") and getLocalDriveMeter() <= 35000 then
    DisableGameInput()
    OwlSleep(40)
    
    if Classic then
        -- Classic branch: Insert Classic combo actions here if needed.
    
    elseif Modern then
        -- Branch 1: Opponent is being counter hit ("Counter")
        if Conditions(0, 125, 0, "Counter", nil, "Counter") then
            OwlSleep(200)
            ifStun(Do_CrMP)
            OwlSleep(40)
            ifStun(Do_bombMP)
        end
        
        -- Branch 2: Opponent is being counter punished ("Punish")
        if Conditions(0, 125, 0, "Punish", nil, "Punish Counter") then
            OwlSleep(200)
            ifStun(Do_CrMP)
            OwlSleep(40)
            ifStun(Do_bombMP)
        end
        
        -- Branch 3: Normal – opponent is neither counter hit nor counter punished
        -- and is very close (distance 0 to 85)
        if Conditions(0, 85, 0, "None", nil, "Normal") then
            OwlSleep(200)
            ifStun(PLight)
            OwlSleep(40)
            ifStun(RLight)
            OwlSleep(40)
            ifStun(Do_bombLP)
        end
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching LK >=35001
if HitConfirm(11, 125, 35001, "None", "(Confirm) Cr LK With Meter") then
    DisableGameInput()
    OwlSleep(40)
    
    if Classic then
        -- Classic branch: Insert Classic combo actions here if needed.
    
    elseif Modern then
        -- Branch 1: Counter – Opponent is being counter hit (true) and not punished.
        if Conditions(0, 125, 0, "Counter", nil, "Counter") then
            OwlSleep(200)
            PressInputDownButton()
            ifStun(PAssist)
            ifStun(PMedium)
            OwlSleep(40)
            ReleaseInputDownButton()
            ifStun(RMedium)
            ifStun(RAssist)
            OwlSleep(40)
            ifStun(Do_scissorOD)
        end
        
        -- Branch 2: Punish Counter – Opponent is not being counter hit but is being counter punished.
        if Conditions(0, 125, 0, "Punish", nil, "Punish Counter") then
            OwlSleep(200)
            PressInputDownButton()
            ifStun(PAssist)
            ifStun(PMedium)
            OwlSleep(40)
            ReleaseInputDownButton()
            ifStun(RMedium)
            ifStun(RAssist)
            OwlSleep(40)
            ifStun(Do_scissorOD)
        end
        
        -- Branch 3: Normal – Opponent is neither counter hit nor punished and is very close (≤85)
        if Conditions(0, 85, 0, "None", nil, "Normal") then
            OwlSleep(150)
            ifStun(PLight)
            OwlSleep(40)
            ifStun(RLight)
            OwlSleep(40)
            ifStun(Do_bombLP)
        end
    end
    
    EnableGameInput()
    OwlSleep(250)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping LK <=35000
if HitConfirm(18, 120, 0, "None", "(Confirm) Jmp LK") and getLocalDriveMeter() <= 35000 then
    DisableGameInput()
    
    if Classic then
        -- Classic branch: Insert Classic combo actions here if needed.
        OwlSleep(200)
        ifStun(Do_CrMP)
        OwlSleep(100)
        ifStun(Do_bombMP)
    
    elseif Modern then
        -- Modern branch: Insert Modern combo actions here if needed.
        OwlSleep(200)
        ifStun(Do_CrMP)
        OwlSleep(100)
        ifStun(Do_bombMP)
    end

    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping LK >=35001
if HitConfirm(18, 120, 35001, "None", "(Confirm) Jmp LK With Meter") then
    DisableGameInput()
    
    if Classic then
        -- Classic branch: Insert Classic-specific actions if needed.
        OwlSleep(200)
        ifStun(Do_CrMP)
        OwlSleep(100)
        ifStun(Do_scissorOD)
    
    elseif Modern then
        -- Modern branch: Execute the combo sequence for Modern.
        OwlSleep(200)
        ifStun(Do_CrMP)
        OwlSleep(100)
        ifStun(Do_scissorOD)
    end

    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT KICK

--#region! ================================================ MEDIUM KICK

--#region Crouching MK <=35000
if HitConfirm(13, 200, 0, 0, "(Confirm) Cr MK") and getLocalDriveMeter() <=35000 then
    DisableGameInput()
    if Classic then
        OS(100)
        ifStun(Do_bombMP)
    elseif Modern then
        OS(100)
        ifStun(Do_bombMP)
    end
    EnableGameInput()
    OS(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MK >=35001
if HitConfirm(13, 200, 35001, 0, "(Confirm) Cr MK With Meter") then
    DisableGameInput()
    if Classic then
        OwlSleep(100)
        ifStun(Do_scissorOD)
    elseif Modern then
        OwlSleep(100)
        ifStun(Do_scissorOD)
    end
    EnableGameInput()
    OS(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping MK >=35001
if HitConfirm(20, 120, 35001, "None", "(Confirm) Jmp MK With Meter") then
    DisableGameInput()
    if Classic then
        OS(200)
        ifStun(PMP)
        OS(40)
        RMP()
        OS(40)
        ifStun(PDown)
        ifStun(PMP)
        OS(40)
        ReleaseInputDownButton()
        RMP()
        OS(100)
        ifStun(Do_scissorOD)
    elseif Modern then
        -- Combo not available on Modern.
    end
    EnableGameInput()
    OS(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping MK <=35000 (Not on Modern)
if HitConfirm(20, 120, 0, "None", "(Confirm) Jmp MK") and getLocalDriveMeter() <=35000 then
    DisableGameInput()
    OwlSleep(200)
    if Classic then
        ifStun(PMP)
        OwlSleep(40)
        RMP()
        OS(40)
        ifStun(PDown)
        ifStun(PMP)
        OS(40)
        RDown()
        RMP()
        OS(100)
        ifStun(Do_bombMP)
    elseif Modern then
        -- Combo not available on Modern.
    end
    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM KICK

--#region! ================================================ HEAVY KICK

--#region Standing HK >=35001 (Not on Modern)
if   getLocalOldMethodMoveID() == 8
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getLocalInAirByte() ~= 2 
and getOpponentDistance() <= 91
and getLocalStunnedStateBeta() == 0
and getLocalDriveMeter()>=35001
    then
        DisableGameInput()
		OS(480)	
		PressInputDownButton()
		PressInputMediumPunch()
		OwlSleep(40)
		ReleaseInputDownButton()
		ReleaseInputMediumPunch()
		OS(100)
		Do_scissorOD()
        EnableGameInput()
       OwlSleep(400)
       setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing HK <=35000 (Not on Modern)
if   getLocalOldMethodMoveID() == 8
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getLocalInAirByte() ~= 2 
and getOpponentDistance() <= 91
and getLocalStunnedStateBeta() == 0
and getLocalDriveMeter()<=35000
    then
        DisableGameInput()
		OwlSleep(480)	
		PressInputDownButton()
		PressInputMediumPunch()
		OwlSleep(40)
		ReleaseInputDownButton()
		ReleaseInputMediumPunch()
		OwlSleep(100)
		Do_bombMP()
        EnableGameInput()
       OwlSleep(400)
       setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Back HK <=35000
if HitConfirm(29, 140, 0, "None", "(Confirm) Back HK") and getLocalDriveMeter() <=35000 then
    DisableGameInput()
    OS(80)
    if Classic then
        ifStun(Do_bombHP)
    elseif Modern then
        ifStun(Do_bombHP)
    end
    EnableGameInput()
    OS(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Back HK >=35001
if HitConfirm(29, 140, 35001, 0, "(Confirm) Back HK With Meter") then
    DisableGameInput()
    OS(80)
    if Classic then
        ifStun(Do_scissorOD)
    elseif Modern then
        ifStun(Do_scissorOD)
    end
    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Jumping HK 
if HitConfirm(22, 200, 0, 0, "(Confirm) Jmp HK")  then
    DisableGameInput()
    --OS(200)
    
    if Classic then
        ifStun(Do_StMP)
    elseif Modern then
        PAssist()
        ifStun(Do_StMP)
        OS(100)
        ifStun(Do_StMP)
        ifStun(Do_StMP)
        ifStun(Do_StMP)
        RAssist()
    end
    
    EnableGameInput()
    OS(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= HEAVY KICK

--#region! ================================================ OVERHEAD

--#region Overhead (Punish)
if HitConfirm(38, 220) then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        PLight()
        OS(20)
        RLight()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= OVERHEAD

--#region! ================================================ SCISSOR KICK

--#region Light Scissor Into Crouching LP on Counter
if getLocalOldMethodMoveID()==53
and getOpponentStunnedStateBeta() ~= 0 
and getLocalInAirByte() ~= 2 
and getOpponentInAirByte() ~= 2 
and getLocalStunnedStateBeta() == 0
and getOpponentDistance()<=139
and getOpponentIsBeingCounterHit()==true
and getLocalMoveTimer()==30
then
DisableGameInput()
PDown()
PLight()
OwlSleep(20)
RDown()
RLight()
EnableGameInput()
OwlSleep(60)
end
--#endregion

--#region Light Scissor Into Crouching MP on Punish Counter
if getLocalOldMethodMoveID()==53
and getOpponentStunnedStateBeta() ~= 0 
and getLocalInAirByte() ~= 2 
and getOpponentInAirByte() ~= 2 
and getLocalStunnedStateBeta() == 0
and getOpponentDistance()<=145
and getOpponentIsBeingCounterPunish()==true
and getLocalMoveTimer()==32
then
DisableGameInput()
OwlSleep(15)
Do_CrMP()
OwlSleep(60)
Do_bombMP() 
EnableGameInput()
OwlSleep(200)
end
--#endregion

--#endregion! ============================================= SCISSOR KICK

--#region! ================================================ COMBOS

--#region Smart st.HP with Bomb
if getLocalOldMethodMoveID()==7
and getOpponentInAirByte() ~= 2 
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getOpponentDistance() <= 100
and getLocalStunnedStateBeta() == 0
and getLocalDriveMeter()>=40000
and getLocalIsProjectileOnScreen()==true
and (getOpponentIsBeingCounterHit() == false and getOpponentIsBeingCounterPunish()== true)
then
DisableGameInput()
PressInputLeftButton()
OS(700)
PHeavy()
OS(40)
RHeavy()
OS(60)
ReleaseInputLeftButton()
PressInputRightButton()
PMedium()
PHeavy()
OS(40)
ReleaseInputRightButton()
RMedium()
RHeavy()
---start stomp:
PressInputDownButton()
OwlSleep(3700)
ReleaseInputDownButton()
PressInputUpButton()
PMedium()
PHeavy()
OwlSleep(40)
ReleaseInputUpButton()
RMedium()
RHeavy()
OwlSleep(500)
PHeavy()
OwlSleep(40)
RHeavy()
---stomp end
OS(540)
PressInputRightButton()
PHeavy()
OwlSleep(40)
ReleaseInputRightButton()
RHeavy()
OwlSleep(900)
Do_bombOD()
OwlSleep(1500)
PressInputDownButton()
OwlSleep(20)
ReleaseInputDownButton()
PressInputDownButton()
PressInputRightButton()
OwlSleep(20)
ReleaseInputDownButton()
OwlSleep(20)
ReleaseInputRightButton()
PressInputDownButton()
OwlSleep(20)
ReleaseInputDownButton()
PressInputDownButton()
PressInputRightButton()
OwlSleep(20)
ReleaseInputDownButton()
PHeavy()
OwlSleep(20)
ReleaseInputRightButton()
RHeavy()		
EnableGameInput()
OwlSleep(400)
end
--#endregion

--#region After OD Scissor Kick
if HitConfirm(105000, 200, 0, 0, "(Confirm) OD Scissor Kick") then
    DisableGameInput()
    if Classic then
        OwlSleep(80)
        ifStun(Do_scissorOD)
    elseif Modern then
        ifStun(function() KillCheck(2500, 3060, 3560) end)
    end
    EnableGameInput()
    OwlSleep(400)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Kill Combo LVL 1
function KillCombo_LVL1()
    print("*** KillCombo_LVL1 ***")
    OS(1550)
    if Classic then
        --NA
    elseif Modern then
        ifStun(Do_StHP)
        OS(60)
        ifStun(Do_LVL1)
    end
end
--#endregion

--#region Kill Combo LVL 2
function KillCombo_LVL2()
    MoveTimer(14, 1500)
    if Classic then
        --NA
    elseif Modern then
        ifStun(Do_StHP)
        OS(80)
        ifStun(LVL2)
    end
end
--#endregion

--#region Kill Combo LVL 3
function KillCombo_LVL3()
    MoveTimer(14, 1500)
    if Classic then
        --NA
    elseif Modern then
        ifStun(Do_StHP)
        OS(80)
        ifStun(LVL3)
    end
end
--#endregion

--#region Kill Combo LVL 3 - Juggle
function KillCombo_LVL3_Juggle()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PToward)
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        OS(300)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        ifStun(function() OS(1400) end) -- Wait time for launcher
        RDown()
        ifStun(DriveRush)
        OS(200)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(250)
        ifStun(PParry)
        OS(20)
        RParry()
        OS(300)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(PToward)
        OS(420) --- lvl 1 timing
        RToward()
        ifStun(QCB)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        ifStun(PBack)
        ifStun(function() OS(1000) end) -- Hands wait time
        ifStun(function() OS(460) end) -- Micro Walk
        RBack()
        ifStun(PDown)
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        RSpecial()
        RDown()
        ifStun(PDown) -- Mash Super for Corner Timing
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        RSpecial()
        RDown()
    end
end
--#endregion

--#region Kill Combo LVL 3 Max Damage  CA + Buff
function KillCombo_LVL3_Max()

    if Classic then
        --NA
    elseif Modern then
        ifStun(PParry)
        OS(320)
        RParry()
        OS(100)
        ifStun(PMedium)
        OS(20)
        RMedium()
        MoveTimer(14, 580) -- Fix Combo Timing
        ifStun(PHeavy)
        OS(20)
        RHeavy()
        OS(300) -- Second Loop if can Kill
        ifStun(PParry)
        OS(20)
        RParry()
        OS(200)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(750)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- End of Loop
        OS(200)
        ifStun(PToward) -- Start launcher
        ifStun(PSpecial)
        OS(40)
        RSpecial()
        RToward()
        ifStun(function() OS(300) end)
        ifStun(PDown)
        ifStun(PSpecial)
        OS(20)
        RSpecial()
        RDown() -- End of Launcher
        ifStun(function() OS(1300) end) -- Wait time after launcher
        ifStun(QCB) -- HP Hands Start
        OS(40)
        ifStun(PHeavy)
        OS(20)
        RHeavy() -- HP Hands End
        --PBack()
        ifStun(function() OS(900) end) -- Hands Wait Time
        ifStun(function() OS(900) end)-- Buff Wait Time
        --RBack()
        --PToward()
        ifStun(PSpecial)
        OS(20)
        --RToward()
        RSpecial()
        ifStun(function() OS(340) end)
        ifStun(PDown)
        ifStun(PSpecial)
        ifStun(PHeavy)
        OS(90)
        RSpecial()
        RHeavy()
        RDown()
    end
end
--#endregion

--#region Dizzy Combo

if getOpponentAnimationID() == 353 -- Dizzy
then
    DisableGameInput()
    ifStun(function() OS(400) end)
    ifStun(PDown)
    OS(20)
    RDown()
    OS(20)
    ifStun(PDown)
    OS(20)
    RDown()
    OS(20)
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    OS(800)
    ifStun(PToward)
    ifStun(PUp)
    OS(600) -- Jump Time
    RUp()
    RToward()
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    ifStun(function() OS(400) end)  -- Wait time for St HP
    ifStun(PHeavy)
    OS(20)
    RHeavy()
    EnableGameInput()
end


--#endregion

--#region Get Buff Combo Extension 

function GetBuff_Combo()

    if Classic then
        --NA
    elseif Modern then
        print("----- Starting Buff Combo) -----") 
        ifStun(DriveRush)
        ifStun(function() OS(300) end)
        ifStun(PToward)
        ifStun(PMedium)
        OS(20)
        RMedium()
        RToward()
        OS(80)
        ifStun(PDown)
        ifStun(PToward)
        ifStun(PMedium)
        OS(40)
        RDown()
        RToward()
        RMedium()
        ifStun(function() OS(920) end) -- Wait Time for Buff Cancel
        ifStun(PDown)
        ifStun(PMedium)
        OS(20)
        RMedium()
        OS(20)
        ifStun(PMedium)
        OS(20)
        RMedium()
        RDown()
        EnableGameInput()
    end
end

--#endregion


--#endregion! ============================================= COMBOS

--#region! ================================================ PUNISH AREA

--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 260  
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
PToward()  
OS(60)
RToward()
PHeavy()
OS(20)  
RHeavy()
EnableGameInput()
setOpponentOldMethodMoveID(0)
setOpponentAnimationID(1)
OS(300)
end
--#endregion

--#endregion! ============================================= PUNISH AREA

--#region! ================================================ ANTI CHARACTER
-- PunCon(charID, moveID, startup, minDistance, maxDistance, label)

--#region Anti Ryu

--#region Punches
--StartUP
if PunCond(1,  6, 9,   0, 200, "St HP")             then PLight() OS(20) RLight() end
--Whiff 
if PunCond(1,  4,  nil,  130, 288, "St MP")           then OS(100) Do_StHP() TatsuMK()  end
if PunCond(1,  6,  9,  221, 288, "St HP")           then AdFlameMP() end
--#endregion

--#region Kicks
--StartUP
if PunCond(1, 18, 9,   0, 199, "Cr MK")             then Do_StLP() PSpecial() OS(20) RSpecial() end
if PunCond(1,  7, 9,   0, 200, "St HK")             then Do_CrMK() AdFlameMP() end
--Whiff
if PunCond(1, 18,  9,  200, 288, "Cr MK")           then AdFlameMP() end
if PunCond(1, 20,  9,  209, 290, "Cr HK")           then AdFlameMP() end
--Block
if PunCond(1,  5, 9,   0, 300, "St MK")             then PBack() OS(200) RBack() end
--#endregion

--#region Unique Attacks
if PunCond(1, 12, nil, 0  , 130, "Whirl Kick")      then Do_StMP() OS(60) Do_StMP() OS(300) AdFlameMP() end
if PunCond(1, 12, nil, 131, 230, "Whirl Kick")      then PBack() OS(300) RBack() end
if PunCond(1, 12, nil, 231, 400, "Whirl Kick")      then PBack() OS(200) RBack() AdFlameMP() end
if PunCond(1,  9, nil,   0, 240, "SoloPlex")        then ShoryukenHP() end
if PunCond(1,  9, nil, 241, 440, "SoloPlex")        then OS(160) AdFlameMP() end
if PunCond(1,  8, nil,   0, 200, "Overhead")        then ShoryukenOD() end
--#endregion

--#region Anit-Air
-- if PunCond(1, 69, nil, 00, 230, "Air Tatsu")    then OS(200) ShoryukenHP() end
-- if AAReady(0,   200, 37, "F.Jump - Close AA")   then DisableGameInput() OS(500) ShoryukenLP() EnableGameInput() OS(1000) end
-- if AAReady(200, 260, 37, "F.Jump - Mid AA")     then DisableGameInput() OS(260) ShoryukenMP() EnableGameInput() OS(2000) end
-- if AAReady(0,   160, 36, "Neutral AA")          then DisableGameInput() OS(260) ShoryukenLP() EnableGameInput() OS(2000) end
--#endregion

--#region DriveRush
if PunCond(1, 92, nil, 120, 220, "DR") then Do_StMK()   end
if PunCond(1, 92, nil, 220, 300, "DR") then Do_StHK()   end
if PunCond(1, 92, nil, 300, 600, "DR") then PSpecial() OS(20) RSpecial()   end
--#endregion

--#region Fireballs 
--Far
-- if PunCond(1, 53, nil, 250, 350, "Fireball LP") then BlockHigh(400, 1300, 400) end --Parry(400, 300, 400) end
-- if PunCond(1, 82, nil, 250, 350, "Fireball LP") then BlockHigh(400, 1300, 400) end --Parry(400, 300, 400) end
-- if PunCond(1, 54, nil, 250, 350, "Fireball MP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 400) end
-- if PunCond(1, 83, nil, 250, 350, "Fireball MP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 400) end
-- if PunCond(1, 55, nil, 253, 400, "Fireball HP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 600) end
-- if PunCond(1, 84, nil, 253, 400, "Fireball HP") then BlockHigh(400, 1400, 400) end --Parry(400, 400, 600) end
-- if PunCond(1, 56, nil, 250, 350, "Denjin Fireball") then BlockHigh(400, 1400, 400) end --Parry(200, 300, 400) end
--Close
-- if PunCond(1, 53, nil, 75, 249, "Fireball LP") then Parry(180, 20, 300) Do_StHP() end
-- if PunCond(1, 82, nil, 75, 249, "Fireball LP") then Parry(180, 20, 300) Do_StHP() end
-- if PunCond(1, 54, nil, 75, 249, "Fireball MP") then Parry(160, 20, 300) Do_StHP() end -- 160 is way too strong
-- if PunCond(1, 83, nil, 75, 249, "Fireball MP") then Parry(160, 20, 300) Do_StHP() end -- 160 is way too strong
-- if PunCond(1, 55, nil, 75, 252, "Fireball HP") then Parry(120, 20, 300) Do_StHP() end
-- if PunCond(1, 84, nil, 75, 252, "Fireball HP") then Parry(120, 20, 300) Do_StHP() end
-- if PunCond(1, 56, nil, 75, 249, "Denjin Fireball") then Parry(120, 20, 300) Do_StHP() end
--#endregion

--#region Denjin Charge
if PunCond(1, 48, nil, 300, 500, "Denjin Charge LP") then DisableGameInput() PSpecial() OS(20) RSpecial() OS(400) EnableGameInput() end
--#endregion

--#region Hashogeki
--StartUP
if PunCond(1, 73, nil,   0, 250, "Hashogeki MP")    then Do_StHP() end -- this can be beat.. maybe EXDP?
if PunCond(1, 74, nil,   0, 160, "Hashogeki HP")    then Do_StHP() end
--Whiff 
if PunCond(1, 72, nil, 160, 300, "Hashogeki LP")    then AdFlameMP() end
if PunCond(1, 73, nil, 250, 300, "Hashogeki MP")    then OS(160) AdFlameMP() end
if PunCond(1, 74, nil, 160, 300, "Hashogeki HP")    then AdFlameMP() end
--#endregion

--#region Blade Kick

--Startup 
if PunCond(1, 64, nil, 0, 200, "Blade Kick LK")     then Do_StHP() end
if PunCond(1, 65, nil, 0, 200, "Blade Kick MK")     then Do_StHP() end
if PunCond(1, 66, nil, 0, 160, "Blade Kick HK")     then Do_StHP() end
--MidRange
if PunCond(1, 64, nil, 201, 250, "Blade Kick LK")     then Parry(100, 20, 300) Do_StHP() end
if PunCond(1, 65, nil, 201, 270, "Blade Kick MK")     then Parry(100, 20, 300) Do_StHP() end
if PunCond(1, 66, nil, 161, 270, "Blade Kick HK")     then Parry(300, 20, 300) Do_StHP() end
--Whiff 
if PunCond(1, 64, nil, 250, 350, "Blade Kick LK")   then OS(80)  AdFlameMP() end
if PunCond(1, 65, nil, 271, 350, "Blade Kick MK")   then OS(240) AdFlameMP() end
if PunCond(1, 66, nil, 271, 450, "Blade Kick HK")   then OS(340) AdFlameMP() end

--#endregion

--#region Tatsu LK
--Whiff
if PunCond(1, 59, nil, 236, 400, "Tatsu LK")  then 
    PBack() 
    OS(200) 
    RBack() 
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 59, nil, 0, 230, "Tatsu LK")  then 
    DisableGameInput()
    PBack() 
    OS(200) 
    RBack() 
    OS(500)
    Do_StHK() 
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#region Tatsu MK
--Whiff
if PunCond(1, 60, nil, 301, 400, "Tatsu MK")  then 
    PBack() 
    OS(200) 
    RBack() 
    OS(200)
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 60, nil, 0, 300, "Tatsu MK")  then 
    DisableGameInput()
    PBack() 
    OS(200) 
    RBack() 
    OS(1000)
    Do_StHK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#region Tatsu HK
--Whiff
if PunCond(1, 61, nil, 301, 400, "Tatsu HK")  then 
    PBack() 
    OS(800) 
    RBack() 
    OS(200)
    AdFlameMP() 
    ifStun(function()  OS(20) end)  Do_StHP()
    setOpponentOldMethodMoveID(0) 
end
--Blocked
if PunCond(1, 61, nil, 0, 300, "Tatsu HK")  then 
    DisableGameInput()
    PBack() 
    OS(800) 
    RBack() 
    OS(1000)
    Do_StHK()
    EnableGameInput()
    setOpponentOldMethodMoveID(0) 
end
--#endregion

--#endregion Anti Ryu

--#endregion! ============================================= ANTI CHARACTER


--------------------------------------------
end -- END OF Character
--#endregion= ============================== 26 - M. Bison
    
--#region= ================================= 28 - Mai
if getLocalCharacterID() == 28 then
--------------------------------------------       

--#region! ================================================ CHARACTER MOVES / ACTIONS

--#region* Standard Actions / Buttons / Controller Motions --------------------

--#region Standing LP
function Do_StLP()
    DisableGameInput()

    if Classic then
        PLP()
        OS(40)
        RLP()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LP
function Do_CrLP()
    DisableGameInput()

    if Classic then
        PDown()
        PLP()
        OS(40)
        RLP()
        RDown()
        
    elseif Modern then
        PDown()
        PLight()
        OS(40)
        RLight()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MP
function Do_StMP()
    DisableGameInput()

    if Classic then
        PMP()
        OS(40)
        RMP()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MP
function Do_CrMP()
    DisableGameInput()

    if Classic then
        PDown()
        PMP()
        OS(40)
        RMP()
        RDown()
        
    elseif Modern then
        PAssist()
        PMedium()
        OS(40)
        RAssist()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HP
function Do_StHP()
    DisableGameInput()

    if Classic then
        PHP()
        OS(40)
        RHP()
        
    elseif Modern then
        PAssist()
        PHeavy()
        OS(40)
        RAssist()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HP
function Do_CrHP()
    DisableGameInput()

    if Classic then
        PDown()
        PHP()
        OS(40)
        RHP()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RDown()
        RToward()
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Standing LK
function Do_StLK()
    DisableGameInput()

    if Classic then
        PLK()
        OS(40)
        RLK()
        
    elseif Modern then
        PLight()
        OS(40)
        RLight()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching LK
function Do_CrLK()
    DisableGameInput()

    if Classic then
        PDown()
        PLK()
        OS(40)
        RLK()
        RDown()
        
    elseif Modern then
        PAssist()
        PLight()
        OS(40)
        RLight()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#region Standing MK
function Do_StMK()
    DisableGameInput()

    if Classic then
        PMK()
        OS(40)
        RMK()
        
    elseif Modern then
        PMedium()
        OS(40)
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching MK
function Do_CrMK()
    DisableGameInput()

    if Classic then
        PDown()
        PMK()
        OS(40)
        RMK()
        RDown()
        
    elseif Modern then
        PDown()
        PMedium()
        OS(40)
        RMedium()
        RDown()
    end

    EnableGameInput()
end
--#endregion

--#region Standing HK
function Do_StHK()
    DisableGameInput()

    if Classic then
        PHK()
        OS(40)
        RHK()
        
    elseif Modern then
        PHeavy()
        OS(40)
        RHeavy()
    end

    EnableGameInput()
end
--#endregion

--#region Crouching HK
function Do_CrHK()
    DisableGameInput()

    if Classic then
        PDown()
        PHK()
        OS(40)
        RHK()
        RDown()
        
    elseif Modern then
        PDown()
        PToward()
        PHeavy()
        OS(40)
        RHeavy()
        RDown()
        RToward()
    end

    EnableGameInput()
end
--#endregion

--#region Block High
function BlockHigh()
    PBack()
    OS(60)
    RBack()
end 
--#endregion

--#region Block Low
function BlockLow()
    PDown()
    PBack()
    OS(80)
    RDown()
    RBack()
end 
--#endregion

--#region Throw
function Throw()
    DisableGameInput()

    if Classic then
        PLP()
        PLK()
        OS(40)
        RLP()
        RLK()
        
    elseif Modern then
        PLight()
        PMedium()
        OS(40)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#region QCF 
function QCF()
    PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	OS(30)
	RToward()
end
--#endregion

--#region QCB 
function QCB()
    PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	OS(30)
	RBack()
end
--#endregion

--#endregion* -------------------------------------------------------

--#region* Special Move Functions ------------------------------------

--#region Ryuuenbu (QCB + Button) ---------------------------------

--#region Ryuuenbu (LP)
function Do_ryuuenbu_LP()
    DisableGameInput()
	QCB()
	PLight()
	OS(20)
	RLight()
    EnableGameInput()
end
--#endregion

--#region Ryuuenbu (MP)
function Do_ryuuenbu_MP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	PMedium()
	OS(20)
	RBack()
	RMedium()
end
--#endregion

--#region Ryuuenbu (HP)
function Do_ryuuenbu_HP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PBack()
	OS(20)
	RDown()
	RBack()
	PBack()
	PHeavy()
	OS(20)
	RBack()
	RHeavy()
end
--#endregion

--#region Ryuuenbu (OD)
function Do_ryuuenbu_OD()
    DisableGameInput()

    if Classic then
        QCB()
        PLP()
        PMP()
        OS(20)
        RLP()
        RMP()
        
    elseif Modern then
        QCB()
        PLight()
        PMedium()
        OS(20)
        RLight()
        RMedium()
    end

    EnableGameInput()
end
--#endregion

--#endregion -------------------------------------------------------

--#region Kachousen (QCF + Button) ---------------------------------

--#region Kachousen (LP) 
function Do_fireball_LP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PLight()
	OS(30)
	RToward()
	RLight()
end
--#endregion

--#region Kachousen (MP) 
function Do_fireball_MP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PMedium()
	OS(30)
	RToward()
	RMedium()
end
--#endregion

--#region Kachousen (HP) 
function Do_fireball_HP()
	PDown()
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PHeavy()
	OS(30)
	RToward()
	RHeavy()
end
--#endregion

--#endregion -------------------------------------------------------

--#region Hishou Ryuuenjin (DP + Button) ---------------------------

--- Hishou Ryuuenjin (LK)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PLight()
    OS(20)
    RToward()
    RLight()
end

--- Hishou Ryuuenjin (MK)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PMedium()
    OS(20)
    RToward()
    RMedium()
end

--- Hishou Ryuuenjin (HK)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PHeavy()
    OS(20)
    RToward()
    RHeavy()
end

--- Hishou Ryuuenjin (OD)
function Do_hishou_LK()
    PToward()
    OS(20)
    RToward()
    PDown()
    PToward()
    OS(20)
    RDown()
    RToward()
    PToward()
    PLight()
    PMedium()
    OS(20)
    RToward()
    RLight()
    RMedium()
end

--#endregion

--#region Hissatsu (Down + Special) ---------------------------------

--#region Hissatsu (LK)
function Do_hissatsu_LK()
    DisableGameInput()

    if Classic then
        QCF()
	    PLK()
	    OS(30)
	    RLK()
        
    elseif Modern then
        PDown()
        PSpecial()
        OS(20)
        RDown()
        RSpecial()
    end

    EnableGameInput()
end
--#endregion

--#region Hissatsu (MK)
function Do_hissatsu_MK()
    DisableGameInput()

    if Classic then
        QCF()
        PMK()
	    OS(30)
        RMK()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Hissatsu (HK)
function Do_hissatsu_HK()
    DisableGameInput()

    if Classic then
        QCF()
	    PHK()
	    OS(30)
        RHK()
        
    elseif Modern then
        -- NA
    end

    EnableGameInput()
end
--#endregion

--#region Hissatsu (OD)
function Do_hissatsu_OD()
    DisableGameInput()

    if Classic then
        QCF()
	    PLK()
        PMK()
	    OS(30)
	    RLK()
        RMK()
        
    elseif Modern then
        PAssist()
        PDown()
        PSpecial()
        OS(20)
        RDown()
        RSpecial()
        RAssist()
    end

    EnableGameInput()
end
--#endregion

--#endregion -------------------------------------------------------

--#endregion* -------------------------------------------------------


--#endregion! ============================================= CHARACTER MOVES / ACTIONS

--#region! ================================================ LIGHT PUNCH

--#region Standing LP
if HitConfirm(3, 200) then
    DisableGameInput()
    
    if Classic then
        PBack() -- Stops Unwanted DP If pressing forward
        OS(40)
        RBack() -- Stops Unwanted DP If pressing forward
        Do_hissatsu_LK()
    elseif Modern then
        -- NA 
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching LP
if HitConfirm(13, 200) then
    DisableGameInput()
    
    if Classic then
        PBack() -- Stops Unwanted DP If pressing forward
        OS(40)
        RBack() -- Stops Unwanted DP If pressing forward
        Do_hissatsu_LK()
    elseif Modern then
        PDown()
        PSpecial()
        OS(20)
        RDown()
        RSpecial()
    end

    EnableGameInput()
    OwlSleep(200)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= LIGHT PUNCH

--#region! ================================================ MEDIUM PUNCH

--#region Crouching MP
if HitConfirm(15, 200)  
then
    DisableGameInput() 
    
    if Classic then
        MoveTimer(14, 0)
        Do_ryuuenbu_OD()
    elseif Modern then
        MoveTimer(14, 0)
        ifStun(PAssist)
        ifStun(PMedium)
        OS(20)
        RAssist()
        RMedium()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Standing MP
if HitConfirm(7, 200)  
then
    DisableGameInput() 
    
    if Classic then
        Do_ryuuenbu_OD()
    elseif Modern then
        PAssist()
        PMedium()
        OS(20)
        RAssist()
        RMedium()
    end
    
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM PUNCH

--#region! ================================================ HEAVY PUNCH

--#region Standing HP >=35001 Need Buff
--[[if   getLocalOldMethodMoveID() == 9 
and getOpponentStunnedStateBeta() ~= 0 
and getOpponentInAirByte() ~= 2 
and getLocalInAirByte() ~= 2
and getOpponentDistance() <= 190
and getLocalStunnedStateBeta() == 0
and getOpponentIsBeingCounterHit() == false
and getOpponentIsBeingCounterPunish() == true
and getLocalDriveMeter()>=35001
then
    DisableGameInput()  -- Commented out for debugging	
    
    PDown() -- Start Fireball OD
	OS(20)
	RDown()
	PDown()
	PToward()
	OS(20)
	RDown()
	RToward()
	PToward()
	PHeavy()
    PMedium()
	OS(600)
	RToward()
    RMedium()
	RHeavy() -- End Fireball


	PAssist()
    PHeavy()
    OS(20)
    RAssist()
    RHeavy()
    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end--]]
--#endregion

--#region Standing HP 
if HitConfirm(9, 190) then
    DisableGameInput()

    if Classic then
        Do_hissatsu_OD()
        
    elseif Modern then
        Do_hissatsu_OD()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching HP - Incomplete
if HitConfirm(17, 190) then
    DisableGameInput()

    if Classic then
        OS(600) -- timing is good need to work on the combo
        PDown()
        PLP()
        OS(20)
        RDown()
        RLP()
        
    elseif Modern then
        Do_hissatsu_OD()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================ HEAVY PUNCH

--#region! ================================================ LIGHT KICK

-- Nothing Yet

--#endregion! ============================================= LIGHT KICK

--#region! ================================================ MEDIUM KICK

--#region Standing MK (Punish)
if HitConfirm(8, 220, 0, "Punish") then
    DisableGameInput()

    if Classic then
        OS(60)
        Do_CrMK()
        
    elseif Modern then
        OS(60)
        Do_CrMK()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Crouching MK 
if HitConfirm(16, 220) then
    DisableGameInput()

    if Classic then
        Do_hissatsu_LK()
        
    elseif Modern then
        Do_hissatsu_LK()
        Do_hissatsu_LK() -- Modern Mash
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= MEDIUM KICK

--#region! ================================================ HEAVY KICK

--#region Standing HK (Punish)
if HitConfirm(10, 220, 0, "Punish") then
    DisableGameInput()

    if Classic then
        -- Nothing Yet
        
    elseif Modern then
        -- Nothing Yet
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= HEAVY KICK

--#region!  =============================================== COMBOS

function Combo1()
    DisableGameInput()

    if Classic then
        Do_StLP()
        Do_CrLP()
        Do_StMP()
        Do_CrMP()
        Do_ryuuenbu_LP()
        Do_hissatsu_LK()
        
    elseif Modern then
        PParry()
        OS(20)
        RParry()
        OS(20)
        PParry()
        OS(20)
        RParry()
        OS(300)
        Do_StHK()
        
        Do_ryuuenbu_LP()
        Do_hissatsu_LK()
    end

    EnableGameInput()
    OwlSleep(300)
    setOpponentOldMethodMoveID(0)
end

--#endregion! ============================================= COMBOS

--#region! ================================================ SHIMMY

--#region Shimmy Punish
if opponentDistance >= 119 and opponentDistance <= 200 
and getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(OpponentAnimationID == 715 or 
OpponentAnimationID == 717 or 
OpponentAnimationID == 700 or 
OpponentAnimationID == 701 or
OpponentAnimationID == 716 or 
OpponentAnimationID == 710 or
OpponentAnimationID == 712) 
then
DisableGameInput()
OS(60)
Do_StHK()
EnableGameInput()
OS(500)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= SHIMMY

--#region! ================================================ REACTIONS

--#region Wakeup OD DP -- Needs Work its messy

local function getODDPMode()
    if getLocalDriveMeter() >= 1 and getOpponentHealthMeter() <= 1600 and getLocalSAMeter() <= 19999 then
        return "burnoutKill"  -- OD DP that puts in Burnout but kills
    elseif getLocalDriveMeter() >= 20050 and getOpponentHealthMeter() >= 3001 and getLocalSAMeter() >= 20000 then
        return "highDrive"  -- Safe OD DP with high Drive Meter
    end
    return nil
end

local function shouldAutoODDP(mode)
    if getOpponentOldMethodMoveID() == 0 or getOpponentDistance() > 200 then
        return false
    end

    local opponentID = getOpponentCharacterID()
    local moveID = getOpponentOldMethodMoveID()

    -- **Ordered by Character ID**
    local validMoves = {
        [1]  = {90},                    -- Ryu
        [2]  = {104},                   -- Luke
        [3]  = {116},                   -- Kim
        [4]  = {155},                   -- Chun
        [5]  = {119},                   -- Manon
        [6]  = {107, 93, 94, 95, 158},  -- Zangief (Multiple Moves)
        [7]  = {91},                    -- JP
        [8]  = {131},                   -- Dhalsim
        [9]  = {117},                   -- Cammy
        [10] = {118},                   -- Ken
        [11] = {94},                    -- Dee Jay
        [12] = {92},                    -- Lily
        [13] = {95},                    -- AKI
        [14] = {97},                    -- Rashid
        [15] = {156},                   -- Blanka
        [16] = {109},                   -- Juri
        [17] = {149, 124, 188},         -- Marisa (Multiple Moves)
        [18] = {107},                   -- Guile
        [19] = {105},                   -- Ed
        [20] = {101},                   -- Honda
        [21] = {147},                   -- Jamie
        [22] = {101},                   -- Akuma
        [26] = {78},                    -- Bison
        [27] = {43},                      -- Terry (Hammer Punch)
        [28] = {37},                    -- Mai
        [29] = {}                       -- Elena
    }

    -- Check if opponent's move is in the valid move list
    local isValidMove = false
    if validMoves[opponentID] then
        for _, id in ipairs(validMoves[opponentID]) do
            if moveID == id then
                isValidMove = true
                break
            end
        end
    end

    if isValidMove then
        return false
    end

    -- Ensure general wakeup conditions
    return getOpponentInAirByte() ~= 2
        and getLocalInAirByte() == 0
        and (getLocalAnimationID() == 340 or getLocalAnimationID() == 341)
        and getOpponentStartUpEndFrame() >= 9
end

--  Determine OD DP mode automatically
local mode = getODDPMode()
if mode and shouldAutoODDP(mode) then
    DisableGameInput()
    OwlSleep(20)
    
    -- Execute OD DP Motion
    PressInputRightButton()
    OwlSleep(20)
    ReleaseInputRightButton()

    PressInputDownButton()
    PressInputRightButton()
    OwlSleep(20)

    ReleaseInputDownButton()
    PLight()  -- OD DP uses both punches
    PMedium()
    OwlSleep(20)

    ReleaseInputRightButton()
    RLight()
    RMedium()

    EnableGameInput()
    OwlSleep(100)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region Backdash Punish
if getOpponentStunnedStateBeta() == 0 
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getOpponentDistance() <= 160
and getLocalStunnedStateBeta() == 0
and getOpponentOldMethodMoveID() == 1 --102
and getOpponentMoveTimer()==0 
and getLocalOldMethodMoveID()==0
and getLocalAnimationID() ~= 174
and getLocalAnimationID() ~= 176
and getLocalAnimationID() ~= 175
and PROBABILITY()
then
DisableGameInput()
Do_CrHK()
OwlSleep(200)
EnableGameInput()
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Auto Super Art 3 on Wake Up if Can Kill -- Needs Work
if getOpponentOldMethodMoveID() ~= 0 
and getOpponentDistance() <= 200  
and 
(
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() ~= 101) or --22 akuma 	
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() ~= 90) or --1: Ryu 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() ~= 104) or --2: Luke 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() ~= 116) or --3: Kim 
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() ~= 155 and getOpponentOldMethodMoveID()~= 34) or --4: Chun 	
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() ~= 119) or --5: Manon 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() ~= 107 and getOpponentOldMethodMoveID()~= 93 and getOpponentOldMethodMoveID()~= 94 and getOpponentOldMethodMoveID()~= 95 and getOpponentOldMethodMoveID()~= 158) or --6: Gief 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() ~= 91) or --7: JP 
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() ~= 131) or --8: Sim 	
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() ~= 117) or --9: Cammy 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() ~= 118) or --10: Ken 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() ~= 94) or --11: DJ 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() ~= 92) or --12: Lily 	
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() ~= 95) or --13: AKI 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() ~= 97) or --14: Rashid 
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() ~= 156) or --15: Blanka 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() ~= 109) or --16: Juri 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() ~= 149) or --17: Marisa 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() ~= 107) or --18: Guile 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() ~= 105) or --19: Ed 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() ~= 147) or --21: Jamie 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() ~= 101)  --20: Honda  
)
    and ((getLocalHealthMeter()>=2251 and getOpponentHealthMeter()<=4000 and getLocalSAMeter()==30000) or (getLocalHealthMeter()<=2250 and getOpponentHealthMeter()<=4500 and getLocalSAMeter()==30000))
    and getOpponentInAirByte() ~= 2 
    and getLocalInAirByte() == 0
	and (getLocalAnimationID() == 341 or getLocalAnimationID() == 340 or getLocalAnimationID() == 341)
	and getOpponentStartUpEndFrame()>= 12
    then
	-- DisableGameInput()  -- Commented out for debugging
	PressInputDownButton()
        OwlSleep(20)
        ReleaseInputDownButton()
        PressInputDownButton()
        PressInputRightButton()
	    OwlSleep(20)
	    ReleaseInputDownButton()
	    OwlSleep(20)
        ReleaseInputRightButton()
	    PressInputDownButton()
        OwlSleep(20)
        ReleaseInputDownButton()
        PressInputDownButton()
        PressInputRightButton()
	    OwlSleep(20)
	    ReleaseInputDownButton()
	    PHeavy()
	    OwlSleep(20)
        ReleaseInputRightButton()
        RHeavy()
EnableGameInput()
OwlSleep(500)
setOpponentOldMethodMoveID(0)
 end
--#endregion

--#region Anti Drive Reversal
if opponentDistance >= 70 
and opponentDistance <= 220 
and getOpponentMoveTimer() == 1 
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and getLocalOldMethodMoveID() == 0
and not getOpponentIsProjectileOnScreen()
then
    local opponentID = getOpponentCharacterID()
    local moveID = getOpponentOldMethodMoveID()

    -- Check if opponent's move is a valid Drive Reversal move
    if driveReversalMoves[opponentID] then
        for _, validMoveID in ipairs(driveReversalMoves[opponentID]) do
            if moveID == validMoveID then
                -- Drive Reversal Detected
                PParry()
                OwlSleep(250)
                RParry()
                EnableGameInput()
                OwlSleep(400)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Drive Rush Check with Crouching MK
if getOpponentStunnedStateBeta() == 0
and getOpponentDistance() <= 250
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and local_ready
and getOpponentMoveTimer() == 2
and getLocalOldMethodMoveID() == 0
and PROBABILITY()
and not getOpponentIsProjectileOnScreen()
and driveRushMoves[getOpponentCharacterID()] ~= nil
then
    for _, validMoveID in ipairs(driveRushMoves[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            Do_CrMK()
            EnableGameInput()
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Block Unsafe Move +4
if getLocalAttackingByte() == 27 and getOpponentDistance() <= 140
and minus4onBlock[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(minus4onBlock[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            print("Blocked a -4 move! Executing Auto-Confirm")
            OS(80)
            DisableGameInput()
            Do_CrLP()
            EnableGameInput()

            break
        end
    end
end
--#endregion

--#region Block Unsafe Move +6
if getLocalAttackingByte() == 27
and getOpponentDistance() <= 161
and minus6onBlock[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(minus6onBlock[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            print("Blocked a -6 move! Executing Auto-Confirm")
            OS(80)
            DisableGameInput()
            Do_CrMP()
            EnableGameInput()
            break
        end
    end
end
--#endregion


--#endregion! ============================================= REACTIONS

--#region! ================================================ THROW LOOP

if getLocalIsThrowing() and getOpponentIsThrowing() == false then
    DisableGameInput()
    OS(500)
    if getOpponentDistance() > 250 then EnableGameInput() end
    OS(1500)

    local randomChoice = math.random(4)

if randomChoice == 1 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Meaty MP
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(340)
    Do_CrMP()

elseif (randomChoice == 2 or randomChoice == 4) and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Throw Loop
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(360)

    -- Backdash check
    if getOpponentStunnedStateBeta() == 0 
    and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
    and getOpponentDistance() <= 160
    and getLocalStunnedStateBeta() == 0
    and getOpponentOldMethodMoveID() == 1 --102
    and getOpponentMoveTimer()==0 
    and getLocalOldMethodMoveID()==0
    and getLocalAnimationID() ~= 174
    and getLocalAnimationID() ~= 176
    and getLocalAnimationID() ~= 175 
    
    then -- Doing BackDash?
        Do_StHP()
    else
        Throw()
    end

elseif randomChoice == 3 and getOpponentDistance() < 235 and getLocalInAirByte() == 0 then -- Shimmy
    PToward()
    OS(40)
    RToward()
    OS(60)
    PToward()
    OS(50)
    RToward() -- end dash
    OS(300)
    PBack()
    OS(200)
    RBack()
    Do_StHP()
end

    EnableGameInput()
end
--#endregion! ============================================= THROW LOOP

--#region! ================================================ STARTUP PUNISH

--#region Startup Punish (18F)
if isCounterReady(220) then
    local StartupPunish_18F = {
        [1]  = {8, 9, 65, 66, 74, 73, 75, 156, 157},   -- Ryu
        [2]  = {25},                                    -- Luke
        [3]  = {27, 28, 80, 181, 76},                  -- Kim
        [4]  = {167, 126, 33, 67},                     -- Chun-Li
        [5]  = {95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 
                105, 106, 107, 108, 109, 59, 169},      -- Manon
        [6]  = {31},                                   -- Zangief
        [7]  = {26, 66, 67, 137},                      -- JP
        [8]  = {82, 84, 209},                          -- Dhalsim
        [9]  = {27, 69, 70, 71},                       -- Cammy
        [10] = {54, 112, 66, 101, 102, 103},           -- Ken
        [11] = {26, 68, 163, 59, 158},                 -- Dee Jay
        [12] = {28, 24, 51, 52, 140},                  -- Lily
        [13] = {40},                                   -- AKI
        [14] = {42, 83, 84, 79, 81, 127},              -- Rashid
        [15] = {26, 30, 208, 66},                      -- Blanka
        [16] = {50, 70, 81, 82, 166, 87, 86, 165},     -- Juri
        [17] = {43, 117, 118, 119, 187},               -- Marisa
        [18] = {26},                                   -- Guile
        [19] = {9000},                                 -- Ed
        [20] = {28, 52, 53, 163},                      -- Honda
        [21] = {9, 19, 10, 20, 76, 110, 111, 184, 137, 
                138, 118, 119, 186, 190},              -- Jamie
        [22] = {8},                                    -- Akuma
        [26] = {7, 27},                                -- Bison
        [27] = {43},                                     -- Terry (Hammer Punch)    
        [28] = {},                                     -- Mai
        [29] = {}                                      -- Elena
    }

    if StartupPunish_18F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_18F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                DisableGameInput()
                Do_StHP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (14-17F)
if isCounterReady(220) then
    local StartupPunish_14to17F = {
        [1]  = {12, 64, 153},                -- Ryu
        [2]  = {32, 27, 142},                -- Luke (?, Double Impact, ?)
        [3]  = {75, 175},                    -- Kim
        [4]  = {8, 30, 66},                  -- Chun-Li
        [5]  = {8, 92, 57, 58},              -- Manon
        [6]  = {6, 29, 33, 41},              -- Zangief
        [7]  = {27, 9000},                   -- JP
        [8]  = {80},                         -- Dhalsim
        [9]  = {9000},                       -- Cammy
        [10] = {9000, 111, 65},              -- Ken
        [11] = {15, 71, 60},                 -- Dee Jay
        [12] = {8, 27},                      -- Lily
        [13] = {18, 19},                     -- AKI
        [14] = {70, 43, 82, 78},             -- Rashid
        [15] = {14},                         -- Blanka
        [16] = {14, 48, 73},                 -- Juri
        [17] = {14, 38, 127, 125, 9000},     -- Marisa
        [18] = {30, 31},                     -- Guile
        [19] = {27, 54, 71, 72, 73},         -- Ed
        [20] = {27, 85},                     -- Honda
        [21] = {8, 13, 14, 71, 109},         -- Jamie
        [22] = {},                           -- Akuma (No values yet)
        [26] = {},                           -- Bison (No values yet)
        [27] = {},                           -- Terry (No values yet)
        [28] = {},                           -- Mai (No values yet)
        [29] = {}                            -- Elena (No values yet)
    }

    if StartupPunish_14to17F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_14to17F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                DisableGameInput()
                Do_CrMP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (12-13F)
if isCounterReady(200) then
    -- Define valid counter punish moves per character
    local StartupPunish_12to13F = {
        [1]  = {7, 72, 73},                     -- Ryu
        [2]  = {30, 78, 77, 65},                -- Luke (Outlaw Kick, ?, ?, ?)
        [3]  = {8},                             -- Kim
        [4]  = {7},                             -- Chun-Li
        [5]  = {9000},                          -- Manon
        [6]  = {7, 15},                         -- Zangief
        [7]  = {5, 7, 8},                       -- JP
        [8]  = {28},                            -- Dhalsim
        [9]  = {9000},                          -- Cammy
        [10] = {8, 110, 64, 166, 174},          -- Ken
        [11] = {7, 69, 58},                     -- Dee Jay
        [12] = {9000},                          -- Lily
        [13] = {8},                             -- AKI
        [14] = {8, 14},                         -- Rashid
        [15] = {32, 65},                        -- Blanka
        [16] = {69, 158},                       -- Juri
        [17] = {12},                            -- Marisa
        [18] = {8},                             -- Guile
        [19] = {16, 69, 70},                    -- Ed
        [20] = {51},                            -- Honda
        [21] = {66, 182},                       -- Jamie
        [22] = {10, 11, 7},                     -- Akuma
        [26] = {8},                             -- Bison
        [27] = {8},                             -- Terry (St.HK)
        [28] = {},                              -- Mai (No values yet)
        [29] = {}                               -- Elena (No values yet)
    }

    -- Check if the opponent's move is in the StartupPunish_12to13F table
    if StartupPunish_12to13F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_12to13F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                print("Starting 12f - 13f punish") -- Debug
                DisableGameInput()
                Do_CrMP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (11F)
if isCounterReady(220) then
    -- Define valid counter punish moves per character
    local StartupPunish_11F = {
        [1]  = {1444},                           -- Ryu
        [2]  = {},                    -- Luke
        [3]  = {32},                             -- Kim
        [4]  = {15, 125},                        -- Chun-Li
        [5]  = {15, 39, 91},                     -- Manon
        [6]  = {14},                             -- Zangief
        [7]  = {28},                             -- JP
        [8]  = {},                               -- Dhalsim (No values yet)
        [9]  = {8},                              -- Cammy
        [10] = {178, 9000},                      -- Ken
        [11] = {9000},                           -- Dee Jay
        [12] = {7, 15},                          -- Lily
        [13] = {92},                             -- AKI
        [14] = {9000},                           -- Rashid
        [15] = {15},                             -- Blanka
        [16] = {9000},                           -- Juri
        [17] = {10, 22},                         -- Marisa
        [18] = {28},                             -- Guile
        [19] = {68, 86, 82},                     -- Ed
        [20] = {14, 15},                         -- Honda
        [21] = {9000},                           -- Jamie
        [22] = {},                               -- Akuma (No values yet)
        [26] = {15},                             -- Bison
        [27] = {60},                               -- Terry (Round Wave)
        [28] = {},                               -- Mai (No values yet)
        [29] = {}                                -- Elena (No values yet)
    }

    -- Check if the opponent's move is in the StartupPunish_11F table
    if StartupPunish_11F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_11F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                DisableGameInput()
                Do_CrMP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion

--#region Startup Punish (8F)
if isCounterReady(190) then
    -- Define valid counter punish moves per character
    local StartupPunish_8F = {
        [1]  = {18},                                   -- Ryu
        [2]  = {6, 13},                                -- Luke (St.MK, ?)
        [3]  = {6, 14, 15},                            -- Kim
        [4]  = {127, 129, 32, 65, 211},                -- Chun-Li
        [5]  = {13, 32, 67, 68, 69, 70, 71, 172, 173, 174, 175, 176, 182}, -- Manon
        [6]  = {12, 19},                               -- Zangief
        [7]  = {6, 25},                                -- JP
        [8]  = {35, 26},                               -- Dhalsim
        [9]  = {7, 6, 13, 15},                         -- Cammy
        [10] = {6, 14, 15},                            -- Ken
        [11] = {14, 13},                               -- Dee Jay
        [12] = {12},                                   -- Lily
        [13] = {6, 30},                                -- AKI
        [14] = {6, 69, 41},                            -- Rashid
        [15] = {6, 13, 52},                            -- Blanka
        [16] = {25, 23},                               -- Juri
        [17] = {19, 41},                               -- Marisa
        [18] = {13},                                   -- Guile
        [19] = {13},                                   -- Ed
        [20] = {9000, 12, 8},                          -- Honda
        [21] = {5},                                    -- Jamie
        [22] = {18, 19},                               -- Akuma
        [26] = {5, 13},                                -- Bison
        [27] = {13, 7},                                 -- Terry (Cr.MK)
        [28] = {},                                     -- Mai
        [29] = {}                                      -- Elena
    }

    -- Directly check opponent data without storing in variables
    if StartupPunish_8F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_8F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                print("Starting 8f punish") -- Debug
                DisableGameInput()  
                Do_CrLP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion 

--#region Startup Punish (9-10F) 
if isCounterReady(190) then
    -- Define valid counter punish moves per character
    local StartupPunish_9to10F = {
        [1]  = {10, 6, 5, 19, 20},               -- Ryu
        [2]  = {5, 7, 8, 15},                    -- Luke (?, St.HP, St.HK, ?)
        [3]  = {7, 74},                          -- Kim
        [4]  = {16, 128},                        -- Chun-Li
        [5]  = {7, 6, 14, 27, 62, 63, 64, 65, 66, 90}, -- Manon
        [6]  = {5, 13, 35},                      -- Zangief
        [7]  = {14, 13, 15},                     -- JP
        [8]  = {33, 37},                         -- Dhalsim
        [9]  = {14, 25},                         -- Cammy
        [10] = {7},                              -- Ken
        [11] = {6, 5},                           -- Dee Jay
        [12] = {5, 14, 13},                      -- Lily
        [13] = {10, 34, 36},                     -- AKI
        [14] = {7, 15},                          -- Rashid
        [15] = {5, 7, 12, 27, 29, 103, 217, 64}, -- Blanka
        [16] = {10, 27, 52, 68},                 -- Juri
        [17] = {21, 20, 34},                     -- Marisa
        [18] = {14, 15, 29, 32},                 -- Guile
        [19] = {7, 6, 9, 15, 14},                -- Ed
        [20] = {5, 13, 83, 84, 87, 88, 89, 6},   -- Honda
        [21] = {6, 29, 30, 47},                  -- Jamie
        [22] = {9, 6},                           -- Akuma
        [26] = {6, 29},                          -- Bison
        [27] = {7, 66},                              -- Terry (?, Quick Burn)
        [28] = {},                               -- Mai (No values yet)
        [29] = {}                                -- Elena (No values yet)
    }

    -- Check if the opponent's move is in the StartupPunish_9to10F table
    if StartupPunish_9to10F[getOpponentCharacterID()] then
        for _, move in ipairs(StartupPunish_9to10F[getOpponentCharacterID()]) do
            if move == getOpponentOldMethodMoveID() then
                print("Starting 9f - 10f punish") -- Debug
                DisableGameInput()  
                Do_CrLP()
                EnableGameInput()
                OwlSleep(100)
                setOpponentOldMethodMoveID(0)
                break
            end
        end
    end
end
--#endregion 

--#endregion! ============================================= STARTUP PUNISH

--#region! ================================================ WHIFF PUNISH

--#region Function: Check if Whiff Punish is Ready
function isWhiffReady(minDistance, maxDistance)
    return getOpponentStunnedStateBeta() == 0
        and getLocalStunnedStateBeta() == 0
        and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
        and (getOpponentDistance() >= minDistance and getOpponentDistance() <= maxDistance)
        and getOpponentMoveTimer() == 0
        and local_ready
        and getLocalOldMethodMoveID() == 0
        and not getOpponentIsProjectileOnScreen()
        
end
--#endregion

--#region Whiff Punish with Crouching MP

local validWhiffPunish_CrMP = {
    [1]  = {},  -- Ryu
    [2]  = {},  -- Luke
    [3]  = {},  -- Kimberly
    [4]  = {},  -- Juri
    [5]  = { [12] = 9 },  -- Manon
    [6]  = {},  -- Marisa
    [7]  = { [3] = 8 },  -- JP
    [8]  = {},  -- Zangief
    [9]  = {},  -- Dhalsim
    [10] = { [4] = 6 },  -- Ken
    [11] = { [12] = 9, [4] = 9 },  -- Dee Jay
    [12] = { [3] = 7 },  -- Lily
    [13] = { [4] = 10 },  -- A.K.I.
    [14] = { [3] = 5 },  -- Rashid
    [15] = { [11] = 6, [3] = 7 },  -- Blanka
    [16] = {},  -- Cammy
    [17] = {},  -- Guile
    [18] = {},  -- Chun-Li
    [19] = {},  -- Ed
    [20] = {},  -- E. Honda
    [21] = { [3] = 7 },  -- Jamie
    [22] = { [17] = 8 },  -- Akuma
    [23] = {},  -- Bison
    [24] = { [5] = 9, [10] = 6 },  -- Terry (St.MP, )
    [25] = {},  -- Mai
    [26] = {}   -- Elena
}

if isWhiffReady(179, 240) 
and validWhiffPunish_CrMP[getOpponentCharacterID()]
and validWhiffPunish_CrMP[getOpponentCharacterID()][getOpponentOldMethodMoveID()] == getOpponentStartUpEndFrame()
then
    DisableGameInput()
    OwlSleep(25)
    Do_CrMP()
    EnableGameInput()
    OwlSleep(100)
    setOpponentOldMethodMoveID(0)
end

--#endregion

--#region Whiff Punish with Crouching MP (5 frames)

whiffPunish5f = {
    [1]  = {15},       -- Ryu
    [2]  = {10},       -- Luke
    [3]  = {},         -- Kimberly
    [4]  = {},         -- Juri
    [5]  = {10},       -- Manon
    [6]  = {},         -- Marisa
    [7]  = {10},       -- JP
    [8]  = {},         -- Zangief
    [9]  = {10},       -- Cammy
    [10] = {10},       -- Ken
    [11] = {},         -- Dee Jay
    [12] = {},         -- Lily
    [13] = {26},       -- A.K.I.
    [14] = {},         -- Rashid
    [15] = {},         -- Blanka
    [16] = {},         -- Guile
    [17] = {17},       -- Marisa
    [18] = {},         -- Chun-Li
    [19] = {},         -- Ed
    [20] = {},         -- E. Honda
    [21] = {25},       -- Jamie
    [22] = {15},       -- Akuma
    [23] = {4, 10},    -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {}          -- Elena
}

if isWhiffReady(170, 190)
and getOpponentStartUpEndFrame() == 5
and whiffPunish5f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish5f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            OwlSleep(25)
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Crouching MP (6 frames)

whiffPunish6f = {
    [1]  = {},         -- Ryu
    [2]  = {},         -- Luke
    [3]  = {10},       -- Kimberly
    [4]  = {11},       -- Juri
    [5]  = {},         -- Manon
    [6]  = {},         -- Marisa
    [7]  = {},         -- JP
    [8]  = {},         -- Zangief
    [9]  = {},         -- Cammy
    [10] = {},         -- Ken
    [11] = {},         -- Dee Jay
    [12] = {},         -- Lily
    [13] = {},         -- A.K.I.
    [14] = {},         -- Rashid
    [15] = {},         -- Blanka
    [16] = {17},       -- Guile
    [17] = {},         -- Marisa
    [18] = {10},       -- Chun-Li
    [19] = {11},       -- Ed
    [20] = {10},       -- E. Honda
    [21] = {},         -- Jamie
    [22] = {2, 16},    -- Akuma
    [23] = {},         -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {11}        -- Elena
}

if isWhiffReady(169, 185)
and getOpponentStartUpEndFrame() == 6
and whiffPunish6f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish6f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            OwlSleep(35)
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Crouching MP (7 frames)

whiffPunish7f = {
    [1]  = {},         -- Ryu
    [2]  = {},         -- Luke
    [3]  = {},         -- Kimberly
    [4]  = {},         -- Juri
    [5]  = {},         -- Manon
    [6]  = {},         -- Marisa
    [7]  = {},         -- JP
    [8]  = {10},       -- Zangief
    [9]  = {},         -- Cammy
    [10] = {},         -- Ken
    [11] = {10},       -- Dee Jay
    [12] = {},         -- Lily
    [13] = {},         -- A.K.I.
    [14] = {10},       -- Rashid
    [15] = {},         -- Blanka
    [16] = {},         -- Guile
    [17] = {},         -- Marisa
    [18] = {},         -- Chun-Li
    [19] = {},         -- Ed
    [20] = {},         -- E. Honda
    [21] = {},         -- Jamie
    [22] = {},         -- Akuma
    [23] = {},         -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {3}         -- Elena (original comment said Bison, but 26 = Elena per your table)
}

if isWhiffReady(175, 190)
and getOpponentStartUpEndFrame() == 7
and whiffPunish7f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish7f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            DisableGameInput()
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Crouching MP (8 frames)

whiffPunish8f = {
    [1]  = {},         -- Ryu
    [2]  = {},         -- Luke
    [3]  = {},         -- Kimberly
    [4]  = {},         -- Juri
    [5]  = {},         -- Manon
    [6]  = {},         -- Marisa
    [7]  = {},         -- JP
    [8]  = {},         -- Zangief
    [9]  = {},         -- Cammy
    [10] = {},         -- Ken
    [11] = {},         -- Dee Jay
    [12] = {10},       -- Lily
    [13] = {},         -- A.K.I.
    [14] = {},         -- Rashid
    [15] = {10},       -- Blanka
    [16] = {},         -- Guile
    [17] = {},         -- Marisa
    [18] = {},         -- Chun-Li
    [19] = {},         -- Ed
    [20] = {},         -- E. Honda
    [21] = {},         -- Jamie
    [22] = {},         -- Akuma
    [23] = {},         -- Bison
    [24] = {},         -- Terry
    [25] = {},         -- Mai
    [26] = {}          -- Elena
}

if isWhiffReady(170, 190)
and getOpponentStartUpEndFrame() == 8
and whiffPunish8f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish8f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            OwlSleep(20)
            Do_CrMP()
            EnableGameInput()
            OwlSleep(100)
            setOpponentOldMethodMoveID(0)
            break
        end
    end
end
--#endregion

--#region Whiff Punish with Standing HK  (8 frames)

whiffPunish_StHK_8f = {
    [1]  = {4, 11, 17},       -- Ryu
    [2]  = {},                -- Luke
    [3]  = {5},               -- Kimberly
    [4]  = {6},               -- Juri
    [5]  = {},                -- Manon
    [6]  = {},                -- Marisa
    [7]  = {},                -- JP
    [8]  = {26},              -- Zangief
    [9]  = {5, 25, 26},       -- Cammy
    [10] = {5, 12},           -- Ken
    [11] = {},                -- Dee Jay
    [12] = {},                -- Lily
    [13] = {},                -- A.K.I.
    [14] = {5, 12},           -- Rashid
    [15] = {},                -- Blanka
    [16] = {6, 21},           -- Guile
    [17] = {},                -- Marisa
    [18] = {5},               -- Chun-Li
    [19] = {5},               -- Ed
    [20] = {},                -- E. Honda
    [21] = {5, 27},           -- Jamie
    [22] = {},                -- Akuma
    [23] = {},                -- Bison
    [24] = {},                -- Terry
    [25] = {},                -- Mai
    [26] = {3}                -- Elena
}

if isWhiffReady(170, 200)
and getOpponentStartUpEndFrame() == 8
and whiffPunish_StHK_8f[getOpponentCharacterID()] ~= nil then
    for _, validMoveID in ipairs(whiffPunish_StHK_8f[getOpponentCharacterID()]) do
        if getOpponentOldMethodMoveID() == validMoveID then
            Do_StHK()
            break
        end
    end
end
--#endregion

--#region Whiff Punish with HK - All Far
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 205 and getOpponentDistance() <= 222)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 26 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 10 ) or  --bison
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 13 ) or --22 akuma 
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 10 ) or --8: Sim 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 29 and getOpponentStartUpEndFrame()== 11 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 9 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --18: Guile 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 41 ) or --17: Marisa 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 19 and getOpponentStartUpEndFrame()== 10 ) or --17: Marisa 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 10 ) or --17: Marisa 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 14 ) or --14: Rashid 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 11 ) or --14: Rashid 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --14: Rashid 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 13 ) or --12: Lily 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 12 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 9 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 11 ) or  --11: DJ 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 15 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 13 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 25 and getOpponentStartUpEndFrame()== 10 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --7: JP 
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 15 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 16 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 13 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 12 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --15: Blanka
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --15: Blanka
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 39 and getOpponentStartUpEndFrame()== 9 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 10 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 12 ) or --6: Gief 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 15 ) or --3: Kim 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 11 ) or --3: Kim 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 7) or --19: Ed 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 13 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 12 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 10 ) or --5: Manon 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 68 and getOpponentStartUpEndFrame()== 9 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 69 and getOpponentStartUpEndFrame()== 9 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 70 and getOpponentStartUpEndFrame()== 9 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 10 and getOpponentStartUpEndFrame()== 12 ) or
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 10 ) or
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 10 and getOpponentStartUpEndFrame()== 12 ) or --13: AKI
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 30 and getOpponentStartUpEndFrame()== 10 ) or --13: AKI
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 10 ) or --13: AKI   
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 14 ) or --10: Ken 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 14 ) or --21: Jamie
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 12 ) or --21: Jamie
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 10 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 11 ) or --9: Cammy 
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 18 and getOpponentStartUpEndFrame()== 10 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 11 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 14 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 19 and getOpponentStartUpEndFrame()== 12 ) or   --1: Ryu
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 11 ) or  --20: Honda 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 13 ) or  --20: Honda 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 14 ) or  --20: Honda 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 14 )  --20: Honda 
)
then
Do_StHK()
end
--#endregion

--#region Whiff Punish With HK Replacement - ALL more far
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 230 and getOpponentDistance() <= 270)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 12 ) or --12: Lily 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 13 ) or --6: Gief 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 9 and getOpponentStartUpEndFrame()== 12 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 16 and getOpponentStartUpEndFrame()== 13 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 11 ) or --19: Ed 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 12 ) or --2: Luke
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 12 ) or --2: Luke
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 13 )  --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(100)
Do_StHK()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with MK - (270 - 300) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 235 and getOpponentDistance() <= 240)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --luke
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 23 and getOpponentStartUpEndFrame()== 10 ) or --juri
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 10 and getOpponentStartUpEndFrame()== 14 ) or --17: Marisa 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 14 ) or --7: JP 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 33 and getOpponentStartUpEndFrame()== 18 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 16 ) or --6: Gief 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 14 ) or --6: Gief 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 18 ) or --2: Luke
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 18 ) or --2: Luke
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 13 ) or --5: Manon 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 17 ) or --21: Jamie
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 9000 and getOpponentStartUpEndFrame()== 9000 )  --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(100)
PMedium()
OwlSleep(40)
RMedium()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with HK Replacement - (270 - 300) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 270 and getOpponentDistance() <= 300)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 20 ) or --juri
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 13 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 18 ) or --21: Jamie
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 9000 and getOpponentStartUpEndFrame()== 9000 )  --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(180)
Do_StHK()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching MP - (180 - 190) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 180 and getOpponentDistance() <= 190)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 26 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or  --bison
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or --3: Kim 
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 8 ) or --4: Chun
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 9 )   --22 akuma 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(15)
Do_CrMP()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Standing MP - (170 - 190) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 170 and getOpponentDistance() <= 190)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --8: Sim 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --14: Rashid 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --14: Rashid 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --12: Lily 	
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --12: Lily 	
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or  --11: DJ 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or  --11: DJ 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --19: Ed 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --2: Luke
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --5: Manon 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 7 ) or --16: Juri 
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --juri
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 19 and getOpponentStartUpEndFrame()== 7 ) or --juri
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --13: AKI 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --13: AKI 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --10: Ken 
(getOpponentCharacterID() == 10 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --10: Ken 
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 26 and getOpponentStartUpEndFrame()== 6 ) or --21: Jamie
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --21: Jamie
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --21: Jamie
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 26 and getOpponentStartUpEndFrame()== 9 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 6 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --9: Cammy 
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 2 and getOpponentStartUpEndFrame()== 6 ) or --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 ) or --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 16 and getOpponentStartUpEndFrame()== 6 ) or --1: Ryu
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 5 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --4: Chun
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 ) or  --22 akuma 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 )   --20: Honda 
)
then
DisableGameInput()  -- Commented out for debugging
OwlSleep(45)
Do_StMP()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion
 
--#region Whiff Punish with Crouching MP - (210 - 240) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 210 and getOpponentDistance() <= 240)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 39 and getOpponentStartUpEndFrame()== 7 ) or --8: Sim 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --18: Guile 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 ) or --18: Guile 
(getOpponentCharacterID() == 11 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or  --11: DJ 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --7: JP 
(getOpponentCharacterID() == 15 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --15: Blanka
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 7 ) or --3: Kim 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --3: Kim 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 7 ) or --2: Luke
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --2: Luke 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 28 and getOpponentStartUpEndFrame()== 7 ) or --13: AKI 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 5 )   --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(45)
Do_CrMP()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching MP - (196 - 230) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 196 and getOpponentDistance() <= 230)
and getOpponentMoveTimer()==0
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --luke
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 8 ) or --17: Marisa 
(getOpponentCharacterID() == 6 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --6: Gief 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 6 ) or --5: Manon 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 11 and getOpponentStartUpEndFrame()== 6 ) or --5: Manon 
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 7 )   --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(50)
Do_CrMP()
EnableGameInput()
OwlSleep(400)
setOpponentOldMethodMoveID(0)
end
--#endregion
 
--#region Whiff Punish with Crouching HK
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 201 and getOpponentDistance() <= 245)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 35 and getOpponentStartUpEndFrame()== 10 ) or --8: Sim 
(getOpponentCharacterID() == 18 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or --18: Guile 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 18 and getOpponentStartUpEndFrame()== 7 ) or --17: Marisa 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 5 and getOpponentStartUpEndFrame()== 7 ) or --17: Marisa 
(getOpponentCharacterID() == 14 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --14: Rashid 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 9 ) or --12: Lily 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --12: Lily 
(getOpponentCharacterID() == 12 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 10 ) or --12: Lily 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 10 ) or --7: JP 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 7 ) or --19: Ed 
(getOpponentCharacterID() == 2 and getOpponentOldMethodMoveID() == 3 and getOpponentStartUpEndFrame()== 8 ) or --2: Luke 
(getOpponentCharacterID() == 5 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 13 ) or --5: Manon 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 9 ) or --13: AKI
(getOpponentCharacterID() == 21 and getOpponentOldMethodMoveID() == 28 and getOpponentStartUpEndFrame()== 9 ) or --21: Jamie
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 9 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 13 ) or --9: Cammy 
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 and getOpponentDistance() >= 230  ) or --9: Cammy 
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 29 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 31 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 9 ) or --4: Chun
(getOpponentCharacterID() == 4 and getOpponentOldMethodMoveID() == 32 and getOpponentStartUpEndFrame()== 13 ) or --4: Chun
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 4 and getOpponentStartUpEndFrame()== 9 ) or  --22 akuma 
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 20 and getOpponentStartUpEndFrame()== 11 ) or   --1: Ryu
(getOpponentCharacterID() == 1 and getOpponentOldMethodMoveID() == 7 and getOpponentStartUpEndFrame()== 15 )    --1: Ryu
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(40)
PDown()
PToward()
PHeavy()
OS(40)
RDown()
RToward()
RHeavy()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching HK - (215 - 280) Distance
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 215 and getOpponentDistance() <= 280)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
 --hard more delay cr.hk
(getOpponentCharacterID() == 22 and getOpponentOldMethodMoveID() == 18 and getOpponentStartUpEndFrame()== 10 ) or  --22 akuma 
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 10 ) or --3: Kim 
(getOpponentCharacterID() == 8 and getOpponentOldMethodMoveID() == 33 and getOpponentStartUpEndFrame()== 13 ) or --8: Sim 
(getOpponentCharacterID() == 17 and getOpponentOldMethodMoveID() == 20 and getOpponentStartUpEndFrame()== 11 ) or --17: Marisa 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 15 and getOpponentStartUpEndFrame()== 12 ) or --7: JP 
(getOpponentCharacterID() == 7 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 ) or --7: JP 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 14 and getOpponentStartUpEndFrame()== 10 ) or --19: Ed 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 10 ) or --19: Ed  
(getOpponentCharacterID() == 16 and getOpponentOldMethodMoveID() == 27 and getOpponentStartUpEndFrame()== 12 ) or --juri
(getOpponentCharacterID() == 9 and getOpponentOldMethodMoveID() == 8 and getOpponentStartUpEndFrame()== 13 and getOpponentDistance() >= 270 ) or --9: Cammy 
(getOpponentCharacterID() == 13 and getOpponentOldMethodMoveID() == 6 and getOpponentStartUpEndFrame()== 10 ) or --13: AKI
(getOpponentCharacterID() == 20 and getOpponentOldMethodMoveID() == 13 and getOpponentStartUpEndFrame()== 11 )   --20: Honda 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(80)
PDown()
PToward()
PHeavy()
OwlSleep(40)
RDown()
RToward()
RHeavy()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Whiff Punish with Crouching MK
if getOpponentStunnedStateBeta() == 0 
and getLocalStunnedStateBeta() == 0
and (getLocalInAirByte() == 0 or getLocalInAirByte() == 1)
and (getOpponentDistance() >= 170 and getOpponentDistance() <= 200)
and getOpponentMoveTimer()==1
and local_ready
and getLocalOldMethodMoveID()==0
and getOpponentIsProjectileOnScreen()==false
and 
(
(getOpponentCharacterID() == 3 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 8 ) or --3: Kim 
(getOpponentCharacterID() == 19 and getOpponentOldMethodMoveID() == 12 and getOpponentStartUpEndFrame()== 6 )  --19: Ed 
)
then
-- DisableGameInput()  -- Commented out for debugging
OwlSleep(120)
PressInputDownButton()
PMedium()
OwlSleep(40)
ReleaseInputDownButton()
RMedium()
EnableGameInput()
OwlSleep(100)
setOpponentOldMethodMoveID(0)
end 
--#endregion

--#endregion! ============================================== WHIFF PUNISH

--#region! ================================================ ANTI CHARACTERS

-- Coming Soon

--#endregion! ============================================== ANTI CHARACTERS

--------------------------------------------
end
--#endregion= ============================== 28 - Mai

--#endregion! ============================================= CHARACTERS

--#region! ================================================ AUTO BLOCKING

--#region Generic Block Close Range with MoveID 
if  getOpponentOldMethodMoveID() > 2 and getOpponentOldMethodMoveID() < 8 and getOpponentDistance() < 150  
then
    BlockLow()
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#region Generic Block Medium Range with MoveID 
if  getOpponentOldMethodMoveID() >= 8 and getOpponentOldMethodMoveID() < 25 and getOpponentDistance() < 200  
then
   BlockLow()
    setOpponentOldMethodMoveID(0)
end
--#endregion

--#endregion! ============================================= AUTO BLOCKING