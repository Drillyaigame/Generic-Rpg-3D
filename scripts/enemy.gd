extends CharacterBody3D
class_name RPGEnemy

signal defeated
var health := 50
var speed := 2.5
var attack_timer := 0.0
var target: RPGPlayer

func _ready() -> void:
 add_to_group("enemies")
 var collision := CollisionShape3D.new()
 var shape := CapsuleShape3D.new()
 shape.radius = 0.45
 shape.height = 1.5
 collision.shape = shape
 collision.position.y = 0.75
 add_child(collision)
 var model := MeshInstance3D.new()
 var mesh := CapsuleMesh.new()
 mesh.radius = 0.45
 mesh.height = 1.5
 model.mesh = mesh
 model.position.y = 0.75
 var material := StandardMaterial3D.new()
 material.albedo_color = Color(0.85, 0.15, 0.22)
 model.material_override = material
 add_child(model)
 target = get_tree().get_first_node_in_group("player") as RPGPlayer

func _physics_process(delta: float) -> void:
 if not is_instance_valid(target):
  return
 attack_timer = maxf(0.0, attack_timer - delta)
 var difference := target.global_position - global_position
 var distance := difference.length()
 if distance < 13.0 and distance > 1.4:
  var direction := difference.normalized()
  velocity.x = direction.x * speed
  velocity.z = direction.z * speed
 else:
  velocity.x = 0.0
  velocity.z = 0.0
 if not is_on_floor():
  velocity.y -= 24.0 * delta
 move_and_slide()
 if distance < 1.8 and attack_timer <= 0.0:
  attack_timer = 1.1
  target.take_damage(10)

func take_damage(amount: int) -> void:
 health -= amount
 if health <= 0:
  defeated.emit()
  queue_free()







