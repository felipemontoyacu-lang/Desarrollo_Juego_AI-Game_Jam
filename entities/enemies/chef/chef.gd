extends Node2D

## El chef: patrulla la cocina y persigue a la rata si se acerca.

const DETECT_RANGE: float = 280.0
const CHASE_SPEED: float = 118.0
const WANDER_SPEED: float = 70.0

var bounds: Rect2 = Rect2(0, 0, 1152, 648)
var chasing: bool = false

var _wander_target: Vector2
var _wander_timer: float = 0.0


func _ready() -> void:
	_pick_wander_target()


func _pick_wander_target() -> void:
	_wander_target = Vector2(
		randf_range(bounds.position.x + 40, bounds.end.x - 40),
		randf_range(bounds.position.y + 40, bounds.end.y - 40)
	)
	_wander_timer = randf_range(2.0, 4.0)


func update_chef(delta: float, player_pos: Vector2) -> void:
	var to_player := player_pos - position
	chasing = to_player.length() < DETECT_RANGE

	if chasing:
		position += to_player.normalized() * CHASE_SPEED * delta
	else:
		_wander_timer -= delta
		var to_target := _wander_target - position
		if to_target.length() < 6.0 or _wander_timer <= 0.0:
			_pick_wander_target()
		else:
			position += to_target.normalized() * WANDER_SPEED * delta

	queue_redraw()


func _draw() -> void:
	if chasing:
		draw_arc(Vector2.ZERO, 24.0, 0.0, TAU, 24, Color(1.0, 0.2, 0.2), 2.0)
	draw_rect(Rect2(-16, -16, 32, 32), Color(0.95, 0.95, 0.95))  # chaqueta
	draw_rect(Rect2(-14, -30, 28, 14), Color.WHITE)  # gorro
	draw_circle(Vector2(-6, -2), 2.5, Color.BLACK)
	draw_circle(Vector2(6, -2), 2.5, Color.BLACK)
	draw_line(Vector2(-8, 8), Vector2(8, 8), Color(0.6, 0.1, 0.1), 2.0)  # boca
