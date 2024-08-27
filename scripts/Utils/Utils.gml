function floatEq(_f1, _f2) {
	return abs(_f1 - _f2) < 1;
}

function betterSign(_n) {
	return sign(_n) == 0 ? 1 : sign(_n);
}