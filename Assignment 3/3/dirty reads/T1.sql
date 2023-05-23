USE [Travel Agency DB]
GO

-- first part
BEGIN TRAN
UPDATE Rooms
SET name_room='UpdatedLor'
WHERE id_room=6
WAITFOR DELAY '00:00:06'
ROLLBACK TRAN