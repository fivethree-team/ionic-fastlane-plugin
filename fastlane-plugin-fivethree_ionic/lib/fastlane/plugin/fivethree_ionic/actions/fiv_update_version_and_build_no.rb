require 'fastlane/action'
require_relative '../helper/fivethree_ionic_helper'
require_relative './fiv_update_version'
require_relative './fiv_increment_build_no'

module Fastlane
  module Actions
    class FivUpdateVersionAndBuildNoAction < Action
      def self.run(params)
        version;
        if(params[:skip_version])
          puts("skiping version, just incrementing build no")
          old_version = sh "echo \"cat //*[local-name()='widget']/@version\" | xmllint --shell #{params[:pathToConfigXML]}|  awk -F'[=\"]' '!/>/{print $(NF-1)}'"
          version = old_version.delete!("\n")
        else
          version = Fastlane::Actions::FivUpdateVersionAction.run(pathToConfigXML:params[:pathToConfigXML])
        end
        build_no = Fastlane::Actions::FivIncrementBuildNoAction.run(
          pathToConfigXML: params[:pathToConfigXML],
          ios: params[:ios]
        )

        return {version: version, build_no: build_no}

      end

      def self.description
        "Fastlane plugin for Ionic v4 Projects"
      end

      def self.authors
        ["Fivethree"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        "returns object containing version and build_no"
      end

      def self.details
        # Optional:
        "Fastlane"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :ios,
                                  env_name: "FIV_INCREMENT_BUILD_NO_IOS",
                               description: "---",
                                  optional: false,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :pathToConfigXML,
          env_name: "FIV_INCREMENT_BUILD_CONFIG",
       description: "---",
          optional: false,
          verify_block: proc do | value |
            UI.user_error!("Couldnt find config.xml! Please change your path.") unless File.exist?(value)
          end  ,
              type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
