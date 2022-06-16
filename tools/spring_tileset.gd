tool
extends TileSet


const GRASS = 0
const DIRT = 1
const FARMLAND = 2
const WETDIRT = 7
const TILLABLEWETDIRT = 8
const WATER = 9

var binds = {
	GRASS : [DIRT, WETDIRT, WATER],
	DIRT : [GRASS, WETDIRT, WATER],
	WETDIRT : [DIRT, GRASS, WATER],
	WATER : [GRASS, DIRT, WETDIRT]
}

func _is_tile_bound(id, neighborId):
	return neighborId in binds[id]
