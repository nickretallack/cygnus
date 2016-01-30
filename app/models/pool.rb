class Pool < ActiveRecord::Base

    def user_attachments
        @user_attachments ||= Attachment.where(parent_model: "user", child_model: "pool").where("? = ANY (child_ids)", id)
    end

    def users
        @users ||= User.where("id = ANY (?)", "{" + user_attachments.map { |attachment| attachment.id }.join(",") + "}")
    end

    def user
        @user ||= users.first
    end

    def submission_attachments
        @submission_attachments ||= Attachment.where(parent_model: "pool", parent_id: id, child_model: "submission")
    end

    def submissions
        @submissions ||= Submission.where("id = ANY (?)", "{" + submission_attachments.map { |submission| submission.id }.join(",") + "}" )
    end

end
