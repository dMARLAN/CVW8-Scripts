local ships = {}
for i = 1, 18 do
    ships[i] = GROUP:FindByName("CommNav-" .. i)
    if i < 13 then
        ships[i]:PatrolZones({ ZONE:New("EWShippingLane") }, 120, "Vee")
    else
        ships[i]:PatrolZones({ ZONE:New("NSShippingLane") }, 120, "Vee")
    end
end