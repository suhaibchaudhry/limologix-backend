class Dispatch < ActiveRecord::Base
  STATUSES = ['yet_to_start', 'started', 'completed', 'cancelled']

  scope :yet_to_start, -> { where(status: 'yet_to_start') }
  scope :started, -> { where(status: 'started') }
  scope :completed, -> { where(status: 'completed') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :active, -> { where('status IN (?)', ['yet_to_start','started'])}

  belongs_to :driver
  belongs_to :trip
end
