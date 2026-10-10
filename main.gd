extends Node2D

## Escena principal de Ratas calientes: arma el nivel, controla reglas y fin de partida.

const PlayerScript = preload("res://entities/player/player.gd")
const ChefScript = preload("res://entities/enemies/chef/chef.gd")
const FoodScript = preload("res://items/food/food_item.gd")
const BurrowScript = preload("res://environment/burrow/burrow.gd")
const HudScript = preload("res://ui/hud.gd")

const ARENA := Rect2(0, 0, 1152, 648)
const FOOD_COUNT: int = 14
const GOAL: int = 8
const TIME_LIMIT: float = 120.0
const CHEF_COUNT: int = 2
const PICKUP_RANGE: float = 26.0
const HIT_RANGE: float = 26.0

var player
var burrow
var hud
var chefs: Array = []
var foods: Array = []
var delivered: int = 0
var time_left: float = TIME_LIMIT
var game_over: bool = false


func _ready() -> void:
	randomize()

	burrow = BurrowScript.new()
	burrow.position = Vector2(110, 540)
	add_child(burrow)

	player = PlayerScript.new()
	player.bounds = ARENA
	player.position = burrow.position + Vector2(0, -90)
	add_child(player)

	for i in range(CHEF_COUNT):
		var chef = ChefScript.new()
		chef.bounds = ARENA
		chef.position = Vector2(randf_range(500, 1050), randf_range(120, 520))
		add_child(chef)
		chefs.append(chef)

	for i in range(FOOD_COUNT):
		var f = FoodScript.new()
		f.position = _random_spot()
		add_child(f)
		foods.append(f)

	hud = HudScript.new()
	add_child(hud)
	hud.show_message("Lleva %d quesos a la madriguera. ¡Evita al chef!" % GOAL)


func _draw() -> void:
	# Piso de baldosas de cocina y paredes.
	draw_rect(ARENA, Color(0.93, 0.9, 0.82))
	for x in range(0, 1152, 64):
		for y in range(0, 648, 64):
			if (x / 64 + y / 64) % 2 == 0:
				draw_rect(Rect2(x, y, 64, 64), Color(0.88, 0.84, 0.74))
	var wall := Color(0.4, 0.3, 0.25)
	draw_rect(Rect2(0, 0, 1152, 10), wall)
	draw_rect(Rect2(0, 638, 1152, 10), wall)
	draw_rect(Rect2(0, 0, 10, 648), wall)
	draw_rect(Rect2(1142, 0, 10, 648), wall)


func _process(delta: float) -> void:
	if game_over:
		return

	time_left -= delta
	player.in_burrow = burrow.is_inside(player.position)

	# Recoger quesos.
	for f in foods.duplicate():
		if player.can_carry() and player.position.distance_to(f.position) < PICKUP_RANGE:
			player.carried += 1
			foods.erase(f)
			f.queue_free()

	# Entregar en la madriguera.
	if player.in_burrow and player.carried > 0:
		delivered += player.carried
		hud.show_message("+%d quesos entregados" % player.carried)
		player.carried = 0

	# Chefs.
	for chef in chefs:
		chef.update_chef(delta, player.position)
		if chef.position.distance_to(player.position) < HIT_RANGE:
			if player.take_hit():
				hud.show_message("¡Te atrapó el chef! Perdiste lo que llevabas.")

	hud.update_status(player.health.current, player.health.max_health, player.heat.ratio(),
		player.heat.is_overheated, player.carried, delivered, GOAL, maxf(time_left, 0.0))

	# Fin de partida.
	if player.health.is_dead():
		_end("Te atraparon. Presiona R para reintentar.")
	elif delivered >= GOAL:
		_end("¡Ganaste! Entregaste %d quesos. Presiona R para jugar otra vez." % delivered)
	elif time_left <= 0.0:
		_end("Se acabó el tiempo. Presiona R para reintentar.")


func _end(text: String) -> void:
	game_over = true
	hud.show_message(text)


func _unhandled_input(event: InputEvent) -> void:
	if game_over and event is InputEventKey:
		var key := event as InputEventKey
		if key.pressed and not key.echo and key.keycode == KEY_R:
			get_tree().reload_current_scene()


func _random_spot() -> Vector2:
	var p := Vector2(randf_range(60, 1090), randf_range(60, 590))
	while p.distance_to(burrow.position) < 130.0:
		p = Vector2(randf_range(60, 1090), randf_range(60, 590))
	return p
