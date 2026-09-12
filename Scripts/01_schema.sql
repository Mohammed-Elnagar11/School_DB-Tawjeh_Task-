CREATE DATABASE School_DB

USE School_DB

CREATE TABLE Department
(
    DId INT IDENTITY(1,1) PRIMARY KEY,
    DName VARCHAR(100) NOT NULL,
    DLeadTId INT NULL,

    CONSTRAINT UQ_Dept_DName
        UNIQUE (DName)
)


CREATE TABLE Teacher
(
    TId INT IDENTITY(1,1) PRIMARY KEY,
    TName VARCHAR(100) NOT NULL,
    TAddress VARCHAR(200),
    TSalary DECIMAL(10,2),
    SuperTId INT NULL,
    DId INT NOT NULL,

    CONSTRAINT FK_Teacher_Dept
        FOREIGN KEY (DId)
        REFERENCES Department(DId)
        ON DELETE NO ACTION,

    CONSTRAINT FK_Teacher_Super
        FOREIGN KEY (SuperTId)
        REFERENCES Teacher(TId)
        ON DELETE SET NULL,

    CONSTRAINT CK_Teacher_NoSelfSupervisor
        CHECK (SuperTId IS NULL OR (SuperTId <> TId))
)


ALTER TABLE Department
ADD CONSTRAINT FK_Dept_LeadTeacher
    FOREIGN KEY (DLeadTId)
    REFERENCES Teacher(TId)
     ON DELETE NO ACTION


CREATE TABLE Student
(
    SId INT IDENTITY(1,1) PRIMARY KEY,
    SLevel INT,
    SAddress VARCHAR(200),
    SName VARCHAR(100) NOT NULL,
    DId INT NOT NULL,

    CONSTRAINT FK_Student_Department
        FOREIGN KEY (DId)
        REFERENCES Department(DId)
        ON DELETE NO ACTION
)


CREATE TABLE Course
(
    CId INT IDENTITY(1,1) PRIMARY KEY,
    CName VARCHAR(100) NOT NULL,
    CDuration INT,
    CDescription VARCHAR(500),
    CDId INT NOT NULL,
    CTId INT NOT NULL,

    CONSTRAINT FK_Course_Department
        FOREIGN KEY (CDId)
        REFERENCES Department(DId)
         ON DELETE NO ACTION,

    CONSTRAINT FK_Course_Teacher
        FOREIGN KEY (CTId)
        REFERENCES Teacher(TId)
         ON DELETE NO ACTION
)


CREATE TABLE Enrollment
(
    SId INT NOT NULL,
    CId INT NOT NULL,
    EDate DATE NOT NULL,
    EGrade DECIMAL(5,2) NULL,

    CONSTRAINT PK_Enrollment
        PRIMARY KEY (SId, CId),

    CONSTRAINT FK_Enrollment_Student
        FOREIGN KEY (SId)
        REFERENCES Student(SId)
        ON DELETE CASCADE,

    CONSTRAINT FK_Enrollment_Course
        FOREIGN KEY (CId)
        REFERENCES Course(CId)
        ON DELETE CASCADE,

    CONSTRAINT CK_Enrollment_Grade
        CHECK (EGrade IS NULL OR EGrade BETWEEN 0 AND 100),

    CONSTRAINT CK_Enrollment_Date
        CHECK (EDate <= CAST(GETDATE() AS DATE))
)