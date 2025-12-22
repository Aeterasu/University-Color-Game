class_name Lerp 

static func cubic_ease_out(a : float, b : float, t : float) -> float:
	var u := 1.0 - pow(1.0 - clamp(t, 0.0, 1.0), 3)
	return lerp(a, b, u)

static func cubic_ease_in_out(a: float, b: float, t: float) -> float:
	t = clamp(t, 0.0, 1.0)
	var u : float = 1.0
	if t < 0.5:
		u = 4.0 * t * t * t
	else:
		u = 1.0 - pow(-2.0 * t + 2.0, 3) / 2.0
	return lerp(a, b, u)

# ---

# Returns an interpolated value with a configurable bounce.
#
# t: 0.0 to 1.0 (normalized time)
# bounciness: higher = more dramatic overshoot and more oscillation
# damping: 0.0–1.0, how quickly the oscillation decays (higher = fast decay)
# frequency: number of bounce cycles
static func bounce_lerp(t: float, from: float, to: float, bounciness := 1.2, damping := 0.5, frequency := 3.0) -> float:
	t = clamp(t, 0.0, 1.0)

	# Base interpolation (ease out for a natural feel).
	var base := 1.0 - pow(1.0 - t, 2)

	# Oscillatory component.
	# The exponent makes the wobble slightly stronger near the end.
	var wobble_time := pow(t, bounciness)
	var omega := TAU * frequency     # angular frequency
	var decay := exp(-damping * t)   # exponential decay

	var bounce := sin(wobble_time * omega) * decay

	return lerp(from, to, base + bounce * (1.0 - t))