---------------------------------------
-- Procedure: sp_GetStudentsByDepartment
-- Description: Returns students by department
------------------------------------------------

CREATE PROCEDURE sp_GetStudentsByDepartment
(
  @DepartmentID INT
) AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
    IF NOT EXISTS
    (
      SELECT 1
      FROM Department
      WHERE DepartmentID = @DepartmentID
    )
    BEGIN
      RAISERROR('Department does not exist.', 16, 1);
      RETURN;
    END;

    -- Return Students
    SELECT
      S.StudentID,
      S.Name,
      S.Email,
      S.Phone,
      S.Gender,
      S.BirthDate,
      D.DepartmentName
    FROM Student S
    INNER JOIN Department D
      ON S.DepartmentID = D.DepartmentID
    WHERE S.DepartmentID = @DepartmentID
    ORDER BY S.Name;
  END TRY

  BEGIN CATCH
      PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
