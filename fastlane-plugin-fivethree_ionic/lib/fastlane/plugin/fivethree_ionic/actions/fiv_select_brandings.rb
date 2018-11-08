module Fastlane
  module Actions
    module SharedValues
      FIV_SELECT_BRANDING_KEYS = :FIV_SELECT_BRANDING_KEYS
    end

    class FivSelectBrandingsAction < Action
      def self.run(params)
        branding_keys = []

        if (ENV["SELECTED_BRANDING"])
          # If comma separated branding array is specified via console parameter
          ENV["SELECTED_BRANDING"].split(",").each {|branding| branding_keys.push(branding)}
        else
          puts "
            ***********************************************************************
              You can also specify one or more brandings via command line parameter
              e.g. 'brandings:branding1'
            ***********************************************************************
          "
          Dir.chdir "#{params[:branding_folder]}" do
            branding_folders = Dir.glob('*').select {|f| File.directory? f}
            branding_folders.unshift("ALL")
            selected_branding_key = UI.select("Select branding: ", branding_folders)
      
            if (selected_branding_key == "ALL")
              branding_folders.shift # remove "ALL" entry
              branding_keys = branding_folders
            else
              selected_branding_key.split(",").each {|branding| branding_keys.push(branding)}
            end
          end
        end
      
        puts "
          ***********************************************
            Selected branding keys = #{branding_keys}
          ***********************************************
        "
        
        return branding_keys
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
          FastlaneCore::ConfigItem.new(key: :branding_folder,
            env_name: "FIV_SELECT_BRANDING_FOLDER", # The name of the environment variable
            description: "Branding folder path for FivSelectBrandingsAction", # a short description of this parameter
            default_value: "../brandings",
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
          ['FIV_SELECT_BRANDING_KEYS', 'A description of what this value contains']
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
