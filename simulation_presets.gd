extends Node
class_name SimulationPresets

enum PresetType {
	BALANCED,
	GREEN_BEARD_DOMINANT,
	PURE_ALTRUIST_VS_NORMAL,
	HARSH_ENVIRONMENT,
	RAPID_EVOLUTION,
	CUSTOM
}

static func create_preset(preset_type: PresetType) -> Simulation:
	var sim = Simulation.new()
	
	match preset_type:
		PresetType.BALANCED:
			sim.row_count = 80
			sim.column_count = 80
			sim.chance_normal = 0.3
			sim.chance_green_beard = 0.4
			sim.chance_fake_green_beard = 0.05
			sim.chance_pure_altruist = 0.3
			sim.chance_predator_eats = 0.1
			sim.chance_altruistic_gets_eaten = 0.15
			sim.chance_saved_gets_saved = 0.7
			sim.chance_cell_is_born = 0.2
			sim.generations_before_birth = 2
			sim.iterations = 2000
			
		PresetType.GREEN_BEARD_DOMINANT:
			sim.row_count = 80
			sim.column_count = 80
			sim.chance_normal = 0.1
			sim.chance_green_beard = 0.7
			sim.chance_fake_green_beard = 0.1
			sim.chance_pure_altruist = 0.05
			sim.chance_predator_eats = 0.15
			sim.chance_altruistic_gets_eaten = 0.1
			sim.chance_saved_gets_saved = 0.9
			sim.chance_cell_is_born = 0.25
			sim.generations_before_birth = 2
			sim.iterations = 2000
			
		PresetType.PURE_ALTRUIST_VS_NORMAL:
			sim.row_count = 80
			sim.column_count = 80
			sim.chance_normal = 0.5
			sim.chance_green_beard = 0.0
			sim.chance_fake_green_beard = 0.0
			sim.chance_pure_altruist = 0.5
			sim.chance_predator_eats = 0.2
			sim.chance_altruistic_gets_eaten = 0.2
			sim.chance_saved_gets_saved = 0.8
			sim.chance_cell_is_born = 0.15
			sim.generations_before_birth = 3
			sim.iterations = 2000
			
		PresetType.HARSH_ENVIRONMENT:
			sim.row_count = 80
			sim.column_count = 80
			sim.chance_normal = 0.3
			sim.chance_green_beard = 0.3
			sim.chance_fake_green_beard = 0.1
			sim.chance_pure_altruist = 0.2
			sim.chance_predator_eats = 0.3
			sim.chance_altruistic_gets_eaten = 0.3
			sim.chance_saved_gets_saved = 0.5
			sim.chance_cell_is_born = 0.1
			sim.generations_before_birth = 4
			sim.iterations = 2000
			
		PresetType.RAPID_EVOLUTION:
			sim.row_count = 60
			sim.column_count = 60
			sim.chance_normal = 0.25
			sim.chance_green_beard = 0.25
			sim.chance_fake_green_beard = 0.15
			sim.chance_pure_altruist = 0.25
			sim.chance_predator_eats = 0.25
			sim.chance_altruistic_gets_eaten = 0.2
			sim.chance_saved_gets_saved = 0.6
			sim.chance_cell_is_born = 0.4
			sim.generations_before_birth = 1
			sim.iterations = 3000
	
	return sim
