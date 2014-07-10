require_relative '../test_helper'

describe Address do
  let(:address) { FactoryGirl.create(:address) }
  subject { Address.new }

  it 'has a valid factory' do
    address.valid?.must_equal true
  end

  describe 'associations' do
    it { subject.must belong_to :user }
    it { subject.must have_many :business_transactions }
  end

  describe 'attributes' do
    it { subject.must_respond_to :title }
    it { subject.must_respond_to :first_name }
    it { subject.must_respond_to :last_name }
    it { subject.must_respond_to :company_name }
    it { subject.must_respond_to :address_line_1 }
    it { subject.must_respond_to :address_line_2 }
    it { subject.must_respond_to :zip }
    it { subject.must_respond_to :city }
    it { subject.must_respond_to :country }
    it { subject.must_respond_to :user_id }
  end

  describe 'validations' do
    it { subject.must validate_presence_of :first_name }
    it { subject.must validate_presence_of :last_name }
    it { subject.must validate_presence_of :address_line_1 }
    it { subject.must validate_presence_of :zip }
    it { subject.must validate_presence_of :city }
    it { subject.must validate_presence_of :country }
  end
end