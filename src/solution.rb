require_relative '../lib/drinks_inviter'
require_relative '../lib/customer_drinks_invite_predicate'

predicate      = CustomerDrinksInvitePredicate.new(max_distance: 100e3)
dublin_office  = { latitude: 53.339428, longitude: -6.257664 }
filename       = 'customers.json'
drinks_inviter = DrinksInviter.new(
  predicate: predicate,
  filename:  filename,
  center:    dublin_office
)
drinks_inviter.call