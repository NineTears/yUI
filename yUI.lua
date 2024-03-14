-- 设置config设置
local yUI_settingFrame = CreateFrame("Frame")
-- 注册事件，在插件加载完成后执行
yUI_settingFrame:RegisterEvent("ADDON_LOADED")
yUI_settingFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "yUI" then
        -- 设置姓名版距离为41码
        SetCVar("nameplateMaxDistance", 41)

        -- 设置天气效果为1
        -- SetCVar("weatherDensity", 1)

        -- 打开世界细节层次
        -- SetCVar("farclip", 7)
    end
end)

-- 设置动作条frame层级
local function yUI_SetFrameStrata(frame)
    if frame and frame:GetFrameStrata() ~= "LOW" then
        frame:SetFrameStrata("LOW")
    end
end

-- 设置宠物动作条的层级
yUI_SetFrameStrata(PetActionBarFrame)
-- 设置姿态条的层级
yUI_SetFrameStrata(ShapeshiftBarFrame)
-- 设置主菜单栏艺术框架的层级
yUI_SetFrameStrata(MainMenuBarArtFrame)
-- 设置施法条的层级
yUI_SetFrameStrata(CastingBarFrame)
-- 设置主菜单经验条的层级
yUI_SetFrameStrata(MainMenuExpBar)
-- 设置主菜单栏的层级
yUI_SetFrameStrata(MainMenuBar)

-- 设置动作条按钮的层级
for i = 1, NUM_ACTIONBAR_BUTTONS do
    yUI_SetFrameStrata(getglobal("ActionButton" .. i))
    yUI_SetFrameStrata(getglobal("MultiBarBottomRightButton" .. i))
    yUI_SetFrameStrata(getglobal("MultiBarBottomLeftButton" .. i))
    yUI_SetFrameStrata(getglobal("MultiBarLeftButton" .. i))
    yUI_SetFrameStrata(getglobal("MultiBarRightButton" .. i))
end

-- 添加自动清理内存功能（登录/重载游戏后，每隔*秒执行一次内存检查和可能的增量垃圾回收）
yUI_autoCleanSettings = {}  -- 声明全局的 SavedVariables 表

local memkb, gckb = gcinfo()   -- 返回当前Lua虚拟机的内存使用情况
local memmb = memkb and memkb > 0 and memkb or 0    -- 当前内存使用量，单位kb
local gcmb = gckb and gckb > 0 and gckb or 0        -- Lua垃圾回收的总内存使用量，单位kb

local next_gc_threshold = gcmb * 1024   -- 把Lua垃圾回收的总内存使用量转换为字节
local threshold = gcmb * 1024 * 0.90

local function performGarbageCollection()
    -- collectgarbage("setpause", 100)      -- 垃圾回收间隔，默认值200，单位是百分之一秒
    -- collectgarbage("setstepmul", 500)    -- 每步的工作量，默认值200
    local function collectIfNecessary()
        local current_memory = memkb and memkb * 1024 or 0 -- 把当前内存使用量转换为字节
        if current_memory >= threshold then
            -- 模拟执行增量垃圾回收
            local steps = math.ceil((next_gc_threshold * 0.1) / 1024)
            for i = 1, steps do
                collectgarbage("step", 10)   -- 逐步增量回收
            end
        end
    end

    collectIfNecessary()    -- 立即进行一次内存检查和可能的增量垃圾回收
end

local function loadAutoCleanSettings()
    -- 加载 SavedVariables
    if yUI_autoCleanSettings.autoclean_enabled == nil then
        -- 自动清理如果未设置，则默认为 true
        yUI_autoCleanSettings.autoclean_enabled = true
    end
end

local function saveAutoCleanSettings()
    -- 保存设置到 SavedVariables
    yUI_autoCleanSettings.autoclean_enabled = yUI_autoCleanSettings.autoclean_enabled
end

local function printAutoCleanStatus()
    local status = yUI_autoCleanSettings.autoclean_enabled and "开启" or "关闭"
    print("自动清理功能当前已" .. status)
end

local function setAutoCleanStatus(enabled)
    yUI_autoCleanSettings.autoclean_enabled = enabled
    saveAutoCleanSettings() -- 保存设置到 SavedVariables
    printAutoCleanStatus()
end

-- 加载自动清理设置
loadAutoCleanSettings()
-- 绑定进入游戏事件的处理函数
local yUI_autoCleanFrame = CreateFrame("Frame")
-- 注册事件
yUI_autoCleanFrame:RegisterEvent("PLAYER_LOGIN")

-- 设置事件处理函数
yUI_autoCleanFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        loadAutoCleanSettings() -- 加载自动清理设置
        -- 开始计时器
        local elapsed = 0   -- 初始化
        local interval = 1  -- 间隔时间，单位为秒
        local function startTimer(self, elapsed)
            if not yUI_autoCleanSettings.autoclean_enabled then
                return
            end

            elapsed = elapsed or 0
            elapsed = elapsed + 1 -- 每秒更新一次

            if elapsed >= interval then
                performGarbageCollection()
                elapsed = 0
            end
        end
        self:SetScript("OnUpdate", startTimer)
    end
end)

-- 添加命令处理函数
SlashCmdList["YUI"] = function(msg)
    local command = string.lower(msg)
    if command == "cleanon" then
        setAutoCleanStatus(true) -- 开启自动清理功能
    elseif command == "cleanoff" then
        setAutoCleanStatus(false) -- 关闭自动清理功能
    else
        print("用法：/yui cleanon|cleanoff")
    end
end
SLASH_YUI1 = "/yui"
