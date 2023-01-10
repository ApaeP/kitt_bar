class SessionCookie
  class << self
    def firefox
      # Finding firefox default user profile folder 
      # where the cookies db file is supposed to be stored (MacOS)
      profiles      = Dir["#{ENV['HOME']}/Library/Application\ Support/Firefox/Profiles/*"]
      profile       = profiles.find { |f| f =~ /\A.+\.default-release\z/ && Dir["#{f}/*"].any?{ |x| x =~ /cookies.sqlite/ } }
      sqlite_db     = "#{profile}/cookies.sqlite"

      # Copy of the file is needed as when Firefox is running, sqlite db is in use hence locked
      tmp_dir       = Dir.pwd << '/kitt_bar_app/tmp'
      FileUtils.cp(sqlite_db, tmp_dir)
      tmp_sqlite_db = "#{tmp_dir}/cookies.sqlite"

      db            = SQLite3::Database.new(tmp_sqlite_db)
      cookie_value  = db.execute('SELECT value FROM moz_cookies WHERE name = "_kitt2017_";').flatten.first

      # delete tmp sqlite files generated
      Dir.glob(File.join(tmp_dir, '/*.sqlite*')).each{ |file| File.delete(file)}
      
      "_kitt2017_=#{cookie_value}"
    end
  end
end
