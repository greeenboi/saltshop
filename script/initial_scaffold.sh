rails generate scaffold User username:text password:text role:uuid date_created:datetime name:text email:text bio:text photo_url:text --primary-key-type=uuid


# Product: The core item in the store
# Attributes: name, description, price, and stock quantity.
rails g scaffold Product name:string description:text price:decimal stock:integer

# Creates the Customer model, which points to a User
# A Customer's details (name, email) come from the associated User.
rails generate scaffold Customer user:references:uniq

# Creates the Admin model, which also points to a User
# An Admin's details come from the associated User.
rails generate scaffold Admin user:references:uniq

# Cart: Belongs to a customer and holds items to be purchased.
# Associations: Each cart belongs to one customer.
rails g scaffold Cart customer:references

# CartItem: Represents a product within a cart.
# Attributes: quantity of the product.
# Associations: Belongs to a cart and a product.
rails g scaffold CartItem cart:references product:references quantity:integer

# Order: Represents a customer's placed order.
# Attributes: status of the order.
# Associations: Belongs to a customer.
rails g scaffold Order customer:references status:string

# OrderItem: Represents a product within an order.
# Attributes: quantity and the price at the time of purchase.
# Associations: Belongs to an order and a product.
rails g scaffold OrderItem order:references product:references quantity:integer price:decimal

# After running the scaffold commands, run the migration to update your database schema.
rails db:migrate