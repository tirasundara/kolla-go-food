json.extract! category, :id, :name, :created_at, :updated_at
json.url food_url(category, format: json)
