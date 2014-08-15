class Dashing.Forecastio extends Dashing.Widget
	@accessor 'current_icon', ->
    	@getIcon(@get('current.icon'))
   
	@accessor 'day_icon', ->
		@getIcon(@get('day.icon'))
    
	getIcon: (iconKey) ->	
		prefix = '/assets/climacons/svg/'
		ext = '.svg'

		if not iconKey 
			return prefix + "Cloud-Refresh" + ext

		key = iconKey.replace(/-/g, "_")

		iconMap = {
			clear_day: "Sun",
			clear_night: "Moon",
			rain: "Cloud-Rain",
			snow: "Snowflake",
			sleet: "Cloud-Hail",
			wind: "Wind",
			fog: "Cloud-Fog-Alt",
			cloudy: "Cloud",
			partly_cloudy_day: "Cloud-Sun",
			partly_cloudy_night: "Cloud-Moon"
		}
	
		fullPath = prefix + iconMap[key] + ext


	getWindDir: (windBearing) ->
		# windBearing is where the wind is coming FROM
		if (windBearing > 315) or (windBearing < 45)
			#direction = "S"
			direction = '/assets/climacons/svg/Compass-South.svg'
		else if (windBearing >= 45) and (windBearing < 135)
			#direction = "W"
			direction = '/assets/climacons/svg/Compass-West.svg'
		else if (windBearing >= 135) and (windBearing < 225)
			#direction = "N"
			direction = '/assets/climacons/svg/Compass-North.svg'
		else 
			#direction = "E"
			direction = '/assets/climacons/svg/Compass-East.svg'
		@set 'wind_bearing', direction
		

	#ready: ->
		# This is fired when the widget is done being rendered

	onData: (data) ->
		# Handle incoming data
		@getWindDir(@get('current.wind_bearing'))
		@unpackWeek(@get('upcoming_week'))
		@getTime()
		# flash the html node of this widget each time data comes in
		#$(@node).fadeOut().fadeIn()

	unpackWeek: (thisWeek) ->
		# get max temp, min temp, icon for the week
		days = []
		for day in thisWeek
			dayObj = {
				time: day['time'],
				min_temp: "#{day['min_temp']}&deg;",
				max_temp: "#{day['max_temp']}&deg;",
				icon: @getIcon(day['icon']) 
			}
			days.push dayObj
		@set 'this_week', days

	getTime: (now = new Date()) ->
		hour = now.getHours()
		minutes = now.getMinutes()
		minutes = if minutes < 10 then "0#{minutes}" else minutes
		ampm = if hour >= 12 then "pm" else "am"
		hour12 = if hour % 12 then hour % 12 else 12
		@set 'last_updated', "#{hour12}:#{minutes} #{ampm}"

