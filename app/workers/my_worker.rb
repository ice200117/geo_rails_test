class MyWorker
    include Sidekiq::Worker
    @@flag = true
    def perform(count)
        while !@@flag do
            sleep(60)
        end
        @@flag = false
        # exec 'touch '+Rails.root.to_s+'/tmp/restart.txt'
        # exec 'touch '+Rails.root.to_s+'/tmp/restart.txt'
        @@flag = true
    end
end
