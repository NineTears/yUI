
    local TearsUI_framesetting = CreateFrame("Frame")
    -- 注册事件，在插件加载完成后执行
    TearsUI_framesetting:RegisterEvent("ADDON_LOADED")
    TearsUI_framesetting:SetScript("OnEvent", function(self, event, addonName)
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
    local function TearsUI_SetFrameStrata(frame)
        if frame and frame:GetFrameStrata() ~= "LOW" then
            frame:SetFrameStrata("LOW")
        end
    end

    -- 设置宠物动作条的层级
    TearsUI_SetFrameStrata(PetActionBarFrame)

    -- 设置姿态条的层级
    TearsUI_SetFrameStrata(ShapeshiftBarFrame)

    -- 设置主菜单栏艺术框架的层级
    TearsUI_SetFrameStrata(MainMenuBarArtFrame)

    -- 设置施法条的层级
    TearsUI_SetFrameStrata(CastingBarFrame)

    -- 设置主菜单经验条的层级
    TearsUI_SetFrameStrata(MainMenuExpBar)

    -- 设置主菜单栏的层级
    TearsUI_SetFrameStrata(MainMenuBar)

    -- 设置动作条按钮的层级
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        TearsUI_SetFrameStrata(_G["ActionButton" .. i])
        TearsUI_SetFrameStrata(_G["MultiBarBottomRightButton" .. i])
        TearsUI_SetFrameStrata(_G["MultiBarBottomLeftButton" .. i])
        TearsUI_SetFrameStrata(_G["MultiBarLeftButton" .. i])
        TearsUI_SetFrameStrata(_G["MultiBarRightButton" .. i])
    end

    -- 添加自动清理内存功能（登录/重载游戏后开启，每10秒且当前使用内存达到下次清理阙值的96%时，执行Lua垃圾回收操作）
    local TearsUI_collectframe = CreateFrame("Frame")
    local function StartMemoryManagement()
        if X then
            print("off")
            X = nil
        else
            print("on")
            X = function()
                local t = GetTime()
                local memoryUsage = gcinfo() / 1024
                local memoryThreshold = gcinfo("count") * 0.96 / 1024 -- 下次自动清理时的最大内存的*%

                if (t - T > 10) and (memoryUsage > memoryThreshold) then
                    collectgarbage()
                    T = t
                end
            end
        end
        TearsUI_collectframe:SetScript("OnUpdate", X)
    end

    TearsUI_collectframe:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
            T, F = T or 0, F or TearsUI_collectframe
            StartMemoryManagement()
        end
    end)

    TearsUI_collectframe:RegisterEvent("PLAYER_LOGIN")
    TearsUI_collectframe:RegisterEvent("PLAYER_ENTERING_WORLD")
