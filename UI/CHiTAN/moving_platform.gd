extends Area2D

@export var move_distance: float = 50.0
@export var move_speed: float = 0.2

@onready var trigger_area = $TriggerArea
var start_position: Vector2
var target_position: Vector2
var has_triggered = false
var is_moving = false

func _ready():
	# Kết nối signal cho deadly collision
	body_entered.connect(_on_body_entered)
	
	# Kết nối signal cho trigger area
	if trigger_area:
		trigger_area.body_entered.connect(_on_trigger_entered)
	
	# Setup movement
	start_position = global_position
	target_position = start_position + Vector2(move_distance, 0)
	
	# Thêm vào group để dễ quản lý
	add_to_group("deadly_objects")

# Khi player chạm vào DeadlyObject -> chết
func _on_body_entered(body):
	print("Deadly object touched by: ", body.name)
	if body.is_in_group("Player"):
		print("Player died from deadly object!")
		kill_player(body)

# Khi player chạm vào TriggerArea -> di chuyển
func _on_trigger_entered(body):
	print("Trigger area touched by: ", body.name)
	if body.is_in_group("Player") and not has_triggered:
		has_triggered = true
		move_object()

func kill_player(player):
	if player.has_method("die"):
		player.die()

func move_object():
	if is_moving:
		return
		
	is_moving = true
	print("DeadlyObject moving from ", global_position, " to ", target_position)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position, move_speed)
	tween.tween_callback(func(): 
		is_moving = false
		print("DeadlyObject finished moving")
	)

# Reset function (gọi khi player respawn)
func reset_object():
	global_position = start_position
	has_triggered = false
	is_moving = false
