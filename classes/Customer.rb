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