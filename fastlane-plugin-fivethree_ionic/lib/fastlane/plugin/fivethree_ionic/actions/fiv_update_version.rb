module Fastlane
  module Actions
    module SharedValues
      FIV_UPDATE_VERSION_CUSTOM_VALUE = :FIV_UPDATE_VERSION_CUSTOM_VALUE
    end

    class FivUpdateVersionAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        old_version = sh "echo \"cat //*[local-name()='widget']/@version\" | xmllint --shell #{params[:pathToConfigXML]}|  awk -F'[=\"]' '!/>/{print $(NF-1)}'"
        old_version = old_version.delete!("\n")
        puts "current version: #{old_version}"

        puts "Insert new version number, current version in config.xml is '#{old_version}' (Leave empty and press enter to skip this step): "
        new_version_number = STDIN.gets.strip
        puts "new version: #{new_version_number}"

        if new_version_number.length > 0
          puts "take new version number"
          version = new_version_number
        else
          puts "take old version number"
          version = old_version
        end

        text = File.read(params[:pathToConfigXML])

        new_contents = text
                     .gsub(/version="[0-9.]*"/, "version=\"#{version}\"")
        
        File.open(params[:pathToConfigXML], "w") {|file| file.puts new_contents}

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
        
        [
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

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['FIV_UPDATE_VERSION_CUSTOM_VALUE', 'A description of what this value contains']
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
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
