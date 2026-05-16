-------------------------------------
-- Procedure: sp_GetStudentExamAnswers
-- Description: Returns student answers for an exam
----------------------------------------------------
CREATE PROCEDURE sp_GetStudentExamAnswers
(
  @ExamID INT,
  @StudentID INT
) AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT EXISTS
    (
      SELECT 1
      FROM Exam
      WHERE ExamID = @ExamID
    )
    BEGIN
      RAISERROR('Exam does not exist.', 16, 1);
      RETURN;
    END;

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

    -- Return Student Answers
    SELECT
      S.StudentID,
      S.Name AS StudentName,
      E.ExamID,
      Q.QuestionID,
      Q.QuestionText,
      C.ChoiceText AS StudentAnswer
    FROM StudentAnswer SA
    INNER JOIN Student S
      ON SA.StudentID = S.StudentID
    INNER JOIN Question Q
      ON SA.QuestionID = Q.QuestionID
    INNER JOIN Choice C
      ON SA.SelectedChoiceID = C.ChoiceID
    INNER JOIN Exam E
      ON Q.ExamID = E.ExamID
    WHERE E.ExamID = @ExamID
      AND S.StudentID = @StudentID
    ORDER BY Q.QuestionID;
  END TRY

  BEGIN CATCH
      PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
