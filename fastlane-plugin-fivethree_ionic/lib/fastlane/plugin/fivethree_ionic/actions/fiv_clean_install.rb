module Fastlane
  module Actions
    module SharedValues
      FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE =
        :FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE
    end

    class FivCleanInstallAction < Action
      def self.run(params)
        if params[:platform].to_s == 'ios' ||
             params[:platform].to_s == 'android'
          sh "rm -rf node_modules platforms/#{params[:platform]}"
        elsif params[:platform].to_s == 'browser'
          sh 'rm -rf node_modules www'
        end

        sh 'rm -rf plugins' if params[:plugins]

        sh "#{params[:package_manager]} install"

        if params[:platform].to_s == 'ios' ||
             params[:platform].to_s == 'android'
          sh "ionic cordova platform add #{params[:platform]}"
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'A short description with <= 80 characters of what this action does'
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        'You can use this action to do cool things...'
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(
            key: :platform,
            env_name: 'CORDOVA_PLATFORM',
            description: 'Platform to build on. Can be android, ios or browser',
            is_string: true,
            default_value: '',
            verify_block:
              proc do |value|
                unless ['', 'android', 'ios', 'browser'].include? value
                  UI.user_error!(
                    'Platform should be either android, ios or browser'
                  )
                end
              end
          ),
          FastlaneCore::ConfigItem.new(
            key: :plugins,
            env_name: 'REFRESH_PLUGINS',
            description: 'also refresh plugins',
            default_value: false,
            is_string: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :package_manager,
            env_name: 'PACKAGE_MANAGER',
            description:
              'What package manager to use to install dependencies: e.g. yarn | npm',
            is_string: true,
            default_value: 'npm',
            verify_block:
              proc do |value|
                unless ['', 'yarn', 'npm'].include? value
                  UI.user_error!(
                    'Platform should be either android, ios or browser'
                  )
                end
              end
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          [
            'FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE',
            'A description of what this value contains'
          ]
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ['Your GitHub/Twitter Name']
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
