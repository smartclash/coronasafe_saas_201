class Student
    def initialize(roll_no, name)
        @roll_no = roll_no
        @name = name
        @is_enrolled = false
    end

    def roll_no
        @roll_no
    end

    def name
        @name
    end

    def is_enrolled?
        @is_enrolled
    end
end

student = Student.new(12345, "John Doe")
puts student.roll_no, student.name, student.is_enrolled
