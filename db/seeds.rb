# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'csv'

ROLES = ["super_admin", "admin", "manager", ]
VEHICLE_TYPES = ["SUV", "Sedan", "Sprinter Van", "Van", "Shuttle Bus"]

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

if Role.super_admin.users.count <=0
  user = User.new
  user.first_name = "Super"
  user.last_name = "Admin"
  user.email = "superadmin@limologix.com"
  user.mobile_number = 7878787878
  user.password = 'Limologix@1234'
  user.role = Role.super_admin
  user.save!
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

csv_text = File.read("#{Rails.root}/db/data/vehicle_make.csv")
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  vehicle_type = VehicleType.find_by(name: row[0])
  vehicle_make =  VehicleMake.find_or_create_by(name: row[1])
  vehicle_type.vehicle_make_ids = (vehicle_type.vehicle_make_ids << vehicle_make.id)
  vehicle_make_type = VehicleMakeType.where(vehicle_type_id: vehicle_type.id, vehicle_make_id: vehicle_make.id).first
  vehicle_model = VehicleModel.find_or_create_by(name: row[2], vehicle_make_type_id: vehicle_make_type.id)
  puts "ONE Vehicle Make & Model created #{vehicle_make.name} --- #{vehicle_model.name}"
end