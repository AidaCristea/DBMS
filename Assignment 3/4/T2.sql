USE [Travel Agency DB]
GO


--update conflict
SET TRAN ISOLATION LEVEL SNAPSHOT
BEGIN TRAN

WAITFOR DELAY '00:00:05'

--T1 has now updated and obtained a lock in this table
--trying to update the same row will result in a error ( proccess is blocked)
UPDATE Rooms SET name_room='Room9New2' WHERE id_room=9
COMMIT TRAN
