extends Node2D

signal changes_end
signal never

@onready var match_game_scene = preload("res://game/match_game/match_game.tscn")
@onready var media_azbuka_scene = preload("res://game/media-azbuka/media_azbuka.tscn")
@onready var zaochnaya_vstrecha_scene = preload("res://game/zaochnaya_vstrecha/zaochnaya_vstrecha.tscn")
@onready var ploshadka_scene = preload("res://game/ploshadka/ploshadka.tscn")
@onready var novye_gorizonty_scene = preload("res://game/novye_gorizonty/novye_gorizonty.tscn")

var guide_replics = [
	"Здравствуйте! Здравствуйте! Здравствуйте!",
	"Сегодня у вас появилась уникальная возможность поучавствовать в виртуальной квест-экскурсии 'Ожившая история' музейной комнаты 'Шляхi нашых гадоу'",
	"Учреждения образования 'Ошмянский государственный аграрно-экономический колледж",
	"Познакомиться с его замечательными людьми, их удивительными судьбами, огромной потенциальной энергией, трудолюбием, настоящими патриотами нашей страны."
]

var conclusion_replics = [
	'Спасибо всем, кто принял виртуальное участие в виртуальной квест-экскурсии "Ожившая история", узнал новые факты о преподавателях , выпускниках , нашей гордостью , основной движущей силой общества .',
	'Всех участников , заинтересовавшихся историей нашего колледжа , приглашаем в нашу музейную комнату "Шляхи нашых гадоу" по адресу: г. Ошмяны , ул. чкалова , 15а',
	'Желаю вам всем удачи, и до новых встреч!'
]

signal timer_end
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Photo.visible = false;
	$Timer.start()
	await timer_end
	change_replics(guide_replics)
	await changes_end
	first_station()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func change_replics(replics: Array):
	for i in range(replics.size()):
		$Guide.get_node("DialogueBox").get_node("Label").text = replics[i]
		await $Guide._on_change_replic
	emit_signal("changes_end")
	
func _on_timer_timeout() -> void:
	emit_signal("timer_end")

func first_station():
	StationTransition.transition("I станция-площадка 'История колледжа в цифрах и фактах'")
	await StationTransition.on_station_transition_finished
	var match_game_session = match_game_scene.instantiate()
	$Guide.get_node("DialogueBox").get_node("Label").text = "Перед вами цифры, таящие в себе секреты прожитых дней колледжа"
	await $Guide._on_change_replic
	$Guide.get_node("DialogueBox").get_node("Label").text = "Что они значат в судьбе колледжа?"
	await $Guide._on_change_replic
	$Guide.get_node("DialogueBox").visible = false
	$Guide.get_node("Guide").visible = false
	add_child(match_game_session)
	await match_game_session.is_game_over
	match_game_session.queue_free()
	$Guide.get_node("DialogueBox").visible = true
	$Guide.get_node("Guide").visible = true
	$Guide.get_node("DialogueBox").get_node("Label").text = "Молодцы, вы хорошо знакомы с историей колледжа! Идём дальше."
	await $Guide._on_change_replic
	second_station()
	 
func second_station():
	var media_azbuka = media_azbuka_scene.instantiate()
	StationTransition.transition("II станция площадка 'Люди удивительной судьбы'")
	await StationTransition.on_station_transition_finished
	$Guide.get_node("DialogueBox").visible = false
	$Guide.get_node("Guide").visible = false
	add_child(media_azbuka)
	await media_azbuka.game_end
	media_azbuka.queue_free()
	$Guide.get_node("DialogueBox").visible = true
	$Guide.get_node("Guide").visible = true
	$Guide.get_node("DialogueBox").get_node("Label").text = "Отличная работа! А сейчас мы с вами познакомимся с Щербаченей Михаилом Никифоровичем"
	await $Guide._on_change_replic
	third_station()

func third_station():
	var zaochnaya_vstrecha = zaochnaya_vstrecha_scene.instantiate()
	StationTransition.transition("III станция — площадка «Заочная встреча с ветераном войны и труда Щербаченой М.Н.»")
	await StationTransition.on_station_transition_finished
	$Guide.get_node("DialogueBox").visible = false
	$Guide.get_node("Guide").visible = false
	add_child(zaochnaya_vstrecha)
	await zaochnaya_vstrecha.game_end
	zaochnaya_vstrecha.queue_free()
	$Guide.get_node("DialogueBox").visible = true
	$Guide.get_node("Guide").visible = true
	$Guide.get_node("DialogueBox").get_node("Label").text = "Надеюсь это было увлекательное чтение для вас! Идём дальше!"
	print("END")
	await $Guide._on_change_replic
	fourth_station()

func fourth_station():
	var ploshadka = ploshadka_scene.instantiate()
	StationTransition.transition('IV станция — площадка "Мир увлечений и интересных дел"')
	await StationTransition.on_station_transition_finished
	$Guide.get_node("DialogueBox").visible = false
	$Guide.get_node("Guide").visible = false
	add_child(ploshadka)
	await ploshadka.game_end
	ploshadka.queue_free()
	$Guide.get_node("DialogueBox").visible = true
	$Guide.get_node("Guide").visible = true
	$Guide.get_node("DialogueBox").get_node("Label").text = "Я уверен это было познавательно узнавать про профессии! Идём дальше!"
	await $Guide._on_change_replic
	print("END")
	fifth_station()
	
func fifth_station():
	var novye_gorizonty = novye_gorizonty_scene.instantiate()
	StationTransition.transition('V станция — площадка "Новые горизонты"')
	await StationTransition.on_station_transition_finished
	$Guide.get_node("Guide").texture = load("res://assets/guide2.png")
	add_child(novye_gorizonty)
	await novye_gorizonty.game_end
	conclusion()
	await get_tree().create_timer(0.5).timeout
	novye_gorizonty.queue_free()
	
func conclusion():
	StationTransition.transition('Заключение')
	await StationTransition.on_station_transition_finished
	$Guide.get_node("Guide").texture = load("res://assets/guide3.png")
	change_replics(conclusion_replics)
	await changes_end
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")
