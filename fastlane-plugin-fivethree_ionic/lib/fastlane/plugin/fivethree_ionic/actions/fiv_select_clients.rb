module Fastlane
    module Actions
      class FivSelectClientsAction < Action
        def self.run(params)
            clients = []
            Dir.chdir "#{params[:clients_folder]}" do
                clients_folders = Dir.glob('*').sort.select {|f| File.directory? f}

                if(ENV["CLIENTS"])
                    envClients = ENV["CLIENTS"].split(",")
                    selectedClients = envClients.select{|x| clients_folders.include?(x) }
                    puts("
                        ***********************************************
                            Selected clients: #{selectedClients}
                        ***********************************************
                        ")
                    return selectedClients
                end

                clients_folders.unshift("All")
                selected_client = UI.select("Select clients: ", clients_folders)

                if (selected_client === "All")
                    clients_folders.shift()
                    puts("
                        ***********************************************
                            Selected clients: #{clients_folders}
                        ***********************************************
                        ")
                    return clients_folders
                end


                puts("
                    ***********************************************
                        Selected client: #{selected_client}
                    ***********************************************
                    ")
                clients.push(selected_client)

            end

            return clients
        end

        def self.description
          "Select list of clients"
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
                        UI.user_error!("No client folder path for FivSelectClientAction given, pass using `client_folder: '../path_to_clients_folder'`") unless (value and not value.empty?)
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
