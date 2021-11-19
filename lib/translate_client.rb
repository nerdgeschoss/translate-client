# frozen_string_literal: true

require_relative "./translate_client/version"
require_relative "./translate_client/client"
require_relative "./translate_client/railtie" if defined?(Rails::Railtie)

module TranslateClient
  class Error < StandardError; end
  class NetworkError < Error; end
end
