extends Node2D

signal game_end
signal timer_end

var questions = {
	"ButtonK_1": {
		"question": "20 лет возглавлял УО «ОПАТК». Награждён Орденом Почёта, золотой медалью «За достигнутые успехи в развитии народного хозяйства СССР». Благодарен медалью «За доблестный труд. В ознаменование 100-летия со дня рождения В.И. Ленина», юбилейной медалью «60 лет Победы в Великой Отечественной войне 1941–1945 гг.», медалью «Ветеран труда», значком «Отличник профтехобразования БССР». Кто это?",
		"answer": "Коляга А.Т."
	},
	"ButtonK_2": {
		"question": "Участник Великой Отечественной войны, комиссар партизанской бригады, 20 лет возглавлял училище. Кто это?",
		"answer": "Куличков А.М."
	},
	"ButtonB": {
		"question": "Учился в нашем учебном заведении, работал мастером производственного обучения, заместителем директора, имеет знак «Отличник образования Республики Беларусь», медаль «За трудовые заслуги», в настоящее время директор. Кто это?",
		"answer": "Войшнарович В.И."
	},
	"ButtonL": {
		"question": "Был учащимся нашего учебного заведения, преподавателем, старшим мастером производственного обучения, заместителем директора, директором. Заслуженный учитель профессионально-технического образования. Кто это?",
		"answer": "Латынцев Ф.К."
	},
	"ButtonP": {
		"question": "Участник Великой Отечественной войны, руководитель подпольной группы, партизан, заслуженный учитель профессионально-технического образования, награждён орденами Ленина, «Знак Почёта»... Работал директором ПТУ №192. Кто это?",
		"answer": "Пархимович С.П."
	},
	"ButtonCH": {
		"question": "Участник Великой Отечественной войны, директор школы механизации сельского хозяйства. Кто это?",
		"answer": "Чайка С.Т."
	}
}

var current_key = ""
var current_button : Button = null

func _ready():
	var buttons = $HBoxContainer.get_children()
	for button in buttons:
		if button is Button:
			button.pressed.connect(_on_letter_pressed.bind(button))
		
	$CheckButton.pressed.connect(_on_check_pressed)
	$HintButton.pressed.connect(_on_hint_pressed)
	$QuestionLabel.text = "Выберите букву, чтобы начать"
	$AnswerInput.visible = false
	$CheckButton.visible = false
	$ResultLabel.text = ""
	$HintButton.visible = false
	$HintPopup.visible = false
	
func _on_letter_pressed(button: Button):
	current_key = button.name  # 👈 используем имя узла, а не текст
	current_button = button
	
	var q = questions.get(current_key, null)
	if q:
		$QuestionLabel.text = q["question"]
		$AnswerInput.visible = true
		$CheckButton.visible = true
		$HintButton.visible = true
		$ResultLabel.text = ""
		$AnswerInput.text = ""
	else:
		$QuestionLabel.text = "Нет данных для этой кнопки."

func _on_check_pressed():
	if current_key == "":
		return
	
	var user_answer = $AnswerInput.text.strip_edges()
	var correct_answer = questions[current_key]["answer"]
	
	if user_answer.to_lower() == correct_answer.to_lower():
		$ResultLabel.text = "Верно!"
		
		if current_button:
			current_button.disabled = true
			current_button.modulate = Color(0.7, 0.7, 0.7)
		
		_next_available_button()
	else:
		$ResultLabel.text = "Неверно. Попробуйте ещё раз!"


func _next_available_button():
	var buttons = $HBoxContainer.get_children()
	for button in buttons:
		if button is Button and not button.disabled:
			_on_letter_pressed(button)
			return
	
	$QuestionLabel.text = "Все вопросы пройдены! Отличная работа!"
	$AnswerInput.visible = false
	$CheckButton.visible = false
	$HintButton.visible = false
	$Timer.start()
	await timer_end
	emit_signal("game_end")

func _on_hint_pressed():
	$HintPopup.popup_centered()
	
func _on_close_hint_pressed():
	$HintPopup.hide()


func _on_timer_timeout() -> void:
	emit_signal("timer_end")
