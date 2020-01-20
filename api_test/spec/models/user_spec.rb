# frozen_string_literal: true
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "when creating" do
    it "doesn't allow  null role" do
      expect{ create(:user, role: nil) }.to raise_exception(ActiveRecord::NotNullViolation)
    end
    it "defaults role to employee" do
      user = create(:user)
      expect(user.employee?).to be(true)
      expect(user.admin?).to be(false)
    end
  end
end
