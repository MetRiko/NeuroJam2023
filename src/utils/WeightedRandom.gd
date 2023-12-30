extends Node
class_name WeightedRandom


static func pick_random(elements_weights: Dictionary):
    var weight_sum := 0.0
    for element in elements_weights:
        weight_sum += elements_weights[element]

    if weight_sum == 0.0:
        return elements_weights.keys().pick_random()
    
    var random := randf_range(0, weight_sum)
    for element in elements_weights:
        if random < elements_weights[element]:
            return element
        random -= elements_weights[element]
    
    return null
