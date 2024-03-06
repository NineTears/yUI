
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


    --- 设置宠物动作条的层级
    PetActionBarFrame:SetFrameStrata("LOW")

    -- 设置姿态条的层级
    ShapeshiftBarFrame:SetFrameStrata("LOW")

    -- 设置主菜单栏艺术框架的层级
    MainMenuBarArtFrame:SetFrameStrata("LOW")

    -- 设置施法条的层级
    CastingBarFrame:SetFrameStrata("LOW")

    -- 设置主菜单经验条的层级
    MainMenuExpBar:SetFrameStrata("LOW")

    -- 设置主菜单栏的层级
    MainMenuBar:SetFrameStrata("LOW")

    -- 设置动作条按钮的层级
    for i = 1, NUM_ACTIONBAR_BUTTONS do
      local button = getglobal("ActionButton" .. i)
      button:SetFrameStrata("LOW")

      button = getglobal("MultiBarBottomRightButton" .. i)
      button:SetFrameStrata("LOW")

      button = getglobal("MultiBarBottomLeftButton" .. i)
      button:SetFrameStrata("LOW")

      button = getglobal("MultiBarLeftButton" .. i)
      button:SetFrameStrata("LOW")

      button = getglobal("MultiBarRightButton" .. i)
      button:SetFrameStrata("LOW")
    end