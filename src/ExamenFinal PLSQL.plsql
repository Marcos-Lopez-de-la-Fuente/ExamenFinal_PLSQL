CREATE OR REPLACE FUNCTION vacantBeds (codeHospital IN VARCHAR2) RETURN INTEGER IS
    numBeds INTEGER;
BEGIN
    SELECT COUNT(*) INTO numBeds
    FROM Admissions
    WHERE HospitalCode = codeHospital AND Discharge = 'F';
    RETURN numBeds;
END;
/

CREATE OR REPLACE PROCEDURE listNames AS
    CURSOR c1 IS
        SELECT * FROM Hospital;
    c11 c1%ROWTYPE;
    codeHospital VARCHAR2(20);
    numBeds INTEGER;
BEGIN
    OPEN c1;
        FETCH c1 INTO c11;
        numBeds := vacantBeds(c11.Code);
        codeHospital := c11.Code;
    CLOSE c1;
    FOR c11 IN c1 LOOP
        IF vacantBeds(c11.Code) < numBeds THEN
            codeHospital := c11.Code;
            numBeds := vacantBeds(c11.Code);
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Hospital Code  |  Staff Number  |  Name');
    DBMS_OUTPUT.PUT_LINE('===================================');
    FOR staffs IN (
        SELECT *
        FROM Staff
        WHERE HospitalCode = codeHospital
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(staffs.HospitalCode||'  '||staffs.StaffNumber||'  '||staffs.Name);
    END LOOP;
END;
/
EXECUTE listNames;



--===============================================



ALTER TABLE Rooms
    ADD freeBeds INTEGER;

CREATE OR REPLACE PROCEDURE freeBeds AS
    CURSOR c1 IS SELECT * FROM Rooms;
    c11 c1%ROWTYPE;
    numBeds INTEGER;
    bedsNegative EXCEPTION;
BEGIN
    FOR c11 IN c1 LOOP
        SELECT COUNT(*) INTO numBeds
        FROM Admissions
        WHERE HospitalCode = c11.HospitalCode AND RoomCode = c11.RoomCode AND Discharge = 'F';
        BEGIN
            IF numBeds < 0 THEN RAISE bedsNegative;
            ELSE
                UPDATE Rooms
                SET FreeBeds = numBeds
                WHERE HospitalCode = c11.HospitalCode AND RoomCode = c11.RoomCode;
            END IF;
        EXCEPTION
            WHEN bedsNegative THEN
                DBMS_OUTPUT.PUT_LINE('Room '|| c11.RoomCode || ' returns a negative number.');
        END;
    END LOOP;
END;
/
EXECUTE freeBeds;



--===============================================



CREATE TABLE staffHospital (
    NameHospital VARCHAR2(20),
    NameStaff VARCHAR2(20),
    Role VARCHAR2(20),
    PRIMARY KEY (NameHospital, NameStaff)
);

CREATE OR REPLACE PROCEDURE updateStaffHospital(nameHospital IN VARCHAR2) AS
    CURSOR c1 IS SELECT * FROM Doctors;
    c11 c1%ROWTYPE;
    CURSOR c2 IS SELECT* FROM Staff;
    c22 c2%ROWTYPE;
    codeHospital VARCHAR2(20);
    nullNameHospital EXCEPTION;
    multiplesNameHospital EXCEPTION;
    counter NUMBER;
    nullStaff EXCEPTION;
    nullMedic EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO counter FROM Hospital WHERE Name = nameHospital;
    IF counter = 0 THEN RAISE nullNameHospital;
    ELSIF counter > 1 THEN RAISE multiplesNameHospital;
    END IF;
    SELECT Code INTO codeHospital FROM Hospital WHERE Name = nameHospital;
    BEGIN
        SELECT COUNT(*) INTO counter FROM Staff WHERE HospitalCode = codeHospital;
        IF counter = 0 THEN RAISE nullStaff; END IF;
        SELECT COUNT(*) INTO counter FROM Doctors WHERE HospitalCode = codeHospital;
        IF counter = 0 THEN RAISE nullMedic; END IF;
    EXCEPTION
        WHEN nullStaff THEN
            DBMS_OUTPUT.PUT_LINE('This hospital has no workers.');
        WHEN nullMedic THEN
            DBMS_OUTPUT.PUT_LINE('This hospital has no doctors.');
    END;
    FOR c11 IN c1 LOOP
        IF c11.HospitalCode = codeHospital THEN
            INSERT INTO staffHospital VALUES (nameHospital, c11.Name, 'doctor');
        END IF;
    END LOOP;
    FOR c22 IN c2 LOOP
        IF c22.HospitalCode = codeHospital THEN
            INSERT INTO staffHospital VALUES (nameHospital, c22.Name, c22.Role);
        END IF;
    END LOOP;
EXCEPTION
    WHEN nullNameHospital THEN
        DBMS_OUTPUT.PUT_LINE('There is no hospital with that name.');
    WHEN multiplesNameHospital THEN
        DBMS_OUTPUT.PUT_LINE('There is more than 1 Hospital with that name.');
END;
/
EXECUTE updateStaffHospital('Son Llatzer');

