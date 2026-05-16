---------------------------------
-- Procedure: sp_GetStudentGrades
-- Description: Returns student grades in all exams
----------------------------------------------------
CREATE PROCEDURE sp_GetStudentGrades
(
  @StudentID INT
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

    -- Return Grades
    SELECT
      S.StudentID,
      S.Name AS StudentName,
      C.CourseName,
      E.ExamID,
      G.Score
    FROM Grade G
    INNER JOIN Student S
      ON G.StudentID = S.StudentID
    INNER JOIN Exam E
      ON G.ExamID = E.ExamID
    INNER JOIN Course C
      ON E.CourseID = C.CourseID
    WHERE S.StudentID = @StudentID
    ORDER BY C.CourseName;
  END TRY

  BEGIN CATCH
      PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
