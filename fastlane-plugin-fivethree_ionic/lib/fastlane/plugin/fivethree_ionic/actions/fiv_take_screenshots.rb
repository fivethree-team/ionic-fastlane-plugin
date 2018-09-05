module Fastlane
  module Actions
    module SharedValues
      FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE = :FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE
    end

    class FivTakeScreenshotsAction < Action
      def self.run(params)
        UI.header "Taking Screenshots..."
          
        sh "ionic cordova run browser --prod && #{params[:cypress]} run -s #{params[:spec]} -b chrome"
        UI.success "Successfully finished taking screenshots"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :cypress,
                                       env_name: "FIV_BUILD_IONIC_ANDROID_IS_PROD",
                                       description: "Dev or Prod build",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :spec,
                                       env_name: "FIV_BUILD_IONIC_ANDROID_IS_PROD",
                                       description: "Dev or Prod build",
                                       optional: false,
                                       type: String)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
       platform == :android
      end
    end
  end
end
