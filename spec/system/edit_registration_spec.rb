require 'rails_helper'

describe 'EditRegistration', type: :system do
  describe 'ユーザー情報の編集' do
    describe 'ゲストユーザー以外を編集する' do
      let!(:user) { FactoryBot.create(:user) }

      before do
        # ログイン後、プロフィール編集ページへ
        visit root_path
        click_link 'LogIn'
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        find('.actions input[type="submit"]').click
        visit user_path(user)
        click_on 'プロフィール編集'
      end

      context 'パスワードを含めて編集する時' do
        it '現在のパスワードを入力し編集できる' do
          fill_in 'user[name]', with: '編集ユーザー'
          fill_in 'user[email]', with: 'edit@example.com'
          fill_in 'user[height]', with: 111.1
          fill_in 'user[password]', with: 'editpass'
          fill_in 'user[password_confirmation]', with: 'editpass'
          fill_in 'user[current_password]', with: 'password'
          click_on '変更を保存'
          expect(page).to have_content 'アカウント情報を変更しました。'
          expect(find('.show-head')).to have_content '編集ユーザー'
          expect(find('.user-info')).to have_content 111.1
          expect(current_path).to eq user_path(user)
          # ログインし直してemailとpasswordが変更されたか確認
          click_on 'ログアウト'
          click_on 'LogIn'
          fill_in 'user[email]', with: 'edit@example.com'
          fill_in 'user[password]', with: 'editpass'
          find('.actions input[type="submit"]').click
          expect(page).to have_content 'ログインしました。'
          expect(current_path).to eq root_path
        end

        it '現在のパスワードを未入力でエラーメッセージが表示される' do
          fill_in 'user[name]', with: '編集ユーザー'
          fill_in 'user[email]', with: 'edit@example.com'
          fill_in 'user[height]', with: 111.1
          fill_in 'user[password]', with: 'editpass'
          fill_in 'user[password_confirmation]', with: 'editpass'
          click_on '変更を保存'
          expect(page).to have_content 'エラーが発生したため ユーザ は保存されませんでした。'
          expect(page).to have_content '現在のパスワード が未入力です'
        end
      end

      context 'パスワード以外を編集する時' do
        it '現在のパスワードの入力を求められない' do
          fill_in 'user[name]', with: '編集ユーザー'
          fill_in 'user[email]', with: 'edit@example.com'
          fill_in 'user[height]', with: 111.1
          click_on '変更を保存'
          expect(page).to have_content 'アカウント情報を変更しました。'
          expect(find('.show-head')).to have_content '編集ユーザー'
          expect(find('.user-info')).to have_content 111.1
          expect(current_path).to eq user_path(user)
          # ログインし直してemailが変更されたか確認
          click_on 'ログアウト'
          click_on 'LogIn'
          fill_in 'user[email]', with: 'edit@example.com'
          fill_in 'user[password]', with: 'password'
          find('.actions input[type="submit"]').click
          expect(page).to have_content 'ログインしました。'
          expect(current_path).to eq root_path
        end
      end
    end

    describe 'ゲストユーザーを編集する' do
      let!(:guest_user) { FactoryBot.create(:user, :guest) }

      before do
        visit root_path
      end

      it '編集が禁止されている', js: true do
        find('label.open-btn').click
        expect(page).to have_content 'ゲストユーザーとしてログインしますか？'
        find('input.signin-as-guest-btn').click
        expect(page).to have_content 'ログインしました。'
        find('.header-avatar').click
        find('#edit-profile').click
        expect(page).to have_content 'ゲストユーザーは利用できません'
        expect(current_path).to eq user_path(guest_user)
      end
    end
  end
end
