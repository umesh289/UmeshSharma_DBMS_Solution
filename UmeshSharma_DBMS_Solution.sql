create database TravelOnTheGo;

use TravelOnTheGo;

drop table PASSENGER;
drop table PRICE;

create table PASSENGER
(Passenger_name varchar(55),
 Category varchar(55),
 Gender varchar(55),
 Boarding_City varchar(55),
 Destination_City varchar(55),
 Distance int,
 Bus_Type varchar(55)
);

create table PRICE
(
 Bus_Type varchar(55),
 Distance int,
 Price int
 );
 
 insert into PASSENGER values
( "Sejal", "AC", "F", "Bengaluru", "Chennai", 350, "Sleeper"),
("Anmol", "Non-AC", "M", "Mumbai", "Hyderabad", 700, "Sitting"),
("Pallavi", "AC", "F", "Panaji", "Bengaluru", 600, "Sleeper"),
("Khusboo", "AC", "F", "Chennai", "Mumbai", 1500, "Sleeper"),
("Udit", "Non-AC", "M", "Trivandrum", "Panaji", 1000, "Sleeper"),
("Ankur", "AC", "M", "Nagpur", "Hyderabad", 500, "Sitting"),
("Hemant", "Non-AC", "M", "Panaji", "Mumbai", 700, "Sleeper"),
("Manish", "Non-AC", "M", "Hyderabad", "Bengaluru", 500, "Sitting"),
("Piyush", "AC", "M", "Pune", "Nagpur", 700, "Sitting");


 insert into PRICE values
("Sleeper", 350, 770),
("Sleeper", 500, 1100),
("Sleeper", 600, 1320),
("Sleeper", 700, 1540),
("Sleeper", 1000, 2200),
("Sleeper", 1200, 2640),
("Sleeper", 350, 434),
("Sitting", 500, 620),
("Sitting", 500, 620),
("Sitting", 600, 744),
("Sitting", 700, 868),
("Sitting", 1000, 1240),
("Sitting", 1200, 1488),
("Sitting", 1500, 1860);

/*
3) How many females and how many male passengers travelled for a minimum distance of
600 KM s?
*/

select GENDER, COUNT(*) from PASSENGER where distance >= 600 group by GENDER;

/*
4) Find the minimum ticket price for Sleeper Bus.
*/

select min(Price) from PRICE where Bus_Type = "Sleeper";


/*
5) Select passenger names whose names start with character 'S'
*/

select Passenger_Name from PASSENGER where Passenger_name like "S%";

/*
6) Calculate price charged for each passenger displaying Passenger name, Boarding City,
Destination City, Bus_Type, Price in the output
*/

select 
PASSENGER.Passenger_name, 
PASSENGER.Boarding_City, 
PASSENGER.Destination_City,
PASSENGER.Bus_Type,
PRICE.Price from PASSENGER inner join PRICE 
ON
PASSENGER.Distance = PRICE.Distance AND PASSENGER.Bus_Type=PRICE.Bus_Type; 

/*
7) What is the passenger name and his/her ticket price who travelled in Sitting bus for a
distance of 1000 KM s
*/

select 
joined.Passenger_name, joined.Price, joined.Distance, joined.Bus_Type
from  (

select 
PASSENGER.Passenger_name, 
PASSENGER.Boarding_City, 
PASSENGER.Destination_City,
PRICE.Bus_Type,
PRICE.Distance,
PRICE.Price from PASSENGER inner join PRICE 
ON
PASSENGER.Distance = PRICE.Distance AND PASSENGER.Bus_Type=PRICE.Bus_Type) as joined
where joined.Distance = 1000 and joined.Bus_Type="Sitting";



/*
8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to
Panaji?
*/


Select PRICE.Price, PRICE.Bus_Type from PRICE where PRICE.Distance in ( 
select PASSENGER.Distance from PASSENGER
where (PASSENGER.Boarding_City="Bengaluru" 
and PASSENGER.Destination_City="Panaji") or
(PASSENGER.Boarding_City="Panaji" 
and PASSENGER.Destination_City="Bengaluru"));

/*
9) List the distances from the "Passenger" table which are unique (non-repeated
distances) in descending order.
*/

Select t1.Distance from PASSENGER as t1 group by  t1.Distance order by t1.Distance desc;

/*
10) Display the passenger name and percentage of distance travelled by that passenger
from the total distance travelled by all passengers without using user variables
*/

select Passenger_name, Distance, Distance * 100.0 / (select sum(Distance) from PASSENGER) as percentage
from PASSENGER;

/*
11) Display the distance, price in three categories in table Price
a) Expensive if the cost is more than 1000
b) Average Cost if the cost is less than 1000 and greater than 500
c) Cheap otherwise
*/

DELIMITER &&
create procedure proc()
BEGIN
Select t1.Distance, t1.Price,
CASE
    WHEN t1.Price > 1000 THEN "Expensive"
    WHEN t1.Price > 500 and t1.Price < 1000 THEN "Average Cost"
    ELSE "Cheap"
END AS Category
FROM PRICE as t1;
END &&

call proc();