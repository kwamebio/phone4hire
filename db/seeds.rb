# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

dealer = Dealer.find_or_create_by!(name: "Main Dealer", email: "dealer@example.com", phone_number: "1234567890", address: "123 Main St", region: "Region A", approved: true)

ActsAsTenant.with_tenant(dealer) do
  Admin.find_or_create_by!(email: "kwameagyemang73@gmail.com") do |admin|
    admin.password = "password"
    admin.password_confirmation = "password"
    admin.dealer = dealer
  end
end
