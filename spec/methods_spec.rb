require 'rspec'

require_relative('../classes/Customer.rb')
require_relative('../classes/Book.rb')

require_relative('../methods.rb')


describe 'Customer' do
    it "It should create a new customer" do
        expect(create_customer()).to be_a(Customer)
    end
end

describe 'Book' do
    it "It should create a new book"
        expect(create_book()).to be_a(Book)
    end
end

