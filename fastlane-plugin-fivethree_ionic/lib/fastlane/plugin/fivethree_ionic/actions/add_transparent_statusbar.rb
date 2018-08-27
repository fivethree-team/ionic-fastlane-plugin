module Fastlane
  module Actions
    module SharedValues
      ADD_TRANSPARENT_STATUSBAR_CUSTOM_VALUE = :ADD_TRANSPARENT_STATUSBAR_CUSTOM_VALUE
    end

    class AddTransparentStatusbarAction < Action
      def self.run(params)

        text = File.read(params[:path])

        if params[:ios]

          puts "platform is ios"

          /super.onCreate\(savedInstanceState\);/

          new_contents = text.gsub(/{/, "{\n [self.viewController.navigationController.navigationBar setBackgroundImage:[UIImage new]
            \nforBarMetrics:UIBarMetricsDefault];
            \nself.viewController.navigationController.navigationBar.shadowImage = [UIImage new];
            \nself.viewController.navigationController.navigationBar.translucent = YES;
            \nself.viewController.navigationController.view.backgroundColor = [UIColor clearColor];")

        else

          puts "platform is android"

          content = text.gsub(/super.onCreate\(savedInstanceState\);/, 
          "super.onCreate(savedInstanceState);
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
          getWindow().getDecorView().setSystemUiVisibility(
          View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
          View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
          }")

            new_contents = content.gsub(/import org.apache.cordova.*;/,
              "import org.apache.cordova.*;\nimport android.os.Build;\nimport android.view.View;")

        end

        File.open(params[:path], "w") {|file| file.puts new_contents}
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
          env_name: "FIV_ADD_TRANSPARENT_STATUSBAR_PLATFORM",
       description: "---",
          optional: false,
              type: Boolean),
          FastlaneCore::ConfigItem.new(key: :path,
                              env_name: "FIV_ADD_TRANSPARENT_STATUSBAR_PATH",
                              description: "Path to Appdelegate.m for ios and MainActivity.java for Android",
                              optional: false,
                              verify_block: proc do | value |
                                UI.user_error!("Couldnt find AppDelegate or Main Activity! Please change your path.") unless File.exist?(value)
                              end  ,
                                  type: String)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['ADD_TRANSPARENT_STATUSBAR_CUSTOM_VALUE', 'A description of what this value contains']
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
