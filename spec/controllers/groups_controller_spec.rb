require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:group) { create(:group) }

  describe 'GET #show' do
    render_views
    context 'ログインユーザーの場合' do
      before do
        sign_in_as(user)
        get :show, params: { id: group.id }
      end

      it 'レスポンスが成功すること', spec_category: "deviseの基本的な導入・認証設定" do
        expect(response).to have_http_status(:success)
      end

      it 'グループ名が、表示されていること' do
        expect(response.body).to include group.name
      end
    end
  end
end
