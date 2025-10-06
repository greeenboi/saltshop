json.extract! user, :id, :username, :password, :role, :date_created, :name, :email, :bio, :photo_url, :created_at, :updated_at
json.url user_url(user, format: :json)
