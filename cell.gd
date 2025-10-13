extends Sprite2D
class_name Cell

enum AltruistType {
	Normal,
	GreenBeard,
	Leecher,
	FakeGreenBeard,
	PureAltruist,
	Dead
}

@export var CellType = AltruistType.Normal:
	set(t):
		CellType = t
		_update_color()
		
var generations_dead: int = 0

func _ready() -> void:
	_update_color()

func _update_color():
	modulate = cell_type_to_color(CellType)
		

func cell_type_to_color(cell_type: AltruistType) -> Color:
	match cell_type:
		AltruistType.Normal:
			return Color.DODGER_BLUE
		AltruistType.GreenBeard:
			return Color.LAWN_GREEN
		AltruistType.Leecher:
			return Color.GOLD
		AltruistType.FakeGreenBeard:
			return Color.ORANGE
		AltruistType.PureAltruist:
			return Color.ORCHID
		AltruistType.Dead:
			return Color.DIM_GRAY
	return Color.WHITE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
