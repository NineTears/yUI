
    local frame = CreateFrame("Frame")
    -- 注册事件，在插件加载完成后执行
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, addonName)
        if addonName == "TearsUI" then
            -- 设置姓名版距离为41码
            SetCVar("nameplateMaxDistance", 41)

            -- 设置天气效果为1
            -- SetCVar("weatherDensity", 1)

            -- 打开世界细节层次
            -- SetCVar("farclip", 7)
        end
    end)

    -- 设置frame层级
    local function SetFrameStrataToLow(frame)
        if frame then
            frame:SetFrameStrata("Low")
        end
    end

    -- 设置宠物动作条的层级
    SetFrameStrataToLow(PetActionBarFrame)

    -- 设置姿态条的层级
    SetFrameStrataToLow(ShapeshiftBarFrame)

    -- 设置主菜单栏艺术框架的层级
    SetFrameStrataToLow(MainMenuBarArtFrame)

    -- 设置施法条的层级
    SetFrameStrataToLow(CastingBarFrame)

    -- 设置主菜单经验条的层级
    SetFrameStrataToLow(MainMenuExpBar)

    -- 设置主菜单栏的层级
    SetFrameStrataToLow(MainMenuBar)

    -- 设置动作条按钮的层级
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        SetFrameStrataToLow(_G["ActionButton" .. i])
        SetFrameStrataToLow(_G["MultiBarBottomRightButton" .. i])
        SetFrameStrataToLow(_G["MultiBarBottomLeftButton" .. i])
        SetFrameStrataToLow(_G["MultiBarLeftButton" .. i])
        SetFrameStrataToLow(_G["MultiBarRightButton" .. i])
    end