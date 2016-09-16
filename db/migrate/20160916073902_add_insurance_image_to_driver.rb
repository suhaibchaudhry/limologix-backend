class AddInsuranceImageToDriver < ActiveRecord::Migration
  def change
    add_column :drivers, :insurance_image, :string
  end
end
