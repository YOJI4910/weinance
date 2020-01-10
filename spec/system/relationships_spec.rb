require 'rails_helper'

describe 'Relationships', type: :system do
  describe 'フォロー機能' do
    let!(:seiya) { FactoryBot.create(:user, :with_records, name: 'seiya') }
    let!(:soshina) { FactoryBot.create(:user, :with_records, name: 'soshina') }

    before do
      visit login_path
      fill_in 'user[email]', with: seiya.email
      fill_in 'user[password]', with: seiya.password
      find('.actions input[type="submit"]').click
    end

    context 'ルートページからフォローする場合' do
      it 'フォロー済み表示され、フォロー/フォロワー数が増える', js: true do
        expect(page).to have_content 'seiya'
        expect(page).to have_content 'soshina'
        expect do
          within "tr#record-#{soshina.records.first.id}" do
            expect(all('.follow-star.fas').length).to eq 0
            find('.follow-star.far').click
            expect(all('.follow-star.fas').length).to eq 1
          end
        end.to change(seiya.followings, :count).by(1) &
                change(soshina.followers, :count).by(1)
      end
    end

    context 'ユーザーページからフォローする場合' do
      it 'フォロー済み表示され、フォロー/フォロワー数が増える', js: true do
        expect(page).to have_content 'seiya'
        expect(page).to have_content 'soshina'
        click_link 'soshina'
        expect do
          within '.follow-beside-avatar' do
            expect(page).to have_content 'フォロー'
            find('.follow-btn').click
            expect(page).to have_content 'フォロー中'
          end
        end.to change(seiya.followings, :count).by(1) &
               change(soshina.followers, :count).by(1)
      end
    end
  end
end
