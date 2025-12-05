pfUI:RegisterModule("group", "vanilla:tbc", function ()
  -- do not go further on disabled UFs
  if C.unitframes.disable == "1" then return end

  -- hide blizzard group frames
  local frame
  for i=1, 4 do
    frame = _G[string.format("PartyMemberFrame%d", i)]
    if frame then
      frame:Hide()
      frame:UnregisterAllEvents()
      frame.Show = function () return end
    end
  end

  pfUI.uf.group = {}

  function pfUI.uf.group:UpdateConfig()
    local startid = C.unitframes.selfingroup == "1" and 0 or 1
    local spacing = C.unitframes.group.pspace
    local rawborder, default_border = GetBorderSize("unitframes")
    local growth = C.unitframes.group.growth or "TOP_TO_BOTTOM"

    for i=0, 4 do
      local active = i >= 1 or startid == 0

      if active then
        pfUI.uf.group[i] = pfUI.uf.group[i] or pfUI.uf:CreateUnitFrame("Party", i, C.unitframes.group)
        pfUI.uf.group[i]:UpdateFrameSize()

        -- Calculate position based on growth direction
        local anchor = growth == "TOP_TO_BOTTOM" and "TOPLEFT" or "BOTTOMLEFT"
        local multiplier = growth == "TOP_TO_BOTTOM" and -1 or 1
        local baseOffset = growth == "TOP_TO_BOTTOM" and -5 or 5
        local yOffset = baseOffset + (multiplier * (i-startid) * 75)

        pfUI.uf.group[i]:ClearAllPoints()
        pfUI.uf.group[i]:SetPoint(anchor, 5, yOffset)
        pfUI.uf.group[i]:UpdateConfig()
        UpdateMovable(pfUI.uf.group[i])
      elseif pfUI.uf.group[i] then
        pfUI.uf.group[i]:UpdateConfig()
        RemoveMovable(pfUI.uf.group[i])
      end

      if C.unitframes.grouptarget.visible == "1" and active then
        pfUI.uf.group[i].target = pfUI.uf.group[i].target or pfUI.uf:CreateUnitFrame("Party" .. i .. "Target", nil, C.unitframes.grouptarget, 0.2)
        pfUI.uf.group[i].target:UpdateFrameSize()
        pfUI.uf.group[i].target:SetPoint("TOPLEFT", pfUI.uf.group[i], "TOPRIGHT", 3*default_border, 0)
        pfUI.uf.group[i].target:UpdateConfig()
        UpdateMovable(pfUI.uf.group[i].target)
      elseif pfUI.uf.group[i] and pfUI.uf.group[i].target then
        pfUI.uf.group[i].target:UpdateConfig()
        RemoveMovable(pfUI.uf.group[i].target)
      end

      if C.unitframes.grouppet.visible == "1" and active then
        pfUI.uf.group[i].pet = pfUI.uf.group[i].pet or pfUI.uf:CreateUnitFrame("PartyPet", i, C.unitframes.grouppet, 0.5)
        pfUI.uf.group[i].pet:UpdateFrameSize()
        pfUI.uf.group[i].pet:SetPoint("BOTTOMLEFT", pfUI.uf.group[i], "BOTTOMRIGHT", 3*default_border, -default_border)
        pfUI.uf.group[i].pet:UpdateConfig()
        UpdateMovable(pfUI.uf.group[i].pet)
      elseif pfUI.uf.group[i] and pfUI.uf.group[i].pet then
        pfUI.uf.group[i].pet:UpdateConfig()
        RemoveMovable(pfUI.uf.group[i].pet)
      end
    end
  end

  pfUI.uf.group:UpdateConfig()
end)
