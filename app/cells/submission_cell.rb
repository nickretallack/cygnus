class SubmissionCell < HelpfulCell

    def new
        render if can_modify? @model
    end

end