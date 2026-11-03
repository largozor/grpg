extends CanvasLayer

# Shows the player's health as hearts in the top left corner

const HEART_TEXTURE = preload("res://assets/Ui/LifeReceptacle/heart.png")
const HEART_SIZE = 16
# heart.png goes from empty to full in quarters
const HEART_FRAMES = 5

@export var hp_per_heart: int = 2
@export var heart_scale: float = 4

@onready var hearts_box = $Hearts

func _on_player_health_changed(hp: int, max_hp: int) -> void:
	var heart_count = ceili(float(max_hp) / hp_per_heart)

	while hearts_box.get_child_count() < heart_count:
		add_heart()
	while hearts_box.get_child_count() > heart_count:
		var heart = hearts_box.get_child(-1)
		hearts_box.remove_child(heart)
		heart.queue_free()

	for i in heart_count:
		var hp_in_heart = clampi(hp - i * hp_per_heart, 0, hp_per_heart)
		var frame = roundi(float(hp_in_heart) / hp_per_heart * (HEART_FRAMES - 1))
		hearts_box.get_child(i).texture.region = Rect2(frame * HEART_SIZE, 0, HEART_SIZE, HEART_SIZE)


func add_heart():
	# Each heart gets its own atlas texture so it can show a different frame
	var atlas = AtlasTexture.new()
	atlas.atlas = HEART_TEXTURE
	var heart = TextureRect.new()
	heart.texture = atlas
	heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	heart.custom_minimum_size = Vector2.ONE * HEART_SIZE * heart_scale
	hearts_box.add_child(heart)
