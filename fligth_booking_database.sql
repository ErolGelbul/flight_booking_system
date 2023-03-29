go
Create Database FBS;
go
USE FBS
--Create Airport table
CREATE TABLE Airport
(
Airport_ID int not null,
AirportName varchar(100),
AirportCity varchar(100),
AirportCountry varchar(100),
CONSTRAINT Airport_PK PRIMARY KEY (Airport_ID)
);


-- create Passenger table 
-- new changes
create table Passenger 
(
Passenger_ID INT not null,
P_FirstName VARCHAR(100),
P_LastName VARCHAR(100),
P_Email VARCHAR(100) CONSTRAINT email_check CHECK (P_Email LIKE '[a-z,0-9,_,-]%@[a-z]%.[a-z][a-z]%'),
P_PhoneNumber BIGINT not null UNIQUE CONSTRAINT Ph_length_check CHECK  (len([P_PhoneNumber])=10),
P_Address VARCHAR(100),
P_City VARCHAR(100),
P_State VARCHAR(100),
P_Zipcode VARCHAR(100) CONSTRAINT zip_chk CHECK (LEN(P_Zipcode)=5),
P_Country VARCHAR(100)
CONSTRAINT Passenger_ID_PK PRIMARY KEY (Passenger_ID)
);

-- create Travel class
CREATE TABLE Travel_Class
(
 Travel_Class_ID INT NOT NULL,
 Travel_Class_Name VARCHAR(100) CONSTRAINT name_list_chk CHECK (Travel_Class_Name IN('First Class','Business Class','Premium Economy','Economy Class','Basic Economy')),
 Travel_Class_Capacity BIGINT,
 CONSTRAINT Travel_Class_PK PRIMARY KEY (Travel_Class_ID)
);

-- create Calendar table
CREATE TABLE Calendar
(
 Day_Date Date NOT NULL,
 Business_Day_YN CHAR(1) Constraint check_character_Business_Day_YN Check(Business_Day_YN In ('Y','N')),
 CONSTRAINT Calendar_PK PRIMARY KEY (Day_Date)
);

-- create Flight Service table
create table Flight_Service
(
Service_ID INT not null,
[Service_Name] VARCHAR(100) CONSTRAINT Service_chk CHECK([Service_Name] in ('Food','French Wine','Wifi','Entertainment','Lounge')),
CONSTRAINT Flight_Service_PK PRIMARY KEY (Service_ID)
);

--ALTER TABLE Flight_Service ALTER [Service_Name] CONSTRAINT Service_chk CHECK([Service_Name] in ('Food','French Wine','Wifi','Entertainment','Lounge'));
-- create Flight Details table
CREATE TABLE Flight_Details (
 Flight_ID INT NOT NULL,
 Source_Airport_ID INT NOT NULL,
 Destination_Airport_ID INT NOT NULL ,
 Departure_Date_Time DateTime,-- CONSTRAINT date_check CHECK (Departure_Date_Time< Arrival_Date_Time),
 Arrival_Date_time DateTime,
 Airplane_Type VARCHAR(100) CONSTRAINT airplane_check CHECK(Airplane_Type IN ('Airbus A380','Boeing 747')),
 CONSTRAINT Flight_Details_PK PRIMARY KEY (Flight_ID),
 CONSTRAINT Flight_Details_Source_FK1 FOREIGN KEY (Source_Airport_ID) REFERENCES Airport(Airport_ID),
 CONSTRAINT Flight_Details_Destination_FK2 FOREIGN KEY (Destination_Airport_ID) REFERENCES Airport(Airport_ID),
 CONSTRAINT Date_check_FD CHECK (Departure_Date_Time< Arrival_Date_Time),
 CONSTRAINT airport_chk CHECK (Source_Airport_ID != Destination_Airport_ID)
 );

 -- create Seat Details table
 CREATE TABLE Seat_Details
(
 Seat_ID VARCHAR(100) NOT NULL,
 Travel_Class_ID INT NOT NULL, 
 Flight_ID INT NOT NULL,
 CONSTRAINT Seat_Details_PK PRIMARY KEY (Seat_ID),
 CONSTRAINT Seat_Details_TravelClassID_FK1 FOREIGN KEY (Travel_Class_ID) REFERENCES Travel_Class(Travel_Class_ID),
 CONSTRAINT Seat_Details_FlightID_FK2 FOREIGN KEY (Flight_ID) REFERENCES Flight_Details(Flight_ID)
)

