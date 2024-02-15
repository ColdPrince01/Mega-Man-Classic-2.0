extends Node2D

const DEATH_PARTICLE = preload("res://LevelScenes/death_particle.tscn")

@export var death_particle_velocity := 30
@export var energy_particle_velocity := 120

var effects_node: Node

func spawn_death_particles(spawn_pos: Vector2):
	var death_particle: Node2D #temp var death particle will be type Node2D
	var world = get_tree().current_scene #world variable set equal to obtaining current scene tree
	for particle in range(8): #for loop to spawn 8 particles
		death_particle = DEATH_PARTICLE.instantiate() #death particle set equal to the constant's instantiation
		death_particle.initialize(spawn_pos, Vector2(1,0).rotated(particle * PI/4), death_particle_velocity) #rotates the energy particle by a factor of PI/4 (45 degrees) over every iteration
		world.add_child.call_deferred(death_particle) #adds death particle to the world
		
		death_particle = DEATH_PARTICLE.instantiate()
		death_particle.initialize(spawn_pos, Vector2(1,0).rotated(particle * PI/4), death_particle_velocity * 2) #spawns a faster wave of particles
		world.add_child.call_deferred(death_particle) #adds death particle to the world
