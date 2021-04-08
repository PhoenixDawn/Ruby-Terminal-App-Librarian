require('yaml')
require('bcrypt')
require('colorize')
require('date')


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
    begin
        save = YAML.dump(entity)
        File.open("#{filepath}.yaml", "w") {|f| f.write save}
    rescue
        puts "Error saving data! #{filepath}".colorize(:red)
    end

end
#LoadData
def load_data(filepath)
    begin
        if File.exist?("#{filepath}.yaml")
            return YAML.load(File.read("#{filepath}.yaml"))
        else
            return []
        end
    rescue
        puts "Error loading data #{filepath} loading empty array".colorize(:red)
        return []
    end

end

#Check book out
def check_out_book(books,customer)
    puts "Please enter full title of a book to check out".colorize(:light_blue)
    book_title = gets.chomp
    puts "Please enter how long to check the book out (Days)".colorize(:light_blue)
    time = gets.chomp.to_i
    books.each do |book|
        if book.title == book_title
            if !book.checkedout
                book.checkout(customer, Date.today + time)
                puts "#{book_title} is now checked out to #{customer.name}".colorize(:green)
                return books
            else
                puts "#{book_title} is already checked out!".colorize(:red)
                return books
            end
        end
    end
    puts "Book not found".colorize(:red)
    return books
end

#Check book in
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
    return puts "Customer not found #{customer_name}".colorize(:red)
end

def get_book(books)
    puts "Please enter a name of a book".colorize(:light_blue)
    book_name = gets.chomp
    books.each do |book|
        if book.title == book_name 
            return book
        end
    end
    puts "Book not found #{book_name}".colorize(:red)
    return nil
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
