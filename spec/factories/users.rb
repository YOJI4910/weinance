FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    sequence(:email) { |n| "test-user-#{n}@example.com" }
    height { 174.2 }
    password { 'password' }

    trait :name_invalid do
      name {''}
    end

    trait :email_invalid do
      email {'test-user'} # @以降がない
    end

    trait :password_invalid do
      password {'pass'} # 6文字以上ない
    end

    trait :guest do
      name {'guest-user'}
      email {'guest@example.com'}
    end

    trait :with_records do
      transient do
        record_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:record, evaluator.record_count, user: user)
      end
    end
  end
end