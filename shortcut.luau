--!nonstrict
-- Region Recorder — Quick Tile

local function applyStatus(status)
    local st = if type(status) == "table" and status.state then status.state else "idle"
    local available = type(status) == "table" and status.available == true

    local labels = { recording = noctalia.tr("shortcut.recording"), selecting = noctalia.tr("shortcut.selecting") }
    shortcut.setLabel(labels[st] or noctalia.tr("shortcut.idle"))
    shortcut.setIcon("crop", "video-off")
    shortcut.setActive(st == "recording" or st == "selecting")
    shortcut.setEnabled(available)
end

applyStatus(noctalia.state.get("status"))
noctalia.state.watch("status", applyStatus)

function onClick()
    noctalia.state.set("command", { action = "toggle", focusedOutputName = noctalia.focusedOutputName() })
end

function onRightClick()
    noctalia.state.set("command", { action = "record-fullscreen", focusedOutputName = noctalia.focusedOutputName() })
end
