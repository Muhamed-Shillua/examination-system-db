----------------------------
-- Procedure: sp_AddQuestion
-- Description: Adds a question to an exam
---------------------------------------------
CREATE PROCEDURE sp_AddQuestion
(
    @ExamID INT,
    @QuestionText NVARCHAR(MAX),
    @Mark INT
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

    IF @Mark <= 0
    BEGIN
      RAISERROR('Question mark must be greater than zero.', 16, 1);
      RETURN;
    END;

    -- Insert Question
    INSERT INTO Question
    (
      ExamID,
      QuestionText,
      Mark
    )
    VALUES
    (
      @ExamID,
      @QuestionText,
      @Mark
    );

    PRINT 'Question added successfully.';
  END TRY

  BEGIN CATCH
    PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
