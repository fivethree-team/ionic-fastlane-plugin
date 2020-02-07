module Fastlane
    module Actions
      class FivSelectEnvAction < Action
        def self.run(params)
            Dir.chdir "#{params[:clients_folder]}/#{params[:client]}/#{params[:environments_folder]}" do
                environment = Dir.glob('*').sort.select {|f| File.directory? f}
                if (ENV["ENV"] && environment.include?(ENV["ENV"]))
                  puts("
                  ***********************************************
                    Selected environment: #{ENV["ENV"]}
                  ***********************************************
                  ")
                  return ENV["ENV"]
                end

                selected_env = UI.select("Select one environment: ", environment)

                puts("
                ***********************************************
                    Selected environment: #{selected_env}
                ***********************************************
                ")
                return selected_env
            end
        end

        def self.description
          "Select a client"
        end

        def self.available_options
            [
                FastlaneCore::ConfigItem.new(
                    key: :clients_folder,
                    env_name: "FIV_CLIENTS_FOLDER", # The name of the environment variable
                    description: "Clients folder path for SelectEnvAction", # a short description of this parameter
                    default_value: "clients",
                    is_string: true,
                    verify_block: proc do |value|
                        UI.user_error!("No client folder path for SelectClientAction given, pass using `client_folder: '../path_to_clients_folder'`") unless (value and not value.empty?)
                        UI.user_error!("Couldn't find clients folder at path '#{value}'") unless File.directory?(value)
                    end),
                    FastlaneCore::ConfigItem.new(
                      key: :environments_folder,
                      env_name: "FIV_ENVIRONMENT_FOLDER", # The name of the environment variable
                      description: "Environment folder path for SelectEnvAction", # a short description of this parameter
                      default_value: "environments",
                      is_string: true,
                      verify_block: proc do |value|
                          UI.user_error!("No environment folder path for SelectClientAction given, pass using `environment: '../path_to_environment_folder'`") unless (value and not value.empty?)
                      end),
                FastlaneCore::ConfigItem.new(
                    key: :client,
                    env_name: "FIV_CLIENT", # The name of the environment variable
                    description: "Client folder path for SelectEnvAction", # a short description of this parameter
                    is_string: true,
                    verify_block: proc do |value|
                        UI.user_error!("No client folder path for SelectEnvAction given, pass using `client: '../path_to_client_folder'`") unless (value and not value.empty?)
                    end)
              ]
        end

        def self.author
          "Marc"
        end

        def self.is_supported?(platform)
          [:ios, :mac, :android].include? platform
        end
      end
    end
end
