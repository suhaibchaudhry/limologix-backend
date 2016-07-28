class WebNotification < ActiveRecord::Base
  belongs_to :notifiable, :polymorphic => true
  belongs_to :publishable, :polymorphic => true
end
