--------------------------------------
-- Procedure: sp_EnrollStudentInCourse
-- Description: Enrolls a student into a course
------------------------------------------------

CREATE PROCEDURE sp_EnrollStudentInCourse
(
  @StudentID INT,
  @CourseID INT
) AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT EXISTS
    (
      SELECT 1
      FROM Student
      WHERE StudentID = @StudentID
    )
    BEGIN
      RAISERROR('Student does not exist.', 16, 1);
      RETURN;
    END;

    IF NOT EXISTS
    (
      SELECT 1
      FROM Course
      WHERE CourseID = @CourseID
    )
    BEGIN
      RAISERROR('Course does not exist.', 16, 1);
      RETURN;
    END;
    IF EXISTS
    (
      SELECT 1
      FROM StudentCourse
      WHERE StudentID = @StudentID
        AND CourseID = @CourseID
    )
    BEGIN
      RAISERROR('Student is already enrolled in this course.', 16, 1);
      RETURN;
    END;

    -- Enroll Student
    INSERT INTO StudentCourse
    (
      StudentID,
      CourseID
    )
    VALUES
    (
      @StudentID,
      @CourseID
    );

    PRINT 'Student enrolled successfully.';
  END TRY
  BEGIN CATCH
    PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
