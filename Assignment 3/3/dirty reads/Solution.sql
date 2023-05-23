USE [Travel Agency DB]
GO

--Solution: set transaction isolation level to read committed
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN

SELECT * FROM Rooms
WAITFOR DELAY '00:00:06'

SELECT* FROM Rooms
COMMIT TRAN