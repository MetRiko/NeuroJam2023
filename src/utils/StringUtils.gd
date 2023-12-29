extends Node
class_name StringUtils


static func schizoify(input_str: String) -> String:
    var random := randf()
    var words := input_str.split(" ")
    var affected_word_idx := randi() % len(words)

    if random < 0.3:
        # Duplicate a word
        words.insert(affected_word_idx, words[affected_word_idx])
    elif random < 0.6:
        # Capitalize a word
        words[affected_word_idx] = words[affected_word_idx].to_upper()
    elif random < 0.8 and len(words) > 1:
        # Replace a word with another one
        var other_word_idx = affected_word_idx
        while other_word_idx == affected_word_idx:
            other_word_idx = randi() % len(words)
        words[affected_word_idx] = words[other_word_idx]
    else:
        # Duplicate letters within a word
        var letters = words[affected_word_idx].split("")
        var new_word := ""
        for letter in letters:
            new_word += letter
            new_word += letter
        
        words[affected_word_idx] = new_word
    
    return " ".join(words)
