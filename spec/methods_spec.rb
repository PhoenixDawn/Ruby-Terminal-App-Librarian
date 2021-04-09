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

def check_if_books_checkedout(books)
    books.each do |book|
        if book.checkedout == true
            return true
        end
    end
    return false
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


describe 'Check books In/Out' do
    it "It should check a book out to a customer" do
        check_out_book("Title1", 10, books, customer1)
        expect(books[0].checkedout).to be(true)
    end

    it "It should check in a book" do
        books = check_book_in("Title1", books)
        expect(books[0].checkedout).to be(false)
    end

    it "It should NOT check a book out to a customer'" do
        check_out_book("BookTitle", 10, books, customer1)
        expect(check_if_books_checkedout(books)).to be(false)
    end

end





