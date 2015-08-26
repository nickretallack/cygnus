module UsersHelper
	def statuses(user, modify: false, verbosity: :verbose)
		html = ""
		case verbosity
		when :verbose
			for i in 0..user.statuses.length-1
				html += "<div class = 'row'>"
				html += "<div class = 'col s6'>"
				html += "<i class = 'small material-icons'>#{CONFIG[:commission_icons].values[i]}</i> #{CONFIG[:commission_icons].keys[i].capitalize}:"
				html += "</div>"
				status = user.statuses[i]
				html += "<div class = 'col s6'>"
				if can_modify? user
					html += "<select name = 'user[statuses][#{i}]' class = 'btn button-with-icon'>"
					CONFIG[:activity_icons].each_with_index do |(key, value), index|
						html += "<option value = #{index} #{"selected = 'selected'" if status == index}>#{key}</option>"
					end
					html += "</select>"
				else
					html += "<i class = 'small material-icons comm-#{CONFIG[:activity_icons].keys[status]}'>#{CONFIG[:activity_icons].values[status]}</i> #{CONFIG[:activity_icons].keys[status].capitalize}"
				end
				html += "</div>"
				html += "</div>"
			end
			# case type
			# when :labels
			# 	CONFIG[:commission_icons].each do |key, value|
			# 		html += "<i class = 'small material-icons'>#{value}</i> #{key}:<br />"
			# 	end
			# when :states
			# 	user.statuses.each do |status|
			# 		html += "<i class = 'small material-icons comm-#{CONFIG[:activity_icons].keys[status]}'>#{CONFIG[:activity_icons].values[status]}</i> #{CONFIG[:activity_icons].keys[status]}<br />"
			# 	end
			# when :modify
			# 	user.statuses.each do |status|
			# 		html += "<a class = 'dropdown-button btn' data-activates = '#{CONFIG[:commission_icons].keys[status]}'><i class = 'small material-icons comm-#{CONFIG[:activity_icons].keys[status]}'>#{CONFIG[:activity_icons].values[status]}</i> #{CONFIG[:activity_icons].keys[status]}<i class = 'material-icons right'>arrow_drop_down</i></div></a><br />"
			# 	end
			# end
		when :condensed
			CONFIG[:commission_icons].each do |key, icon|
				html += "<i class = 'small material-icons'>"+icon+"</i>"
			end
			html += "<br />"
			user.statuses.each do |status|
				html += "<i class = 'small material-icons comm-#{CONFIG[:activity_icons].keys[status]}'>#{CONFIG[:activity_icons].values[status]}</i>"
			end
		end
		html.html_safe
	end
end
