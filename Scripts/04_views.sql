USE School_DB
Go

-- Each Department with Student Count and Teacher Count.
CREATE VIEW vw_DepartmentSummary
AS
SELECT
    D.DId,
    D.DName,
    ISNULL(S.StudentCount, 0) StudentCount,
    ISNULL(T.TeacherCount, 0) TeacherCount
FROM Department D
LEFT JOIN
(
    SELECT
        DId,
        COUNT(*) StudentCount
    FROM Student
    GROUP BY DId
) AS S
    ON D.DId = S.DId

LEFT JOIN
(
    SELECT
        DId,
        COUNT(*) AS TeacherCount
    FROM Teacher
    GROUP BY DId
) AS T
    ON D.DId = T.DId;
 Go

-- Each Teacher and the number of Courses they teach
CREATE VIEW vw_TeacherCourseLoad
AS
SELECT
    T.TId,
    T.TName,
    COUNT(C.CId) CourseCount
FROM Teacher T
LEFT JOIN Course C
    ON T.TId = C.CTId
GROUP BY
    T.TId,
    T.TName;
GO


-- combining Student information, enrolled Courses, Grades, and a computed Status
CREATE VIEW vw_StudentFullReport
AS
SELECT
    S.SId, S.SName, C.CId, C.CName,  E.EGrade,
    CASE
        WHEN E.EGrade IS NULL THEN 'Pending'
        WHEN E.EGrade >= 50 THEN 'Passed'
        ELSE 'Failed'
    END AS Status
FROM Student S
INNER JOIN Department D
    ON S.DId = D.DId
INNER JOIN Enrollment E
    ON S.SId = E.SId
INNER JOIN Course AS C
    ON E.CId = C.CId;
GO


-- identify the top Student by average Grade
CREATE VIEW vw_DepartmentTopStudent
AS
WITH StudentAverages AS
(
    SELECT S.SId, S.SName, D.DId, D.DName, AVG(E.EGrade) AverageGrade
    FROM Student S
    INNER JOIN Department D
        ON S.DId = D.DId
    INNER JOIN Enrollment E
        ON S.SId = E.SId
    WHERE E.EGrade IS NOT NULL
    GROUP BY S.SId, S.SName, D.DId, D.DName
),
RankedStudents AS
(
    SELECT SId, SName, DId,DName, AverageGrade,
        RANK() OVER
        (
            PARTITION BY DId
            ORDER BY AverageGrade DESC
        ) AS StudentRank
    FROM StudentAverages
)
SELECT DId, DName, SId, SName, AverageGrade
FROM RankedStudents
WHERE StudentRank = 1;
GO