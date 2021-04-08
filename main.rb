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
user = {username: "ph", password: "123"}

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
        if customer
        books = check_out_book(books, customer)
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
