extends Node2D

signal is_game_over
signal timer_end

var left_selected: Button = null
var right_selected: Button = null

# Соответствия (по тексту или ID)
var correct_pairs = {
	"1950 (ПТО)": "Школа механизации сельского хозяйства",
	"1954 (ПТО)": "Училище механизации сельского хозяйства №18",
	"1962 (ПТО)": "Сельское профессионально-техническое училище №18",
	"1969 (ПТО)": "Среднее профессионально-техническое училище сельского хозяйства",
	"1981 (ПТО)": "Профессионально-техническое училище №192 сельскохозяйственного производства",
	"2005 (ПТО)": "Учреждение образования «Ошмянский государственный сельскохозяйственный профессиональный лицей»",
	"22.12.2007 (ПТО)": "УО «Ошмянский государственный аграрно-технический колледж»",
	"2019 (ПТО)": "УО «Ошмянский государственный аграрно-экономический колледж»",
	"1950 (ССО)": "Школа учётчиков и бригадиров",
	"1953 (ССО)": "Сельскохозяйственный техникум",
	"2001 (ССО)": "УО «Ошмянский государственный аграрно-экономический колледж»",
	"2019 (ССО)": "Объединённый аграрно-экономический колледж (аграрно-экономический колледж + аграрно-технический колледж)"
}

func _ready():
	for b in $LeftContainer.get_children():
		if b is Button:
			b.pressed.connect(_on_left_pressed.bind(b))
	for b in $RightContainer.get_children():
		if b is Button:
			b.pressed.connect(_on_right_pressed.bind(b))

func _on_left_pressed(button: Button):
	left_selected = button
	$Label.text = "Выбрано: " + button.text

func _on_right_pressed(button: Button):
	right_selected = button
	if left_selected:
		_check_match()

func _check_match():
	if correct_pairs.get(left_selected.text) == right_selected.text:
		$Label.text = "Верно!"
		left_selected.disabled = true
		right_selected.disabled = true
	else:
		$Label.text = "Неверно! Попробуй снова."
	
	left_selected = null
	right_selected = null
	_check_game_over()
	
func _check_game_over():
	var all_disabled = true

	for b in $LeftContainer.get_children():
		if b is Button and not b.disabled:
			all_disabled = false
			break
	
	if all_disabled:
		for b in $RightContainer.get_children():
			if b is Button and not b.disabled:
				all_disabled = false
				break
	
	if all_disabled:
		$Timer.start()
		await timer_end
		emit_signal("is_game_over")


func _on_timer_timeout() -> void:
	emit_signal("timer_end")
