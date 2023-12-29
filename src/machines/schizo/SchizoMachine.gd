extends Node2D


@export var pill_tscn: PackedScene
@export var pill_spawnpoint: Node2D

@export var pill_spawn_time: float

@onready var pill_spawn_timer: Timer = $PillSpawnTimer

var active := false


func _process(delta):
    if get_tree().get_first_node_in_group("SchizoPill") == null and not active:
        active = true
        print("Spawn pill")
        pill_spawn_timer.start(pill_spawn_time)
        await pill_spawn_timer.timeout

        var pill_inst = pill_tscn.instantiate()
        add_child(pill_inst)
        pill_inst.position = pill_spawnpoint.position
        active = false
