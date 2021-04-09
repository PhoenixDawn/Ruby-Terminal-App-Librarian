#Application for librarian
require('colorize')

require_relative('classes/Customer.rb')
require_relative('classes/Book.rb')

require_relative('methods.rb')

user = {}

users = []
customers = []
books = []

customers = load_data("customers")
books = load_data("books")
users = load_data("users")

#DEBUG MODE
# user = {username: "ph", password: "123"}

hasCheckedOverDueBooks = false

if ARGV.include?("--help")
    puts '      
    What options do and how to use them
-- AddCustomer
    - Follow prompts, input Name, Phone number, Email
    - This allows you to be able to tell which customer loaned what book.
-- ViewCustomers
    - Shows all currently registered customers available to loan books too
-- AddBook
    - Follow prompt, input title, author and year released
-- Remove book
    - Follow prompt, input a title of a book you want removed from the database
-- Viewbooks
    - View all books currently in collection
-- CheckOutBook
    - Follow prompts, input title of book you want to loan and the name of the person to loan it to.
-- CheckInBook
    - Follow prompts, input title of book you want to check in
-- ViewOverdueBooks
    - Will display all currently overdue books
-- quit
    -- Leaves program'

    return
end

#login with command 
if ARGV.length == 2
    users.each do |currUser|
        if currUser[0] == ARGV[0]
            encrypted_password = BCrypt::Password.new(currUser[1])
            if encrypted_password == ARGV[1]
                user = {username:currUser[0], password: currUser[1]}
                puts "You are now logged in!".colorize(:green)
            else
                puts "Incorrect login information!".colorize(:red)
            end
        end
    end
    ARGV.clear
end


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
            signedUp = signup(username, password, users)
            if signedUp
                user = signedUp
                users.push(user)
                save_data("users", users)
            else
                p users
                p user
                puts "Username already exists".colorize(:red)
            end

        elsif input == "login"
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
    puts "Options: AddCustomer, ViewCustomers, AddBook, RemoveBook, ViewBooks, CheckOutBook, CheckInBook, ViewOverdueBooks, quit".colorize(:blue)
    input = gets.chomp.downcase
    case input
    when "addcustomer"
        puts "Customer Name?".colorize(:light_blue)
        name = gets.chomp
        puts "Customer Email?".colorize(:light_blue)
        email = gets.chomp
        puts "Customer Phone Number?".colorize(:light_blue)
        phone = gets.chomp
    
        newCustomer = Customer.new(name, phone, email)
        customers.push(newCustomer)
        save_data("customers", customers)
    when "viewcustomers"
        customers.each do |customer|
            puts customer.to_s.colorize(:light_green)
        end
    when "addbook"
        puts "Book Name?".colorize(:light_blue)
        name = gets.chomp
        puts "Book Author?".colorize(:light_blue)
        author = gets.chomp
        puts "Book year it was released?".colorize(:light_blue)
        year = gets.chomp

        newBook = Book.new(name, author, year)
        books.push(newBook)
        save_data("books", books)
    when "removebook"
        book = get_book(books)
        if book 
            puts "Book #{book.title} removed!".colorize(:green)
        end
    when "viewbooks"
        books.each do |book|
            puts book.to_s.colorize(:light_green)
        end
    when "checkoutbook"
        customer = get_customer(customers)
        puts "Please enter full title of a book to check out".colorize(:light_blue)
        book_title = gets.chomp
        puts "Please enter how long to check the book out (Days)".colorize(:light_blue)
        time = gets.chomp.to_i

        if customer
        books = check_out_book(book_title, time, books, customer)
        save_data("books", books)
        end
    when "checkinbook"
        puts "Please enter the full title of the book to check in".colorize(:light_blue)
        book_title = gets.chomp
        books = check_book_in(book_title, books)
        save_data("books", books)
    when "viewoverduebooks"
        check_overdue_books(books)
    when "quit"
        puts "Good Bye!"
        return
    else

    end
end
