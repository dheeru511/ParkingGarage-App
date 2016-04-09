# ParkingGarage-App
App for parking garage owners to manage parking spots



The app assumes that there are 320 physical units present in the parking lot. When the app is launched for the first time it configures 120 regular,20 handicap and 20 motorcycle spots

A table is created in coredata with 320 records with unique unit Nos which represent 320 physical units in the parking lot. When user reconfigures , the app looks for all the unoccupied units in the parking garage and converts parking spots from regular to handicap and so on.

The spot number shown on UI is min of the unit numbers the spot occupies.

 For ex if a handicap spot is created with units 3,4 and 5. The spot number is 3

While reconfiguring , the spot numbers for the unoccupied spots might get changed but the spot numbers for occupied spots remain intact. Because , in realtime if a person comes back to pick car, it will be awkward to know that the spot number has changed now.This is achieved as below

EX:

Say there are only 3 regular spots and 2 motorcycle spots , out of which 1 regular spot(highlighted) is occupied
 
| Unit No | Regular Spot No                             | Motorcycle Spot No                           |
|---------|---------------------------------------------|----------------------------------------------|
| 1       | 1                                           |                                              |
| 2       | 1                                           |                                              |
| 3       | 2                                           |                                              |
| 4       | 2                                           |                                              |
| 5       | 3                                           |                                              |
| 6       | 3                                           |                                              |
| 7       |                                             | 7                                            |
| 8       |                                             | 8                                            |
|         | total spots                               3 | total spots                                2 |


Now if the user reconfigures the spots to 6 motorcycle spots and 1 regular spot , the occupied spot is left undisturbed as below

| Unit No | Regular Spot No                             | Motorcycle Spot No                           |
|---------|---------------------------------------------|----------------------------------------------|
| 1       |                                             | 1                                            |
| 2       |                                             | 2                                            |
| 3       | 2                                           |                                              |
| 4       | 2                                           |                                              |
| 5       |                                             | 5                                            |
| 6       |                                             | 6                                            |
| 7       |                                             | 7                                            |
| 8       |                                             | 8                                            |
|         | total spots                               1 | total spots                                6 |



When user reconfigures, no of spots information should be provided for at least two types, the app calculates the third type and if the combination is not possible , app displays a popup with same message.

For Ex
we are left with 10 units and we have to create handicap spots out of it, one unit (10-3*3=1) remains unused , so the app doesn’t allow it.

when user searches for a spot no by entering unique ID, the app shows the spot no highlighted with red outline. The user can click on the spot and book it using other unique id or free it.


Coding Specifics:

- Instance of model object is created in app delegate and is shared across the app as app delegate is a singleton object

Assumptions:

Drivers license is accepted as unique identifier. As licenses are unique, assumption is no two spots are booked with same license ID
User enters valid values while configuring parking lot from regular to handicap and so on








