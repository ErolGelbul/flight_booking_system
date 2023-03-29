USE FBS
--procedure 1
Go
CREATE PROCEDURE Flight_Availability
@Departure_Date  date,
@Arrival_Date date,
@available char(1) OUTPUT

AS
IF EXISTS(SELECT Flight_ID FROM Flight_Details
 WHERE CONVERT(Date,Departure_Date_time) = @Departure_Date
    AND CONVERT(Date,Arrival_Date_time) = @Arrival_Date 
)

BEGIN
    SET @available='Y'    
    SELECT * FROM Flight_Details
 WHERE CONVERT(Date,Departure_Date_time) = @Departure_Date
    AND CONVERT(Date,Arrival_Date_time) = @Arrival_Date
 
END
ELSE
BEGIN

Print 'Flight Detail Doesnt exist'
end








--PROCEDURE 2

Go
CREATE PROCEDURE [dbo].[UpdateFlightDetails] 
@flag bit output,-- return 0 for fail,1 for success
@FlightID INT,
@DeptDateTime DATETIME,
@ArivalDateTime DATETIME,
@AirplaneType VARCHAR(100)
AS
BEGIN
 Update Flight_Details set Departure_Date_Time = @DeptDateTime,
                           Arrival_Date_time = @ArivalDateTime,
                           Airplane_Type = @AirplaneType
 Where Flight_ID = @FlightID 
 set @flag=1;
 
END



 --Procedure 3

 Go
 CREATE PROCEDURE [dbo].[PassengerCRUD] 
                    @Action VARCHAR(10), 
                    @Passenger_ID int = NULL, 
                    @FName VARCHAR(100) = NULL, 
                    @LName VARCHAR(100) = NULL, 
                    @Email VARCHAR(100) = NULL,
                    @PNumber BIGINT = NULL, 
                    @Address VARCHAR(100) = NULL,
                    @city VARCHAR(100) = NULL,  
                    @State VARCHAR(100) = NULL, 
                    @Zipcode VARCHAR(100) = NULL, 
                    @Country VARCHAR(100) = NULL

AS
BEGIN
      SET NOCOUNT ON;
 
      --SELECT
      IF @Action = 'SELECT'
      BEGIN
            SELECT Passenger_ID, P_FirstName,P_LastName,P_Email,P_PhoneNumber,P_Address,P_City,
                              P_State,P_Zipcode,P_Country
            FROM Passenger
      END
 
      --INSERT
      IF @Action = 'INSERT'
      BEGIN
 INSERT INTO dbo.Passenger([Passenger_ID], [P_FirstName],[P_LastName],[P_Email],[P_PhoneNumber],[P_Address],[P_City],
                              [P_State],[P_Zipcode],[P_Country] )

 VALUES (@Passenger_ID, @FName, @LName, @Email, @PNumber, @Address, @city, @State, @Zipcode, @Country)
      END
 
      --UPDATE
      IF @Action = 'UPDATE'
      BEGIN
            UPDATE Passenger
            SET Passenger_ID = @Passenger_ID, P_FirstName = @FName, P_LastName = @LName, P_Email= @Email, P_PhoneNumber = @PNumber, 
                P_Address = @Address, P_City = @city, P_State = @State, P_Zipcode =  @Zipcode, P_Country = @Country
            WHERE Passenger_ID = @Passenger_ID
      END
 
      --DELETE
      IF @Action = 'DELETE'
      BEGIN
            DELETE FROM Passenger
            WHERE Passenger_ID = @Passenger_ID
      END
END



--Procedure 4
GO
CREATE PROCEDURE UpdatePayment 
       @paymentID INT,@paid_date date OUTPUT
AS
  BEGIN
  Update Payment_Status
  SET Payment_Status_YN='Y' WHERE Payment_ID=@paymentID
  SELECT @paid_date=GETDATE()
   
END
