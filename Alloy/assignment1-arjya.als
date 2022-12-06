sig Car { }			// set of all cars
one sig Rentals
{
	available: set Car,	// set of all available cars, ready to be rented
	rented: set Car,	// set of all cars currently on rent
}

// Problem 1
pred badInstances[]
{
	not(all c: Car | (c in Rentals.available && c not in Rentals.rented) or 
				(c in Rentals.rented && c not in Rentals.available)) or
				not(some c: Car | c in Rentals.available)
	// find all the instances which do not satisfy either P1 or P2 or both where:
	// P1: for all cars c, either c is available and not rented OR c is rented and not available (basically XOR operation)
	// P2: some car c is available
}

run badInstances for 8

// Problem 2
fact ensureP1
{
	all c: Car | (c in Rentals.available && c not in Rentals.rented) or (c in Rentals.rented && c not in Rentals.available)
	// fact to ensure for all cars c, either c is available and not rented OR c is rented and not available
}

fact ensureP2
{
	some c: Car | c in Rentals.available
	// fact to ensure  some car c is available
}

pred show {}

run show for 8

// Problem 3
pred rent[toRent: Car, newAvail: Rentals -> set Car, newRented: Rentals -> set Car]
{
	toRent in Rentals.available and #Rentals.available > 1

	// if the car toRent is available and the number of available cars is at least 2 then the car toRent is newRented
	// and all the old rented cars are also copied to newRented and newAvail contains all the cars that were 
	// previously available and the car toRent gets out of that relation as it is now being rented.

	// Notice that, we are checking that at least 2 cars are available at first, to satisfy the criterion that at least 1 car
	// should remain available after we give 1 car for rent 
	implies newRented = rented + Rentals->toRent and newAvail = available -  Rentals->toRent 

	// if the car toRent is not currently available or only one car is currently available then newAvail and
	// newRented remains same as old available and old rented. If there is only 1 car available, then we can't give
	// it for rent as it will violate the property P2
	else newRented = rented and newAvail = available
}

pred return[toReturn: Car, newAvail: Rentals -> set Car, newRented: Rentals -> set Car]
{
	toReturn in Rentals.rented

	// if the car toReturn is currently rented then we will add it to the newAvail relation along with all the cars
	// that were previously available. Simultaneously, newRented will contain all the cars that were previously rented
	// except the toReturn car
	implies newRented = rented - Rentals->toReturn  and newAvail = available + Rentals->toReturn

	// if the car toReturn is currently not rented then all newAvailable and newRented will remain same as
	// old available and old rented respectively
	else newRented = rented and newAvail = available
}

run rent for 8
run return for 8

// Problem 4

// predicate to check if the newAvail and newRented follows P1 and P2
pred checkProperties[newAvail: Rentals -> set Car, newRented: Rentals -> set Car]
{
	all c: Car | (c in Rentals.newAvail && c not in Rentals.newRented) or 
			 (c in Rentals.newRented && c not in Rentals.newAvail)

	some c: Car | c in Rentals.newAvail
}

pred findBugsInRent[toRent: Car, newAvail: Rentals -> set Car, newRented: Rentals -> set Car]
{
	// report bugs if the new instances returned from rent[ ] doesn't obey properties P1 and P2
	 rent[toRent, newAvail, newRented] and not checkProperties[newAvail, newRented]
}

pred findBugsInReturn[toReturn: Car, newAvail: Rentals -> set Car, newRented: Rentals -> set Car]
{
	// report bugs if the new instances returned from return[ ] doesn't obey properties P1 and P2
	return[toReturn, newAvail, newRented] and not checkProperties[newAvail, newRented]
}

run findBugsInRent for 8
run findBugsInReturn for 8
