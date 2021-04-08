class Book
    attr_accessor :checked_out_to, :checked_out_date
    attr_reader :title, :author, :year, :checkedout
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