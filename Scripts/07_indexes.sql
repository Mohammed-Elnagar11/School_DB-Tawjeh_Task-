
-- Index on Enrollment.StudentId

CREATE INDEX IX_Enrollment_StudentId
ON Enrollment(SId);
GO



-- Composite Index: Enrollment(StudentId, CourseId)
/* Note:
  The current Enrollment Primary Key is already (SId, CId),
  so SQL Server already maintains an index for this combination. (Redundancy)
  */
CREATE INDEX IX_Enrollment_StudentId_CourseId
ON Enrollment(SId, CId)


-- Duplicate Enrollment Check

SELECT
    1 AS AlreadyEnrolled FROM Enrollment
WHERE SId = 1 AND CId = 2;
GO



--  Get all courses of a student
-- Use it before/after StudentId index comparison.

SELECT E.SId, E.CId, E.EDate, E.EGrade FROM Enrollment E
WHERE E.SId = 1;
GO



--  Composite Index for Students in a Course ordered by Grade DESC


CREATE INDEX IX_Enrollment_CourseId_EGrade
ON Enrollment(CId, EGrade DESC)
INCLUDE(SId);
GO


-- Students in a Course ordered by Grade

SELECT S.SId, S.SName, E.EGrade FROM Enrollment E
INNER JOIN Student S
ON E.SId = S.SId
WHERE E.CId = 1
AND E.EGrade IS NOT NULL
ORDER BY E.EGrade DESC;
GO


-- Performance Analysing

SET STATISTICS IO ON;
SET STATISTICS TIME ON;


SELECT E.SId, E.CId, E.EDate, E.EGrade FROM Enrollment E
WHERE E.SId = 1;

SELECT S.SId, S.SName, E.EGrade FROM Enrollment E
INNER JOIN Student S
ON E.SId = S.SId
WHERE E.CId = 1 AND E.EGrade IS NOT NULL
ORDER BY E.EGrade DESC;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO