USE [Travel Agency DB]
GO

--part 1
BEGIN TRAN
--exclusive lock on table Rooms
UPDATE Rooms SET name_room='RoomTransaction1' WHERE id_room=8
WAITFOR DELAY '00:00:10'

--this transaction will be blocked, because T2 already has an exclusive lock on Hotel
UPDATE Hotel SET hotel_name='HotelTarnsaction1' WHERE id_hotel=1
COMMIT TRAN

