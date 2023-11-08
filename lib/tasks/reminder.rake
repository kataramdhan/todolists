desc 'reminder deadline task'
task deadline_call: :environment do
  
    tasks = Task.where(deadline: DateTime.now..(DateTime.now + 48.hours))
    tasks.each do |obj|
        TaskMailer.with(user: obj.user, task: obj).deadline_remainder_email.deliver_now
    end
end