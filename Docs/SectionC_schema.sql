/* =====================================================================
   RaceDay Database Schema
   PROG6212 POE - Section C

   This script creates the full database schema for the RaceDay system,
   matching the 8-entity ERD exactly (Organiser, Venue, Route, Event,
   Category, Participant, Entry, Result). No deliberate deviations from
   the ERD are present in this script.

   Tested to run cleanly on a fresh SQL Server instance from top to
   bottom in SSMS.
   ===================================================================== */

/* ---------------------------------------------------------------------
   0. Fresh database setup
   --------------------------------------------------------------------- */
IF DB_ID('RaceDayDB') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDayDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDayDB;
END
GO

CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

/* ---------------------------------------------------------------------
   1. Tables
   --------------------------------------------------------------------- */

-- Organiser: creates and manages events
CREATE TABLE [Organiser] (
    OrganiserID       INT IDENTITY(1,1) PRIMARY KEY,
    Name              NVARCHAR(100)  NOT NULL,
    Email             NVARCHAR(150)  NOT NULL UNIQUE,
    Phone             NVARCHAR(20)   NULL,
    OrganisationName  NVARCHAR(150)  NULL
);
GO

-- Venue: a physical location that can host events
CREATE TABLE [Venue] (
    VenueID       INT IDENTITY(1,1) PRIMARY KEY,
    VenueName     NVARCHAR(150)   NOT NULL,
    AddressLine   NVARCHAR(200)   NULL,
    City          NVARCHAR(100)   NOT NULL,
    Province      NVARCHAR(100)   NULL,
    Latitude      DECIMAL(9,6)    NOT NULL,
    Longitude     DECIMAL(9,6)    NOT NULL
);
GO

-- Route: a defined course that a Category runs/rides/walks
CREATE TABLE [Route] (
    RouteID            INT IDENTITY(1,1) PRIMARY KEY,
    RouteName          NVARCHAR(150)  NOT NULL,
    Distance           DECIMAL(6,2)   NOT NULL,           -- km
    RouteMapURL        NVARCHAR(255)  NULL,
    ElevationGain      DECIMAL(6,2)   NOT NULL DEFAULT 0,  -- metres
    StartCoordinates   NVARCHAR(100)  NULL,
    FinishCoordinates  NVARCHAR(100)  NULL
);
GO

-- Participant: a user account that enters events
CREATE TABLE [Participant] (
    ParticipantID      INT IDENTITY(1,1) PRIMARY KEY,
    Name               NVARCHAR(100)  NOT NULL,
    Email              NVARCHAR(150)  NOT NULL UNIQUE,
    Phone              NVARCHAR(20)   NULL,
    DateOfBirth        DATE           NOT NULL,
    EmergencyContact   NVARCHAR(100)  NULL
);
GO

-- Event: a race day event, created by an Organiser, held at a Venue
CREATE TABLE [Event] (
    EventID       INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID   INT             NOT NULL,
    VenueID       INT             NOT NULL,
    EventName     NVARCHAR(150)   NOT NULL,
    EventType     NVARCHAR(50)    NOT NULL,
    EventDate     DATE            NOT NULL,
    Description   NVARCHAR(500)   NULL,
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserID) REFERENCES [Organiser](OrganiserID) ON DELETE NO ACTION,
    CONSTRAINT FK_Event_Venue     FOREIGN KEY (VenueID)     REFERENCES [Venue](VenueID)         ON DELETE NO ACTION
);
GO

-- Category: a distance/age/type division within an Event, run over a Route
CREATE TABLE [Category] (
    CategoryID     INT IDENTITY(1,1) PRIMARY KEY,
    EventID        INT             NOT NULL,
    RouteID        INT             NOT NULL,
    CategoryName   NVARCHAR(100)   NOT NULL,
    MinAge         INT             NOT NULL DEFAULT 0,
    EntryFee       DECIMAL(8,2)    NOT NULL DEFAULT 0,
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventID) REFERENCES [Event](EventID) ON DELETE NO ACTION,
    CONSTRAINT FK_Category_Route FOREIGN KEY (RouteID) REFERENCES [Route](RouteID) ON DELETE NO ACTION
);
GO

-- Entry: a Participant's registration into a specific Category
CREATE TABLE [Entry] (
    EntryID         INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID   INT             NOT NULL,
    CategoryID      INT             NOT NULL,
    EntryDate       DATE            NOT NULL DEFAULT GETDATE(),
    PaymentStatus   NVARCHAR(20)    NOT NULL DEFAULT 'Pending',
    RaceNumber      INT             NULL,
    CONSTRAINT FK_Entry_Participant FOREIGN KEY (ParticipantID) REFERENCES [Participant](ParticipantID) ON DELETE NO ACTION,
    CONSTRAINT FK_Entry_Category    FOREIGN KEY (CategoryID)    REFERENCES [Category](CategoryID)      ON DELETE NO ACTION,
    CONSTRAINT UQ_Entry_Participant_Category UNIQUE (ParticipantID, CategoryID),
    CONSTRAINT CHK_Entry_PaymentStatus CHECK (PaymentStatus IN ('Pending', 'Paid', 'Refunded'))
);
GO

