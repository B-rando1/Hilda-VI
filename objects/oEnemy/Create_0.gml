jumpSpeed = 6;
grav = 0.06;
moveSpeed = 1.5;

hSpeed = 0;
vSpeed = 0;

sitTimer = 0;
sitTimeAvg = 30;
setSitTime = function() {
	sitTime = random_range(sitTimeAvg - 0.2 * sitTimeAvg, sitTimeAvg + 0.2 * sitTimeAvg);
}
sitTime = sitTimeAvg;
setSitTime();

tof = 2 * jumpSpeed / grav;