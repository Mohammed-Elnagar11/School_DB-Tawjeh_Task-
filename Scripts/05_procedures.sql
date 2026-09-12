Use School_DB;
Go

-- sp_GetStudentsByDepartment
CREATE PROCEDURE sp_GetStudentsByDepartment
    @DeptId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT S.SId, S.SName, S.SLevel, S.SAddress, D.DName
    FROM Student S
    INNER JOIN Department D
        ON S.DId = D.DId
    WHERE S.DId = @DeptId;
END;
GO

-- Using
EXEC sp_GetStudentsByDepartment @DeptId = 1;
Go


-- sp_EnrollStudent
CREATE PROCEDURE sp_EnrollStudent
    @StudentId INT,
    @CourseId INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
    -- Checking Student existance
        IF NOT EXISTS (SELECT 1 FROM Student WHERE SId = @StudentId)
        BEGIN
            RAISERROR('Student does not exist.', 16, 1);
            RETURN;
        END;
        -- Checking Course existance
        IF NOT EXISTS (SELECT 1 FROM Course WHERE CId = @CourseId)
        BEGIN
            RAISERROR('Course does not exist.', 16, 1);
            RETURN;
        END;
        -- Check that Student and Course belong to the same Department
        IF EXISTS
        (
            SELECT 1
            FROM Student AS S
            INNER JOIN Course AS C ON C.CId = @CourseId
            WHERE S.SId = @StudentId AND S.DId <> C.CDId
        )
        BEGIN
            RAISERROR('Student and Course must belong to the same Department.', 16, 1);
            RETURN;
        END;
        -- Prevent duplicate Enrollment
        IF EXISTS
        (
            SELECT 1 FROM Enrollment
            WHERE SId = @StudentId AND CId = @CourseId
        )
        BEGIN
            RAISERROR('Student is already enrolled in this Course.', 16, 1);
            RETURN;
        END;
        -- Create Enrollment
        INSERT INTO Enrollment (SId, CId, EDate, EGrade)
        VALUES (@StudentId, @CourseId, CAST(GETDATE() AS DATE), NULL);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

EXEC sp_EnrollStudent
    @StudentId = 1,
    @CourseId = 5;

SELECT * FROM Enrollment
WHERE SId = 1 AND CId = 5;


EXEC sp_EnrollStudent
    @StudentId = 1,
    @CourseId = 5; -- Student is already enrolled in this Course.
    
EXEC sp_EnrollStudent
    @StudentId = 1,
    @CourseId = 9; -- Student and Course must belong to the same Department.
Go
  
  
-- sp_TransferStudent
CREATE PROCEDURE sp_TransferStudent
    @StudentId INT,
    @NewDepartmentId INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Check that the Student exists
        IF NOT EXISTS (SELECT 1 FROM Student WHERE SId = @StudentId)
        BEGIN
            RAISERROR('Student does not exist.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        -- Check that the new Department exists
        IF NOT EXISTS (SELECT 1 FROM Department WHERE DId = @NewDepartmentId)
        BEGIN
            RAISERROR('New Department does not exist.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        -- Check if Student is already in this Department
        IF EXISTS (SELECT 1 FROM Student WHERE SId = @StudentId AND DId = @NewDepartmentId)
        BEGIN
            RAISERROR('Student is already in this Department.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        -- Check for Enrollment conflicts
        IF EXISTS
        (
            SELECT 1
            FROM Enrollment AS E
            INNER JOIN Course AS C ON E.CId = C.CId
            INNER JOIN Student AS S ON E.SId = S.SId
            WHERE E.SId = @StudentId AND C.CDId <> @NewDepartmentId
        )
        BEGIN
            RAISERROR('Transfer conflicts with existing Course Enrollments.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        -- Transfer Student
        UPDATE Student
        SET DId = @NewDepartmentId
        WHERE SId = @StudentId;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO


EXEC sp_TransferStudent
    @StudentId = 6,
    @NewDepartmentId = 2; -- Transfered Successfully

    EXEC sp_TransferStudent
    @StudentId = 1,
    @NewDepartmentId = 2; -- Transfer conflicts with existing Course Enrollments.