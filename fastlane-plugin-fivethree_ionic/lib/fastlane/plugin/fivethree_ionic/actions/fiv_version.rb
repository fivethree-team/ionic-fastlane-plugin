module Fastlane
  module Actions
    module SharedValues
      FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE = :FIV_BUILD_IONIC_ANDROID_CUSTOM_VALUE
    end

    class FivVersionAction < Action
      def self.run(params)
        version_and_build_no = Fastlane::Actions::FivUpdateVersionAndBuildNoAction.run(ios: params[:ios],pathToConfigXML:params[:pathToConfigXML])
        
        Fastlane::Actions::FivBumpVersionAction.run(
          message: "fastlane(#{params[:ios] ? "ios" : "android"}): build #{version_and_build_no[:build_no]}, version: #{version_and_build_no[:version]}"
          )


        Fastlane::Actions::PushToGitRemoteAction.run(
          remote: params[:remote],
          local_branch: params[:local_branch],
          remote_branch: params[:remote_branch],
          force: params[:force],
          tags: params[:tags]
        )

        return version_and_build_no
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
          FastlaneCore::ConfigItem.new(key: :ios,
          env_name: "FIV_INCREMENT_BUILD_NO_IOS",
       description: "---",
          optional: false,
              type: Boolean),
FastlaneCore::ConfigItem.new(key: :pathToConfigXML,
          env_name: "FIV_INCREMENT_BUILD_CONFIG",
       description: "---",
          optional: false,
          verify_block: proc do | value |
            UI.user_error!("Couldnt find config.xml! Please change your path.") unless File.exist?(value)
          end  ,
              type: String),
              FastlaneCore::ConfigItem.new(key: :local_branch,
                                       env_name: "FL_GIT_PUSH_LOCAL_BRANCH",
                                       description: "The local branch to push from. Defaults to the current branch",
                                       default_value_dynamic: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :remote_branch,
                                       env_name: "FL_GIT_PUSH_REMOTE_BRANCH",
                                       description: "The remote branch to push to. Defaults to the local branch",
                                       default_value_dynamic: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :force,
                                       env_name: "FL_PUSH_GIT_FORCE",
                                       description: "Force push to remote",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :tags,
                                       env_name: "FL_PUSH_GIT_TAGS",
                                       description: "Whether tags are pushed to remote",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :remote,
                                       env_name: "FL_GIT_PUSH_REMOTE",
                                       description: "The remote to push to",
                                       default_value: 'origin')
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
        ["garygrossgarten"]
      end

      def self.is_supported?(platform)
       platform == :android
      end
    end
  end
end
