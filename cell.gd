extends Sprite2D
class_name Cell

enum AltruistType {
	Normal,
	GreenBeard,
	FakeGreenBeard,
	PureAltruist,
	Dead
}

@export var CellType = AltruistType.Normal:
	set(t):
		CellType = t
		_update_color()
		
var generations_dead: int = 0
var row: int = -1
var column: int = -1
var iteration_used_as_altruist: int = -1

func _ready() -> void:
	# Create shader material if it doesn't exist
	if material == null:
		var shader_mat = ShaderMaterial.new()
		shader_mat.shader = preload("res://cell.gdshader")
		shader_mat.set_shader_parameter("tint_strength", 1.0) # Adjust value between 0.0 and 1.0
		material = shader_mat
	_update_color()

func _update_color():
	if material is ShaderMaterial:
		material.set_shader_parameter("tint_color", cell_type_to_color(CellType))
	else:
		self_modulate = cell_type_to_color(CellType)
		

static func cell_type_to_color(cell_type: AltruistType) -> Color:
	match cell_type:
		AltruistType.Normal:
			return Color.DODGER_BLUE
		AltruistType.GreenBeard:
			return Color.LAWN_GREEN
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
