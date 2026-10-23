extends CharacterBody2D


@onready var player = get_node("/root/Thursday/Player")

const DEFAULT_HEALTH: float = 30

var health: float = DEFAULT_HEALTH
var damage: float = 5
var speed: float = 2700

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()
	health = DEFAULT_HEALTH
	

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if (abs(abs(global_position.x) - abs(player.global_position.x)) < 256 && abs(abs(global_position.y) - abs(player.global_position.y)) < 256):
		direction = global_position.direction_to(player.global_position)
	velocity = direction * speed * delta
	move_and_slide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health == 0:
		queue_free()
