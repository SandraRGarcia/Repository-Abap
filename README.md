# Repository-Abap
Prototype to Beverage delivery program

There was created the executable program ZR_BEST_VEHICLE_FOR_DELIVERY, it's transaction code ZTR_DELIVERY with selection screen with two radiobuttons to be select as per need.
First radiobutton makes available fields to receive Destination and Quantity to be transported.
On execution, once validated the values from the selection screen, the information is passed to a Class ZCL_DELIVERY via method PROCESS.
To calculate the best route, it first saves all 2 point distances, that I call pairs, into a internal table. The distance of the inverse direction is also saved into the internal table. 
Since the distance from one point to another (For example, point A to B) can be different in the inverse direction (from B to A), it first checks whether the inversed direction exists, if not, save using same distance from original direction.
From all pairs, where one of the points is the Destination point, it searchs all other pairs that have the other point  and saves into a second internal table routes with 3 points and distance from Destination to the farest point.
Next it loops the routes and sumarize the distance from the third point to the fourth, fourth to fifth and so on until the current point there is no pair.
After all distances from destination to all other points is saved into the routes internal table, it selects all vehicles with capacity to transport the required amount, identify all routes from all locals that have those vehicles to calculate the score as per formula provided in the especification.
The result is displayed at screen in a ALV report.
Once selected, the second radiobuttons greys out the Destination and Quantity fields and makes available a matchcode that displays a list of all configuration tables to be updated when necessary.
Once selected a table, it's maintenance screen is opened.

# Instructions for tests:
- Call transaction ZTR_DELIVERY
+ To determine which vehicle is the best option to deliver beer, select radiobutton 'Determine best vehicle' and fill in the screen fields informing the destination point and quantity to be transported.
- Press F8.
- The results table will list the vehicle and it's original location. Best option on top.
+ To support the solution, there are a list of configurations that can be accessed via same transaction ZTR_DELIVERY.
To update any of the configurations whenever necessary, select radiobutton 'Configuration' and open the list on 'Update' field, to select which table to update.
- Press F8.
