-- listen for power events and dispatch to nameplates
local addon = KuiNameplates
local ele = addon:NewElement('PowerBar')
-- prototype additions #########################################################
function addon.Nameplate.UpdatePower(f)
    f = f.parent
    if f.elements.PowerBar then
        if f.state.power_type then
            local pmax = UnitPowerMax(f.unit,f.state.power_type) or 1
            f.PowerBar:SetMinMaxValues(0,pmax)
            local pcur = UnitPower(f.unit,f.state.power_type) or 0
            f.PowerBar:SetValue(pcur)
        else
            f.PowerBar:SetValue(0)
        end
    end
end
function addon.Nameplate.UpdatePowerType(f,on_show)
    f = f.parent

    -- get unit's primary power type
    local power_index,power_name = UnitPowerType(f.unit)
    local power_max = UnitPowerMax(f.unit,power_index)

    if not (issecretvalue and issecretvalue(power_max)) and (power_max == nil or power_max == 0) then
        power_index = nil
    end

    f.state.power_type = power_index

    if f.elements.PowerBar then
        -- update bar colour
        if power_index then
            f.PowerBar:SetStatusBarColor(unpack(
                ele.colours[power_name or power_index] or
                ele.colours['MANA']
            ))
        else
            f.PowerBar:SetStatusBarColor(0,0,0)
            f.PowerBar:SetValue(0)
        end
    end

    if not on_show then
        addon:DispatchMessage('PowerTypeUpdate', f)
    end

    -- and bar values
    f.handler:UpdatePower()
end
-- messages ####################################################################
function ele:Show(f)
    f.handler:UpdatePowerType(true)
end
-- events ######################################################################
function ele:PowerTypeEvent(_,f)
    f.handler:UpdatePowerType()
end
function ele:PowerEvent(_,f)
    f.handler:UpdatePower()
end
-- enable/disable per frame ####################################################
function ele:EnableOnFrame(frame)
    frame.PowerBar:Show()
    frame.handler:UpdatePowerType(true)
end
function ele:DisableOnFrame(frame)
    frame.PowerBar:Hide()
end
-- register ####################################################################
function ele:OnEnable()
    self:RegisterMessage('Show')

    self:RegisterUnitEvent('UNIT_DISPLAYPOWER','PowerTypeEvent')
    self:RegisterUnitEvent('UNIT_MAXPOWER','PowerTypeEvent')
    self:RegisterUnitEvent('UNIT_POWER_FREQUENT','PowerEvent')
    self:RegisterUnitEvent('UNIT_POWER_UPDATE','PowerEvent')
end
function ele:Initialise()
    self.colours = {}

    -- get default colours
    for p,c in next, PowerBarColor do
        if c.r and c.g and c.b then
            self.colours[p] = {c.r,c.g,c.b}
        end
    end
end
