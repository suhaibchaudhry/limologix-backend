# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:

  ROLES = ["manager", "admin"]
  VEHICLE_TYPES = ["suv", "van", "bus", "sedan"]

  def get_dummy_image
    filename = "dummy_image_#{(1..10).to_a.sample}"
    tempfile = open(FFaker::Avatar.image)
    extension = tempfile.content_type.match(/gif|jpeg|png|jpg/).to_s
    filename += ".#{extension}" if extension

    ActionDispatch::Http::UploadedFile.new({
      tempfile: tempfile,
      content_type: tempfile.content_type,
      filename: filename
    })
  end

  if Role.count <= 0
    ROLES.each do |role|
      Role.find_or_create_by(name: role)
      puts "One role is created with title #{role}"
    end
  end

  if VehicleType.count <= 0
    VEHICLE_TYPES.each do |type|
      vehicle_type = VehicleType.new
      vehicle_type.name = type
      vehicle_type.description = FFaker::Lorem.sentence
      vehicle_type.capacity = (1..10).to_a.sample
      vehicle_type.image = get_dummy_image
      puts "One Vehicle type is created with name #{vehicle_type.name}" if vehicle_type.save!
    end
  end
