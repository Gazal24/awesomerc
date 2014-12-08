-- Create a battery widget
batterywidget = widget({ type = "textbox" })
batterywidget.text = ""

batterywidgettimer = timer({ timeout = 5 })
batterywidgettimer:add_signal("timeout",
  function()
    spacer = " "
    adapter = "BAT0"
    local fstatus = io.open("/sys/class/power_supply/"..adapter.."/status")
    local status = fstatus:read()

    fh = assert(io.popen("acpi | cut -d, -f 2 | cut -d ' ' -f 2 | cut -d '%' -f 1", "r"))
    local battery = fh:read("*l")

    if status:match("Charging") then
	-- SET FORMATTING
	batterytext = "<span color='green'>" .. battery .. "</span>"
    else
	-- IF STATUS IS OTHER THAN CHARGING THEN CHECK FOR LOW BATTER AND NOTIFY.
	if tonumber(battery) < 10 then
                naughty.notify({ title      = "BATTERY WARNING"
                               , text       = "Battery low!"..spacer..battery.."%"..spacer.."left!"
                               , timeout    = awe
                               , position   = "top_right"
                               , fg         = beautiful.fg_focus
                               , bg         = beautiful.bg_focus
                               })
	end

	-- NOW FORMAT ACCORDING TO STATUS
	if status:match("Discharging") then
		batterytext = "<span color='red'>" .. battery .. "</span>"
	else
		batterytext = "<span color='yellow'>" .. battery .. "</span>"
	end
    end

    batterywidget.text = " [" .. batterytext .. "] "
    fh:close()
  end
)

batterywidgettimer:start()
