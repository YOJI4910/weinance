require 'rails_helper'

describe 'Users through OmniAuth', type: :system do
  describe 'Omniauthのサインアップ' do

    context 'twitterでのサインアップ' do
      before do
        OmniAuth.config.mock_auth[:twitter] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth
        visit new_user_registration_path
      end
  
      it 'サインアップをするとユーザー数が増える' do
        expect do
          click_link 'Twitterアカウントでログイン'
        end.to change(User, :count).by(1)
        expect(page).to have_content 'Twitter アカウントによる認証に成功しました。'
        expect(page).to have_no_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
        expect(current_path).to eq root_path
      end

      it "すでに連携されたユーザーがサインアップしようとするとユーザーは増えない" do
        click_link 'Twitterアカウントでログイン'
        click_link "LogOut"
        click_link "LogIn"
        expect do
          click_link 'Twitterアカウントでログイン'
        end.not_to change(User, :count)
      end
    end

    context 'googleでのサインアップ' do
      before do
        OmniAuth.config.mock_auth[:google] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth :google
        visit new_user_registration_path
      end
  
      it 'サインアップをするとユーザー数が増える' do
        expect do
          click_link 'Googleアカウントでログイン'
        end.to change(User, :count).by(1)
        expect(page).to have_content 'Google アカウントによる認証に成功しました。'
        expect(page).to have_no_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
        expect(current_path).to eq root_path
      end

      it "すでに連携されたユーザーがサインアップしようとするとユーザーは増えない" do
        click_link 'Googleアカウントでログイン'
        click_link "LogOut"
        click_link "LogIn"
        expect do
          click_link 'Googleアカウントでログイン'
        end.not_to change(User, :count)
      end
    end

    context 'facebookでのサインアップ' do
      before do
        OmniAuth.config.mock_auth[:facebook] = nil
        Rails.application.env_config['omniauth.auth'] = set_omniauth :facebook
        visit new_user_registration_path
      end
  
      it 'サインアップをするとユーザー数が増える' do
        expect do
          click_link 'Facebookアカウントでログイン'
        end.to change(User, :count).by(1)
        expect(page).to have_content 'Facebook アカウントによる認証に成功しました。'
        expect(page).to have_no_content 'ここをクリック！！ ゲストユーザーとしてログインし、すべての機能を試そう！'
        expect(current_path).to eq root_path
      end

      it "すでに連携されたユーザーがサインアップしようとするとユーザーは増えない" do
        click_link 'Facebookアカウントでログイン'
        click_link "LogOut"
        click_link "LogIn"
        expect do
          click_link 'Facebookアカウントでログイン'
        end.not_to change(User, :count)
      end
    end
  end
end
