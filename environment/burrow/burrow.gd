extends Node2D

## Madriguera: aquí la rata entrega quesos y se enfría rápido.

const RADIUS: float = 56.0


func is_inside(p: Vector2) -> bool:
	return p.distance_to(position) < RADIUS


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, Color(0.35, 0.22, 0.12))
	draw_circle(Vector2.ZERO, RADIUS - 10.0, Color(0.15, 0.1, 0.06))
	draw_string(ThemeDB.fallback_font, Vector2(-60, -RADIUS - 8), "MADRIGUERA",
		HORIZONTAL_ALIGNMENT_CENTER, 120, 14, Color.WHITE)
