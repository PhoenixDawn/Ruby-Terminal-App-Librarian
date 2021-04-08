require 'rspec'

require_relative('../classes/Customer.rb')
require_relative('../classes/Book.rb')

require_relative('../methods.rb')


#Dummy users
user1 = ["Test1", "Pass1"]
user2 = ["Test2", "Pass2"]

users = [user1, user2]

#Dummy books
book1 = Book.new("Title1", "Author", "2010")
book2 = Book.new("Title2", "Author", "2010")

books = [book1, book2]

#Dummy customers
customer1 = Customer.new("John", "12345", "John@e.c")
customer2 = Customer.new("Smith", "54321", "Smith@e.c")

customers = [customer1, customer2]


describe 'Customer' do
    it "It should create a new customer" do
        expect(create_customer()).to be_a(Customer)
        p users
    end
end

describe 'Book' do
    it "It should create a new book" do
        expect(create_book()).to be_a(Book)
    end
end

describe 'Login/Signup' do
    it "It should find a user with the name 'Test1'" do
        expect(find_user?("Test1", users)).to be(true)
    end 
    it "It should NOT find a user with the name 'John Doe'" do
        expect(find_user?("John Doe", users)).to be(false)
    end
    it "Should return an array of the user" do
        expect(signup("user", "pass", users)).to be_a(Array)
    end
    it "It should return false creating a user" do
        expect(signup("Test1", "pass", users)).to be(false)
    end

end






