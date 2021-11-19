module TranslateClient
  class Client
    class Error < StandardError; end
    class NetworkError < Error; end

    attr_reader :locales, :token, :base_url

    def initialize
      @locales = ([I18n.default_locale.to_s] + I18n.available_locales.map(&:to_s)).uniq
      @token, @base_url = Rails.application.config_for(:translate).values_at(:token, :url)
    end

    def upload
      locales.each do |locale|
        path = locale_path(locale)
        next unless path.exist?

        puts "uploading #{locale} from #{path}"
        response = HTTParty.put("#{base_url}#{token}", body: path.read, headers: { 'Content-Type' => 'text/x-yaml' })
        raise NetworkError, response.body unless response.success?
      end
    end

    def download
      locales.each do |locale|
        path = locale_path(locale)
        puts "downloading #{locale} to #{path}"
        response = HTTParty.get("#{base_url}#{token}/#{locale}.yml")
        raise NetworkError, response.body unless response.success?

        File.write(path, response.body)
      end
    end

    def sync
      upload
      download
    end

    private

    def locale_path(locale)
      Rails.root.join("config", "locales", "#{locale}.yml")
    end
  end
end
