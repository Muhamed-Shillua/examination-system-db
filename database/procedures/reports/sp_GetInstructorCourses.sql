-- ====================================================
-- Procedure: sp_GetInstructorCourses
-- Description: Returns instructor courses with student count
-- ====================================================

CREATE PROCEDURE sp_GetInstructorCourses
(
  @InstructorID INT
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

    -- Return Courses
    SELECT
      I.InstructorID,
      I.Name AS InstructorName,
      C.CourseID,
      C.CourseName,
      COUNT(SC.StudentID) AS StudentCount
    FROM InstructorCourse IC
    INNER JOIN Instructor I
      ON IC.InstructorID = I.InstructorID
    INNER JOIN Course C
      ON IC.CourseID = C.CourseID
    LEFT JOIN StudentCourse SC
      ON C.CourseID = SC.CourseID
    WHERE I.InstructorID = @InstructorID
    GROUP BY
      I.InstructorID,
      I.Name,
      C.CourseID,
      C.CourseName
    ORDER BY C.CourseName;
  END TRY

  BEGIN CATCH
      PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
