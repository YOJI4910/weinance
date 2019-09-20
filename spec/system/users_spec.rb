require 'rails_helper'

describe 'レコード管理機能', type: :system do
  describe '一覧表示機能' do
    before do
      user_a = FactoryBot.create(:user, name: 'ユーザーA', email:'a@example.com', height: 174.2)
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
        expect(page).to have_content '74.2'
      end
    end
  end
end