extends Node2D

@export var cell_scene: PackedScene
@export var simulation: Simulation
@export var sleepTimer: float = 0.5

var cell_width: int = 15
var label_height: int = 50
var _is_waiting = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	for column in range(simulation.column_count):
		simulation.cell_matrix.push_back([])
		for row in range(simulation.row_count):
			var cell = cell_scene.instantiate()
			if is_edge(column, row):
				cell.visible = false
				cell.CellType = cell.AltruistType.Dead
			else:
				cell.CellType = simulation.get_cell_type_by_chance()
			self.add_child(cell)
			cell.position = Vector2(column * cell_width, label_height + row * cell_width)
			
			simulation.cell_matrix[column].push_back(cell)
			

func is_edge(column, row):
	return row == 0 or column == 0 or row == simulation.row_count - 1 or column == simulation.column_count - 1

func _process(delta):
	if not _is_waiting:
		simulation_iteration()
	pass

func simulation_iteration():
	_is_waiting = true
	await get_tree().create_timer(sleepTimer).timeout
	
	if simulation.current_iteration >= simulation.iterations + 1:
		_is_waiting = false
		return

	var is_finished = simulation.current_iteration == simulation.iterations + 1

	var label_text = ""
	if is_finished:
		label_text = "[shake][b]Simulation finished[/b][/shake] after [b]%d[/b] iterations" % simulation.iterations
	else:
		simulation.simulation_iteration()
		label_text = "[shake][b]Simulation running[/b][/shake] [b]%d/%d[/b] iterations" % [simulation.current_iteration, simulation.iterations]
		simulation.refresh_stats()


	label_text += "\n[color=dodgerblue]Normal: %d[/color] [color=lawngreen]GreenBeard: %d[/color] [color=orange]Fakers: %d[/color] [color=ORCHID]Pure altruist: %d[/color] [color=gold]Leecher: %d[/color] [color=gray]Dead: %d[/color]" % [
		simulation.amount_normal, simulation.amount_green_beard, simulation.amount_fake_green_beard, simulation.amount_pure_altruist, simulation.amount_leecher, simulation.amount_dead]
	$InfoLabel.text = label_text
	_is_waiting = false
