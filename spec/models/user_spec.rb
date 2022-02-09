require 'rails_helper'

RSpec.describe User, type: :model do
  
  describe 'User Validations' do

    it 'password and password_confirmation fields should match' do
      @user = User.new(name: 'Ichigo', last_name: 'Kurosaki', email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai' )

      expect(@user.password).to eq(@user.password_confirmation)
    end
    
    it "cannot register user if first name is blank" do
      @user = User.new(name: nil, last_name: 'Kurosaki', email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai' )
      @user.save
      
      expect(User.where(email: 'ichigo@bankai.com').count) == 0
    end

    it "cannot register if last name is blank" do
      @user = User.new(name: 'Ichigo', last_name: nil, email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai' )
      @user.save
      
      expect(User.where(email: 'ichigo@bankai.com').count) == 0
    end
    
    it "cannot register user if email is blank" do
      @user = User.new(name: nil, last_name: 'Kurosaki', email: nil, password: 'bankai', password_confirmation: nil )
      @user.save
      
      expect(User.where(email: 'ichigo@bankai.com').count) == 0
    end

    it "cannot register user if email already exist" do
      @user_1 = User.new(name: 'Ichigo', last_name: 'Kurosaki', email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai' )
      @user_1.save
      
      @user_2 = User.new(name: 'Ichigo', last_name: 'Kurosaki', email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai' )
      @user_2.save
      expect(User.where(email: 'ichigo@bankai.com').count) == 1
    end        
    

    it "cannot register if password is less than 5 characters long" do
      @user = User.new(name: nil, last_name: 'Kurosaki', email: nil, password: '1234', password_confirmation: '1234' )
      @user.save
      
      expect(User.where(email: 'ichigo@bankai.com').count) == 0
    end

    it "can register if password is 5 characters long" do
      @user = User.new(name: nil, last_name: 'Kurosaki', email: nil, password: '12345', password_confirmation: '12345' )
      @user.save
      
      expect(User.where(email: 'ichigo@bankai.com').count) == 1
    end


  end

  describe '.authenticate_with_credentials' do

    it 'should authenticate users if credentials match' do
      user = User.new(name: 'Ichigo', last_name: 'Kurosaki', email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai')
      user.save

      user_login = User.authenticate_with_credentials('ichigo@bankai.com', 'bankai')
      expect(user_login).to be_instance_of(User)
    end

    it 'should authenticate user if the email is in different cases' do
      user = User.new(name: 'Ichigo', last_name: 'Kurosaki', email: 'ICHiGO@bankai.com', password: 'bankai', password_confirmation: 'bankai')
      user.save

      user_login = User.authenticate_with_credentials('ichigo@bankai.com', 'bankai')
      expect(user_login).to be_instance_of(User)
    end

    it 'should authenticate users if there is whitespace in the email address' do
      @user = User.new(name: 'Ichigo', last_name: 'Kurosaki', email: 'ichigo@bankai.com', password: 'bankai', password_confirmation: 'bankai')
      @user.save

      expect(User.authenticate_with_credentials(' ichigo@bankai.com ', 'bankai')).to eq(@user)
    end

  end
  
end