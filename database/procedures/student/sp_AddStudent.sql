---------------------------
-- Procedure: sp_AddStudent
-- Description: Adds a new student to the system
------------------------------------------------

CREATE PROCEDURE sp_AddStudent
(
    @Name NVARCHAR(100),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(20) = NULL,
    @Address NVARCHAR(200) = NULL,
    @Gender CHAR(1),
    @BirthDate DATE = NULL,
    @DepartmentID INT
) AS
BEGIN
  SET NOCOUNT ON;

  BEGIN TRY
      IF @Gender NOT IN ('M', 'F')
      BEGIN
          RAISERROR('Invalid gender value.', 16, 1);
          RETURN;
      END;

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

      IF EXISTS
      (
          SELECT 1
          FROM Student
          WHERE Email = @Email
      )
      BEGIN
          RAISERROR('Email already exists.', 16, 1);
          RETURN;
      END;

      INSERT INTO Student
      (
          Name,
          Email,
          Phone,
          Address,
          Gender,
          BirthDate,
          DepartmentID
      )
      VALUES
      (
          @Name,
          @Email,
          @Phone,
          @Address,
          @Gender,
          @BirthDate,
          @DepartmentID
      );

      PRINT 'Student added successfully.';
  END TRY

  BEGIN CATCH
      PRINT ERROR_MESSAGE();
  END CATCH
END;
GO
