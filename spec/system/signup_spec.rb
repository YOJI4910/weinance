require 'rails_helper'

describe 'Signup', type: :system do
  before do
    visit root_path
    click_on 'Register'
  end

  context '登録に成功する場合' do
    it '登録後に自動ログインし、ルートページをリダイレクトする' do
      expect(current_path).to eq new_user_registration_path
      fill_in 'user[name]', with: 'Seiya'
      fill_in 'user[email]', with: 'seiya@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      expect do
        click_on 'Sign up'
      end.to change(User, :count).by(1)
      expect(current_path).to eq root_path
      expect(page).to have_content 'アカウント登録が完了しました。'
      expect(page).to have_no_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
    end
  end

  context '登録に失敗する場合' do
    it 'エラーメッセージが表示される' do
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: 'invalid@invalid'
      fill_in 'user[password]', with: '1234'
      fill_in 'user[password_confirmation]', with: '123'
      expect do
        click_on 'Sign up'
      end.to change(User, :count).by(0)
      expect(page).to have_content '4 件のエラーが発生したため ユーザ は保存されませんでした。'
      expect(page).to have_content 'パスワード（確認用） が一致しません'
      expect(page).to have_content 'パスワード は6文字以上に設定して下さい'
      expect(page).to have_content 'ユーザー名 が未入力です'
      expect(page).to have_content 'メールアドレス は有効でありません'
    end
  end
end