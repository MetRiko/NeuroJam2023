extends Interactable

@export var cookie_tscn: PackedScene


func start_interacting():
    var cookie_inst: Cookie = cookie_tscn.instantiate()
    add_child(cookie_inst)

    (get_tree().get_first_node_in_group("Player") as Player).connect_joint(cookie_inst)

