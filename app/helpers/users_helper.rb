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

  def new_edit_fields
    {
      name: {},
      email: {field: "email_field"},
      password: {field: "password_field"},
      password_confirmation: {label: "confirmation", field: "password_field"},
      gallery: {label: "offsite galleries"},
      details: {label: "profile description", field: "text_area"},
      price: {label: "what i charge", field: "text_area"},
      tags: {label: "types of artwork i do (tags my profile may be searched by)"},
      #picture: {}
    }
  end

  def new_edit_checkboxes
    {
      commissions: {"prices" => true},
      trades: {},
      requests: {}
    }
  end
end
