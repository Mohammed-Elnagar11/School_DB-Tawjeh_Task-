USE School_DB

INSERT INTO Department (DName, DLeadTId)
VALUES
('Computer Science', NULL),
('Mathematics', NULL),
('Physics', NULL)

-- CS
INSERT INTO Teacher
(TName, TAddress, TSalary, SuperTId, DId)
VALUES
('Ahmed Hassan', 'Cairo', 18000, NULL, 1),
('Mohamed Ali', 'Giza', 15000, 1, 1),
('Omar Khaled', 'Cairo', 14500, 1, 1),
('Youssef Samir', 'Giza', 14000, 1, 1),
('Karim Adel', 'Cairo', 13500, 1, 1),
('Mostafa Tarek', 'Giza', 13000, 1, 1),
('Hassan Mahmoud', 'Cairo', 12500, 1, 1),
('Amr Nabil', 'Giza', 12000, 1, 1)

-- Math
INSERT INTO Teacher
(TName, TAddress, TSalary, SuperTId, DId)
VALUES
('Ibrahim Fathy', 'Cairo', 17000, NULL, 2),
('Mahmoud Ashraf', 'Giza', 14500, 9, 2),
('Tamer Wael', 'Cairo', 14000, 9, 2)

--Physics
INSERT INTO Teacher
(TName, TAddress, TSalary, SuperTId, DId)
VALUES
('Khaled Sameh', 'Cairo', 17500, NULL, 3),
('Adel Hossam', 'Giza', 14500, 12, 3),
('Sherif Ahmed', 'Cairo', 14000, 12, 3)


UPDATE Department
SET DLeadTId = 1 -- Ahmed
WHERE DId = 1

UPDATE Department
SET DLeadTId = 9 -- Ibrahim
WHERE DId = 2;

UPDATE Department
SET DLeadTId = 12 -- Khalid
WHERE DId = 3


INSERT INTO Student
(SLevel, SAddress, SName, DId)
VALUES
(1, 'Cairo', 'Ali Hassan', 1),
(2, 'Giza', 'Omar Ahmed', 1),
(3, 'Cairo', 'Youssef Mohamed', 1),
(4, 'Giza', 'Karim Hassan', 1),
(2, 'Cairo', 'Mahmoud Ali', 1),
(3, 'Giza', 'Ahmed Samir', 1),

(1, 'Cairo', 'Hany Adel', 2),
(2, 'Giza', 'Tarek Mahmoud', 2),
(3, 'Cairo', 'Mostafa Ashraf', 2),
(4, 'Giza', 'Islam Fathy', 2),

(1, 'Cairo', 'Khaled Ibrahim', 3),
(2, 'Giza', 'Amr Hassan', 3),
(3, 'Cairo', 'Sherif Adel', 3),
(4, 'Giza', 'Nour Sameh', 3)


-- CS
INSERT INTO Course
(CName, CDuration, CDescription, CDId, CTId)
VALUES
('Database Systems', 45, 'Introduction to relational databases and SQL Server', 1, 2), -- T is Mohamed Ali
('SQL Server Engineering', 40, 'Database design, constraints and performance', 1, 2),
('Data Modeling', 35, 'ERD, relationships and database normalization', 1, 2),
('Advanced SQL', 40, 'Advanced querying, views and stored procedures', 1, 2),

('Object Oriented Programming', 50, 'Programming using object oriented concepts', 1, 3),
('Data Structures', 55, 'Fundamental data structures and algorithms', 1, 4),
('Algorithms', 50, 'Algorithm design and complexity', 1, 5),
('Software Engineering', 40, 'Software development principles and practices', 1, 6)


-- Math
INSERT INTO Course
(CName, CDuration, CDescription, CDId, CTId)
VALUES
('Calculus I', 50, 'Fundamentals of differential and integral calculus', 2, 9),
('Linear Algebra', 45, 'Vectors, matrices and linear transformations', 2, 10),
('Discrete Mathematics', 45, 'Logic, sets and mathematical structures', 2, 9),
('Probability', 40, 'Probability theory and basic statistics', 2, 11)


-- Physics
INSERT INTO Course
(CName, CDuration, CDescription, CDId, CTId)
VALUES
('Classical Mechanics', 50, 'Fundamentals of classical mechanics', 3, 12),
('Electromagnetism', 50, 'Electric and magnetic fields', 3, 13),
('Thermodynamics', 45, 'Heat, energy and thermodynamic systems', 3, 14),
('Modern Physics', 45, 'Introduction to modern physics', 3, 12)


INSERT INTO Enrollment
(SId, CId, EDate, EGrade)
VALUES
(1, 1, '2026-08-01', 85),
(1, 2, '2026-08-01', 72),
(1, 3, '2026-08-02', 91),
(1, 4, '2026-08-03', NULL),

(2, 1, '2026-08-01', 45),
(2, 5, '2026-08-02', 67),
(2, 6, '2026-08-03', NULL),

(3, 1, '2026-08-01', 95),
(3, 5, '2026-08-02', 88),
(3, 7, '2026-08-03', 79),

(4, 2, '2026-08-01', 55),
(4, 6, '2026-08-02', NULL),
(4, 8, '2026-08-03', 40),

(7, 9, '2026-08-01', 82),
(7, 10, '2026-08-02', 76),
(8, 9, '2026-08-01', NULL),
(8, 11, '2026-08-02', 48),
(9, 10, '2026-08-01', 91),
(9, 11, '2026-08-02', 87),
(9, 12, '2026-08-03', 93),
(10, 12, '2026-08-01', 35),

(11, 13, '2026-08-01', 88),
(11, 14, '2026-08-02', 74),
(12, 13, '2026-08-01', NULL),
(12, 15, '2026-08-02', 45),
(13, 16, '2026-08-01', 92),
(14, 15, '2026-08-01', 66),
(5, 6, '2026-08-01', NULL),
(5, 7, '2026-08-01', NULL)