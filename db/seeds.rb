# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'csv'

ROLES = ['super_admin', 'admin', 'manager']
VEHICLE_TYPE_WITH_ICONS = {
  'SUV': 'vehicle-icons-suv.png',
  'Sedan': 'vehicle-icons-sedan.png',
  'Sprinter Van': 'vehicle-icons-sprinter-van.png',
  'Van': 'vehicle-icons-van.png',
  'Shuttle Van': 'vehicle-icons-shuttle-van.png',
  }

def generate_upload_file_image(filename)
  image_file = File.open(File.join(Rails.root, "app/assets/images/#{filename}"),'r')

  content_type = `file --mime -b #{image_file.path}`.split(";")[0]

  ActionDispatch::Http::UploadedFile.new({
    tempfile: image_file,
    content_type: content_type,
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
  user.first_name = 'Super'
  user.last_name = 'Admin'
  user.email = 'superadmin@limologix.com'
  user.mobile_number = 7878787878
  user.password = 'Limologix@1234'
  user.role = Role.super_admin
  user.save!
end

if VehicleType.count <= 0
  VEHICLE_TYPE_WITH_ICONS.each do |name, icon|
    vehicle_type = VehicleType.new
    vehicle_type.name = name
    vehicle_type.description = "Lorem Ipsum is simply dummy text of the printing and 
    typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since 
    the 1500s, when an unknown printer took a galley of type and scrambled it to make a type 
    specimen book. It has survived not only five centuries, but also the leap into electronic 
    typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release 
    of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing 
    software like Aldus PageMaker including versions of Lorem Ipsum."
    vehicle_type.capacity = (1..10).to_a.sample
    vehicle_type.image = generate_upload_file_image(icon)
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