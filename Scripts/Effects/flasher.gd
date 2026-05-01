class_name Flasher extends Effector

var flash_material: Material : set = set_flash_material

var previous_material: Material

func flash(duration: float = 0.2) -> void:
	assert(target is CanvasItem, "The target on your flasher isn't set")
	
	if target.material != flash_material:
		previous_material = target.material
	
	target.material = flash_material
	
	await target.get_tree().create_timer(duration).timeout
	
	if is_instance_valid(target):
		target.material = previous_material


func set_flash_material(value: Material) -> Flasher:
	flash_material = value
	return self 


func set_color(color: Color) -> Flasher:
	flash_material = flash_material.duplicate() as ShaderMaterial
	flash_material.set_shader_parameter("flash_color", color)
	return self