class Trip < ActiveRecord::Base
  STATUSES = ['pending', 'dispatched', 'active', 'closed', 'cancelled']

  STATUSES.each do |status|
    scope status.to_sym, -> { where(status: status) }

    define_method("#{status}?") do
      self.status == status
    end
  end

  belongs_to :user
  belongs_to :customer
  belongs_to :vehicle_type

  has_one :start_destination, as: :locatable, dependent: :destroy
  has_one :end_destination, as: :locatable, dependent: :destroy

  has_many :dispatches
  has_one :active_dispatch, -> { where('status IN (?)', ['yet_to_start','started'])}, class_name: 'Dispatch'

  has_many :request_notifications, -> { where kind: 'request' }, class_name: 'TripNotification'

  validates :pick_up_at, :passengers_count, presence: true
  accepts_nested_attributes_for :start_destination
  accepts_nested_attributes_for :end_destination

  def update_status_to_active!
    destroy_scheduled_worker
    self.status = 'active'
    save
  end

  def update_status_to_dispatch!
    self.status = 'dispatch'
    save
  end

  def update_status_to_cancelled!
    destroy_scheduled_worker
    self.status = 'cancelled'
    save
  end

  def nearest_driver
    drivers_geolocation = $redis.hgetall("drivers")
    nearest_driver = nil
    nearest_distance = 20

    already_requested_drivers = self.request_notifications.collect(&:driver_id)
    drivers_not_visible = Driver.invisible.collect(&:id)
    drivers_in_active_trips = Dispatch.active.collect(&:driver_id)
    driver_ids = [*already_requested_drivers, *drivers_not_visible, *drivers_in_active_trips].uniq

    if drivers_geolocation.present?
      drivers_geolocation.each do|key, value|
        geolocation = JSON.parse(value)
        if !(driver_ids.include?(key.to_i)) && ((Time.now.to_i - geolocation["timestamp"].to_i) < 60)
          distance = self.start_destination.calculate_distance(geolocation['latitude'], geolocation['longitude'])
          if distance < nearest_distance
            nearest_distance = distance
            nearest_driver = key.to_i
          end
        end
      end
    end
    nearest_driver
  end

  def destroy_scheduled_worker
    job = find_scheduled_worker
    job.delete if job.present?
  end

  def find_scheduled_worker
    scheduled = Sidekiq::ScheduledSet.new
    scheduled.each do |job|
      if job.klass == 'TripRequestWorker' && job.args.first == self.id
        return job
      end
    end
  end

  def reschedule_worker_to_run_now
    job = find_scheduled_worker
    job.add_to_queue if job.present?
  end
end
