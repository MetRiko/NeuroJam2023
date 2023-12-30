extends VBoxContainer

@onready var filter_label: Label = $FilterLabel
@onready var schizo_label: Label = $SchizoLabel
@onready var sleepy_label: Label = $SleepyLabel
@onready var justice_label: Label = $JusticeLabel
@onready var emotional_label: Label = $EmotionalLabel
@onready var donowall_label: Label = $DonowallLabel
@onready var karaoke_label: Label = $KaraokeLabel
@onready var sleep_label: Label = $SleepLabel


func _process(delta):
    filter_label.text = "Filter power: %s" % Game.get_neuro_logic().filter_power
    schizo_label.text = "Schizo power: %s" % Game.get_neuro_logic().schizo_power
    sleepy_label.text = "Sleepy power: %s" % Game.get_neuro_logic().sleepy_power
    justice_label.text = "Justice factor: %s" % Game.get_neuro_logic().justice_factor
    emotional_label.text = "Emotional state: %s" % Game.get_neuro_logic().emotional_state
    donowall_label.text = "Donowall power: %s" % Game.get_neuro_logic().donowall_power
    karaoke_label.text = "Karaoke active: %s" % Game.get_neuro_logic().karaoke_active
    sleep_label.text = "Sleep active: %s" % Game.get_neuro_logic().sleep_active
