SOURCE path/to/your_file.sql;


create database hospitals;

create table private_hospitals (
sr_no int,
city_name varchar(255),
zone_number int ,
ward_name varchar(255),
ward_number varchar(20),
facility_name varchar(255),
hospital_type varchar(255),
hospital_class varchar(255),
hospital_level varchar(255),
pharmacy_availability varchar(20),
no_of_beds_in_emg_ward varchar(20),
no_of_beds_in_facility_type int,
no_of_drs varchar(20),
no_of_nurses varchar(20),
no_of_midwives_professionals varchar(20),
avg_month_patient_footfall varchar(20),
ambulance_service varchar(20),
count_of_ambulance varchar(20) 
);

create table public_hospitals (
city_name varchar(255),
zone_name varchar(255),
ward_name varchar(255),
zone_number int,
ward_number varchar(20),
facility_name varchar(255),
hospital_type varchar(255),
hospital_class varchar(255),
hospital_level varchar(255),
pharmacy_availability varchar(20),
no_of_beds_in_emg_ward varchar(20),
no_of_beds_in_facility_type int,
no_of_drs varchar(20),
no_of_nurses varchar(20),
no_of_midwives_professionals varchar(20),
avg_month_patient_footfall varchar(20),
ambulance_service varchar(20),
count_of_ambulance varchar(20) 
);

ALTER TABLE private_hospitals DROP COLUMN sr_no;
alter table public_hospitals drop column zone_name;

ALTER TABLE public_hospitals 
MODIFY COLUMN zone_number INT AFTER city_name;

create table all_hospitals as
select
	city_name,
	zone_number,
	ward_name,
	ward_number,
	facility_name,
	hospital_type,
	hospital_class,
	hospital_level,
	pharmacy_availability,
	no_of_beds_in_emg_ward,
	no_of_beds_in_facility_type,
	no_of_drs,
	no_of_nurses,
	no_of_midwives_professionals,
	avg_month_patient_footfall,
	ambulance_service,
	count_of_ambulance
from private_hospitals
union all
select
	city_name,
	zone_number,
    ward_name,
	ward_number,
	facility_name,
	hospital_type,
	hospital_class,
	hospital_level,
	pharmacy_availability,
	no_of_beds_in_emg_ward,
	no_of_beds_in_facility_type,
	no_of_drs,
	no_of_nurses,
	no_of_midwives_professionals,
	avg_month_patient_footfall,
	ambulance_service,
	count_of_ambulance 
from public_hospitals;

UPDATE all_hospitals
SET hospital_type = 
    CASE 
        WHEN hospital_type IN ('optahl', 'optahlm', 'opth.','Opthal','Opthalm','Ophthalmology+Ent','Opthlm','Optholm','Ophthalmologyology','Ophthalmologyologym','Ophthalmologyologymology','Ophthalmologyologymology+Ent','Ophthalmologyologymologym') THEN 'Ophthalmology'
        WHEN hospital_type IN ('CANSER') THEN 'Cancer'
        WHEN hospital_type IN ('cardiologist','CARDIOLOGY') THEN 'Cardiology'
        WHEN hospital_type IN ('sergical') THEN 'Surgical'
        WHEN hospital_type IN ('Specility Both') THEN 'speciality'
        WHEN hospital_type IN ('Dispensary (OPD)','Dispensary (OPD + Immunization Centre)','Dispensary (OPD - Mobile Clinic)') THEN 'Dispensary'
        ELSE hospital_type
    END;

    
    
update all_hospitals
set ambulance_service = 
    case
        when ambulance_service in ('YES') then 'Yes'
        when ambulance_service in ('N.A.') then 'No'
        else ambulance_service
	end;
    

update all_hospitals
set pharmacy_availability =
    case 
        when pharmacy_availability in ('YES') THEN 'Yes'
        when pharmacy_availability in ('N.A.') THEN 'No'
        else pharmacy_availability
    end;
    
set sql_safe_updates = 0;

ALTER TABLE all_hospitals  
DROP COLUMN no_of_beds_in_emg_ward;

ALTER TABLE all_hospitals  
DROP COLUMN no_of_drs;

ALTER TABLE all_hospitals  
DROP COLUMN no_of_nurses;

ALTER TABLE all_hospitals 
DROP COLUMN no_of_midwives_professionals;





# Analysis

# Total Hospitals
select count(*) as Total_Hospitals from all_hospitals;

# Total Public hospitals
select count(hospital_class) as Total_Public_Hospitals
from all_hospitals
where hospital_class = "Public";

# Total Private hospitals
select count(hospital_class) as Total_Private_Hospitals
from all_hospitals
where hospital_class = "private";

# Total hospitals which provide ambulance service
select count(ambulance_service) as Ambulance_Enabled_Hospitals
from all_hospitals
where ambulance_service = "Yes";

# Total hospitals which has pharmacy
select count(pharmacy_availability) as pharmacy_availability
from all_hospitals
where pharmacy_availability = "Yes";

# Top 5 hospitals which has more beds
select facility_name, no_of_beds_in_facility_type
from all_hospitals
order by no_of_beds_in_facility_type desc 
limit 5;

# Top 5 Hospital types
select hospital_type, count(*) as Total_hospitals
from all_hospitals
group by hospital_type
order by count(*) desc
limit 5;

# Total hospitals based on levels
select hospital_level, count(*) as Total_hospitals
from all_hospitals
group by hospital_level;






























