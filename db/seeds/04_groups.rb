group = Group.create! \
  name: 'My Group'

alice = User.where(name: 'alice').first
bob = User.where(name: 'bob').first
product = Product.first

GroupProduct.create! \
  group_id: group.id,
  product_id: product.id

Membership.create! \
  group_id: group.id,
  user_id: alice.id,
  email: alice.email

Membership.create! \
  group_id: group.id,
  user_id: bob.id,
  email: bob.email

