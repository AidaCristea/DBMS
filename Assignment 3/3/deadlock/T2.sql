USE [Travel Agency DB]
GO

--SELECT * FROM Hotel
--SELECT * FROM Rooms


BEGIN TRAN
--exclusive lock on Hotel
UPDATE Hotel SET hotel_name='HotelTransaction2' WHERE id_hotel=1
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T1 already has an exclusive lock on Rooms
UPDATE Rooms SET name_room='RoomTransaction2' WHERE id_room=8

COMMIT TRAN

--this transaction will be chosen as the deadlock victim
-- and it will terminate with an error
--the tables will containt the values from T1
