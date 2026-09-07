extends Node

signal game_end

var left_selected: Button
var right_selected: Button
var positions = []

@onready var piece_scene = preload("res://game/ploshadka/Piece.tscn")
var grid_size = Vector2(6, 4)
var piece_size = 200
var snap_threshold = 50
@onready var texture = preload("res://assets/dsc04958.jpg")
var pieces = []

var correct_pairs = {
	"колбы": "лаборанты",
	"корова, дойка, аппарат": "операторы машинного доения",
	"трактор на поле": "трактористы(то)",
	"счёты": "бухгалтера, счетоводы",
	"ноутбук": "программисты",
	'книга "Уголовный \nкодекс Республики \nБеларусь"': "юристы",
	"магазин, товары, \nпродавцы": "продавцы",
	"кастрюля, черпак": "повара"
}

func _ready():
	$Reload.visible = false;
	for b in $task_1/RightContainer.get_children():
		if b is Button:
			b.pressed.connect(_on_left_pressed.bind(b))
	for b in $task_1/RightContainer2.get_children():
		if b is Button:
			b.pressed.connect(_on_right_pressed.bind(b))
	for b in $task_1/RightContainer3.get_children():
		if b is Button:
			b.pressed.connect(_on_right_pressed.bind(b))
	for b in $task_1/RightContainer4.get_children():
		if b is Button:
			b.pressed.connect(_on_right_pressed.bind(b))
	for b in $task_1/RightContainer5.get_children():
		if b is Button:
			b.pressed.connect(_on_right_pressed.bind(b))
	$Label2/CheckButton.pressed.connect(check_answer)
	$Label2/HintButton.pressed.connect(hint_1)
	$Label2/HintButton2.pressed.connect(hint_2)
	$Label2/HintButton3.pressed.connect(hint_3)
	$Label3/CheckButton3.pressed.connect(circles_button)

func _on_left_pressed(button: Button):
	left_selected = button
	$task_1/Label.text = "Выбрано: " + button.text

func _on_right_pressed(button: Button):
	right_selected = button
	if left_selected:
		_check_match()

func _check_match():
	if correct_pairs.get(right_selected.text) == left_selected.text:
		$task_1/Label.text = "Верно!"
		left_selected.disabled = true
		right_selected.disabled = true
		right_selected.get_node("Sprite2D").modulate.r = 0.3
		right_selected.get_node("Sprite2D").modulate.g = 0.3
		right_selected.get_node("Sprite2D").modulate.b = 0.3
	else:
		$task_1/Label.text = "Неверно! Попробуй снова."
	
	left_selected = null
	right_selected = null
	check_game_over()
	
func check_game_over():
	var all_disabled = true

	for b in $task_1/RightContainer.get_children():
		if b is Button and not b.disabled:
			all_disabled = false
			break
	
	if all_disabled:
		await get_tree().create_timer(1).timeout
		$task_1.visible = false
		show_circles()
		print("END")

func show_circles():
	$Label3.visible = true

func circles_button():
	$Sprite2D2.visible = true
	$Label3.visible = false
	$Reload.visible = true
	create_scrambled_puzzle()

func create_scrambled_puzzle():
	# Создаем позиции сетки
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			positions.append(Vector2((x * piece_size / 15) + 1500, (y * piece_size) + 100))
	
	# Перемешиваем позиции
	positions.shuffle()
	
	for i in range(grid_size.x * grid_size.y):
		var piece = piece_scene.instantiate()
		add_child(piece)
		pieces.append(piece)
		
		# Настройка текстуры (аналогично первому способу)
		var row = i / int(grid_size.x)
		var col = i % int(grid_size.x)
		var region = Rect2(col * piece_size, row * piece_size, piece_size, piece_size)
		
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = texture
		atlas_texture.region = region
		
		piece.get_node("TextureRect").texture = atlas_texture
		
		# Случайная позиция
		piece.position = positions[i]
		var original_pos = Vector2(
			((i % int(grid_size.x)) * piece_size) + 100,
			((i / int(grid_size.x)) * piece_size) + 100
		)
		piece.set_original_position(original_pos)

func check_piece_snap(piece):
	print("here")
	print(piece.position.distance_to(piece.get_original_position()))
	print(snap_threshold)
	if piece.position.distance_to(piece.get_original_position()) < snap_threshold:
		piece.position = piece.get_original_position()
		piece.set_correct(true)
		check_puzzle_complete()

func check_puzzle_complete():
	for i in pieces:
		if i.is_correct() == false:
			return
	$Reload.visible = false
	await get_tree().create_timer(1).timeout
	$Sprite2D2.visible = false
	for i in pieces:
		i.visible = false
	$Label2.visible = true
	
func check_answer():
	var user_answer = $Label2/AnswerInput.text.strip_edges()
	var answer = "Барташевич Н.А."
	
	if user_answer.to_lower() == answer.to_lower():
		$Label2.text = "Верно!"
		await get_tree().create_timer(1).timeout
		emit_signal("game_end")
	else:
		$Label2.text = "Неверно. Попробуйте ещё раз!"
		await get_tree().create_timer(1).timeout
		$Label2.text = 'Кто является создателем трактора "гном"?'
func hint_1():
	$Label2/Label2.visible = true
	$Label2/HintButton2.visible = true
func hint_2():
	$Label2/Label3.visible = true
	$Label2/HintButton3.visible = true
func hint_3():
	$Label2/Label4.visible = true

func _on_reload_pressed() -> void:
	for i in range(grid_size.x * grid_size.y):
		pieces[i].position = positions[i]
		pieces[i].set_correct(false)
