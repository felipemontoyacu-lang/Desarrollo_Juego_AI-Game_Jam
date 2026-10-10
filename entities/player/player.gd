extends Node2D

## La rata jugadora.

const HealthComponent = preload("res://components/health_component.gd")
const HeatComponent = preload("res://components/heat_component.gd")

const BASE_SPEED: float = 220.0
const CARRY_CAPACITY: int = 3
const HIT_COOLDOWN: float = 1.0

var health
var heat
var carried: int = 0
var in_burrow: bool = false
var bounds: Rect2 = Rect2(0, 0, 1152, 648)

var _hit_timer: float = 0.0


func _ready() -> void:
	health = HealthComponent.new()
	health.setup(3)
	add_child(health)

	heat = HeatComponent.new()
	add_child(heat)


func _physics_process(delta: float) -> void:
	var dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var moving := dir.length() > 0.1
	var speed := BASE_SPEED * (0.5 if heat.is_overheated else 1.0)

	if moving:
		position += dir.normalized() * speed * delta
		heat.add(22.0 * delta)
	else:
		heat.cool(18.0 * delta)

	if in_burrow:
		heat.cool(45.0 * delta)

	position = position.clamp(bounds.position + Vector2(20, 20), bounds.end - Vector2(20, 20))
	_hit_timer = maxf(0.0, _hit_timer - delta)
	queue_redraw()


func can_carry() -> bool:
	return carried < CARRY_CAPACITY


## Devuelve true si el chef realmente golpeó (no está en cooldown).
## Al ser golpeada, la rata suelta los quesos que llevaba.
func take_hit() -> bool:
	if _hit_timer > 0.0 or health.is_dead():
		return false
	_hit_timer = HIT_COOLDOWN
	health.take_damage(1)
	carried = 0
	return true


func _draw() -> void:
	var flash := _hit_timer > 0.0 and int(_hit_timer * 10.0) % 2 == 0
	var body_color := Color(0.55, 0.45, 0.4).lerp(Color(1.0, 0.3, 0.1), heat.ratio())
	if flash:
		body_color = Color.WHITE

	draw_line(Vector2(-14, 8), Vector2(-30, 16), Color(0.9, 0.6, 0.6), 3.0)  # cola
	draw_circle(Vector2.ZERO, 16.0, body_color)
	draw_circle(Vector2(-6, -14), 6.0, body_color)  # orejas
	draw_circle(Vector2(6, -14), 6.0, body_color)
	draw_circle(Vector2(8, -3), 2.5, Color.BLACK)  # ojo

	for i in range(carried):
		draw_rect(Rect2(-12 + i * 10, -30, 8, 8), Color(1.0, 0.85, 0.2))
