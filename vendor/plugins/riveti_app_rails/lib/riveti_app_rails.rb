require 'net/http'

module Riveti

  module Api
    
    def self.send_events(events_hash)
      send_objects('events', events_hash)
    end
    
    def self.send_videos(videos_hash)
      send_objects('videos', videos_hash)
    end
    
    def self.send_objects(plural_object_name, objects_hash)
      url = URI.parse(Riveti::Constants.r_platform_host)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.post("/#{plural_object_name}/bulk_create.json", "r_api_key=#{CGI::escape(Riveti::Constants.config['api_key'])}&#{plural_object_name}=#{CGI::escape(objects_hash.to_json)}", remote_headers)
      }
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        return true
      else
        res.error!
      end
    end
    

    def self.remote_headers(params_hash = nil)
      { Riveti::Constants.r_signature_headers_key => signature_header }
    end

    def self.signature_header
      raw_signature_string = "r_sig_api_key=#{CGI::escape(Riveti::Constants.config['api_key'])}&r_sig_time=#{CGI::escape(Time.now.to_f.to_s)}"
      computed_signature = Digest::MD5.hexdigest([raw_signature_string, Riveti::Constants.config['secret_key']].join)
      "#{raw_signature_string}&r_sig=#{CGI::escape(computed_signature)}"
    end
  end


  module Constants    
    mattr_reader :r_platform_host
    @@r_platform_host = RAILS_ENV == 'production' ? 'http://www.riveti.com' : 'http://riveti-development.heroku.com'
    mattr_reader :r_asset_host
    @@r_asset_host = RAILS_ENV == 'production' ? 'http://asset%d.riveti.com' : 'http://asset%d.riveti.com'
    mattr_reader :r_site_headers_key
    @@r_site_headers_key = 'Site-UID'
    mattr_reader :r_signature_headers_key
    @@r_signature_headers_key = 'R-Signature'
    mattr_reader :r_max_signature_age
    @@r_max_signature_age = 45.minutes

    @@config = nil
    def self.config
      if @@config.nil?
        @@config = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'riveti_app.yml'))).result)[RAILS_ENV]
      end
      @@config
    end
  end

  class IncorrectSignature < StandardError; end
  class SignatureTooOld < StandardError; end
end