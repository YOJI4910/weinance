require 'rails_helper'

describe 'Signin', type: :system do
  context 'ログインに成功する場合' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:guest_user) { FactoryBot.create(:user, :guest) }

    it 'ログインしルートページへリダイレクトする' do
      visit root_path
      click_link 'LogIn'
      expect(current_path).to eq login_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      find('.actions input[type="submit"]').click
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_no_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
      expect(current_path).to eq root_path
    end

    it 'ゲストユーザーとしてログインできる', js: true do
      visit root_path
      expect(page).to have_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
      find('label.open-btn').click
      expect(page).to have_content 'ゲストユーザーとしてログインしますか？'
      find('input.signin-as-guest-btn').click
      expect(page).to have_content 'ログインしました。'
      expect(page).to have_no_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
    end
  end

  context 'ログインに失敗する場合' do
    let!(:user) { FactoryBot.create(:user) }

    it '不正なメールアドレスではログインできない' do
      visit root_path
      click_link 'LogIn'
      expect(current_path).to eq login_path
      fill_in 'user[email]', with: 'invalid@example.com'
      fill_in 'user[password]', with: user.password
      find('.actions input[type="submit"]').click
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      expect(page).to have_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
      expect(current_path).to eq new_user_session_path
    end

    it '不正なパスワードではログインできない' do
      visit root_path
      click_link 'LogIn'
      expect(current_path).to eq login_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: 'invalid'
      find('.actions input[type="submit"]').click
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      expect(page).to have_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
      expect(current_path).to eq new_user_session_path
    end
  end
end
