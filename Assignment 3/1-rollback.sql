-- Hotel, Rooms, TypeOfRoom
USE [Travel Agency DB]
GO

DROP TABLE IF EXISTS LogTable
CREATE TABLE LogTable(
	Lid INT IDENTITY PRIMARY KEY,
	TypeOperation VARCHAR(50),
	TableOperation VARCHAR(50),
	ExecutionDate DATETIME
);


GO


--use m:n relation Hotel - Rooms

CREATE OR ALTER FUNCTION ufValidateBigString (@s VARCHAR(100))
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return =1
	IF(@s IS NULL OR LEN(@s) <2 OR LEN(@s)>100)
	BEGIN
		SET @return=0
	END
	RETURN @return
END
GO

CREATE OR ALTER FUNCTION ufValidateSmallString (@s VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return =1
	IF(@s IS NULL OR LEN(@s) <2 OR LEN(@s)>50)
	BEGIN
		SET @return=0
	END
	RETURN @return
END
GO


CREATE OR ALTER FUNCTION ufValidateInteger(@int INT)
RETURNS INT
AS
BEGIN
	DECLARE @return INT
	SET @return=1
	IF(@int <0)
	BEGIN
		SET @return=0
	END
	RETURN @return 
END
GO



CREATE OR ALTER PROCEDURE uspAddHotel(@price INT, @stars INT, @hName VARCHAR(100))
AS
	SET NOCOUNT ON
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


	/*IF EXISTS(SELECT * FROM Hotel H WHERE H.id_hotel=@id)
	BEGIN
		RAISERROR('Hotel already exists', 14, 1)
	END
	IF NOT EXISTS(SELECT * FROM City WHERE City.id_city=@hcityId)
	BEGIN
		RAISERROR('City with that id does not exist', 14, 1)
	END*/
	INSERT INTO Hotel VALUES(@maxId, @price, @stars, @hName, @cityId)
	INSERT INTO LogTable VALUES('add', 'hotel', GETDATE())
GO


CREATE OR ALTER PROCEDURE uspAddRooms(@nameR VARCHAR(50))
AS
	SET NOCOUNT ON
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
GO

/*
CREATE OR ALTER PROCEDURE uspAddTypeOfRoom(@hId INT, @rId INT)
AS
	SET NOCOUNT ON
	DECLARE @maxId INT
	SET @maxId =1
	SELECT TOP 1 @maxId=id_hotel+1 FROM Hotel ORDER BY id_hotel DESC


	IF EXISTS (SELECT * FROM TypeOfRoom T WHERE T.id_hotel=@hId AND T.id_room=@rId)
	BEGIN
		RAISERROR('Type of room already exists', 14, 1)
	END
	INSERT INTO TypeOfRoom VALUES (@hId, @rId)
	INSERT INTO LogTable VALUES('add', 'typeofroom', GETDATE())
GO*/


CREATE OR ALTER PROCEDURE uspAddTypeOfRoom(@hotelName VARCHAR(100), @roomName VARCHAR(50))
AS
	SET NOCOUNT ON
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

GO



CREATE OR ALTER PROCEDURE uspAddCommitScenario
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC uspAddHotel 170, 3, 'Hotel2'
		EXEC uspAddRooms 'L'
		EXEC uspAddTypeOfRoom 'Hotel2', 'Duplex'
		COMMIT TRAN
		SELECT 'Transaction commited'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		INSERT INTO LogTable VALUES ('addLogTable', 'rolledback all data', GETDATE())
		RETURN
	END CATCH
GO

CREATE OR ALTER PROCEDURE uspAddRollbackScenario
AS
	BEGIN TRAN
	BEGIN TRY
		EXEC uspAddHotel 20, 3, 'Hotel3'
		EXEC uspAddRooms '' --this fails due to validation, there already is a room with that id, so everything fails
		EXEC uspAddTypeOfRoom 'Hotel3', 'Triple'
		COMMIT TRAN
		SELECT 'Transaction commited'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		INSERT INTO LogTable VALUES ('addLogTable', 'rolledback all data', GETDATE())
		RETURN
	END CATCH
GO


EXEC uspAddCommitScenario
EXEC uspAddRollbackScenario

SELECT * FROM LogTable

SELECT * FROM Hotel
SELECT * FROM Rooms
SELECT * FROM TypeOfRoom

DELETE FROM Hotel WHERE id_hotel=5
DELETE FROM TypeOfRoom WHERE id_hotel=3
DELETE FROM Rooms WHERE id_room=7