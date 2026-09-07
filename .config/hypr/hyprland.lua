-- ==== Monitors ====
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@240",
    position = "0x0",
    scale = "1",
})

-- hl.monitor({
--     output = "",
--     mode = "preferred",
--     position = "auto",
--     scale = "1",
--     mirror = "eDP-1",
-- })

-- ==== Environment variables ====
hl.env("TERMINAL", "alacritty -e")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

hl.env("GDK_BACKEND", "wayland,x11")

hl.env("WLR_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")
hl.env("XCURSOR_SIZE", "24")

-- ==== Settings ====
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 7,
    bezier = "myBezier",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 7,
    bezier = "default",
    style = "popin 80%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "default",
})
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 7,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "default",
})

hl.device({
    name = "razer-razer-viper-mini",
    sensitivity = -0.25,
    accel_profile = "flat",
})

hl.device({
    name = "razer-razer-viper",
    sensitivity = -0.25,
    accel_profile = "flat",
})

hl.device({
    name = "razer-razer-viper-mini-1",
    sensitivity = -0.25,
    accel_profile = "flat",
})

-- ==== Window rules ====
hl.window_rule({
    name = "jetbrains",
    match = {
        class = "jetbrains-[a-zA-Z]*",
        title = "(^\\s*$)|(win[0-9]+)",
        float = true,
    },
    no_follow_mouse = true,
    no_initial_focus = true,
    no_anim = true,
})

hl.window_rule({
    name = "floating",
    match = {
        float = true,
    },
    animation = "slide",
})

hl.window_rule({
    name = "xdg-desktop-portal",
    match = {
        class = "xdg-desktop-portal-[a-zA-Z]+",
    },
    animation = "slide",
    float = true,
})

-- ==== Binds ====
local mainMod = "SUPER"

-- Basic window management
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + P", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Application hotkeys
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("alacritty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("alacritty -e ranger"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("runner"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("power_menu"))
hl.bind("Print", hl.dsp.exec_cmd("grimblast copy output"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("clipboard_menu"))

-- Volume
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("hotkey_volume mute"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("hotkey_volume down"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("hotkey_volume up"), { repeating = true })

-- Brightness
hl.bind(mainMod .. " + F6", hl.dsp.exec_cmd("hotkey_brightness off"))
hl.bind(mainMod .. " + F3", hl.dsp.exec_cmd("hotkey_brightness down"), { repeating = true })
hl.bind(mainMod .. " + F4", hl.dsp.exec_cmd("hotkey_brightness up"), { repeating = true })

hl.bind("XF86DisplayToggle", hl.dsp.exec_cmd("hotkey_brightness off"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("hotkey_brightness down"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("hotkey_brightness up"), { repeating = true })

-- Switch windows
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move windows between workspaces
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Move/resize floating windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())
hl.bind(mainMod .. " + SHIFT + mouse:272", hl.dsp.window.resize())

hl.config({
    input = {
        kb_layout = "us,ru",
        kb_options = "grp:alt_shift_toggle,compose:ralt",
        numlock_by_default = true,
        follow_mouse = 1,
        touchpad = {
            scroll_factor = 0.2,
            natural_scroll = true,
        },
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = "rgba(88c0d0aa)",
            inactive_border = "rgba(4c566aaa)",
        },
        layout = "dwindle",
    },
    decoration = {
        rounding = 2,
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "slave",
    },
    gestures = {
        workspace_swipe_touch = true,
    },
})

-- ==== Auto start programs ====
hl.on("hyprland.start", function()
    hl.exec_cmd("swayidle -w")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("wl-paste --watch cliphist store")
end)

