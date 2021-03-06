# `change_scene path [enable_automatic_transition] [run_events]`
#
# Switches the current scene to another scene
#
# **Parameters**
#
# - *path*: Path of the new scene
# - *enable_automatic_transition*: Automatically transition to the new scene 
#   (default: `true`)
# - *run_events*: Run the standard ESC events of the new scene (default: `true`)
#
# @ESC
extends ESCBaseCommand
class_name ChangeSceneCommand


# Return the descriptor of the arguments of this command
func configure() -> ESCCommandArgumentDescriptor:
	return ESCCommandArgumentDescriptor.new(
		1, 
		[TYPE_STRING, TYPE_BOOL, TYPE_BOOL],
		[null, true, true]
	)
	
	
# Validate wether the given arguments match the command descriptor
func validate(arguments: Array) -> bool:
	if not ResourceLoader.exists(arguments[0]):
		escoria.logger.report_errors(
			"change_scene: Invalid scene", 
			["Scene %s was not found" % arguments[0]]
		)
		return false
	if not ResourceLoader.exists(
		ProjectSettings.get_setting("escoria/ui/game_scene")
	):
		escoria.logger.report_errors(
			"change_scene: Game scene not found", 
			[
				"The path set in 'ui/game_scene' was not found: %s" % \
						ProjectSettings.get_setting("escoria/ui/game_scene")
			]
		)
		return false
	return .validate(arguments)


# Run the command
func run(command_params: Array) -> int:
	escoria.logger.info(
		"Changing scene to %s (enable_automatic_transition = %s)" % [
		command_params[0],	# scene file
		command_params[1]	# enable_automatic_transition
	])
	
	escoria.room_manager.change_scene(command_params[0], command_params[1])
		
	return ESCExecution.RC_OK