-- create Reservation table 
 CREATE TABLE Reservation (
 Reservation_ID INT NOT NULL,
 Passenger_ID INT NOT NULL,
 Seat_ID VARCHAR(100) NOT NULL,
 --Default Value recorded below
 Date_Of_Reservation Date DEFAULT(getDate()),
 CONSTRAINT Reservation_PK PRIMARY KEY (Reservation_ID),
 CONSTRAINT Reservation_Passenger_ID_FK1 FOREIGN KEY (Passenger_ID) REFERENCES Passenger(Passenger_ID),
 CONSTRAINT Reservation_Seat_ID_FK2 FOREIGN KEY (Seat_ID) REFERENCES Seat_Details(Seat_ID)
 );

 -- create Payment Status table
 --add table again
  CREATE TABLE Payment_Status (
 Payment_ID INT NOT NULL IDENTITY(1,1),
 Payment_Status_YN CHAR(1) Constraint check_character_Payment_Status_YN Check(Payment_Status_YN In ('Y','N')),
 Payment_Due_Date Date,
 Payment_Amount INT,
 Reservation_ID INT NOT NULL,
 CONSTRAINT Payment_Status_PK PRIMARY KEY (Payment_ID),
 CONSTRAINT Payment_Reservation_ID_FK FOREIGN KEY (Reservation_ID) REFERENCES Reservation(Reservation_ID)
 );

--create Flight cost table 
CREATE TABLE Flight_Cost
(   
 Seat_ID VARCHAR(100) NOT NULL,
 Valid_From_Date Date NOT NULL,
 Valid_To_Date Date NOT NULL,
 Cost BIGINT,
 CONSTRAINT Flight_Cost_PK PRIMARY KEY (Seat_ID,Valid_From_Date),
 CONSTRAINT Flight_Cost_Seat_ID_FK1 FOREIGN KEY (Seat_ID) REFERENCES Seat_Details(Seat_ID),
 CONSTRAINT Flight_Cost_Valid_From_Date_FK2 FOREIGN KEY (Valid_From_Date) REFERENCES Calendar(Day_Date),
 CONSTRAINT Flight_Cost_Valid_To_Date_FK3 FOREIGN KEY (Valid_To_Date) REFERENCES Calendar(Day_Date)
);

--create Service offering table 
CREATE TABLE Service_Offering
(
 Travel_Class_ID INT NOT NULL,
 Service_ID  int NOT NULL,
 Offered_YN CHAR(1) Constraint check_character_Offered_YN Check(Offered_YN In ('Y','N')),
 From_Month VARCHAR(20),
 To_Month VARCHAR(20),
 CONSTRAINT Service_Offering_TCI_FK1 FOREIGN KEY (Travel_Class_ID) REFERENCES Travel_Class(Travel_Class_ID),
 CONSTRAINT Service_Offering_SID_FK2 FOREIGN KEY (Service_ID) REFERENCES Flight_Service(Service_ID),
 CONSTRAINT Service_Offering_PK PRIMARY KEY (Travel_Class_ID,Service_ID)
);

--Creating indexes for all primary keys
CREATE UNIQUE INDEX SO_Index ON Service_Offering(Travel_Class_ID,Service_ID);
CREATE UNIQUE INDEX FC_Index ON Flight_Cost(Seat_ID,Valid_From_Date);
CREATE UNIQUE INDEX PS_Index ON Payment_Status(Payment_ID);
CREATE UNIQUE INDEX R_Index ON Reservation(Reservation_ID);
CREATE UNIQUE INDEX SD_Index ON Seat_Details(Seat_ID);
CREATE UNIQUE INDEX FD_Index ON Flight_Details(Flight_ID);
CREATE UNIQUE INDEX FS_Index ON Flight_Service(Service_ID);
CREATE UNIQUE INDEX Cal_Index ON Calendar(Day_Date);
CREATE UNIQUE INDEX T_Index ON Travel_Class(Travel_Class_ID);
CREATE UNIQUE INDEX Pass_Index ON Passenger(Passenger_ID);
CREATE UNIQUE INDEX Air_Index ON Airport(Airport_ID);

--Creating non clustered index
USE P4_FBS
CREATE NONCLUSTERED INDEX email_indx ON Passenger(P_Email);
CREATE NONCLUSTERED INDEX dep_indx ON Flight_Details(Departure_Date_Time);
CREATE NONCLUSTERED INDEX city_indx ON Airport(AirportCity);
go
sp_helpindex Airport
go
sp_helpindex Passenger
go
sp_helpindex Flight_Details