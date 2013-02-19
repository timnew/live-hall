desc "Launch app in default mode"
task :app => 'app:watch'

namespace :app do
  desc "Launch the app"
  task :run do
    sh 'coffee app'
  end
  
  desc "Start the app with auto-realod"
  task :watch do
    sh %q{supervisor -i specs,views -e coffee,js app.coffee}
  end
end

desc "Run spec in default mode"
task :spec => %w[spec:once spec:db]

namespace :spec do
  desc "Run specs once"
  task :once, :test_files do |t, args|
    args.with_defaults test_files: 'specs/*Spec.coffee specs/**/*Spec.coffee'
    sh %Q[mocha -r 'specs/specHelper.js' -R spec -G -t 5000 #{args.test_files}]
  end
  
  desc "Run the specs when file changes"
  task :watch, :test_files do |t, args|
    args.with_defaults test_files: 'specs/*Spec.coffee specs/**/*Spec.coffee'
    sh %Q[mocha -r 'specs/specHelper.js' -R spec -w -G -t 5000 #{args.test_files}]
  end

  desc "Run specs for all adapters of Expirable Repository"
  task :db do
    environments = %w{memory redis}

    environments.each do |env|
      sh %Q[NODE_ENV=test:#{env} mocha -r 'specs/specHelper.js' -R spec -G 'specs/services/ExpirableRepositoryDbTest.coffee']
    end
  end
end

namespace :db do
  desc "Invoke Automigrate provided by juggledb"
  task :automigrate do
    sh %q{coffee db/RebuildDatabase}
  end

  desc "Migrate the database"
  task :migrate do
    sh %q{sequel -m ./db/migrations mysql://root@localhost/ticket_service_development}
  end
  
  desc "Create database"
  task :create do
    sh %q{echo "create database ticket_service_development;" | mysql -u root}
  end
  
  desc "Drop database"
   task :drop do
   sh %q{echo "drop database ticket_service_development;" | mysql -u root}
   end
   
  desc "Drop and then create database"
  task :reset => %w[db:drop db:create]
end

namespace :redis do
  desc "Init .mac_curl"
  task :mac_curl do
    sh %q{cp ./.mac_curl ~/}
  end
  
  desc "Inject default redis fixture"
  task :fixture do
    sh %q{echo set "creds:x8yy16FAMo4r3bEdqDWk86VPDhFBuw5G" "fW_7x0nT>WCeAnxc32xSZ?JiwtST?3T900Dn73uCI-_L~by8;t3uo2zp_e+QPNz9d" | redis-cli}
    sh %q{echo set "creds:841Rt1fZsYvdpfm5GjuUGZ4K3eqizYn8" "r1ul<ZBV0EyQDNOobabWllPNJn1ids_k7A8a!S;zkbT1MRLq65kHXUnlgM_Z7<dCC" | redis-cli}
    sh %q{cat ./db/fixture.sql | mysql -u root}
  end
end

desc "Launch default console"
task :console => 'console:node'

namespace :console do
  desc "Launch default node console"
  task :node do
    puts "require('coffee-script'); require('./initEnvironment');"
    sh %q{node}
  end

  desc "Launch coffee console"
  task :coffee do
    sh %q{coffee -r "./initEnvironment"}
  end
end


