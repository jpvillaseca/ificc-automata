extends Sprite2D

enum AltruistType {
	Normal,
	GreenBeard,
	Leecher,
	FakeGreenBeard,
	Purple,
	Dead
}

@export var CellType = AltruistType.Normal:
	set(t):
		CellType = t
		_update_color()
		

func _ready() -> void:
	_update_color()

func _update_color():
	match CellType:
		AltruistType.Normal:
			modulate = Color.AQUA
		AltruistType.GreenBeard:
			modulate = Color.GREEN
		AltruistType.Leecher:
			modulate = Color.ORANGE
		AltruistType.FakeGreenBeard:
			modulate = Color.GREEN_YELLOW
		AltruistType.Purple:
			modulate = Color.PURPLE
		AltruistType.Dead:
			modulate = Color.DIM_GRAY
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
