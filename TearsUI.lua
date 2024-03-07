    -- 设置config设置
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


    -- 设置动作条frame层级
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


    -- 添加自动清理内存功能（登录/重载游戏后开启，每10秒进行一次内存检查和可能的增量垃圾回收）
    local TearsUI_collectframe = CreateFrame("Frame")
    TearsUI_collectframe:RegisterEvent("PLAYER_LOGIN")
    TearsUI_collectframe:RegisterEvent("PLAYER_ENTERING_WORLD")

    local function performGarbageCollection()
        collectgarbage("setpause", 100)   -- 降低垃圾回收间隔
        collectgarbage("setstepmul", 400)    -- 减少每步的工作量
        local next_gc_threshold = collectgarbage("setpause") * 1024 -- 下一次自动触发垃圾回收时的最大阈值，转换为字节
        local threshold = next_gc_threshold * 0.96
        local function collectIfNecessary()
            local current_memory = collectgarbage("count") * 1024 -- 当前内存使用量，转换为字节
            if current_memory >= threshold then
                -- 模拟执行增量垃圾回收
                local steps = math.ceil((current_memory - threshold) / 1024)
                for i = 1, steps do
                    collectgarbage("step", 1)    -- 逐步增量回收
                end
            end
        end
        -- 每隔10秒执行一次内存检查并进行垃圾回收
        local timer = C_Timer.NewTicker(10, collectIfNecessary)
        collectIfNecessary() -- 立即进行一次内存检查和可能的增量垃圾回收
    end

    TearsUI_collectframe:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
            if not collectgarbage("isrunning") then
                collectgarbage("start")
            end
            performGarbageCollection()
        end
    end)
