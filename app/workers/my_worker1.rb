class MyWorker1
    include Sidekiq::Worker
    def perform(count)
        sleep(count)
        puts 'perform1'
    end
end
