require 'rails_helper'

RSpec.describe 'Groupモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { group.valid? }

    let(:group) { build(:group) }

    context 'nameカラム' do
      it '空欄でないこと', spec_category: "バリデーションとメッセージ表示" do
        group.name = ''
        is_expected.to eq false
      end
      it '入力されていれば、有効であること' do
        group.name = "テストグループ"
        is_expected.to eq true
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'GroupUserモデルとの関係' do
      it '1:Nとなっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        expect(Group.reflect_on_association(:group_users).macro).to eq :has_many
      end
    end
    context 'Userとの関係' do
      it 'N:1となっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        association = Group.reflect_on_association(:owner)
        expect(association.macro).to eq :belongs_to
        expect(association.klass).to eq User
      end
    end
    context 'Userとの、間接的な関係(members)' do
      it 'through: group_usersでhas_manyとなっている', spec_category: "基本的なアソシエーション概念と適切な変数設定" do
        association = Group.reflect_on_association(:members)
        expect(association.macro).to eq :has_many
        expect(association.options[:through]).to eq :group_users
        expect(association.options[:source]).to eq :user
      end
    end
  end
end
