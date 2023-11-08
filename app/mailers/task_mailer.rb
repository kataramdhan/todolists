class TaskMailer < ApplicationMailer

    def deadline_remainder_email
        @user = params[:user]
        @task = params[:task]
        mail(to: @user.email, subject: 'Tugas Sudah Mendekati Deadline')
    end
end
