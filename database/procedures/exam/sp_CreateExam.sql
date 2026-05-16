---------------------------
-- Procedure: sp_CreateExam
-- Description: Creates a new exam for a course
-----------------------------------------------------

CREATE PROCEDURE sp_CreateExam
(
  @CourseID INT,
  @ExamDate DATETIME,
  @TotalMarks INT
) AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
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

    IF @TotalMarks <= 0
    BEGIN
      RAISERROR('Total marks must be greater than zero.', 16, 1);
      RETURN;
    END;

    -- Create Exam
    INSERT INTO Exam
    (
      CourseID,
      ExamDate,
      TotalMarks
    )
    VALUES
    (
      @CourseID,
      @ExamDate,
      @TotalMarks
    );

    PRINT 'Exam created successfully.';
  END TRY

  BEGIN CATCH
    PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
