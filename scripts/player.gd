extends CharacterBody3D
class_name RPGPlayer

signal health_changed(value: int)
signal died

@export var speed := 6.0
@export var max_health := 100
var health := 100
var attack_cooldown := 0.0
var invulnerability := 0.0
var mobile_vector := Vector2.ZERO
var camera: Camera3D
var mesh: MeshInstance3D

func _ready() -> void:
 add_to_group("player")
 health = max_health
 var shape := CollisionShape3D.new()
 var capsule := CapsuleShape3D.new()
 capsule.radius = 0.42
 capsule.height = 1.8
 shape.shape = capsule
 shape.position.y = 0.9
 add_child(shape)
 mesh = MeshInstance3D.new()
 var body := CapsuleMesh.new()
 body.radius = 0.42
 body.height = 1.8
 mesh.mesh = body
 mesh.position.y = 0.9
 var mat := StandardMaterial3D.new()
 mat.albedo_color = Color(0.22, 0.68, 0.95)
 mesh.material_override = mat
 add_child(mesh)
 camera = Camera3D.new()
 camera.position = Vector3(0, 10, 13)
 camera.rotation_degrees.x = -37
 camera.current = true
 add_child(camera)
 health_changed.emit(health)

func _physics_process(delta: float) -> void:
 attack_cooldown = maxf(0.0, attack_cooldown - delta)
 invulnerability = maxf(0.0, invulnerability - delta)
 var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
 if mobile_vector.length() > 0.01:
  input_dir = mobile_vector
 var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
 velocity.x = direction.x * speed
 velocity.z = direction.z * speed
 velocity.y -= 24.0 * delta if not is_on_floor() else velocity.y
 if direction.length() > 0.01:
  mesh.rotation.y = atan2(direction.x, direction.z)
 move_and_slide()
 if Input.is_action_just_pressed("attack"):
  attack()

func attack() -> void:
 if attack_cooldown > 0.0:
  return
 attack_cooldown = 0.45
 for enemy in get_tree().get_nodes_in_group("enemies"):
  if not is_instance_valid(enemy):
   continue
  var offset: Vector3 = enemy.global_position - global_position
  if offset.length() <= 2.3:
   enemy.take_damage(25)

func take_damage(amount: int) -> void:
 if invulnerability > 0.0:
  return
 invulnerability = 0.7
 health = maxi(0, health - amount)
 health_changed.emit(health)
 if health == 0:
  died.emit()
  health = max_health
  global_position = Vector3(0, 0.15, 0)
  health_changed.emit(health)







