extends AnimatableBody2D

@export var move_distance: float = 2000.0  # Khoảng cách di chuyển
@export var move_speed: float = 2.0      # Tốc độ di chuyển
@onready var area_2d = $Area2D
@onready var sprite = $Sprite2D

var start_position: Vector2
var target_position: Vector2
var is_moving = false
var has_triggered = false

func _ready():
	start_position = global_position
	target_position = start_position + Vector2(move_distance, 0)
	
	# Kết nối signal
	area_2d.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body):
	if body.is_in_group("Player") and not has_triggered:
		has_triggered = true
		move_platform()

func move_platform():
	if is_moving:
		return
		
	is_moving = true
	
	# Tạo tween để di chuyển mượt
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, move_speed)
	tween.tween_callback(func(): is_moving = false)
