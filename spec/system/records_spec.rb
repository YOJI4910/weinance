require 'rails_helper'

describe 'レコード', type: :system do
  describe '投稿機能' do
    context 'ログインしている時' do
      let(:user) { FactoryBot.create(:user) }
      let!(:record) { FactoryBot.create(:record, weight: 88.8, user: user) }

      before do
        visit login_path
        fill_in "session_email", with: user.email
        fill_in "session_password", with: user.password
        click_on 'Log in' # ログイン後、rootページにリダイレクト
      end

      it 'rootページに投稿ページへのリンクが表示される' do
        within '.records-sec' do
          expect(page).to have_css('#record_submit')
          expect(find('a#record_submit')['href']).to eq new_record_path
        end
      end

      it '新規レコード記録後、rootページに戻る' do
        find("a#record_submit").click
        expect(current_path).to eq new_record_path
        fill_in "record_weight", with: 88.8
        expect do
          find("#create_record").click
        end.to change(Record, :count).by(1)
        expect(current_path).to eq root_path
      end

      it 'レコードを修正できる' do
        visit user_path(user)
        expect(first("tr#history-#{record.id} td")).to have_content 88.8
        first('a.record-edit-btn').click
        expect(current_path).to eq edit_record_path(record)
        fill_in "edit-record-field", with: 50.5
        click_on "修正を保存"
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "体重記録を修正しました"
        expect(first("tr#history-#{record.id} td")).to have_no_content 88.8
        expect(first("tr#history-#{record.id} td")).to have_content 50.5
      end

      it 'レコードを削除できる', js: true do
        visit user_path(user)
        expect(first("tr#history-#{record.id} td")).to have_content 88.8
        expect do
          page.accept_confirm do
            first('a.record-delete-btn').click
          end
          expect(page).to have_content 'レコードを削除しました'
        end.to change(Record, :count).by(-1)
      end
    end

    context 'ログインしていない時' do
      it 'rootページに投稿ページへのリンクが表示されない' do
        visit root_path
        within '.records-sec' do
          expect(page).to have_no_css('#record_submit')
        end
      end
    end
  end
end