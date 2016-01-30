class SubmissionCell < HelpfulCell

    def new
        if @parent_controller.is_a? PoolsController
            @submission = Submission.new
            @pool = @parent_controller.instance_variable_get("@pool")
            render
        end
    end

    def edit
        @submission = @model
        @pool = @submission.pool
        @user = @pool.user
        @title = title_for submission: @submission
        render
    end

end