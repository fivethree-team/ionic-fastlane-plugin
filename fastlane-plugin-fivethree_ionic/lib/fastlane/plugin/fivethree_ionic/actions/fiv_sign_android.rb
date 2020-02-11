module Fastlane
  module Actions
    class FivSignAndroidAction < Action
      def self.run(params)
        keystore_path = Fastlane::Actions::FivAndroidKeystoreAction.run(params)

        keychain_entry =
          CredentialsManager::AccountManager.new(
            user: "#{params[:keystore_name]}_android_keystore_storepass"
          )
        keystore_storepass = keychain_entry.password

        keychain_entry =
          CredentialsManager::AccountManager.new(
            user: "#{params[:keystore_name]}_android_keystore_keypass"
          )
        keystore_keypass = keychain_entry.password

        puts "You can delete the password if they are wrong stored in the keychain: 'fastlane fastlane-credentials remove --username android_keystore_storepass' and 'fastlane fastlane-credentials remove --username android_keystore_keypass'"

        android_build_tool_path =
          "#{params[:android_sdk_path]}/build-tools/#{
            params[:android_build_tool_version]
          }"

        zipalign_apk_file = params[:apk_zipalign_target]
        if (File.file?(zipalign_apk_file))
          remove_zipalign = "rm -Rf #{zipalign_apk_file}"
          sh remove_zipalign
        end

        # zipalign APK
        zipalign =
          "#{android_build_tool_path}/zipalign -v 4 \
          #{
            params[:apk_source]
          } \
          #{zipalign_apk_file}"
        sh zipalign

        if (!File.directory?(params[:apk_signed_target]))
          Dir.mkdir params[:apk_signed_target]
        end

        output_path =
          "#{params[:apk_signed_target]}/app-release-#{params[:app_version]}-#{
            params[:app_build_no]
          }.apk"

        sign =
          "#{android_build_tool_path}/apksigner sign \
          --ks #{
            keystore_path
          } \
          --ks-key-alias #{
            params[:key_alias]
          } \
          --ks-pass pass:#{keystore_keypass} \
          --out #{
            output_path
          } \
          #{zipalign_apk_file}"
        self.run_shell_script(sign, params[:silent])

        verify =
          ("#{android_build_tool_path}/apksigner verify -v #{output_path}")
        self.run_shell_script(verify, params[:silent])

        return output_path
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Zipalign, sign and verify android apk'
      end

      def self.run_shell_script(command, silent)
        Fastlane::Actions.sh(command, log: silent)
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        'You can use this action to do cool things...'
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
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
            key: :android_sdk_path,
            env_name: 'FIV_ANDROID_SDK_PATH',
            description: 'Path to your installed Android SDK',
            is_string: true,
            default_value: '~/Library/Android/sdk'
          ),
          FastlaneCore::ConfigItem.new(
            key: :android_build_tool_version,
            env_name: 'FIV_ANDROID_SDK_BUILD_TOOL_VERSION',
            description:
              'Android Build Tool version used for `zipalign`, `sign` and `verify`',
            is_string: true,
            default_value: '28.0.3'
          ),
          FastlaneCore::ConfigItem.new(
            key: :apk_source,
            env_name: 'FIV_APK_SOURCE',
            description: 'Source path to the apk file',
            is_string: true,
            default_value:
              './platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk'
          ),
          FastlaneCore::ConfigItem.new(
            key: :apk_zipalign_target,
            env_name: 'FIV_APK_ZIPALIGN_TARGET',
            description: 'Target path for the zipaligned apk',
            is_string: true,
            default_value:
              './platforms/android/app/build/outputs/apk/release/app-release-unsigned-zipalign.apk'
          ),
          FastlaneCore::ConfigItem.new(
            key: :apk_signed_target,
            env_name: 'FIV_APK_SIGNED_TARGET',
            description: 'Tarket path of the signed apk',
            is_string: true,
            default_value: './platforms/android/app/build/outputs/apk/release'
          ),
          FastlaneCore::ConfigItem.new(
            key: :key_alias,
            env_name: 'FIV_ANDROID_KEYSTORE_ALIAS',
            description: 'Key alias of the keystore',
            is_string: true,
            optional: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_version,
            env_name: 'FIV_APP_VERSION',
            description: 'App version',
            is_string: true,
            default_value: ''
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_build_no,
            env_name: 'FIV_APP_BUILD_NO',
            description: 'App build number',
            is_string: true,
            default_value: ''
          ),
          FastlaneCore::ConfigItem.new(
            key: :silent,
            env_name: 'FIV_SIGN_ANDROID_SILENT',
            description: 'Wether to sign android silently',
            is_string: false,
            default_value: true
          )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          [
            'FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE',
            'A description of what this value contains'
          ]
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        %w[marcjulian]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
