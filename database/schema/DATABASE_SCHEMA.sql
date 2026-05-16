-- Create a new database called 'ExaminationSystem'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
  SELECT name
    FROM sys.databases
    WHERE name = N'ExaminationSystem'
)
CREATE DATABASE ExaminationSystem;
GO

USE ExaminationSystem;
GO

-----------------
--- DEPARTMENT
-----------------
CREATE TABLE Department
(
  DepartmentID INT PRIMARY KEY,
  DepartmentName VARCHAR(50) NOT NULL,
  ManagerID INT NULL,

  CONSTRAINT FK_Department_Manager
    FOREIGN KEY (ManagerID) REFERENCES Instructor(InstructorID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);


-----------------
--- STUDENT
-----------------
CREATE TABLE STUDENT
(
  StudentID INT IDENTITY PRIMARY KEY,
  StudentName VARCHAR(50) NOT NULL,
  Email VARCHAR(50) NOT NULL UNIQUE,
  Phone NVARCHAR(15),
  Address NVARCHAR(50),
  Gender CHAR(1),
  BirthDate DATE NULL,
  DepartmentID INT NOT NULL,

  CONSTRAINT CK_Student_Gender CHECK(Gender IN ('M', 'F')),

  CONSTRAINT FK_Student_Department
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
    ON DELETE NO ACTION
    ON UPDATE CASCADE
);


-----------------
--- INSTRUCTOR
-----------------
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    Email NVARCHAR(50) NOT NULL UNIQUE,
    Salary MONEY NOT NULL,
    Degree NVARCHAR(15) NULL,
    DepartmentID INT NOT NULL,

    CONSTRAINT CK_Instructor_Salary CHECK (Salary > 0),

    CONSTRAINT FK_Instructor_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);


-----------------
--- COURSE
-----------------
CREATE TABLE Course (
    CourseID INT IDENTITY PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    DepartmentID INT NOT NULL,

    CONSTRAINT FK_Course_Department
        FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-----------------
--- COURSE TOPIC
-----------------
CREATE TABLE CourseTopic (
    TopicID INT IDENTITY PRIMARY KEY,
    CourseID INT NOT NULL,
    TopicName NVARCHAR(100) NOT NULL,

    CONSTRAINT UQ_Topic UNIQUE (CourseID, TopicName),

    CONSTRAINT FK_CourseTopic_Course
        FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID)
        ON DELETE CASCADE
);

-----------------
--- EXAM
-----------------
CREATE TABLE Exam (
    ExamID INT IDENTITY PRIMARY KEY,
    CourseID INT NOT NULL,
    ExamDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalMarks INT NOT NULL,

    CONSTRAINT CK_Exam_Marks CHECK (TotalMarks > 0),

    CONSTRAINT FK_Exam_Course
        FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID)
        ON DELETE CASCADE
);

-----------------
--- QUESTION
-----------------
CREATE TABLE Question (
    QuestionID INT IDENTITY PRIMARY KEY,
    ExamID INT NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    Mark INT NOT NULL,

    CONSTRAINT CK_Question_Mark CHECK (Mark > 0),

    CONSTRAINT FK_Question_Exam
        FOREIGN KEY (ExamID)
        REFERENCES Exam(ExamID)
        ON DELETE CASCADE
);

-----------------
--- CHOICE
-----------------
CREATE TABLE Choice (
    ChoiceID INT IDENTITY PRIMARY KEY,
    QuestionID INT NOT NULL,
    ChoiceText NVARCHAR(255) NOT NULL,
    IsCorrect BIT NOT NULL DEFAULT 0,

    CONSTRAINT FK_Choice_Question
        FOREIGN KEY (QuestionID)
        REFERENCES Question(QuestionID)
        ON DELETE CASCADE
);

-------------------
--- STUDENT COURSE
-------------------
CREATE TABLE StudentCourse (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT GETDATE(),
    FinalGrade FLOAT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT PK_StudentCourse PRIMARY KEY (StudentID, CourseID),

    CONSTRAINT CK_StudentCourse_Status CHECK (Status IN ('Active','Completed','Dropped')),

    CONSTRAINT FK_StudentCourse_Student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON DELETE CASCADE,

    CONSTRAINT FK_StudentCourse_Course
        FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID)
        ON DELETE CASCADE
);

---------------------
--- INSTRUCTOR COURSE
---------------------
CREATE TABLE InstructorCourse (
    InstructorID INT NOT NULL,
    CourseID INT NOT NULL,
    AssignedDate DATE NOT NULL DEFAULT GETDATE(),
    Role NVARCHAR(20) NOT NULL DEFAULT 'Primary',

    CONSTRAINT PK_InstructorCourse PRIMARY KEY (InstructorID, CourseID),

    CONSTRAINT CK_InstructorCourse_Role CHECK (Role IN ('Primary','Assistant')),

    CONSTRAINT FK_InstructorCourse_Instructor
        FOREIGN KEY (InstructorID)
        REFERENCES Instructor(InstructorID)
        ON DELETE CASCADE,

    CONSTRAINT FK_InstructorCourse_Course
        FOREIGN KEY (CourseID)
        REFERENCES Course(CourseID)
        ON DELETE CASCADE
);

-------------------
--- STUDENT ANSWER
-------------------
CREATE TABLE StudentAnswer (
    StudentID INT NOT NULL,
    QuestionID INT NOT NULL,
    SelectedChoiceID INT NOT NULL,
    AnswerTime DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_StudentAnswer PRIMARY KEY (StudentID, QuestionID),

    CONSTRAINT FK_StudentAnswer_Student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON DELETE CASCADE,

    CONSTRAINT FK_StudentAnswer_Question
        FOREIGN KEY (QuestionID)
        REFERENCES Question(QuestionID)
        ON DELETE CASCADE,

    CONSTRAINT FK_StudentAnswer_Choice
        FOREIGN KEY (SelectedChoiceID)
        REFERENCES Choice(ChoiceID)
);

-----------------
--- GRADE
-----------------
CREATE TABLE Grade (
    StudentID INT NOT NULL,
    ExamID INT NOT NULL,
    Score FLOAT NOT NULL DEFAULT 0,

    CONSTRAINT PK_Grade PRIMARY KEY (StudentID, ExamID),

    CONSTRAINT CK_Grade_Score CHECK (Score BETWEEN 0 AND 100),

    CONSTRAINT FK_Grade_Student
        FOREIGN KEY (StudentID)
        REFERENCES Student(StudentID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Grade_Exam
        FOREIGN KEY (ExamID)
        REFERENCES Exam(ExamID)
        ON DELETE CASCADE
);
