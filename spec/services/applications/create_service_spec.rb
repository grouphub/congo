require "spec_helper"

describe Applications::CreateService do
  let(:benefit_plan) { create(:benefit_plan) }
  let(:group)        { create(:group, slug: "group_test_service") }
  let(:user)         { create(:user) }
  let(:broker)       { create(:user, :broker) }
  let!(:membership)   { create(:membership, user_id: user.id, group: group) }

  let(:attributes) { { benefit_plan_id: benefit_plan.id,
                       group_slug: group.slug,
                       user_id: user.id,
                       selected_by_id: broker.id } }


  subject { Applications::CreateService.new(attributes) }

  describe "#process" do
    it "creates the application" do
      expect { subject.process }.
        to change(Application, :count).by 1
    end
  end

  describe "when the membership is present and user id is not" do
    let(:attributes) { { benefit_plan_id: benefit_plan.id,
                         group_slug: group.slug,
                         membership_id: membership.id,
                         selected_by_id: broker.id } }

    it "creates the application" do
      expect { subject.process }.
        to change(Application, :count).by 1
    end
  end
end
