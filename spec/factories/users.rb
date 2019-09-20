FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    height { 174.2 }
    password { 'password' }
  end
end