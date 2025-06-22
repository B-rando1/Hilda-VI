glow = 0;
fade = 0;
glowAmt = 0.15;
fadeAmt = 0.05;
if (crossedOver) {
	glow = 1;
	fade = 1;
	glowAmt *= -1;
	fadeAmt *= -1;
}
depth -= 30;