extends Resource
class_name Simulation


@export var row_count: int = 20
@export var column_count: int = 20
@export var chance_normal: float = 0.5
@export var chance_green_beard: float = 0.5
@export var chance_fake_green_beard: float = 0.0
@export var chance_leecher: float = 0.0
@export var chance_purple: float = 0.0
@export var chance_predator_eats: float = 0.1
@export var chance_altruistic_gets_eaten: float = 0.3
@export var chance_saved_gets_saved: float = 1.0
@export var chance_cell_is_born: float = 0.1

@export var iterations: int = 100

var cell_matrix: Array = []
var previous_cell_states: Array = []


var rng = RandomNumberGenerator.new()


func _init():
	rng.randomize()

func get_cell_type_by_chance() -> int:
	var roll = rng.randf()
	# normalize chances since they might not add up to 1
	var total = chance_normal + chance_green_beard + chance_fake_green_beard + chance_leecher + chance_purple
	var normalized_normal = chance_normal / total
	var normalized_green_beard = chance_green_beard / total
	var normalized_fake_green_beard = chance_fake_green_beard / total
	var normalized_leecher = chance_leecher / total
	var normalized_purple = chance_purple / total
	if roll < normalized_normal:
		return 0 # Normal
	elif roll < normalized_normal + normalized_green_beard:
		return 1 # GreenBeard
	else:
		return 3 # FakeGreenBeard

func simulation_iteration():
	previous_cell_states = []
	for column in range(column_count):
		previous_cell_states.push_back([])
		for row in range(row_count):
			previous_cell_states[column].push_back(cell_matrix[column][row].CellType)
			
	for column in range(1, column_count - 1):
		for row in range(1, row_count - 1):
			var cell = cell_matrix[column][row]
			var current = previous_cell_states[column][row]

			if current == cell.AltruistType.Dead:
				if rng.randf() < chance_cell_is_born:
					cell.CellType = get_cell_type_by_chance()
				continue
		
			# is an altruist nearby
			var altruist_nearby = false
			var altruist_cell
			for x in range(-1, 2):
				for y in range(-1, 2):
					if not (x == 0 and y == 0):
						var neighbour_type = previous_cell_states[column + x][row + y]
						if neighbour_type == cell.AltruistType.GreenBeard:
							altruist_nearby = true
							altruist_cell = cell_matrix[column + x][row + y]
							break

			# eat, chance to be eaten
			if rng.randf() < chance_predator_eats:
				if altruist_nearby:
					# chance to save neighbour
					if rng.randf() < chance_saved_gets_saved:
						# saved
						if rng.randf() < chance_altruistic_gets_eaten:
							# altruist gets eaten
							altruist_cell.CellType = altruist_cell.AltruistType.Dead
					else:
						# not saved, original cell dies
						cell.cell_type = cell.AltruistType.Dead
				cell.CellType = cell.AltruistType.Dead


var amount_normal: int = 0
var amount_green_beard: int = 0
var amount_leecher: int = 0
var amount_fake_green_beard: int = 0
var amount_purple: int = 0
var amount_dead: int = 0
var current_iteration: int = 0

func refresh_stats():
	current_iteration += 1
	amount_normal = 0
	amount_green_beard = 0
	amount_leecher = 0
	amount_fake_green_beard = 0
	amount_purple = 0
	amount_dead = 0
	for column in range(column_count):
		for row in range(row_count):
			var cell = cell_matrix[column][row]
			match cell.CellType:
				cell.AltruistType.Normal:
					amount_normal += 1
				cell.AltruistType.GreenBeard:
					amount_green_beard += 1
				cell.AltruistType.Leecher:
					amount_leecher += 1
				cell.AltruistType.FakeGreenBeard:
					amount_fake_green_beard += 1
				cell.AltruistType.Purple:
					amount_purple += 1
				cell.AltruistType.Dead:
					amount_dead += 1
