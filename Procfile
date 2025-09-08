web: bundle exec puma -C config/puma.rb
worker: SOLID_QUEUE_PROCESSES=${SOLID_QUEUE_PROCESSES:-2} SOLID_QUEUE_THREADS=${SOLID_QUEUE_THREADS:-5} bundle exec solid_queue
release: rails db:migrate
