extends Node2D

signal answer_given
signal game_end

var fifth_station_replics1 = [
		"Ответьте на вопросы",
		"Кто он? Преподаватель, руководитель сегодняшнего дня?",
		"Преподаватель и директор с большим опытом. Человек с большой буквы. Среднего роста, с доброжелательной улыбкой и внимательным взглядом.",
		"Говорит спокойно и уверенно, умеет объяснить сложные вещи простыми словами. Всегда аккуратен, пунктуален и требователен, но при этом справедлив. Видно, что он любит своё дело и уважает студентов.",
		"Знаком ли вам этот человек? Кто он?"
	]

var fifth_station_replics2 = [
	"Энергичная, интеллигентная, в меру строгая, требовательная, умеет быстро и неотложно решать все проблемы учащихся",
	"Кому вы могли бы адресовать этот словесный портрет?"
	]
	
@onready var game = get_node("/root/Game") 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	question1()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func question1():
	game.change_replics(fifth_station_replics1)
	await game.changes_end
	game.get_node("Photo").visible = true
	game.change_replics(["Правильно, это Войшнарович В.И., директор ОГАЭК. Переходим к следующему человеку!"])
	await game.get_node("Guide")._on_change_replic
	game.get_node("Photo").visible = false
	question2()


func question2():
	game.change_replics(fifth_station_replics2)
	await game.changes_end
	game.get_node("Photo").texture = load("res://assets/ignatovich.jpg")
	game.get_node("Photo").visible = true
	game.change_replics(["Правильно, это Игнатович М.К., заместитель директора по воспитательной работе."])
	await game.get_node("Guide")._on_change_replic
	game.get_node("Photo").visible = false
	game.change_replics(["Много слов благодарности сегодня получают наши преподаватели, руководители от учащихся, их родителей, от управления образования."])
	await game.get_node("Guide")._on_change_replic
	emit_signal("game_end")
