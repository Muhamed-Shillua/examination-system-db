-- ====================================================
-- Procedure: sp_GetCourseTopics
-- Description: Returns topics for a specific course
-- ====================================================

CREATE PROCEDURE sp_GetCourseTopics
(
  @CourseID INT
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

    -- Return Topics
    SELECT
      C.CourseName,
      CT.TopicID,
      CT.TopicName
    FROM CourseTopic CT
    INNER JOIN Course C
      ON CT.CourseID = C.CourseID
    WHERE C.CourseID = @CourseID
    ORDER BY CT.TopicName;
  END TRY

  BEGIN CATCH
    PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
