class Trip < ActiveRecord::Base
  STATUSES = ['pending', 'dispatched', 'inactive', 'active', 'closed', 'cancelled']

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

  has_many :mobile_notifications, as: :notifiable, dependent: :destroy
  has_many :request_notifications, -> { where kind: 'trip_request' }, as: :notifiable, class_name: 'MobileNotification'

  has_many :trip_groups
  has_many :groups, through: :trip_groups, source: :group

  validates :pick_up_at, :passengers_count, presence: true
  accepts_nested_attributes_for :start_destination
  accepts_nested_attributes_for :end_destination

  def accept!(driver)
    dispatch = driver.dispatches.new(trip_id: self.id)

    web_notification = WebNotification.new(message: {title: "Trip Accept", body: "#{driver.full_name} accepted the trip", trip: {id: self.id}}.to_json,
      publishable: self.user.company, notifiable: self, kind: 'trip_accept')

    if dispatch.valid? & web_notification.valid? && web_notification.save && dispatch.save && update_status!('active')

      driver.deduct_toll_credit!(Driver::TOLL_AMOUNT_FOR_DISPATCH)
      PaymentTransactionWorker.perform_async(driver) unless driver.has_enough_toll_credit?

      destroy_scheduled_worker
      return true
    else
      return false
    end
  end

  def dispatch!
    web_notification = WebNotification.create(message: {title: "Trip notification started", body: "Notification for this trip started."}.to_json,
        publishable: self.user.company, notifiable: self, kind: 'trip_dispatch')
    update_status!('dispatched')
  end

  def inactive!
    web_notification = WebNotification.create(message: {title: "Trip moved to inactive", body: "Trip moved to inactive state because no driver interested in this trip."}.to_json,
        publishable: self.user.company, notifiable: self, kind: 'trip_inactive')
    update_status!('inactive')
  end

  def cancel!
    destroy_scheduled_worker
    update_status!('cancelled')
  end

  def close!
    update_status!('closed')
  end

  def find_nearest_driver
    redis_drivers_list = $redis.hgetall("drivers")
    nearest_driver = nil
    nearest_distance = Settings.driver_search_radius

    drivers_in_groups = self.groups.includes(:drivers).flat_map {|group| group.driver_ids}

    already_requested_drivers = self.request_notifications.collect(&:driver_id)
    drivers_not_visible = Driver.invisible.collect(&:id)
    drivers_in_active_trips = Dispatch.active.collect(&:driver_id)

    driver_ids = drivers_in_groups - [*already_requested_drivers, *drivers_not_visible, *drivers_in_active_trips].uniq

    driver_ids.each do |driver_id|
      driver = Driver.find_by(id: driver_id)

      if (redis_drivers_list["#{driver.channel}"].present? && driver.vehicle.vehicle_type == self.vehicle_type)
        driver_geolocation = JSON.parse(redis_drivers_list["#{driver.channel}"])

        if ((Time.now.to_i - driver_geolocation["timestamp"].to_i) < 180)
          distance = self.start_destination.calculate_distance(driver_geolocation['latitude'].to_f, driver_geolocation['longitude'].to_f)

          if distance < nearest_distance
            nearest_distance = distance
            nearest_driver = driver
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


  private

  def update_status!(status)
    self.status = status
    self.save
  end
end