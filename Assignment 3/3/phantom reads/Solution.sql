USE [Travel Agency DB]
GO

--solution: set transaction isolation level to serializable
SET TRAN ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN
SELECT * FROM Rooms
WAITFOR DELAY '00:00:06'
SELECT * FROM Rooms
COMMIT TRAN

--DELETE FROM Rooms WHERE id_room =8