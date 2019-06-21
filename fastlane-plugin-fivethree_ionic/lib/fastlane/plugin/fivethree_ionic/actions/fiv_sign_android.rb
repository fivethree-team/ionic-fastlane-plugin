module Fastlane
  module Actions
    module SharedValues
      CORDOVA_IOS_RELEASE_BUILD_PATH = :CORDOVA_IOS_RELEASE_BUILD_PATH
      CORDOVA_ANDROID_RELEASE_BUILD_PATH = :CORDOVA_ANDROID_RELEASE_BUILD_PATH
    end

    class FivSignAndroidAction < Action
      def self.run(params)

       
        keystore_path = Fastlane::Actions::FivAndroidKeystoreAction.run(params)

        keychain_entry = CredentialsManager::AccountManager.new(user: "#{params[:keystore_name]}_android_keystore_storepass")
        keystore_storepass = keychain_entry.password

        keychain_entry = CredentialsManager::AccountManager.new(user: "#{params[:keystore_name]}_android_keystore_keypass")
        keystore_keypass = keychain_entry.password

        puts "Silent execution of jarsigner because we don't want to print passwords. You can delete the password if they are wrong stored in the keychain: 'fastlane fastlane-credentials remove --username android_keystore_storepass' and 'fastlane fastlane-credentials remove --username android_keystore_keypass'"
        sign = "jarsigner -tsa http://timestamp.digicert.com -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore #{keystore_path} -storepass #{keystore_storepass} -keypass #{keystore_keypass} #{ENV['CORDOVA_ANDROID_RELEASE_BUILD_PATH']} #{params[:key_alias]}"
        path = "./platforms/android/app/build/outputs/apk/release/app-release-#{params[:version]}-#{params[:build_no]}.apk"
        zipalign = "$ANDROID_SDK/build-tools/$ANDROID_BUILD_TOOL_VERSION/zipalign -v 4 \"#{ENV['CORDOVA_ANDROID_RELEASE_BUILD_PATH']}\" \"#{path}\""
        if params[:silent]
          self.run_silent(sign)
          self.run_silent(zipalign)
        else
          sh sign
          sh zipalign
        end
      
        return path

      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "A short description with <= 80 characters of what this action does"
      end
      def self.run_silent(command)
        Fastlane::Actions::sh(command, log: false)
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
          FastlaneCore::ConfigItem.new(key: :output_directory,
            env_name: "ANDROID_KEYSTORE_OUTPUT_DIRECTORY",
            description: "",
            is_string: true,
            optional: false,
            default_value: File.absolute_path(File.join(Dir.pwd, ".android_signing"))),
FastlaneCore::ConfigItem.new(key: :keystore_name,
            env_name: "ANDROID_KEYSTORE_KEYSTORE_NAME",
            description: "",
            is_string: true,
            optional: false),
FastlaneCore::ConfigItem.new(key: :key_alias,
            env_name: "ANDROID_KEYSTORE_KEYSTORE_ALIAS",
            description: "",
            is_string: true,
            optional: false),
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "CURRENT_BUILD_VERSION",
            description: "current build version from config.xml",
            is_string: true,
            default_value: ''
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_no,
            env_name: "CURRENT_BUILD_NUMBER",
            description: "current build number from config.xml",
            is_string: true,
            default_value: ''
          ),
          FastlaneCore::ConfigItem.new(
            key: :silent,
            env_name: "SIGN_ANDROID_SLIENT",
            description: "wether to sign android silently",
            is_string: false,
            default_value: true
          )
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
