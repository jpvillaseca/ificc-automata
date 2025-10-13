extends Resource
class_name Simulation


@export var row_count: int = 20 # including edges
@export var column_count: int = 20 # including edges
@export var chance_normal: float = 0.5 # chance a cell is a normal cell
@export var chance_green_beard: float = 0.5 # chance a cell is a green beard
@export var chance_fake_green_beard: float = 0.0 # chance a cell is a fake green beard
@export var chance_pure_altruist: float = 0.5 # chance a cell is a pure altruist
@export var chance_predator_eats: float = 0.1 # chance that a cell is eaten by a predator
@export var chance_altruistic_gets_eaten: float = 0.3 # chance that an altruistic cell gets eaten when saving another
@export var chance_saved_gets_saved: float = 1.0 # chance that a saved cell is saved again
@export var chance_cell_is_born: float = 0.1 # chance a dead cell is reborn
@export var generations_before_birth: int = 3 # how many generations a cell must be dead before it can be born again

@export var iterations: int = 100

var cell_matrix: Array = []
var previous_cell_states: Array = []


var rng = RandomNumberGenerator.new()


func _init():
	rng.randomize()

func is_edge(column, row):
	return row == 0 or column == 0 or row == row_count - 1 or column == column_count - 1


func get_cell_type_by_chance() -> int:
	var roll = rng.randf()
	# normalize chances since they might not add up to 1
	var total = chance_normal + chance_green_beard + chance_fake_green_beard + chance_pure_altruist
	var normalized_normal = chance_normal / total
	var normalized_green_beard = chance_green_beard / total
	var normalized_fake_green_beard = chance_fake_green_beard / total
	var normalized_pure_altruist = chance_pure_altruist / total
	if roll < normalized_normal:
		return Cell.AltruistType.Normal
	elif roll < normalized_normal + normalized_green_beard:
		return Cell.AltruistType.GreenBeard
	elif roll < normalized_normal + normalized_green_beard + normalized_fake_green_beard:
		return Cell.AltruistType.FakeGreenBeard
	elif roll < normalized_normal + normalized_green_beard + normalized_fake_green_beard + normalized_pure_altruist:
		return Cell.AltruistType.PureAltruist
	return Cell.AltruistType.Normal

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

			# dead cell, chance to be born
			if current == Cell.AltruistType.Dead:
				cell.generations_dead += 1
				if cell.generations_dead <= generations_before_birth:
					continue
				if rng.randf() < chance_cell_is_born:
					cell.CellType = get_cell_type_by_chance()
					cell.generations_dead = 0
				continue
		
			# theres an altruist nearby
			var altruist_nearby = false
			var altruist_cell
			for x in range(-1, 2):
				for y in range(-1, 2):
					if not (x == 0 and y == 0):
						var neighbour_type = previous_cell_states[column + x][row + y]
						# neighbor will help if:
						# - is pure altruist
						# - is green beard and current is green beard or fake green beard
						if neighbour_type == Cell.AltruistType.PureAltruist || neighbour_type == Cell.AltruistType.GreenBeard && (current == Cell.AltruistType.FakeGreenBeard || current == Cell.AltruistType.GreenBeard):
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
							altruist_cell.CellType = Cell.AltruistType.Dead
					else:
						# not saved, original cell dies
						cell.CellType = Cell.AltruistType.Dead
				cell.CellType = Cell.AltruistType.Dead


var amount_normal: int = 0
var amount_green_beard: int = 0
var amount_fake_green_beard: int = 0
var amount_pure_altruist: int = 0
var amount_dead: int = 0
var current_iteration: int = 0

func refresh_stats():
	current_iteration += 1
	amount_normal = 0
	amount_green_beard = 0
	amount_fake_green_beard = 0
	amount_pure_altruist = 0
	amount_dead = 0
	for column in range(column_count):
		for row in range(row_count):
			var cell = cell_matrix[column][row]
			match cell.CellType:
				Cell.AltruistType.Normal:
					amount_normal += 1
				Cell.AltruistType.GreenBeard:
					amount_green_beard += 1
				Cell.AltruistType.FakeGreenBeard:
					amount_fake_green_beard += 1
				Cell.AltruistType.PureAltruist:
					amount_pure_altruist += 1
				Cell.AltruistType.Dead:
					amount_dead += 1

	# update chances based on current stats
	var total_alive = amount_normal + amount_green_beard + amount_fake_green_beard + amount_pure_altruist
	if total_alive == 0:
		chance_normal = 0.0
		chance_green_beard = 0.0
		chance_fake_green_beard = 0.0
		chance_pure_altruist = 0.0
	else:
		chance_normal = float(amount_normal) / total_alive
		chance_green_beard = float(amount_green_beard) / total_alive
		chance_fake_green_beard = float(amount_fake_green_beard) / total_alive
		chance_pure_altruist = float(amount_pure_altruist) / total_alive
