group = Group.create! \
  name: 'My Group'

alice = User.where(email: 'alice@first-account.com').first
bob = User.where(email: 'bob@first-account.com').first
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