-- Result: the recorded outcome for a completed Entry (at most one per Entry)
CREATE TABLE [Result] (
    ResultID     INT IDENTITY(1,1) PRIMARY KEY,
    EntryID      INT             NOT NULL UNIQUE,
    FinishTime   TIME            NULL,
    Position     INT             NULL,
    Status       NVARCHAR(20)    NOT NULL DEFAULT 'Finished',
    CONSTRAINT FK_Result_Entry FOREIGN KEY (EntryID) REFERENCES [Entry](EntryID) ON DELETE CASCADE,
    CONSTRAINT CHK_Result_Status CHECK (Status IN ('Finished', 'DNF', 'DNS'))
);
GO

/* ---------------------------------------------------------------------
   2. Seed Data
   --------------------------------------------------------------------- */

-- Organisers (2)
INSERT INTO [Organiser] (Name, Email, Phone, OrganisationName) VALUES
('John Ndlovu',        'john.ndlovu@raceday.co.za',  '0712345678', 'Comrades Marathon Association'),
('Sarah van der Merwe', 'sarah.vdm@raceday.co.za',    '0823456789', 'Cape Town Cycle Tour Trust');
GO

-- Venues (3)
INSERT INTO [Venue] (VenueName, AddressLine, City, Province, Latitude, Longitude) VALUES
('Scottsville Sports Club', '2 Sutton Park Ave', 'Pietermaritzburg', 'KwaZulu-Natal', -29.600600, 30.379400),
('V&A Waterfront',          'Dock Rd',           'Cape Town',        'Western Cape',  -33.903600, 18.420100),
('FNB Stadium',              'Nasrec Rd',         'Soweto',           'Gauteng',       -26.233800, 27.982900);
GO

-- Routes (4)
INSERT INTO [Route] (RouteName, Distance, RouteMapURL, ElevationGain, StartCoordinates, FinishCoordinates) VALUES
('Comrades Down Run',            87.70, 'https://raceday.co.za/routes/comrades-down',      1200.00, '-29.6006,30.3794', '-29.8587,31.0218'),
('Cape Town Cycle Tour Route',  109.00, 'https://raceday.co.za/routes/ct-cycle-tour',        850.00, '-33.9036,18.4201', '-33.9036,18.4201'),
('Soweto 10km Route',            10.00, 'https://raceday.co.za/routes/soweto-10km',           80.00, '-26.2338,27.9829', '-26.2400,27.9700'),
('Soweto 21km Route',            21.10, 'https://raceday.co.za/routes/soweto-21km',          180.00, '-26.2338,27.9829', '-26.2500,27.9600');
GO

-- Participants (2)
INSERT INTO [Participant] (Name, Email, Phone, DateOfBirth, EmergencyContact) VALUES
('Thabo Mokoena', 'thabo.mokoena@gmail.com', '0731234567', '1995-04-12', 'Nomvula Mokoena - 0739876543'),
('Lisa Botha',     'lisa.botha@gmail.com',    '0839876543', '1998-09-23', 'Pieter Botha - 0821234567');
GO

-- Events (3)
INSERT INTO [Event] (OrganiserID, VenueID, EventName, EventType, EventDate, Description) VALUES
(1, 1, 'Comrades Marathon 2027',     'Marathon',  '2027-06-13', 'The ultimate human race - an ultramarathon between Pietermaritzburg and Durban.'),
(2, 2, 'Cape Town Cycle Tour 2027',  'CycleTour', '2027-03-08', 'The world''s largest timed cycle race, starting and ending near the V&A Waterfront.'),
(1, 3, 'Soweto Marathon 2027',       'Marathon',  '2027-11-07', 'An annual marathon celebrating the history and spirit of Soweto.');
GO

-- Categories (4, covering all 3 events)
INSERT INTO [Category] (EventID, RouteID, CategoryName, MinAge, EntryFee) VALUES
(1, 1, 'Down Run Ultra',       18, 950.00),
(2, 2, '109km Individual',     12, 650.00),
(3, 3, '10km Fun Run',         10, 150.00),
(3, 4, '21km Half Marathon',   16, 300.00);
GO

-- Entries / Enrolments (4 sample enrolments)
INSERT INTO [Entry] (ParticipantID, CategoryID, EntryDate, PaymentStatus, RaceNumber) VALUES
(1, 1, '2027-01-15', 'Paid',    1023),
(2, 2, '2027-01-20', 'Paid',    4521),
(1, 3, '2027-02-01', 'Pending', NULL),
(2, 4, '2027-02-03', 'Paid',    778);
GO

-- Results (sample result for a completed entry)
INSERT INTO [Result] (EntryID, FinishTime, Position, Status) VALUES
(2, '03:45:12', 245, 'Finished');
GO
