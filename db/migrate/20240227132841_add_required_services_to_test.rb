class AddRequiredServicesToTest < ActiveRecord::Migration[7.0]
  def change
    add_column :tests, :required_services, :json
  end
end
