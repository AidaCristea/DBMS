USE [Travel Agency DB]
GO

--part 2; the row is changed while T2 is in progress, so we will see both values for room_name
SET TRAN ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
--see first insert
SELECT * FROM Rooms
WAITFOR DELAY '00:00:06'
SELECT * FROM Rooms
COMMIT TRAN


--DELETE FROM Rooms WHERE id_room =8
