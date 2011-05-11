namespace :markitup do
  namespace :install do
    task :setup => :environment do
      ROOT=(defined?(RAILS_ROOT)) ? RAILS_ROOT : Rails.root
      PRE=File.join('lib', 'markitup')
      DST=File.join(ROOT, PRE)
      directory DST
    end

    desc "fetches basic assets"
    task :base => :setup do
      PKG='latest'
      SRC="http://markitup.jaysalvat.com/downloads/download.php?id=releases/#{PKG}"
      sh "wget -O #{DST}/#{PKG}.zip '#{SRC}'"
      sh "unzip -foq #{DST}/#{PKG}.zip -d #{DST}"
      sh "ln -sf ../../#{PRE}/#{PKG}/markitup public/javascripts"
      sh "ln -sf ../../#{PRE}/#{PKG}/markitup public/stylesheets"
      sh "ln -sf ../../#{PRE}/#{PKG}/markitup public/images"
    end

    desc "fetches markdown assets"
    task :markdown => :setup do
      PKG='markdown'
      SRC="http://markitup.jaysalvat.com/downloads/download.php?id=markupsets/#{PKG}"
      sh "wget -O #{DST}/#{PKG}.zip '#{SRC}'"
      sh "unzip -foq #{DST}/#{PKG}.zip -d #{DST}"
      sh "ln -sf ../../#{PKG} #{DST}/latest/markitup"
    end
  end
end
