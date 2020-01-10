require 'rails_helper'

RSpec.describe 'Records', type: :request do
  describe 'GET #new' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        get new_record_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'POST #create' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        record_params = FactoryBot.attributes_for(:record)
        post records_path, params: { post: record_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'GET #edit' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        record = FactoryBot.create(:record)
        get edit_record_path(record)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'PATCH #update' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        record = FactoryBot.create(:record)

        record_params = FactoryBot.attributes_for(:record, weight: 77.7)
        patch record_path(record), params: { record: record_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'DELETE #destroy' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        record = FactoryBot.create(:record)
        delete record_path(record)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
