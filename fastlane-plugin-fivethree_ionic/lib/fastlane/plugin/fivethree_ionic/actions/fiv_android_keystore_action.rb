module Fastlane
  module Actions
    module SharedValues
      ANDROID_KEYSTORE_KEYSTORE_PATH = :ANDROID_KEYSTORE_KEYSTORE_PATH
      ANDROID_KEYSTORE_RELEASE_SIGNING_PATH = :ANDROID_KEYSTORE_RELEASE_SIGNING_PATH
    end

    class FivAndroidKeystoreAction < Action
      def self.run(params)
      
        output_directory = params[:output_directory]
        keystore_name = params[:keystore_name]
        keystore_path = File.join(output_directory, keystore_name) + '.keystore'

        # Validating output doesn't exist yet for our android signing info
        if File.directory?(output_directory)
          if File.exists?(keystore_path)
            return keystore_path
          end
        else
          UI.message "android keystore doesnt exist yet. creating one for you..."
          Dir.mkdir output_directory
        end


        puts "Please enter the keystore password for new keystore:"
        keychain_entry = CredentialsManager::AccountManager.new(user: "#{keystore_name}_android_keystore_storepass")
        password = keychain_entry.password

        puts "Please enter the keystore password for new keystore:"
        keypass_entry = CredentialsManager::AccountManager.new(user: "#{keystore_name}_android_keystore_keypass")
        key_password = keypass_entry.password

        alias_name = Fastlane::Actions::PromptAction.run(text:"Enter kexystore alias")


        full_name = Fastlane::Actions::PromptAction.run(text:"Enter kexystore full name")
        org = Fastlane::Actions::PromptAction.run(text:"Enter kexystore org")
        org_unit = Fastlane::Actions::PromptAction.run(text:"Enter kexystore org unit")
        city_locality = Fastlane::Actions::PromptAction.run(text:"Enter city")
        state_province = Fastlane::Actions::PromptAction.run(text:"Enter state")
        country = Fastlane::Actions::PromptAction.run(text:"country")
        
        Actions.lane_context[SharedValues::ANDROID_KEYSTORE_KEYSTORE_PATH] = keystore_path
        
        # Create keystore with command
        unless File.file?(keystore_path)
          keytool_parts = [
            "keytool -genkey -v",
            "-keystore #{keystore_path}",
            "-alias #{alias_name}",
            "-keyalg RSA -keysize 2048 -validity 10000",
            "-storepass #{password} ",
            "-keypass #{key_password}",
            "-dname \"CN=#{full_name}, OU=#{org_unit}, O=#{org}, L=#{city_locality}, S=#{state_province}, C=#{country}\"",
          ]
          sh keytool_parts.join(" ")
        else
          UI.message "Keystore file already exists - #{keystore_path}"
        end
        
        # Create release-signing.properties for automatic signing with Ionic
          
          release_signing_path = File.join(output_directory, "release-signing.properties")
          Actions.lane_context[SharedValues::ANDROID_KEYSTORE_RELEASE_SIGNING_PATH] = release_signing_path
          
          unless File.file?(release_signing_path)
            out_file = File.new(release_signing_path, "w")
            out_file.puts("storeFile=#{keystore_name}")
            out_file.puts("storePassword=#{password}")
            out_file.puts("keyAlias=#{alias_name}")
            out_file.puts("keyPassword=#{key_password}")
            out_file.close
          else
            UI.message "release-signing.properties file already exists - #{release_signing_path}"
          end
        
        return keystore_path
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Generate an Android keystore file"
      end

      def self.details
        "Generate an Android keystore file"
      end

      def self.available_options
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
                                       optional: false)
        ]
      end

      def self.output
        [
          ['ANDROID_KEYSTORE_KEYSTORE_PATH', 'Path to keystore'],
          ['ANDROID_KEYSTORE_RELEASE_SIGNING_PATH', 'Path to release-signing.properties']
        ]
      end

      def self.return_value
        "Path to keystore"
      end

      def self.authors
        ["fivethree"]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
