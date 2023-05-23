USE [Travel Agency DB]
GO

--solution: set transactionisolation level to repeatable read
SET TRAN ISOLATION LEVEL REPEATABLE READ
BEGIN TRAN
--see first insert
SELECT * FROM Rooms
WAITFOR DELAY '00:00:06'
SELECT * FROM Rooms
COMMIT TRAN


--DELETE FROM Rooms WHERE id_room =8
