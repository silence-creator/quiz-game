extends Control

var is_dragging = false
var _original_position = Vector2.ZERO
var _is_correct = false
var drag_offset = Vector2.ZERO

func _ready():
	_original_position = position
	# Включаем обработку ввода
	mouse_filter = MOUSE_FILTER_PASS

func set_original_position(pos):
	_original_position = pos

func get_original_position():
	return _original_position

func set_correct(value):
	_is_correct = value

func is_correct():
	return _is_correct

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and !_is_correct:
			is_dragging = true
			drag_offset = position - get_global_mouse_position()
			get_viewport().set_input_as_handled()
			print("no")
		else:
			is_dragging = false
			print("yes")
			get_parent().check_piece_snap(self)

func _process(delta):
	if is_dragging and !_is_correct:
		position = get_global_mouse_position() + drag_offset
