# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:

  ROLES = ["manager", "admin"]
  ROLES.each do |role|
    Role.find_or_create_by(name: role)
    puts "One role is created with title #{role}"
  end
