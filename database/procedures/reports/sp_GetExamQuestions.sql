---------------------------------
-- Procedure: sp_GetExamQuestions
-- Description: Returns exam questions with choices
----------------------------------------------------

CREATE PROCEDURE sp_GetExamQuestions
(
  @ExamID INT
)
AS
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

    -- Return Questions & Choices
    SELECT
      E.ExamID,
      Q.QuestionID,
      Q.QuestionText,
      C.ChoiceID,
      C.ChoiceText
    FROM Exam E
    INNER JOIN Question Q
      ON E.ExamID = Q.ExamID
    INNER JOIN Choice C
      ON Q.QuestionID = C.QuestionID
    WHERE E.ExamID = @ExamID
    ORDER BY Q.QuestionID, C.ChoiceID;
  END TRY

  BEGIN CATCH
    PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
