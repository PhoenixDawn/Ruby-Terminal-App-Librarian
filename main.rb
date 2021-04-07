#Application for librarian

require('csv')
require('yaml')
require('bcrypt')

quit = false
user = {}

customers = []
books = []

# def print_from_csv()
# CSV.open("users.csv", "a+") do |csv|
#     csv.each do |row|
#         p row
#     end
# end
# end

# print_from_csv()


# CLASSES ---------------------------------------------------------------
#Customer class
class Customer
    attr_reader :name, :email, :phone_number
    def initialize(name, phone_number, email)
        @name = name
        @phone_number = phone_number
        @email = email
    end

    def to_s
        "Name: #{@name}, Phone Number: #{@phone_number}, Email: #{@email}"
    end
end

class Book
attr_accessor :checked_out_to, :checked_out_date
attr_reader :title, :author, :year
    def initialize(title, author, year)
        @title = title
        @author = author
        @year = year
        @checkedout = false
        @checked_out_to = nil
        @checked_out_date = nil
    end

    def to_s
        "Name: #{@title}, Author: #{@author}, Year: #{@year}, Is Checked out: #{@checkedout}"
    end

    def checkout(customer, return_date)
        @checkedout = true
        @checked_out_date = return_date
        @checked_out_to = customer
    end

    def checkin()
        @checkedout = false
        @checked_out_to = nil
        @checked_out_date = nil
    end

end
# CLASSES ---------------------------------------------------------------




#METHODS ----------------------------------------------------------------


#Add a new customer
def create_customer()
    puts "Customer Name?"
    name = gets.chomp
    puts "Customer Email?"
    email = gets.chomp
    puts "Customer Phone Number?"
    phone = gets.chomp

    return Customer.new(name, phone, email)
end

def create_book()
    puts "Book Name?"
    name = gets.chomp
    puts "Book Author?"
    author = gets.chomp
    puts "Book year it was released?"
    year = gets.chomp

    return Book.new(name, author, year)
end

#see if the user exists. 
def find_user?(user)
    CSV.open("users.csv", "a+") do |csv|
        csv.each do |row|
            if row[0] == user
                return row
            end
        end
        return false
    end
end

#Add the user to the csv file
def add_user_csv(details)
    CSV.open("users.csv", "a") do |csv|
        csv << details
    end
end


#Signup
def signup(username, password)
    if !find_user?(username)
        #Encrypt password
        encrypt_password = BCrypt::Password.create(password)        
        user = [username, encrypt_password]
        add_user_csv(user)
        return user
    else
        return false
    end
end

#Get user input
def get_login_details()
    puts "please input your username"
    user = gets.chomp
    puts "Please enter your password"
    pass = gets.chomp

    return user, pass
end

#SaveData
def save_data(filepath, entity)
    #Save Customers
    save = YAML.dump(entity)
    File.open("#{filepath}.yaml", "w") {|f| f.write save}

end
#LoadData
def load_data(filepath)
    if File.exist?("#{filepath}.yaml")
        return YAML.load(File.read("#{filepath}.yaml"))
    else
        return []
    end


end

def check_out_book(books,customer, time)
    puts "Please enter full title of a book to check out"
    book_title = gets.chomp
    books.collect! do |book|
    p book.title
    p book_title
        if book.title == book_title
            book.checkout(customer, time)
            puts "#{book_title} is now checked out to #{customer.name}"
            return books
        end
    end
    return puts "Book not found"
end

def check_book_in(books)
    puts "Please enter the full title of the book to check in"
    book_title = gets.chomp
    books.collect! do |book|
        if book.title == book_title
            book.checkin()
            puts "#{book_title} is now checked in!"
            return books
         end
    end
    puts "Book not found!"
end

def get_customer(customers)
    puts "Please enter a name of a customer"
    customer_name = gets.chomp
    customers.each do |customer|
        if customer.name == customer_name
            return customer
        end
    end
    return puts "Customer not found"
end

def check_overdue_books(books)
    books.each do |book|
        if book.checked_out_date != nil
            if book.checked_out_date < Date.today
                puts "'#{book.title}' is overdue please contact #{book.checked_out_to}"
            end
        end
    end
end

#METHODS ----------------------------------------------------------------



customers = load_data("customers")
books = load_data("books")


#DEBUG MODE
user = {username: "ph", password: "123"}

check_overdue_books(books)

while true
    #Shuold repeat this loop until the user is signed in
    until user != {}
        puts "Options: login, signup, quit"
        input = gets.chomp

        if input == "quit"
            return
        end

        if input == "signup"
            username, password = get_login_details()
            signedUp = signup(username, password)
            if signedUp
                user = signedUp
            else
                puts "Username already exists"
            end
            p user

        elsif input == "login"
            username, password = get_login_details()
            row = find_user?(username)
            if row
                encrypted_password = BCrypt::Password.new(row[1])
                if encrypted_password == password
                    user = {username:row[0], password: row[1]}
                    puts "You are now logged in!"
                else
                    puts "Incorrect login information!"
                end
            else
                puts "Incorrect login information!"
            end
        end
    end

    #Once user is signed in then application can do its thing
    puts "Options: AddCustomer, ViewCustomers, AddBook, ViewBooks, CheckOutBook, CheckInBook, quit"
    input = gets.chomp.downcase
    #Add user
    case input
    when "addcustomer"
        newCustomer = create_customer()
        customers.push(newCustomer)
        save_data("customers", customers)
    when "viewcustomers"
        customers.each do |customer|
            puts customer.to_s
        end
    when "addbook"
        newBook = create_book()
        books.push(newBook)
        save_data("books", books)
    when "viewbooks"
        books.each do |book|
            puts book.to_s
        end
    when "checkoutbook"
        customer = get_customer(customers)
        books = check_out_book(books, customer, Date.today + 3)
        save_data("books", books)
    when "checkinbook"
        books = check_book_in(books)
        save_data("books", books)

    when "quit"
        puts "Good Bye!"
        return
    else

    end
end
