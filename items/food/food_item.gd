extends Node2D

## Queso que la rata puede recoger y llevar a la madriguera.

var _time: float = 0.0


func _process(delta: float) -> void:
	_time += delta
	queue_redraw()


func _draw() -> void:
	var s := 1.0 + 0.08 * sin(_time * 5.0)
	var pts := PackedVector2Array([
		Vector2(0, -12) * s,
		Vector2(12, 8) * s,
		Vector2(-12, 8) * s,
	])
	draw_colored_polygon(pts, Color(1.0, 0.85, 0.2))
	draw_circle(Vector2(-3, 2) * s, 2.0, Color(0.9, 0.6, 0.1))
