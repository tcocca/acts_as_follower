FactoryGirl.define do
  factory :jon, class: User do |u|
    u.name 'Jon'
  end

  factory :sam, class: User do |u|
    u.name 'Sam'
   end

  factory :bob, class: User do |u|
    u.name 'Bob'
  end

  factory :addy, class: User do |u|
  	u.name 'Addison'
  	u.email 'addy@example.com'
  end

  factory :claire, class: User do |u|
  	u.name 'Claire'
  	u.email 'claire@example.com'
  end
end
