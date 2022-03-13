class_name EnemySpawner extends Node2D


# Public variables

export(Array, PackedScene) var possible_enemies: Array


# Public method

func spawn() -> Enemy:
	var instance: Enemy = possible_enemies[randi() % possible_enemies.size()].instance()
	instance.position = position

	return instance
