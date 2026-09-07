extends CanvasLayer

signal on_station_transition_finished

@onready var color_rect = $FadeRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	color_rect.get_node("StationName").visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "StationTransition":
		on_station_transition_finished.emit()
		animation_player.play("StationTransitionReverse")
	elif anim_name == "StationTransitionReverse":
		color_rect.visible = false
		color_rect.get_node("StationName").visible = false
		
func transition(station_text):
	color_rect.visible = true
	color_rect.get_node("StationName").text = station_text
	color_rect.get_node("StationName").visible = true
	animation_player.play("StationTransition")
