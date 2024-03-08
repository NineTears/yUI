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


    -- 添加自动清理内存功能（登录/重载游戏后，每隔*秒执行一次内存检查和可能的增量垃圾回收）
    tearsUI_autoCleanSettings = {}  -- 声明全局的 SavedVariables 表
    local tearsUI_autoCleanFrame = CreateFrame("Frame")

    local memkb, gckb = gcinfo()   -- 返回当前Lua虚拟机的内存使用情况
    local memmb = memkb and memkb > 0 and memkb or 0   -- 当前内存使用量
    local gcmb = gckb and gckb > 0 and gckb or 0    -- Lua垃圾回收的总内存使用量

    local function performGarbageCollection()
        -- collectgarbage("setpause", 100)   -- 垃圾回收间隔，默认值200，单位是百分之一秒
        -- collectgarbage("setstepmul", 500)    -- 每步的工作量，默认值200
        local next_gc_threshold = gcmb * 1024   -- 把Lua垃圾回收的总内存使用量转换为字节
        local threshold = next_gc_threshold * 0.90

        local function collectIfNecessary()
            local current_memory = memmb * 1024   -- 把当前内存使用量转换为字节
            if current_memory >= threshold then
                -- 模拟执行增量垃圾回收
                local steps = math.ceil((next_gc_threshold - threshold) / 1024)
                for i = 1, steps do
                    collectgarbage("step", 3)    -- 逐步增量回收
                end
            end
        end

        collectIfNecessary() -- 立即进行一次内存检查和可能的增量垃圾回收
    end

    local function loadAutoCleanSettings()
        -- 加载 SavedVariables
        if tearsUI_autoCleanSettings.autoclean_enabled == nil then
            -- 自动清理如果未设置，则默认为 true
            tearsUI_autoCleanSettings.autoclean_enabled = true
        end
    end

    local function saveAutoCleanSettings()
        -- 保存设置到 SavedVariables
        tearsUI_autoCleanSettings.autoclean_enabled = tearsUI_autoCleanSettings.autoclean_enabled
    end

    local function printAutoCleanStatus()
        local status = tearsUI_autoCleanSettings.autoclean_enabled and "开启" or "关闭"
        print("自动清理功能当前已" .. status)
    end

    local function setAutoCleanStatus(enabled)
        tearsUI_autoCleanSettings.autoclean_enabled = enabled
        saveAutoCleanSettings() -- 保存设置到 SavedVariables
        printAutoCleanStatus()
    end

    local elapsed = 0
    local interval = 1 -- 间隔时间，单位为秒
    local function startTimer()
        elapsed = elapsed + arg1
        if elapsed >= interval then
            performGarbageCollection()
            elapsed = 0
        end
    end

    tearsUI_autoCleanFrame:SetScript("OnUpdate", function(self, elapsed)
        startTimer()
    end)

    -- 添加命令处理函数
    SlashCmdList["TEARSUI"] = function(msg)
        local command = string.lower(msg)
        if command == "cleanon" then
            setAutoCleanStatus(true) -- 开启自动清理功能
        elseif command == "cleanoff" then
            setAutoCleanStatus(false) -- 关闭自动清理功能
        else
            print("用法：/tearsui cleanon|cleanoff")
        end
    end
    SLASH_TEARSUI1 = "/tearsui"

    local function startTimer(interval, func)
        local frame = CreateFrame("Frame")
        frame.interval = interval
        frame.elapsed = 0
        frame:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = self.elapsed + elapsed
            if self.elapsed >= self.interval then
                self.elapsed = 0
                func()
            end
        end)
        return frame
    end
