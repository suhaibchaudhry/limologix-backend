module V1
  class ClearDispatch < API
    namespace :clear do
      post 'dispatch' do
        Dispatch.active.destroy_all
        { message: 'All active dispatches (if any) are deleted.'}
      end
    end
  end
end