class SessionCookie
  class << self
    def firefox
      if current_cookie = current
        current_cookie_expiry     = DateTime.parse(current_cookie.dig(:expiry))
        current_cookie_value      = current_cookie.dig(:value)
        current_cookie_expires_in = (current_cookie_expiry - Date.today).to_i

        return "#{current_cookie.dig(:name)}=#{current_cookie.dig(:value)}" if current_cookie_expires_in > 1
      end

      cookies_db     = firefox_profile_cookies
      tmp_cookies_db = copy_cookies_db(cookies_db)
      cookie_json    = extract_from(tmp_cookies_db)
      write(cookie_json)
      delete_db_copies!
      "#{cookie_json.dig(:name)}=#{cookie_json.dig(:value)}"
    end

    def json_path
      File.join(Dir.pwd, '/kitt_bar_app/config/cookies.json')
    end

    def current
      cookie = JSON.parse(File.open(json_path).read) if File.exist?(json_path) rescue nil
      return nil unless cookie

      cookie.transform_keys!(&:to_sym)
      return nil if cookie.dig(:name).nil? || cookie.dig(:name).empty? ||
                    cookie.dig(:value).nil? || cookie.dig(:value).empty? ||
                    cookie.dig(:expiry).nil? || cookie.dig(:expiry).empty?

      cookie
    end

    def firefox_profile_cookies
      # Finding firefox default user profile folder
      # where the cookies db file is supposed to be stored (MacOS) yolo
      profiles = Dir["#{ENV['HOME']}/Library/Application\ Support/Firefox/Profiles/*"]
      profile  = profiles.find { |f| f =~ /\A.+\.default-release\z/ && Dir["#{f}/*"].any?{ |x| x =~ /cookies.sqlite/ } }
      "#{profile}/cookies.sqlite"
    end

    def copy_cookies_db(path)
      # Copy of the file is needed as when Firefox is running, db is locked
      FileUtils.cp(path, tmp_dir)
      "#{tmp_dir}/#{path[/(?<=\/)[^\/]+\.sqlite(?=\z)/]}"
    end

    def extract_from(path)
      db          = SQLite3::Database.new(path)
      cookie_name = "_kitt2017_"
      cookie_value, cookie_expiry = db.execute("SELECT value, expiry FROM moz_cookies WHERE name = \"#{cookie_name}\";").flatten
      {
        name: cookie_name,
        expiry: Time.at(cookie_expiry || 0).to_datetime,
        value: cookie_value
      }
    end

    def tmp_dir
      Dir.pwd << '/kitt_bar_app/tmp'
    end

    def delete_db_copies!
      Dir.glob(File.join(tmp_dir, '/*.sqlite*')).each{ |file| File.delete(file)}
    end

    def write(json)
      File.open(json_path, "w+") { |file| file.write(JSON.dump(json)) }
    end
  end
end
