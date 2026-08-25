--!nonstrict
-- Region Recorder — Bar Widget

local state, available = "idle", true

local function send(action)
    noctalia.state.set("command", { action = action, nonce = os.time(), focusedOutputName = noctalia.focusedOutputName() })
end

local function applyStatus(status)
    if type(status) == "table" then
        state = status.state or "idle"
        available = if status.available ~= nil then status.available else true
    end

    local hideInactive = noctalia.getConfig("hide_inactive")
    if not available then
        barWidget.setGlyph("video-off")
        barWidget.setGlyphColor("on_surface_variant")
        barWidget.setTooltip(noctalia.tr("widget.unavailable"))
        barWidget.setVisible(not hideInactive)
        return
    end

    local configs = {
        recording = { glyph = "disc", color = "error", tooltip = noctalia.tr("widget.recording"), vis = true },
        selecting = { glyph = "crosshair", color = "primary", tooltip = noctalia.tr("widget.selecting"), vis = true },
        idle = { glyph = "video", color = "on_surface", tooltip = noctalia.tr("widget.idle"), vis = not hideInactive },
    }

    local cfg = configs[state] or configs.idle
    barWidget.setGlyph(cfg.glyph)
    barWidget.setGlyphColor(cfg.color)
    if cfg.color == "error" or cfg.color == "primary" then
        barWidget.setColor(cfg.color)
    end
    barWidget.setTooltip(cfg.tooltip)
    barWidget.setVisible(cfg.vis)
end

function onClick()
    if available then send("toggle") end
end

function onRightClick()
    if available then send(if state == "idle" then "record-fullscreen" else "stop") end
end

applyStatus(noctalia.state.get("status"))
noctalia.state.watch("status", applyStatus)
