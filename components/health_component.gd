extends Node

## Componente de vida reutilizable (Juego: Ratas calientes)

signal died

var max_health: int = 3
var current: int = 3


func setup(max_hp: int) -> void:
	max_health = max_hp
	current = max_hp


func take_damage(amount: int) -> void:
	if current <= 0:
		return
	current = max(0, current - amount)
	if current == 0:
		died.emit()


func is_dead() -> bool:
	return current <= 0
