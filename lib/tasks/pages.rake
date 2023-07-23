# lib/tasks/import_keywords.rake

require 'csv'

namespace :pages do
  desc 'Import keywords from CSV files to Pages'
  task import_entities: :environment do
    ['entities', 'nouns', 'verbs'].each do |filename|
      CSV.foreach(Rails.root.join('lib', "#{filename}.csv"), headers: true) do |row|
        puts "Creating Page for #{row[0]}"
        Page.find_or_create_by!(keywords: row[0])
      end
    end
  end
end
