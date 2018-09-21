# This module has the primary QA search method.  It also includes methods to process the linked data results and convert
# them into the expected QA json results format.
module Qa::Authorities
  module LinkedData
    class AuthorityService
      # Load or reload the linked data configuration files
      def self.load_authorities
        auth_cfg = {}
        # load QA configured linked data authorities
        Dir[File.join(Qa::Engine.root, 'config', 'authorities', 'linked_data', '*.json')].each do |fn|
          auth = File.basename(fn, '.json').upcase.to_sym
          json = File.read(File.expand_path(fn, __FILE__))
          cfg = JSON.parse(json).deep_symbolize_keys
          auth_cfg[auth] = cfg
        end

        # load app configured linked data authorities and overrides
        Dir[Rails.root.join('config', 'authorities', 'linked_data', '*.json')].each do |fn|
          auth = File.basename(fn, '.json').upcase.to_sym
          json = File.read(File.expand_path(fn, __FILE__))
          cfg = JSON.parse(json).deep_symbolize_keys
          auth_cfg[auth] = cfg
        end
        @@authotity_configs = auth_cfg
      end

      # Get the list of names of the loaded authorities
      # @return [Array<String>] all loaded authority configurations
      def self.authority_configs
        @@authotity_configs
        # ::LINKED_DATA_AUTHORITIES_CONFIG
      end

      # Get the configuration for an authority
      # @param [String] name of the authority
      # @return [Array<String>] configuration for the specified authority
      def self.authority_config(authname)
        @@authotity_configs[authname]
      end

      # Get the list of names of the loaded authorities
      # @return [Array<String>] names of the authority config files that are currently loaded
      def self.authority_names
        authority_configs.keys.sort
      end
    end
  end
end
