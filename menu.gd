extends Control


func _on_start_button_pressed():
	# Gather all parameters
	var params = {
		"row_count": $ScrollContainer/VBoxContainer/RowCount/SpinBox.value,
		"column_count": $ScrollContainer/VBoxContainer/ColumnCount/SpinBox.value,
		"chance_normal": $ScrollContainer/VBoxContainer/ChanceNormal/SpinBox.value,
		"chance_green_beard": $ScrollContainer/VBoxContainer/ChanceGreenBeard/SpinBox.value,
		"chance_fake_green_beard": $ScrollContainer/VBoxContainer/ChanceFakeGreenBeard/SpinBox.value,
		"chance_pure_altruist": $ScrollContainer/VBoxContainer/ChancePureAltruist/SpinBox.value,
		"chance_predator_eats": $ScrollContainer/VBoxContainer/ChancePredatorEats/SpinBox.value,
		"chance_altruistic_gets_eaten": $ScrollContainer/VBoxContainer/ChanceAltruisticGetsEaten/SpinBox.value,
		"chance_saved_gets_saved": $ScrollContainer/VBoxContainer/ChanceSavedGetsSaved/SpinBox.value,
		"chance_cell_is_born": $ScrollContainer/VBoxContainer/ChanceCellIsBorn/SpinBox.value,
		"generations_before_birth": $ScrollContainer/VBoxContainer/GenerationsBeforeBirth/SpinBox.value,
		"iterations": $ScrollContainer/VBoxContainer/Iterations/SpinBox.value,
		"sleep_timer": $ScrollContainer/VBoxContainer/SleepTimer/SpinBox.value,
		"enable_rendering": $ScrollContainer/VBoxContainer/EnableRendering/CheckBox.button_pressed
	}
	
	# Store parameters globally
	GameManager.simulation_params = params
	
	# Change to game scene
	get_tree().change_scene_to_file("res://game.tscn")
