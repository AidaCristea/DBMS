USE [Travel Agency DB]
GO

--solution: set deadlock priority to high for the second transaction
--now T1 will be chosen as the deadlock victim, as it has a lower priority
--default priority id normal(0)

SET DEADLOCK_PRIORITY HIGH
BEGIN TRAN
--exclusive lock on Hotel
UPDATE Hotel SET hotel_name='HotelTransaction2' WHERE id_hotel=1
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T1 already has an exclusive lock on Rooms
UPDATE Rooms SET name_room='RoomTransaction2' WHERE id_room=8

COMMIT TRAN