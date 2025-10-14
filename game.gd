extends Node2D

@export var cell_scene: PackedScene
@export var simulation: Simulation
@export var sleepTimer: float = 0.0
@export var enable_rendering: bool = true

var cell_width: int = 15
var label_height: int = 240
var _is_waiting = false

var rng = RandomNumberGenerator.new()

var plot_normal
var plot_green_beard
var plot_fake_green_beard
var plot_pure_altruist


func _ready():
	rng.randomize()

	# Apply parameters from GameManager if available
	if GameManager.simulation_params.size() > 0:
		var params = GameManager.simulation_params
		simulation.row_count = params.get("row_count", 80)
		simulation.column_count = params.get("column_count", 80)
		simulation.chance_normal = params.get("chance_normal", 0.4)
		simulation.chance_green_beard = params.get("chance_green_beard", 0.4)
		simulation.chance_fake_green_beard = params.get("chance_fake_green_beard", 0.01)
		simulation.chance_pure_altruist = params.get("chance_pure_altruist", 0.3)
		simulation.chance_predator_eats = params.get("chance_predator_eats", 0.1)
		simulation.chance_altruistic_gets_eaten = params.get("chance_altruistic_gets_eaten", 0.2)
		simulation.chance_saved_gets_saved = params.get("chance_saved_gets_saved", 0.8)
		simulation.chance_cell_is_born = params.get("chance_cell_is_born", 0.2)
		simulation.generations_before_birth = params.get("generations_before_birth", 2)
		simulation.iterations = params.get("iterations", 2000)
		sleepTimer = params.get("sleep_timer", 0.0)
		enable_rendering = params.get("enable_rendering", true)
	
	# Setup graph (always, not just when params exist)
	$Graph2D.x_max = simulation.iterations
	$Graph2D.x_min = 0
	$Graph2D.y_max = simulation.row_count * simulation.column_count
	$Graph2D.y_min = 0
	plot_normal = $Graph2D.add_plot_item("", Cell.cell_type_to_color(Cell.AltruistType.Normal), 1.0)
	plot_green_beard = $Graph2D.add_plot_item("", Cell.cell_type_to_color(Cell.AltruistType.GreenBeard), 1.0)
	plot_fake_green_beard = $Graph2D.add_plot_item("", Cell.cell_type_to_color(Cell.AltruistType.FakeGreenBeard), 1.0)
	plot_pure_altruist = $Graph2D.add_plot_item("", Cell.cell_type_to_color(Cell.AltruistType.PureAltruist), 1.0)


	for column in range(simulation.column_count):
		simulation.cell_matrix.push_back([])
		for row in range(simulation.row_count):
			var cell = cell_scene.instantiate()
			cell.column = column
			cell.row = row
			cell.position = Vector2(column * cell_width, label_height + row * cell_width)
			cell.visible = enable_rendering
			simulation.cell_matrix[column].push_back(cell)
			add_child(cell)
	
	simulation.restart()
	update_info_label()

			
func is_edge(column, row):
	return row == 0 or column == 0 or row == simulation.row_count - 1 or column == simulation.column_count - 1

func _process(delta):
	if not _is_waiting:
		simulation_iteration()
	pass

func simulation_iteration():
	_is_waiting = true
	await get_tree().create_timer(sleepTimer).timeout
	
	if simulation.current_iteration > simulation.iterations + 1:
		_is_waiting = false
		return

	var label_text = ""
	if simulation.current_iteration == simulation.iterations + 1:
		label_text = "[shake][b]Simulation finished[/b][/shake] after [b]%d[/b] iterations" % simulation.iterations
	else:
		simulation.simulation_iteration()
		label_text = "[b]Simulation running[/b] [b]%d/%d[/b] iterations" % [simulation.current_iteration, simulation.iterations]
		simulation.refresh_stats()
		plot_normal.add_point(Vector2(simulation.current_iteration, simulation.amount_normal))
		plot_green_beard.add_point(Vector2(simulation.current_iteration, simulation.amount_green_beard))
		plot_fake_green_beard.add_point(Vector2(simulation.current_iteration, simulation.amount_fake_green_beard))
		plot_pure_altruist.add_point(Vector2(simulation.current_iteration, simulation.amount_pure_altruist))


	label_text += "\n[color=dodgerblue]Normal: %d[/color]\n[color=lawngreen]GreenBeard: %d[/color]\n[color=orange]Fakers: %d[/color]\n[color=ORCHID]Pure altruist: %d[/color]\n[color=gray]Dead: %d[/color]" % [
		simulation.amount_normal, simulation.amount_green_beard, simulation.amount_fake_green_beard, simulation.amount_pure_altruist, simulation.amount_dead]
	$InfoLabel.text = label_text

	_is_waiting = false

func update_info_label():
	var text = "Iteration: %d | Normal: %d | Green Beard: %d | Fake Green Beard: %d | Pure Altruist: %d | Dead: %d" % [
		simulation.current_iteration,
		simulation.amount_normal,
		simulation.amount_green_beard,
		simulation.amount_fake_green_beard,
		simulation.amount_pure_altruist,
		simulation.amount_dead
	]
	$InfoLabel.text = text

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
