require 'rails_helper'

describe 'レコード管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email:'a@example.com', height: 174.2, created_at:'2019-10-2')
      FactoryBot.create(:record, weight: 74.2, user: user_a)
    end

    context 'ルートページにアクセスした時' do
      before do
        # ユーザーAでログイン
        visit login_path
        fill_in "session_email", with: 'a@example.com'
        fill_in "session_password", with: 'password'
        click_button 'LogIn'
      end
      it 'ユーザーAのレコードが表示される' do
        expect(page).to have_content 'ユーザーA'
        expect(page).to have_content '74.2'
      end
    end

    context '新しく体重を記録した時' do
      before do
        # ユーザーAでログイン
        visit login_path
        fill_in "session_email", with: 'a@example.com'
        fill_in "session_password", with: 'password'
        click_button 'LogIn'
        # 体重を記録
        puts "Waiting..."
        sleep 3
        puts "OK."
        # 時間を指定
        travel_to Time.zone.local(2019, 11, 2) do
          puts Time.current
          click_link 'record_submit'
          fill_in "record_weight", with: '81.6'
          click_button 'create_record'
        end
      end
      it 'ユーザーAの新しいレコードが表示される' do
        chg_weight = (((81.6 - 74.2)/74.2)*100).round(0) 
        expect(page).to have_content '2019/11/02' # Datep
        expect(page).to have_content '81.6' # Last Weight
        expect(page).to have_content '26.9' # BMI
        # Changeは時間が合わないので、単体テストで対応
      end
    end
  end
end