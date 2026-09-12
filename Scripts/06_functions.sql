Use School_DB
Go


CREATE FUNCTION fn_CalculateAge
(
    @DateOfBirth DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;

    SET @Age = DATEDIFF(YEAR, @DateOfBirth, GETDATE());

    -- If birthday has not occurred yet this year, subtract one year.
    IF DATEADD(YEAR, @Age, @DateOfBirth) > CAST(GETDATE() AS DATE)
        SET @Age = @Age - 1;

    RETURN @Age;
END;
GO
-- Testing
SELECT dbo.fn_CalculateAge('2000-05-10') Age; -- 26
SELECT dbo.fn_CalculateAge('2000-12-20') Age; -- 25
GO


CREATE FUNCTION fn_GetCoursesByStudent
(
    @StudentId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        C.CId, C.CName, C.CDuration, C.CDescription, C.CDId, E.EDate, E.EGrade
    FROM Enrollment E
    INNER JOIN Course C
        ON E.CId = C.CId
    WHERE E.SId = @StudentId
)
GO
-- Testing
SELECT *
FROM dbo.fn_GetCoursesByStudent(1);
GO


CREATE FUNCTION fn_GetTopStudentsByCourse
(
    @CourseId INT,
    @TopN INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT SId, SName, EGrade, StudentRank
    FROM
    (
        SELECT S.SId, S.SName, E.EGrade,

            RANK() OVER
            (
                ORDER BY E.EGrade DESC
            ) AS StudentRank

        FROM Enrollment E
        INNER JOIN Student S
            ON E.SId = S.SId
        WHERE E.CId = @CourseId
          AND E.EGrade IS NOT NULL
    ) AS RankedStudents
    WHERE StudentRank <= @TopN
);
GO
--Testing
SELECT *
FROM dbo.fn_GetTopStudentsByCourse(1, 3);
GO

CREATE FUNCTION fn_IsPassed
(
    @Grade DECIMAL(5,2)
)
RETURNS VARCHAR(10)
AS
BEGIN

    DECLARE @Result VARCHAR(10);

    IF @Grade IS NULL
        SET @Result = 'Pending';

    ELSE IF @Grade >= 50
        SET @Result = 'Passed';

    ELSE
        SET @Result = 'Failed';

    RETURN @Result;

END;
GO
-- Testing
SELECT dbo.fn_IsPassed(85) AS Result; -- Passed
SELECT dbo.fn_IsPassed(40) AS Result; -- Failed
SELECT dbo.fn_IsPassed(NULL) AS Result; -- Pending