
DROP TABLE Admissions;
DROP TABLE Staff;
DROP TABLE Rooms;
DROP TABLE Doctors;
DROP TABLE Hospital;
DROP TABLE Patients;

--====================================================================================

CREATE TABLE Hospital(
    Code VARCHAR2(20),
    Name VARCHAR2(20),
    Address VARCHAR2(20),
    Phone VARCHAR2(20),
    AmountBeds INTEGER DEFAULT 0,

    PRIMARY KEY (Code)
);

--====================================================================================

CREATE TABLE Doctors(
    HospitalCode VARCHAR2(20),
    DoctorNumber VARCHAR2(20),
    Name VARCHAR2(20),
    Especiality VARCHAR2(20),

    PRIMARY KEY (DoctorNumber, HospitalCode),
    CONSTRAINT Doctors_fk FOREIGN KEY(HospitalCode)
    REFERENCES Hospital(Code)
);

--====================================================================================

CREATE TABLE Patients (
    ID VARCHAR2(20),
    Name VARCHAR2(20),
    Address VARCHAR2(20),
    Sex VARCHAR2(20) NOT NULL,
    Birthday date,

    PRIMARY KEY (ID),
    CONSTRAINT Sex_check CHECK (Sex IN ('M', 'F'))
);

--====================================================================================

CREATE TABLE Rooms(
    RoomCode VARCHAR2(20),
    HospitalCode VARCHAR2(20),
    Name VARCHAR2(20),
    BedsQuantity INTEGER default 0,

    PRIMARY KEY (RoomCode, HospitalCode),
    CONSTRAINT hCode_fk FOREIGN KEY(HospitalCode)
    REFERENCES Hospital(Code)
);

--====================================================================================

CREATE TABLE Staff(
    HospitalCode VARCHAR2(20),
    RoomCode VARCHAR2(20),
    StaffNumber VARCHAR2(20),
    Name VARCHAR2(20),
    Role VARCHAR2(20),
    Shift VARCHAR2(20),
    Salary INTEGER,

    PRIMARY KEY(HospitalCode, RoomCode, StaffNumber),
    CONSTRAINT Roomc_fk FOREIGN KEY(HospitalCode, RoomCode)
    REFERENCES Rooms(HospitalCode, RoomCode),
    CONSTRAINT SHIFT_check CHECK (Shift IN ('M', 'A', 'N'))
);

--====================================================================================

CREATE TABLE Admissions(
    Code VARCHAR2(20),
    RoomCode VARCHAR2(20),
    HospitalCode VARCHAR2(20),
    BedNumber INTEGER,
    Discharge VARCHAR2(20),

    PRIMARY KEY (Code),
    CONSTRAINT Admissions_fk FOREIGN KEY(HospitalCode, RoomCode)
    REFERENCES Rooms(HospitalCode, RoomCode),
    CONSTRAINT Admis_fk FOREIGN KEY(Code)
    REFERENCES Patients(ID),
    CONSTRAINT BooleanCheck CHECK (Discharge in ('T', 'F'))
);

--====================================================================================
--====================================================================================
--====================================================================================
--====================================================================================
--====================================================================================

INSERT INTO Hospital VALUES
('100','Son Llatzer','Ctra. de Manacor','971202000',1500);
INSERT INTO Hospital VALUES
('101','Son Dureta','C/Andrea Doria','971151000',500);
INSERT INTO Hospital VALUES
('102','Son Espases','Ctra. de Valldemossa','971205000',2000);

--====================================================================================

INSERT INTO Doctors VALUES
('100','10','Main Mercy','Cardiologist');
INSERT INTO Doctors VALUES
('100','20','Albert Munoz','Paediatrician');
INSERT INTO Doctors VALUES
('101','11','Javi Gonzales','Psychologist');
INSERT INTO Doctors VALUES
('101','21','Pere Duran','Neurologist');
INSERT INTO Doctors VALUES
('102','12','Leroy Jenkins','Cardiologist');
INSERT INTO Doctors VALUES
('102','22','Genji Hanzo','Surgeon');

--====================================================================================

INSERT INTO Patients VALUES
('847496', 'Lluís Rigo', 'C/Son Gotleu', 'M',TO_DATE('20/10/1994','DD/MM/YYYY'));
INSERT INTO Patients VALUES
('142536', 'Carles Dorst', 'C/Arenal', 'M',TO_DATE('10/05/1980','DD/MM/YYYY'));
INSERT INTO Patients VALUES
('369845', 'Àngela Barceló', 'C/Villa', 'F',TO_DATE('05/08/1995','DD/MM/YYYY'));
INSERT INTO Patients VALUES
('142576', 'Ramon Moreno', 'C/Son Rapinya', 'M',TO_DATE('27/12/2004','DD/MM/YYYY'));
INSERT INTO Patients VALUES
('789685', 'Eva Serra', 'C/Molinar', 'F',TO_DATE('19/11/1990','DD/MM/YYYY'));
INSERT INTO Patients VALUES
('953684', 'Xavier Terra', 'C/Son Banya', 'M',TO_DATE('4/01/2001','DD/MM/YYYY'));

--====================================================================================

INSERT INTO Rooms VALUES
('200','100', 'Suite', 1);
INSERT INTO Rooms VALUES
('300','100', 'Regular', 2);
INSERT INTO Rooms VALUES
('201','101', 'Big', 4);
INSERT INTO Rooms VALUES
('202','101', 'Big', 3);
INSERT INTO Rooms VALUES
('301','102', 'Regular', 2);
INSERT INTO Rooms VALUES
('203','102', 'Big', 5);

--====================================================================================

INSERT INTO Staff VALUES
('100','200','1','Josep Hernan','Security','A',1200);
INSERT INTO Staff VALUES
('100','300','2','Diego Duremens','Receptionist','M',1400);
INSERT INTO Staff VALUES
('100','200','3','Laura Doval','Assistant','N',950);
INSERT INTO Staff VALUES
('101','202','4','Pilar Corró','Nurse','A',1200);
INSERT INTO Staff VALUES
('101','201','5','Mercè Main','Nurse','M',1900);
INSERT INTO Staff VALUES
('101','202','6','Jose Kappa','Assistant', 'N', 1150);
INSERT INTO Staff VALUES
('102','301','7','Julio Julian','Nurse','N',1900);
INSERT INTO Staff VALUES
('102','203','8','Ignasi Terrassa','Nurse','A',1400);
INSERT INTO Staff VALUES
('102','301','9','Manuela Herreros','Security','M',1250);

--====================================================================================

INSERT INTO Admissions VALUES
('847496', '200', '100',1,'F');
INSERT INTO Admissions VALUES
('142536', '200', '100',1,'T');
INSERT INTO Admissions VALUES
('369845', '202', '101',1,'F');
INSERT INTO Admissions VALUES
('142576', '202', '101',2,'F');
INSERT INTO Admissions VALUES
('789685', '301', '102',1,'F');
INSERT INTO Admissions VALUES
('953684', '203', '102',1,'T');