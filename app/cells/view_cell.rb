class ViewCell < HelpfulCell

  def hidable(options)
    @title = options[:title] || ""
    @content = options[:content] || ""
    @open = options[:open] || false
    @associated = options[:associated]
    @on_destroy = options[:on_destroy]
    render
  end

  def setting(name, label)
    @name = name
    @label = label
    render
  end

  def page_nav
    @path = Proc.new{ |page|
      parent = params.keys.collect{|key| /(.+)_id/.match(key)}.compact[0][1] rescue nil
      if parent
        self.send("#{controller.controller_name}_path", controller.instance_variable_get("@#{parent}"), page)
      else
        self.send("#{controller.controller_name}_path", page)
      end
    }
    @page = (params[:page] || "1").to_i
    @total = controller.instance_variable_get("@total_#{controller.controller_name}")
    @results_per_page = controller.controller_name.classify.constantize.results_per_page
    render unless @total <= @results_per_page
  end

  def markdown_cheatsheet
    cell(:view).(:hidable, title: "Markdown Cheatsheet", content: render)
  end

  ["about", "footer"].each do |method|
    define_method method do
      render method
    end
  end

  def header(options = {})
    params[:action] = params[:page_name] if params[:page_name]
    if options[:sanitize]
      (_header[params[:controller].singularize.to_sym][params[:action].to_sym][:title].call rescue nil) || (_header[params[:controller].singularize.to_sym][params[:action].to_sym][:both].call rescue nil) || CONFIG[:name]
    else
      (_header[params[:controller].singularize.to_sym][params[:action].to_sym][:header].call rescue nil) || (_header[params[:controller].singularize.to_sym][params[:action].to_sym][:both].call rescue nil)
    end
  end

  def _header
    {
      user: {
        index: {
          both: ->{
            case true
            when search_defaults
              "Open Artists"
            when search_all
              "All Users"
            else
              session["terms"]["tags"]
            end
          }
        },
        dashboard: {
          both: ->{
            if at_least? :admin
              "Administrator Dashboard"
            else
              "Settings"
            end
          }
        },
        show: {
          both: ->{
            @user.name
          }
        }
      },
      pool: {
        index: {
          title: ->{
            if @user
              "#{@user.name}'s pools"
            else
              "All Pools"
            end
          },
          header: ->{
            if @user
              "#{link_to @user.name, user_path(@user.name)}'s pools"
            else
              "All Pools"
            end
          }
        }
      },
      submission: {
        index: {
          title: ->{
            if @pool
              "#{@pool.user.name}'s #{title_for @pool}"
            else
              "All Submissions"
            end
          },
          header: ->{
            if @pool
              if can_modify? @pool.user
                nil
              else
                "#{link_to @pool.user.name, user_path(@pool.user)}'s #{title_for @pool}"
              end
            else
              "All Submissions"
            end
          }
        },
        show: {
          both: ->{
            if (@pool and can_modify? @pool.user) or can_modify? @submission.pool.user
              nil
            else
              title_for @submission
            end
          }
        }
      },
      order_form: {
        index: {
          both: ->{
            "Order forms"
          }
        },
        show: {
          title: ->{
            title_for @order_form
          }
        }
      },
      message: {
        index: {
          both: ->{
            "Conversations"
          }
        },
        activity: {
          both: ->{
            "Activity"
          }
        }
      },
      order: {
        new: {
          title: ->{
            "Order from #{@order.user.name}"
          },
          header: ->{
            "Place an order with #{link_to @order.user.name, user_path(@order.user)}"
          }
        },
        show: {
          title: ->{
            "Order from #{@order.name.blank?? @order.patron.name : @order.name}"
          },
          header: ->{
            "Order from #{@order.name.blank?? link_to(@order.patron.name, user_path(@order.patron)) : @order.name}"
          }
        }
      },
      card: {
        index: {
          title: ->{
            if current_user? @user
              "Workboard"
            else
              "#{@user.name}'s workboard"
            end
          },
          header: ->{
            if current_user? @user
              "Workboard"
            else
              "#{link_to params[User.slug], user_path(params[User.slug])}'s workboard"
            end
          }
        }
      },
      application: {
        about: {
          both: ->{
            "About #{CONFIG[:name]}"
          }
        }
      }
    }
  end

end