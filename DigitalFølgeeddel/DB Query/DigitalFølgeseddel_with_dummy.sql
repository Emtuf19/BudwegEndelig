--IF DB_ID('DigitalFølgeseddel') IS NOT NULL
--CREATE DATABASE DigitalFølgeseddel;
--GO
USE DigitalFølgeseddel;
/*GO

CREATE TABLE Station (
    StationId     INT IDENTITY(1,1) PRIMARY KEY,
    StationName   NVARCHAR(100) NOT NULL UNIQUE,
    --StationOrder  TINYINT NOT NULL
);

CREATE TABLE Employee (
    EmployeeId    INT IDENTITY(1,1) PRIMARY KEY,
    StationId     INT NOT NULL FOREIGN KEY REFERENCES Station(StationId),
    EmployeeName  NVARCHAR(100) NOT NULL
);

CREATE TABLE DeliveryNote (
    DeliveryNoteId INT IDENTITY(1,1) PRIMARY KEY,
    FollowSlipNo   INT NOT NULL UNIQUE,
    --CreatedAt      DATETIME2(0) NULL
);

CREATE TABLE DeliveryNoteStep (
    StepId         INT IDENTITY(1,1) PRIMARY KEY,
    --KOMMENTAR ON DELETE CASCADE gør sådan at, når vi fjerner en følgeseddel, så fjerner den også alle tilhørende steps!
    DeliveryNoteId INT NOT NULL FOREIGN KEY REFERENCES DeliveryNote(DeliveryNoteId) ON DELETE CASCADE,
    --StationId      INT NOT NULL FOREIGN KEY REFERENCES Station(StationId), BLEV FJERNET! IKKE FJERN UDKOMMENTERING!!!!
    EmployeeId     INT NOT NULL FOREIGN KEY REFERENCES Employee(EmployeeId),
    ArrivalTime    DATETIME2(0) NULL,
    FinishTime     DATETIME2(0) NULL,
    AntalStart     INT NOT NULL,
    Tilgang        INT NOT NULL,
    AfgangFrem     INT NOT NULL,
    AfgangTilbage  INT NOT NULL,
    Spild          INT NOT NULL
);
GO
INSERT INTO Station(StationName) VALUES ('Adskillelse');
INSERT INTO Station(StationName) VALUES ('Rengøring');
INSERT INTO Station(StationName) VALUES ('Galvanisering');
INSERT INTO Station(StationName) VALUES ('Renovering');
INSERT INTO Station(StationName) VALUES ('Mærkning');
INSERT INTO Station(StationName) VALUES ('Indgangskontrol');
INSERT INTO Station(StationName) VALUES ('Montage');
INSERT INTO Station(StationName) VALUES ('Slutkontrol');
INSERT INTO Station(StationName) VALUES ('Pakkelinje');

INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Adskillelse_1' FROM Station WHERE StationName='Adskillelse';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Adskillelse_2' FROM Station WHERE StationName='Adskillelse';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Adskillelse_3' FROM Station WHERE StationName='Adskillelse';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Rengøring_1' FROM Station WHERE StationName='Rengøring';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Rengøring_2' FROM Station WHERE StationName='Rengøring';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Rengøring_3' FROM Station WHERE StationName='Rengøring';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Galvanisering_1' FROM Station WHERE StationName='Galvanisering';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Galvanisering_2' FROM Station WHERE StationName='Galvanisering';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Galvanisering_3' FROM Station WHERE StationName='Galvanisering';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Renovering_1' FROM Station WHERE StationName='Renovering';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Renovering_2' FROM Station WHERE StationName='Renovering';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Renovering_3' FROM Station WHERE StationName='Renovering';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Mærkning_1' FROM Station WHERE StationName='Mærkning';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Mærkning_2' FROM Station WHERE StationName='Mærkning';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Mærkning_3' FROM Station WHERE StationName='Mærkning';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Indgangskontrol_1' FROM Station WHERE StationName='Indgangskontrol';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Indgangskontrol_2' FROM Station WHERE StationName='Indgangskontrol';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Indgangskontrol_3' FROM Station WHERE StationName='Indgangskontrol';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Montage_1' FROM Station WHERE StationName='Montage';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Montage_2' FROM Station WHERE StationName='Montage';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Montage_3' FROM Station WHERE StationName='Montage';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Slutkontrol_1' FROM Station WHERE StationName='Slutkontrol';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Slutkontrol_2' FROM Station WHERE StationName='Slutkontrol';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Slutkontrol_3' FROM Station WHERE StationName='Slutkontrol';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Pakkelinje_1' FROM Station WHERE StationName='Pakkelinje';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Pakkelinje_2' FROM Station WHERE StationName='Pakkelinje';
INSERT INTO Employee(StationId, EmployeeName) SELECT StationId, 'Pakkelinje_3' FROM Station WHERE StationName='Pakkelinje';

INSERT INTO DeliveryNote(FollowSlipNo) VALUES (300001);
INSERT INTO DeliveryNote(FollowSlipNo) VALUES (300002);
INSERT INTO DeliveryNote(FollowSlipNo) VALUES (300003);
INSERT INTO DeliveryNote(FollowSlipNo) VALUES (300004);
INSERT INTO DeliveryNote(FollowSlipNo) VALUES (300005);

INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Adskillelse'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Adskillelse' AND e.EmployeeName='Adskillelse_1'),'2025-11-11 08:00:00', '2025-11-11 08:20:00', 50, 50, 50, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Rengøring'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Rengøring' AND e.EmployeeName='Rengøring_1'),'2025-11-11 08:30:00', '2025-11-11 08:50:00', 50, 50, 50, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Galvanisering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Galvanisering' AND e.EmployeeName='Galvanisering_1'),'2025-11-11 09:00:00', '2025-11-11 09:20:00', 50, 50, 49, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Renovering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Renovering' AND e.EmployeeName='Renovering_1'),'2025-11-11 09:30:00', '2025-11-11 09:50:00', 49, 49, 48, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Mærkning'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Mærkning' AND e.EmployeeName='Mærkning_1'),'2025-11-11 10:00:00', '2025-11-11 10:20:00', 49, 49, 49, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Indgangskontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Indgangskontrol' AND e.EmployeeName='Indgangskontrol_1'),'2025-11-11 10:30:00', '2025-11-11 10:50:00', 49, 49, 48, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Montage'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Montage' AND e.EmployeeName='Montage_1'),'2025-11-11 11:00:00', '2025-11-11 11:20:00', 48, 48, 48, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Slutkontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Slutkontrol' AND e.EmployeeName='Slutkontrol_1'),'2025-11-11 11:30:00', '2025-11-11 11:50:00', 48, 48, 47, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300001),(SELECT StationId FROM Station WHERE StationName='Pakkelinje'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Pakkelinje' AND e.EmployeeName='Pakkelinje_1'),'2025-11-11 12:00:00', '2025-11-11 12:20:00', 48, 48, 47, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Adskillelse'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Adskillelse' AND e.EmployeeName='Adskillelse_2'),'2025-11-11 08:15:00', '2025-11-11 08:35:00', 60, 60, 60, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Rengøring'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Rengøring' AND e.EmployeeName='Rengøring_2'),'2025-11-11 08:45:00', '2025-11-11 09:05:00', 60, 60, 60, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Galvanisering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Galvanisering' AND e.EmployeeName='Galvanisering_2'),'2025-11-11 09:15:00', '2025-11-11 09:35:00', 60, 60, 59, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Renovering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Renovering' AND e.EmployeeName='Renovering_2'),'2025-11-11 09:45:00', '2025-11-11 10:05:00', 59, 59, 58, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Mærkning'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Mærkning' AND e.EmployeeName='Mærkning_2'),'2025-11-11 10:15:00', '2025-11-11 10:35:00', 59, 59, 59, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Indgangskontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Indgangskontrol' AND e.EmployeeName='Indgangskontrol_2'),'2025-11-11 10:45:00', '2025-11-11 11:05:00', 59, 59, 58, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Montage'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Montage' AND e.EmployeeName='Montage_2'),'2025-11-11 11:15:00', '2025-11-11 11:35:00', 58, 58, 58, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Slutkontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Slutkontrol' AND e.EmployeeName='Slutkontrol_2'),'2025-11-11 11:45:00', '2025-11-11 12:05:00', 58, 58, 57, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300002),(SELECT StationId FROM Station WHERE StationName='Pakkelinje'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Pakkelinje' AND e.EmployeeName='Pakkelinje_2'),'2025-11-11 12:15:00', '2025-11-11 12:35:00', 58, 58, 57, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Adskillelse'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Adskillelse' AND e.EmployeeName='Adskillelse_3'),'2025-11-11 08:30:00', '2025-11-11 08:50:00', 70, 70, 70, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Rengøring'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Rengøring' AND e.EmployeeName='Rengøring_3'),'2025-11-11 09:00:00', '2025-11-11 09:20:00', 70, 70, 70, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Galvanisering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Galvanisering' AND e.EmployeeName='Galvanisering_3'),'2025-11-11 09:30:00', '2025-11-11 09:50:00', 70, 70, 69, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Renovering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Renovering' AND e.EmployeeName='Renovering_3'),'2025-11-11 10:00:00', '2025-11-11 10:20:00', 69, 69, 68, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Mærkning'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Mærkning' AND e.EmployeeName='Mærkning_3'),'2025-11-11 10:30:00', '2025-11-11 10:50:00', 69, 69, 69, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Indgangskontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Indgangskontrol' AND e.EmployeeName='Indgangskontrol_3'),'2025-11-11 11:00:00', '2025-11-11 11:20:00', 69, 69, 68, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Montage'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Montage' AND e.EmployeeName='Montage_3'),'2025-11-11 11:30:00', '2025-11-11 11:50:00', 68, 68, 68, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Slutkontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Slutkontrol' AND e.EmployeeName='Slutkontrol_3'),'2025-11-11 12:00:00', '2025-11-11 12:20:00', 68, 68, 67, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300003),(SELECT StationId FROM Station WHERE StationName='Pakkelinje'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Pakkelinje' AND e.EmployeeName='Pakkelinje_3'),'2025-11-11 12:30:00', '2025-11-11 12:50:00', 68, 68, 67, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300004),(SELECT StationId FROM Station WHERE StationName='Adskillelse'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Adskillelse' AND e.EmployeeName='Adskillelse_1'),'2025-11-11 08:45:00', '2025-11-11 09:05:00', 80, 80, 80, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300004),(SELECT StationId FROM Station WHERE StationName='Rengøring'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Rengøring' AND e.EmployeeName='Rengøring_1'),'2025-11-11 09:15:00', '2025-11-11 09:35:00', 80, 80, 80, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300004),(SELECT StationId FROM Station WHERE StationName='Galvanisering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Galvanisering' AND e.EmployeeName='Galvanisering_1'),'2025-11-11 09:45:00', '2025-11-11 10:05:00', 80, 80, 79, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300004),(SELECT StationId FROM Station WHERE StationName='Renovering'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Renovering' AND e.EmployeeName='Renovering_1'),'2025-11-11 10:15:00', '2025-11-11 10:35:00', 79, 79, 78, 1, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300004),(SELECT StationId FROM Station WHERE StationName='Mærkning'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Mærkning' AND e.EmployeeName='Mærkning_1'),'2025-11-11 10:45:00', '2025-11-11 11:05:00', 79, 79, 79, 0, 0);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300004),(SELECT StationId FROM Station WHERE StationName='Indgangskontrol'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Indgangskontrol' AND e.EmployeeName='Indgangskontrol_1'),'2025-11-11 11:15:00', NULL, 79, 79, 78, 0, 1);
INSERT INTO DeliveryNoteStep (DeliveryNoteId, EmployeeId, ArrivalTime, FinishTime, AntalStart, Tilgang, AfgangFrem, AfgangTilbage, Spild) VALUES ((SELECT DeliveryNoteId FROM DeliveryNote WHERE FollowSlipNo=300005),(SELECT StationId FROM Station WHERE StationName='Adskillelse'),(SELECT e.EmployeeId FROM Employee e JOIN Station s ON s.StationId=e.StationId WHERE s.StationName='Adskillelse' AND e.EmployeeName='Adskillelse_2'),'2025-11-11 09:00:00', NULL, 90, 90, 90, 0, 0);
GO

--NICE TO HAVE, men er ikke en del af databasen. Det er en midlertidig tabel man kan bruge til at se samlet data
CREATE OR ALTER VIEW dbo.vw_AllSteps AS
SELECT
  dn.FollowSlipNo,
  s.StationName,
  e.EmployeeName,
  dns.ArrivalTime,
  dns.FinishTime,
  dns.AntalStart,
  dns.Tilgang,
  dns.AfgangFrem,
  dns.AfgangTilbage,
  dns.Spild
FROM dbo.DeliveryNoteStep dns
JOIN dbo.DeliveryNote dn ON dn.DeliveryNoteId = dns.DeliveryNoteId
JOIN dbo.Employee     e  ON e.EmployeeId     = dns.EmployeeId
JOIN dbo.Station      s  ON s.StationId      = e.StationId;
GO*/

