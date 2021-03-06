# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  steam_name       :string(255)
#  email            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  password_digest  :string(255)
#  remember_token   :string(255)
#  admin            :boolean          default(FALSE)
#  steam_games      :text
#  steam_id         :string(255)
#  privacy_state    :string(255)
#  avatar_icon      :string(255)
#  avatar_medium    :string(255)
#  avatar_full      :string(255)
#  custom_url       :string(255)
#  steam_rating     :float
#  hours_played_2wk :float
#  real_name        :string(255)
#  steam_id_64      :string(255)
#

require 'spec_helper'

describe User do
  before do 
    @user = User.new(steam_name: "rafer32", 
                     email: "user@example.com",
                     password: "foobar", 
                     password_confirmation: "foobar")
  end

  subject { @user }

  it { should be_valid }
  it { should_not be_admin }
  it { should respond_to(:steam_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:steam_id) }
  it { should respond_to(:privacy_state) }
  it { should respond_to(:avatar_icon) }
  it { should respond_to(:avatar_medium) }
  it { should respond_to(:avatar_full) }
  it { should respond_to(:custom_url) }
  it { should respond_to(:steam_rating) }
  it { should respond_to(:hours_played_2wk) }
  it { should respond_to(:real_name) }
  it { should respond_to(:steam_id_64) }
  it { should respond_to(:steam_games) }

  describe "when steam_name is not present" do
    before { @user.steam_name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe "when email is already taken (case insensitive)" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password does not match password_confirmation" do
    before { @user.password_confirmation = "hunter2" }
    it { should_not be_valid }
  end

  describe "when password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "with admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "steam profile fields" do
    before { @user.save }
    its(:steam_id) { should_not be_blank }
    its(:privacy_state) { should_not be_blank }
    its(:avatar_icon) { should_not be_blank }
    its(:avatar_medium) { should_not be_blank }
    its(:avatar_full) { should_not be_blank }
    its(:custom_url) { should_not be_blank }
    its(:steam_rating) { should_not be_blank }
    its(:hours_played_2wk) { should_not be_blank }
    its(:real_name) { should_not be_blank }

    its(:steam_rating) { should be_a(Float) }
    its(:hours_played_2wk) { should be_a(Float) }
  end

  describe "steam_games" do
    before { @user.save }
    its(:steam_games) { should_not be_blank }
    its(:steam_games) { should be_a(Hash) }
  end
end
