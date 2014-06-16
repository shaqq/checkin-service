require 'spec_helper'

describe User do

  describe :validations do

    it 'validates the required attributes' do
      user = User.new(name: 'shaqq', email: 'shakerislam@gmail.com', password: 'JGL', password_confirmation: 'JGL')
      expect(user.valid?).to be true
    end

    it 'is invalid without a name' do
      user = User.new(email: 'watchthe@jimmyfallon.bit', password: 'JGL', password_confirmation: 'JGL')
      expect(user.valid?).to be false
    end

    it 'is invalid without an email address' do
      user = User.new(name: 'Tiny Dancer', password: 'JGL', password_confirmation: 'JGL')
      expect(user.valid?).to be false
    end

    it 'is invalid without a password' do
      user = User.new(name: 'Tiny Dancer', email: 'watchthe@jimmyfallon.bit', password_confirmation: 'JGL')
      expect(user.valid?).to be false
    end

    it 'is invalid without a password confirmation' do
      user = User.new(name: 'Tiny Dancer', email: 'watchthe@jimmyfallon.bit')
      expect(user.valid?).to be false
    end

    it 'is invalid if the email is not unique' do
      user_1 = User.create(name: 'Tiny Dancer', email: 'watchthe@jimmyfallon.bit', password: 'JGL', password_confirmation: 'JGL')
      user_2 = User.create(name: 'Larger Dancer', email: 'watchthe@jimmyfallon.bit', password: 'JGL', password_confirmation: 'JGL')
      expect(user_2.valid?).to be false
    end

  end

end
