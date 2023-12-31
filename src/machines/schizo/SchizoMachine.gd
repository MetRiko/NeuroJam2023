extends BaseMachine


@export var pill_tscn: PackedScene
@export var pill_spawnpoint: Node2D

@export var pill_spawn_time: float

@onready var pill_spawn_timer: Timer = $PillSpawnTimer

var active := false


func _ready():
    pill_spawn_timer.timeout.connect(_spawn_pill)
    Game.do_pause.connect(_on_pause)
    Game.do_start.connect(_on_start)
    Game.do_reset.connect(_on_reset)
    

func kill_pill():
    var pill = get_tree().get_first_node_in_group("SchizoPill")
    if pill != null:
        pill.queue_free()
    
    
func _on_pause():
    active = false
    pill_spawn_timer.stop()
    deactivate_machine()
    

func _on_start():
    activate_machine()
    

func _on_reset():
    kill_pill()
    active = false
    pill_spawn_timer.stop()


func _process(delta):
    if machine_active and get_tree().get_first_node_in_group("SchizoPill") == null and not active:
        active = true
        print("Spawn pill")
        pill_spawn_timer.start(pill_spawn_time)


func _spawn_pill():
    if machine_active:
        var pill_inst = pill_tscn.instantiate()
        add_child(pill_inst)
        pill_inst.position = pill_spawnpoint.position
        active = false
