extends Node2D

func _ready() -> void:
	MusicPlayer.get_node("Music_MainMenu").play()
	
func _process(delta: float) -> void:
	pass


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_rules_button_pressed() -> void:
	get_tree().change_scene_to_file("res://elements/rules/rules.tscn")

func _on_play_button_pressed() -> void:
	FadeIn.transition()
	await FadeIn.on_transition_finished
	get_tree().change_scene_to_file("res://game/game.tscn")
