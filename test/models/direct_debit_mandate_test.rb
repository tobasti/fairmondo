#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe DirectDebitMandate do
  subject { DirectDebitMandate.new }
  let(:user) { build_stubbed :user }
  let(:mandate) { DirectDebitMandate.new(user: user) }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :reference }
    it { subject.must_respond_to :state }
    it { subject.must_respond_to :activated_at }
    it { subject.must_respond_to :last_used_at }
    it { subject.must_respond_to :revoked_at }
  end

  describe 'associations' do
    it { subject.must belong_to(:user) }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :user_id }
    it { subject.must validate_presence_of :reference }
    it { subject.must validate_uniqueness_of :reference }
  end

  describe '#build_reference' do
    it 'should create a reference consisting of user id and number' do
      ref = mandate.build_reference
      ref.must_equal "#{user.id}-001"
    end

    it 'should count up if mandates are already present' do
      mandate1 = DirectDebitMandate.new(user: user)
      mandate1.reference = mandate1.build_reference
      mandate1.save

      mandate2 = DirectDebitMandate.new(user: user)
      ref = mandate2.build_reference
      ref.must_equal "#{user.id}-002"
    end
  end

  describe 'class methods' do
    describe '#creditor_identifier' do
      it 'should return Fairmondo SEPA Creditor Identifier' do
        DirectDebitMandate.creditor_identifier.must_equal 'DE15ZZZ00001452371'
      end
    end
  end

  describe 'methods' do
    describe '#reference_date' do
      it 'should return the date of created_at' do
        travel_to Time.new(2016, 4, 1, 12)
        mandate = DirectDebitMandate.create(user: user, reference: '001')
        travel_back

        mandate.reference_date.to_s.must_equal '2016-04-01'
      end
    end
  end

  describe 'state' do
    before do
      mandate.reference = '001'
    end

    it 'should be new for a new instance' do
      mandate.state.must_equal 'new'
      mandate.activated_at.must_be_nil
      mandate.revoked_at.must_be_nil
    end

    it 'should be able to get activated' do
      mandate.activate!

      mandate.state.must_equal 'active'
      mandate.activated_at.wont_be_nil
    end

    it 'should be able to get inactive if active' do
      mandate.activate!
      mandate.deactivate!

      mandate.state.must_equal 'inactive'
    end

    it 'should be able to get revoked if active' do
      mandate.activate!
      mandate.revoke!

      mandate.state.must_equal 'revoked'
      mandate.revoked_at.wont_be_nil
    end
  end
end
