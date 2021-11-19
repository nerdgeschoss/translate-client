namespace :locale do
  desc "Synchronizes locale yml files with the translation server."
  task sync: :environment do
    TranslateClient::Client.new.sync
  end
end
