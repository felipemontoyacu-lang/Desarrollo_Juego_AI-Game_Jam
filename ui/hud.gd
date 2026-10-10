extends CanvasLayer

## Interfaz: estado de la rata y mensajes en pantalla.

var _status: Label
var _message: Label


func _ready() -> void:
	var width: float = get_viewport().get_visible_rect().size.x

	_status = Label.new()
	_status.position = Vector2(16, 12)
	_status.add_theme_font_size_override("font_size", 20)
	add_child(_status)

	_message = Label.new()
	_message.position = Vector2(0, 280)
	_message.size = Vector2(width, 80)
	_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message.add_theme_font_size_override("font_size", 28)
	add_child(_message)


func update_status(health: int, max_health: int, heat_ratio: float, overheated: bool,
		carried: int, delivered: int, goal: int, time_left: float) -> void:
	var warn := "   ¡SOBRECALENTADA!" if overheated else ""
	_status.text = "Vida: %d/%d   Calor: %d%%   Llevas: %d   Entregados: %d/%d   Tiempo: %ds%s" % [
		health, max_health, int(heat_ratio * 100.0), carried, delivered, goal, int(time_left), warn
	]


func show_message(text: String) -> void:
	_message.text = text
