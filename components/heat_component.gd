extends Node

## Componente de calor: correr calienta a la rata; si llega al máximo se sobrecalienta
## y se mueve más lento hasta enfriarse.

signal overheated

const MAX_HEAT: float = 100.0
const RECOVER_AT: float = 35.0

var heat: float = 0.0
var is_overheated: bool = false


func add(amount: float) -> void:
	heat = clampf(heat + amount, 0.0, MAX_HEAT)
	if heat >= MAX_HEAT and not is_overheated:
		is_overheated = true
		overheated.emit()


func cool(amount: float) -> void:
	heat = maxf(0.0, heat - amount)
	if is_overheated and heat <= RECOVER_AT:
		is_overheated = false


func ratio() -> float:
	return heat / MAX_HEAT
