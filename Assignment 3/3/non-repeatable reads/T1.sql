USE [Travel Agency DB]
GO

--part 1
INSERT INTO Rooms VALUES (8, 'EightR')
BEGIN TRAN
WAITFOR DELAY '00:00:04'
UPDATE Rooms
SET name_room='EightRUpdated'
WHERE id_room=8
COMMIT TRAN