--DEN BEHØVER I IKKE FJERNE KOMMENTAR PÅ, DA JEG IKKE RIGTIG HAR BRUGT DEN TIL EN SKID!
/*CREATE VIEW vw_LastKnownPosition AS
WITH LastArrival AS (
    SELECT 
        dn.DeliveryNoteId,
        dn.FollowSlipNo,
        dns.StepId,
        dns.StationId,
        dns.EmployeeId,
        dns.ArrivalTime,
        dns.FinishTime,
        ROW_NUMBER() OVER (PARTITION BY dn.DeliveryNoteId ORDER BY dns.ArrivalTime DESC) AS rn
    FROM DeliveryNoteStep dns
    JOIN DeliveryNote dn ON dn.DeliveryNoteId = dns.DeliveryNoteId
)
SELECT 
    la.FollowSlipNo,
    s.StationName AS LastArrivedStation,
    la.ArrivalTime AS LastArrivalTime,
    la.FinishTime AS LastFinishTime,
    e.EmployeeName AS LastEmployee,
    (SELECT COUNT(*) FROM DeliveryNoteStep x WHERE x.DeliveryNoteId=la.DeliveryNoteId AND x.FinishTime IS NOT NULL) AS StepsFinished,
    CASE WHEN (SELECT COUNT(*) FROM DeliveryNoteStep x WHERE x.DeliveryNoteId=la.DeliveryNoteId AND x.FinishTime IS NOT NULL) = 9 THEN 1 ELSE 0 END AS IsCompleted
FROM LastArrival la
JOIN Employee e ON e.EmployeeId=la.EmployeeId
LEFT JOIN Station s ON s.StationId=la.StationId
WHERE la.rn=1;
GO*/


--SELECT * FROM vw_AllSteps;