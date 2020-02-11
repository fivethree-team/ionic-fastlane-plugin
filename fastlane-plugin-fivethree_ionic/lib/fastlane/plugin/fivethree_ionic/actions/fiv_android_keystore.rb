module Fastlane
  module Actions
    class FivAndroidKeystoreAction < Action
      def self.run(params)
        keystore_path = params[:keystore_path]
        keystore_name = params[:keystore_name]
        keystore_file = File.join(keystore_path, keystore_name) + '.keystore'

        # Validating output doesn't exist yet for our android signing info
        if File.directory?(keystore_path)
          return keystore_file if File.exists?(keystore_file)
        else
          UI.message 'android keystore doesnt exist yet. creating one for you...'
          Dir.mkdir keystore_path
        end

        puts 'Please enter the keystore password for new keystore with atleast 6 characters:'
        keychain_entry =
          CredentialsManager::AccountManager.new(
            user: "#{keystore_name}_android_keystore_storepass"
          )
        password = keychain_entry.password

        puts 'Please enter the keystore password for new keystore atleast 6 characters:'
        keypass_entry =
          CredentialsManager::AccountManager.new(
            user: "#{keystore_name}_android_keystore_keypass"
          )
        key_password = keypass_entry.password

        alias_name = params[:key_alias]
        puts "Keystore alias #{alias_name}"

        full_name =
          Fastlane::Actions::PromptAction.run(text: 'Enter kexystore full name')
        org = Fastlane::Actions::PromptAction.run(text: 'Enter kexystore org')
        org_unit =
          Fastlane::Actions::PromptAction.run(text: 'Enter kexystore org unit')
        city_locality = Fastlane::Actions::PromptAction.run(text: 'Enter city')
        state_province =
          Fastlane::Actions::PromptAction.run(text: 'Enter state')
        country = Fastlane::Actions::PromptAction.run(text: 'country')

        # Create keystore with command
        unless File.file?(keystore_file)
          keytool =
            "keytool -genkey -v \
              -keystore #{
              keystore_file
            } \
              -alias #{
              alias_name
            } \
              -keyalg RSA -keysize 2048 -validity 10000 \
              -storepass #{
              password
            } \
              -keypass #{
              key_password
            } \
              -dname \"CN=#{full_name}, OU=#{org_unit}, O=#{
              org
            }, L=#{city_locality}, S=#{state_province}, C=#{
              country
            }\"
            "
          sh keytool
        else
          UI.message "Keystore file already exists - #{keystore_file}"
        end

        # Create release-signing.properties for automatic signing with Ionic
        release_signing_path =
          File.join(keystore_path, 'release-signing.properties')

        unless File.file?(release_signing_path)
          out_file = File.new(release_signing_path, 'w')
          out_file.puts("storeFile=#{keystore_name}")
          out_file.puts("storePassword=#{password}")
          out_file.puts("keyAlias=#{alias_name}")
          out_file.puts("keyPassword=#{key_password}")
          out_file.close
        else
          UI.message "release-signing.properties file already exists - #{
                       release_signing_path
                     }"
        end

        return keystore_file
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Generate an Android keystore file or validate keystore exists'
      end

      def self.details
        'Generate an Android keystore file or validate keystore exists'
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :keystore_path,
            env_name: 'FIV_KEYSTORE_PATH',
            description: 'Path to android keystore',
            is_string: true,
            default_value: './fastlane/android'
          ),
          FastlaneCore::ConfigItem.new(
            key: :keystore_name,
            env_name: 'FIV_KEYSTORE_NAME',
            description: 'Name of the keystore',
            is_string: true,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :key_alias,
            env_name: 'FIV_ANDROID_KEYSTORE_ALIAS',
            description: 'Key alias of the keystore',
            is_string: true,
            optional: false
          )
        ]
      end

      def self.output
        [
          ['ANDROID_KEYSTORE_KEYSTORE_PATH', 'Path to keystore'],
          [
            'ANDROID_KEYSTORE_RELEASE_SIGNING_PATH',
            'Path to release-signing.properties'
          ]
        ]
      end

      def self.return_value
        'Path to keystore'
      end

      def self.authors
        %w[fivethree]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
