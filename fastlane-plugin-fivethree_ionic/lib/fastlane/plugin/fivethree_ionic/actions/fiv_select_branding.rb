module Fastlane
  module Actions
    module SharedValues
      FIV_SELECTED_BRANDING_KEY = :FIV_SELECTED_BRANDING_KEY
      FIV_SELECTED_BRANDING_PATH = :FIV_SELECTED_BRANDING_PATH
    end

    class FivSelectBrandingAction < Action
      def self.run(params)
        Dir.chdir "#{params[:branding_folder]}" do
          branding_folders = Dir.glob('*').select {|f| File.directory? f}
          selected_branding_key = UI.select("Select one branding: ", branding_folders)
      
          puts "
            ***********************************************
              Selected branding key = #{selected_branding_key}
            ***********************************************
          "

          ENV['FIV_SELECTED_BRANDING_KEY'] = selected_branding_key
          ENV['FIV_SELECTED_BRANDING_PATH'] = "#{params[:branding_folder]}/#{selected_branding_key}" 
      
          return selected_branding_key
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Action lets the user select one branding key from a folder"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "For whitelabel programming it is very helpful to extract all assets into a `brandings` folder.
        This actions helps to select one branding key which can further be used to copy assets, build application or more."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :branding_folder,
                                       env_name: "FIV_SELECT_BRANDING_API_TOKEN", # The name of the environment variable
                                       description: "Branding folder path for FivSelectBrandingAction", # a short description of this parameter
                                       default_value: "brandings",
                                       is_string: true,
                                       verify_block: proc do |value|
                                          UI.user_error!("No branding folder path for FivSelectBrandingAction given, pass using `branding_folder: '../path_to_branding_folder'`") unless (value and not value.empty?)
                                          UI.user_error!("Couldn't find branding folder at path '#{value}'") unless File.directory?(value)
                                       end)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['FIV_SELECTED_BRANDING_KEY', 'Selected branding key'],
          ['FIV_SELECTED_BRANDING_PATH', 'Selected branding path']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["marcjulian"]
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

        true
      end
    end
  end
end
