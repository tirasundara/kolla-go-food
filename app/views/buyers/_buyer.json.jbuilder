json.extract! buyer, :id, :name, :email, :phone, :address, :created_at, :updated_at
json.url buyer_url(buyer, format: :json)
