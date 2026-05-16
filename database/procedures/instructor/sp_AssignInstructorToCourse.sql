-- ====================================================
-- Procedure: sp_AssignInstructorToCourse
-- Description: Assigns an instructor to a course
-- ====================================================

CREATE PROCEDURE sp_AssignInstructorToCourse
(
    @InstructorID INT,
    @CourseID INT,
    @Role NVARCHAR(20) = 'Primary'
) AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT EXISTS
    (
      SELECT 1
      FROM Instructor
      WHERE InstructorID = @InstructorID
    )
    BEGIN
      RAISERROR('Instructor does not exist.', 16, 1);
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

    IF @Role NOT IN ('Primary', 'Assistant')
    BEGIN
      RAISERROR('Invalid instructor role.', 16, 1);
      RETURN;
    END;
    IF EXISTS
    (
      SELECT 1
      FROM InstructorCourse
      WHERE InstructorID = @InstructorID
        AND CourseID = @CourseID
    )
    BEGIN
      RAISERROR('Instructor is already assigned to this course.', 16, 1);
      RETURN;
    END;

    -- Assign Instructor
    INSERT INTO InstructorCourse
    (
      InstructorID,
      CourseID,
      Role
    )
    VALUES
    (
      @InstructorID,
      @CourseID,
      @Role
    );
    PRINT 'Instructor assigned successfully.';
  END TRY
  BEGIN CATCH
      PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
