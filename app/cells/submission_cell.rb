class SubmissionCell < HelpfulCell

    def new
    end

    def edit
        @submission = @model
        @pool = @submission.pool
        @user = @pool.user
        @title = title_for submission: @submission
        render
    end

end