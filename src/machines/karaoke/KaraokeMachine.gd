extends Node2D


var _notes_collected: int = 0
var notes_collected: int:
    get:
        return _notes_collected
    set(value):
        _notes_collected = value
        note_progress_bar.value = _notes_collected * 10

@export var notes_to_start: int

@export var note_tscn: PackedScene
@export var note_spawn_area: CollisionShape2D
@export var note_spawn_interval: float
@export var karaoke_duration: float

@onready var note_spawn_timer: Timer = $NoteSpawnTimer
@onready var karaoke_timer: Timer = $KaraokeTimer
@onready var note_progress_bar: TextureProgressBar = $NoteProgress
@onready var note_icon: Sprite2D = $NoteIcon

@export var off_color: Color
@export var available_color: Color
@export var active_color: Color

@export var max_notes_in_world: int = 3

var _active = false


func _ready():
    note_progress_bar.max_value = notes_to_start * 10
    note_progress_bar.value = 0
    note_spawn_timer.start(note_spawn_interval)
    note_spawn_timer.timeout.connect(spawn_note)

    note_icon.modulate = off_color


# func start_interacting():
#     if notes_collected >= notes_to_start and not _active:
#         start_karaoke()


func start_karaoke():
    _active = true
    notes_collected = 0
    karaoke_timer.start(karaoke_duration)
    note_icon.modulate = active_color
    Game.get_neuro_logic().update_karaoke_status(true)
    print("Karaoke start")

    await karaoke_timer.timeout

    print("Karaoke end")
    Game.get_neuro_logic().update_karaoke_status(false)
    note_icon.modulate = off_color
    _active = false


func spawn_note():
    if not _active and notes_collected < notes_to_start and get_tree().get_node_count_in_group("Note") < max_notes_in_world:
        var note_inst: Note = note_tscn.instantiate()
        var rect := note_spawn_area.shape.get_rect()
        var pos := Vector2(randf_range(rect.position.x, rect.position.x + rect.size.x), randf_range(rect.position.y, rect.position.y + rect.size.y))
        note_spawn_area.add_child(note_inst)
        note_inst.position = pos
        note_inst.destroy.connect(on_note_collected)


func on_note_collected():
    if not _active and notes_collected < notes_to_start:
        print("Note collected")
        notes_collected += 1
        if notes_collected >= notes_to_start:
            note_icon.modulate = available_color
            start_karaoke()
            
