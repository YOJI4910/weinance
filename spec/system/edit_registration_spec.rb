require 'rails_helper'

describe 'EditRegistration', type: :system do
  describe 'ユーザー情報の編集' do
    let!(:user) { FactoryBot.create(:user) }

    before do
      visit root_path
      click_link 'LogIn'
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      find('.actions input[type="submit"]').click
    end

    context 'パスワードを含めて編集する時' do
      it 'ユーザー情報が変更される' do
      end
    end

    context 'パスワード以外を編集する時' do
      it 'パスワードの入力を求められない' do
      end
    end
  end
end
