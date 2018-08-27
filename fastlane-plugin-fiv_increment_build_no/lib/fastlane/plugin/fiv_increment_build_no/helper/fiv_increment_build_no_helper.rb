require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class FivIncrementBuildNoHelper
      # class methods that you define here become available in your action
      # as `Helper::FivIncrementBuildNoHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the fiv_increment_build_no plugin helper!")
      end
    end
  end
end
