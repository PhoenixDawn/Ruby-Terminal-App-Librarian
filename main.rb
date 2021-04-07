#Application for librarian

require('csv')
require('yaml')
require('bcrypt')
require('colorize')

quit = false
user = {}

users = []
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
    puts "Customer Name?".colorize(:light_blue)
    name = gets.chomp
    puts "Customer Email?".colorize(:light_blue)
    email = gets.chomp
    puts "Customer Phone Number?".colorize(:light_blue)
    phone = gets.chomp

    return Customer.new(name, phone, email)
end

def create_book()
    puts "Book Name?".colorize(:light_blue)
    name = gets.chomp
    puts "Book Author?".colorize(:light_blue)
    author = gets.chomp
    puts "Book year it was released?".colorize(:light_blue)
    year = gets.chomp

    return Book.new(name, author, year)
end

#see if the user exists. 
def find_user?(username)
    users.each do |user|
        if user = username
            return true
        end
    end
        return false
end

#Add the user to the csv file
# def add_user_csv(details)
#     CSV.open("users.csv", "a") do |csv|
#         csv << details
#     end
# end


#Signup
def signup(username, password)
    if !find_user?(username)
        #Encrypt password
        encrypt_password = BCrypt::Password.create(password)        
        user = [username, encrypt_password]
        return user
    else
        return false
    end
end

#Get user input
def get_login_details()
    puts "please input your username".colorize(:light_blue)
    user = gets.chomp
    puts "Please enter your password".colorize(:light_blue)
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
    puts "Please enter full title of a book to check out".colorize(:light_blue)
    book_title = gets.chomp
    books.collect! do |book|
        if book.title == book_title
            book.checkout(customer, time)
            puts "#{book_title} is now checked out to #{customer.name}".colorize(:green)
            return books
        end
    end
    return puts "Book not found".colorize(:red)
end

def check_book_in(books)
    puts "Please enter the full title of the book to check in".colorize(:light_blue)
    book_title = gets.chomp
    books.collect! do |book|
        if book.title == book_title
            book.checkin()
            puts "#{book_title} is now checked in!".colorize(:green)
            return books
         end
    end
    puts "Book not found!".colorize(:red)
end

def get_customer(customers)
    puts "Please enter a name of a customer".colorize(:light_blue)
    customer_name = gets.chomp
    customers.each do |customer|
        if customer.name == customer_name
            return customer
        end
    end
    return puts "Customer not found".colorize(:red)
end

def check_overdue_books(books)
    flag = false
    books.each do |book|
        if book.checked_out_date != nil
            if book.checked_out_date < Date.today
                flag = true
                puts "'#{book.title}' is overdue please contact #{book.checked_out_to}".colorize(:red)
            end
        end
    end
    if !flag 
        puts "There are currently no overdue books!".colorize(:green)
    end
end

#METHODS ----------------------------------------------------------------



customers = load_data("customers")
books = load_data("books")
users = load_data("users")


#DEBUG MODE
# user = {username: "ph", password: "123"}

hasCheckedOverDueBooks = false

while true
    #Shuold repeat this loop until the user is signed in
    until user != {}
        puts "Options: login, signup, quit".colorize(:blue)
        input = gets.chomp

        if input == "quit"
            return
        end

        if input == "signup"
            username, password = get_login_details()
            signedUp = signup(username, password)
            if signedUp
                user = signedUp
                users.push(user)
                save_data("users", users)
            else
                puts "Username already exists".colorize(:red)
            end

        elsif input == "login"
        p users
            username, password = get_login_details()

            users.each do |currUser|
                if currUser[0] == username
                    encrypted_password = BCrypt::Password.new(currUser[1])
                    if encrypted_password == password
                        user = {username:currUser[0], password: currUser[1]}
                        puts "You are now logged in!".colorize(:green)
                    else
                        puts "Incorrect login information!".colorize(:red)
                    end
                end
            end
            if user == {}
                puts "Incorrect login information!...".colorize(:red)
            end
        end
    end
    if !hasCheckedOverDueBooks
        check_overdue_books(books)
        hasCheckedOverDueBooks = true
    end
    #Once user is signed in then application can do its thing
    puts "Options: AddCustomer, ViewCustomers, AddBook, ViewBooks, CheckOutBook, CheckInBook, ViewOverdueBooks, quit".colorize(:blue)
    input = gets.chomp.downcase
    #Add user
    case input
    when "addcustomer"
        newCustomer = create_customer()
        customers.push(newCustomer)
        save_data("customers", customers)
    when "viewcustomers"
        customers.each do |customer|
            puts customer.to_s.colorize(:light_green)
        end
    when "addbook"
        newBook = create_book()
        books.push(newBook)
        save_data("books", books)
    when "viewbooks"
        books.each do |book|
            puts book.to_s.colorize(:light_green)
        end
    when "checkoutbook"
        customer = get_customer(customers)
        if customer
        books = check_out_book(books, customer, Date.today + 3)
        save_data("books", books)
        end
    when "checkinbook"
        books = check_book_in(books)
        save_data("books", books)
    when "viewoverduebooks"
        check_overdue_books(books)
    when "quit"
        puts "Good Bye!"
        return
    else

    end
end
