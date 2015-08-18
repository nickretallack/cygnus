module UsersHelper
	def comm_statuses_verbose(user)
	  "<h3><span class='label label-#{user.commissions ? "success" : "danger"}'>#{user.commissions ? "$" : "<span class='glyphicon glyphicon-ban-circle'></span>"} Commissions</span></h3>
	   <h3><span class='label label-#{user.trades ? "success" : "danger"}'><span class='glyphicon #{user.trades ? "glyphicon-transfer" : "glyphicon-ban-circle"}'></span> Trades</span></h3>
	   <h3><span class='label label-#{user.requests ? "success" : "danger"}'><span class='glyphicon #{user.requests ? "glyphicon-list-alt" : "glyphicon-ban-circle"}'></span> Requests</span></h3>".html_safe
	end
	def comm_statuses_condensed(user)
	  "#{user.commissions ? "<span class='text-success'>$</span>" : "<span class='text-danger'>$</span>"}
	   <span class='glyphicon #{user.trades ? "glyphicon-transfer" : "glyphicon-transfer text-danger"}'></span>
	   <span class='glyphicon #{user.requests ? "glyphicon-list-alt" : "glyphicon-list-alt text-danger"}'></span>".html_safe
	end

	def statuses(user, verbosity:)
		case verbosity
		when :verbose
			"verbose"
		when :condensed
			"<i class = 'small material-icons'>perm_identity</i><i class = 'small material-icons'>loop</i><i class = 'small material-icons'>loyalty</i><i class = 'small material-icons'>supervisor_account</i>".html_safe
		end
	end
end
