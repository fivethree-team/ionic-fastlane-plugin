module Fastlane
    module Actions
      class FivSelectClientAction < Action
        def self.run(params)
            Dir.chdir "#{params[:clients_folder]}" do
                clients_folders = Dir.glob('*').sort.select {|f| File.directory? f}
                if (ENV["CLIENT"])
                  if (clients_folders.include?(ENV["CLIENT"]))
                    puts("
                      ***********************************************
                        Selected client: #{ENV["CLIENT"]}
                      ***********************************************
                      ")
                      return ENV["CLIENT"]
                  else
                      UI.user_error!("Client #{ENV["CLIENT"]} is not available.")
                  end
                end
                
                selected_client = UI.select("Select one client: ", clients_folders)
            
                puts("
                ***********************************************
                    Selected client: #{selected_client}
                ***********************************************
                ")
                return selected_client
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
                    description: "Clients folder path for SelectClientAction", # a short description of this parameter
                    default_value: "clients",
                    is_string: true,
                    verify_block: proc do |value|
                        UI.user_error!("No client folder path for SelectClientAction given, pass using `client_folder: '../path_to_clients_folder'`") unless (value and not value.empty?)
                        UI.user_error!("Couldn't find clients folder at path '#{value}'") unless File.directory?(value)
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