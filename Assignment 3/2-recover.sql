USE [Travel Agency DB]
GO

CREATE OR ALTER PROCEDURE uspAddHotelRecover(@price INT, @stars INT, @hName VARCHAR(100))
AS
	SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
		DECLARE @maxId INT
		SET @maxId =1
		SELECT TOP 1 @maxId=id_hotel+1 FROM Hotel ORDER BY id_hotel DESC


		IF(dbo.ufValidateBigString(@hName) <>1)
		BEGIN
			RAISERROR('Hotel name is invalid', 14, 1)
		END
		IF(dbo.ufValidateInteger(@price) <>1)
		BEGIN
			RAISERROR('Price is invalid', 14,1)
		END
		IF(dbo.ufValidateInteger(@stars)<>1)
		BEGIN
			RAISERROR('Stars is invalid', 14, 1)
		END
		DECLARE @cityId INT
		SET @cityId=1
		SELECT TOP 1 @cityId=id_city FROM City ORDER BY RAND()
		INSERT INTO Hotel VALUES(@maxId, @price, @stars, @hName, @cityId)
		INSERT INTO LogTable VALUES('add', 'hotel', GETDATE())
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddRoomsRecover(@nameR VARCHAR(50))
AS
	SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
		DECLARE @maxId INT
		SET @maxId =1
		SELECT TOP 1 @maxId=id_room+1 FROM Rooms ORDER BY id_room DESC


		IF(dbo.ufValidateSmallString(@nameR) <>1)
		BEGIN
			RAISERROR('Room name is invalid', 14, 1)
		END
		/*IF EXISTS (SELECT * FROM Rooms R WHERE R.id_room=@id)
		BEGIN
			RAISERROR('Room already exists', 14, 1)
		END*/
		INSERT INTO Rooms VALUES (@maxId, @nameR)
		INSERT INTO LogTable VALUES('add', 'rooms', GETDATE())
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddTypeOfRoomRecover(@hotelName VARCHAR(100), @roomName VARCHAR(50))
AS
	SET NOCOUNT ON
	BEGIN TRAN
	BEGIN TRY
		IF(dbo.ufValidateBigString(@hotelName) <>1)
		BEGIN
			RAISERROR('Hotel name is invalid', 14, 1)
		END
	
		IF(dbo.ufValidateSmallString(@roomName) <>1)
		BEGIN
			RAISERROR('Room name is invalid', 14, 1)
		END

		DECLARE @hotelId INT
		SET @hotelId= (SELECT id_hotel FROM Hotel WHERE hotel_name=@hotelName)
		DECLARE @roomId INT
		SET @roomId=(SELECT id_room FROM Rooms WHERE name_room=@roomName)
		IF(@hotelId IS NULL)
		BEGIN
			RAISERROR('No hotel with the given name', 14, 1)
		END

		IF(@roomId IS NULL)
		BEGIN
			RAISERROR('No room with the given name', 14, 1)
		END
		INSERT INTO TypeOfRoom VALUES(@hotelId, @roomId)
		INSERT INTO LogTable VALUES('add', 'typeofroom', GETDATE())

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
GO


CREATE OR ALTER PROCEDURE uspGoodAddScenario
AS
	EXEC uspAddHotelRecover 100, 2, 'Hotel3'
	EXEC uspAddRoomsRecover 'Six'
	EXEC uspAddTypeOfRoomRecover 'Hotel3', 'Six'
GO

CREATE OR ALTER PROCEDURE uspBadAddScenario
AS
	EXEC uspAddHotelRecover 40, 3, 'Hotel4'
	EXEC uspAddRoomsRecover 'S'
	EXEC uspAddTypeOfRoomRecover 'Hotel4', 'Triple'
GO

EXEC uspBadAddScenario
SELECT * FROM LogTable

EXEC uspGoodAddScenario
SELECT * FROM LogTable

SELECT * FROM Hotel
SELECT * FROM Rooms
SELECT * FROM TypeOfRoom