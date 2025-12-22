class_name Jelly

static func jelly_ease_out(t: float, start: float, end: float, 
					bounce: float = 1.5, 
					elasticity: float = 0.4, 
					damping: float = 0.6) -> float:

	t = clamp(t, 0.0, 1.0)
	
	# Exponential decay
	var decay = pow(2.0, -10.0 * t * damping)
	
	# Sine wave for oscillation
	var oscillation = sin((t - elasticity / 4.0) * (2.0 * PI) / elasticity)
	
	# Combine for elastic overshoot
	var elastic = decay * oscillation * bounce * (1.0 - t)
	
	# Base easing (ease-out cubic)
	var base = 1.0 - pow(1.0 - t, 3.0)
	
	# Apply to range
	var progress = base + elastic
	return lerp(start, end, progress)


# Alternative: Spring-based jelly interpolation
static func jelly_spring(t: float, start: float, end: float,
				  stiffness: float = 100.0,
				  friction: float = 10.0) -> float:

	t = clamp(t, 0.0, 1.0)
	
	var omega = sqrt(stiffness)
	var zeta = friction / (2.0 * sqrt(stiffness))
	
	if zeta < 1.0:  # Underdamped (bouncy)
		var envelope = exp(-zeta * omega * t)
		var oscillation = cos(omega * sqrt(1.0 - zeta * zeta) * t)
		var progress = 1.0 - envelope * oscillation
		return lerp(start, end, progress)
	else:  # Critically damped or overdamped
		var progress = 1.0 - exp(-omega * t)
		return lerp(start, end, progress)


# Preset configurations for common jelly effects
enum JellyPreset {
	SUBTLE,      # Gentle overshoot
	BOUNCY,      # Medium bounce
	SUPER_JELLY, # Maximum jiggle
	QUICK_SNAP,  # Fast with small bounce
}

static func jelly_preset(t: float, start: float, end: float, preset: JellyPreset) -> float:
	match preset:
		JellyPreset.SUBTLE:
			return jelly_ease_out(t, start, end, 0.8, 0.5, 0.8)
		JellyPreset.BOUNCY:
			return jelly_ease_out(t, start, end, 1.7, 0.4, 0.6)
		JellyPreset.SUPER_JELLY:
			return jelly_ease_out(t, start, end, 2.5, 0.3, 0.4)
		JellyPreset.QUICK_SNAP:
			return jelly_ease_out(t, start, end, 1.2, 0.6, 0.9)
		_:
			return jelly_ease_out(t, start, end)