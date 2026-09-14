-- every student with the name of their department.

SELECT S.* FROM Student S
INNER JOIN 
Department D
ON S.DId = D.DId;


-- teachers who teach more than 3 courses.

SELECT T.TId, T.TName, COUNT(C.CId) CourseCount FROM Teacher T
INNER JOIN 
Course C
ON T.TId = C.CTId
GROUP BY T.TId, T.TName
HAVING COUNT(C.CId) > 3;


-- students who have not any graded enrollment.

SELECT S.SId, S.SName FROM Student S
LEFT JOIN Enrollment E
ON S.SId = E.SId
GROUP BY S.SId, S.SName
HAVING COUNT(E.CId) = 0;


-- Departments whose Lead Teacher supervises more than 5 teachers.

SELECT D.DId, D.DName, L.TName LeadTeacher, COUNT(T.TId) SupervisedTeachers
FROM Department D
INNER JOIN Teacher L
    ON D.DLeadTId = L.TId
INNER JOIN Teacher T
    ON T.SuperTId = L.TId
GROUP BY D.DId, D.DName, L.TId, L.TName
HAVING COUNT(T.TId) > 5;


-- Every course with its department and assigned teacher.

SELECT C.CId, C.CName, D.DName, T.TName TeacherName
FROM Course C
INNER JOIN Department D
    ON C.CDId = D.DId
INNER JOIN Teacher T
    ON C.CTId = T.TId;