--------------------------
-- Procedure: sp_AddChoice
-- Description: Adds a choice to a question
---------------------------------------------
CREATE PROCEDURE sp_AddChoice
(
  @QuestionID INT,
  @ChoiceText NVARCHAR(255),
  @IsCorrect BIT = 0
)
AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT EXISTS
    (
      SELECT 1
      FROM Question
      WHERE QuestionID = @QuestionID
    )
    BEGIN
      RAISERROR('Question does not exist.', 16, 1);
      RETURN;
    END;

    IF @IsCorrect = 1
      AND EXISTS
      (
        SELECT 1
        FROM Choice
        WHERE QuestionID = @QuestionID
          AND IsCorrect = 1
      )
    BEGIN
      RAISERROR('A correct choice already exists for this question.', 16, 1);
      RETURN;
    END;

    -- Insert Choice
    INSERT INTO Choice
    (
      QuestionID,
      ChoiceText,
      IsCorrect
    )
    VALUES
    (
      @QuestionID,
      @ChoiceText,
      @IsCorrect
    );

    PRINT 'Choice added successfully.';
  END TRY

  BEGIN CATCH
    PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
