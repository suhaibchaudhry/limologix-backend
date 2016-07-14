class Dispatch < ActiveRecord::Base
  STATUSES = ['yet_to_start', 'started', 'completed', 'cancelled']

  STATUSES.each do |status|
    scope status.to_sym, -> { where(status: status) }

    define_method("#{status}?") do
      self.status == status
    end
  end

  scope :active, -> { where('status IN (?)', ['yet_to_start','started'])}

  belongs_to :driver
  belongs_to :trip

  def start!
    update_status!('started')
  end

  def stop!
    update_status!('completed')
  end

  private

  def update_status!(status)
    self.status = status
    self.save
  end
end
