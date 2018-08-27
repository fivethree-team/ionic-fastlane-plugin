require 'fastlane/action'
require_relative '../helper/fivethree_ionic_helper'

module Fastlane
  module Actions
    class FivethreeIonicAction < Action
      def self.run(params)
        UI.message("The fivethree_ionic plugin is working!")
      end

      def self.description
        "Fastlane plugin for Ionic v4 Projects"
      end

      def self.authors
        ["Marc Stammerjohann"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Fastlane"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "FIVETHREE_IONIC_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
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
