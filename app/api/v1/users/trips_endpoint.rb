module V1
  module Users
    class TripsEndpoint < Root
      before do
        authenticate!
      end
      namespace :users do
        namespace :trips do
        end
      end
    end
  end
end