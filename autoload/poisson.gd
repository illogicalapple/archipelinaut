extends Node

func generate(radius: float, region_size: Vector2, rng: RandomNumberGenerator, use_center: bool = false, limit: int = 20):
	var cell_size: float = radius / 1.41421
	var grid := []
	var points := []
	var spawn_points := []
	var center: Vector2 = region_size / 2
	spawn_points.append(center)
	for i in range(ceil(region_size.x / cell_size)):
		grid.append([])
		for j in range(ceil(region_size.y / cell_size)):
			grid[i].append(0)
	if use_center:
		points.append(center)
		grid[floor(center.x / cell_size)][floor(center.y / cell_size)] = len(points)
	while len(spawn_points) > 0:
		var spawn_index: int = 0
		var spawn_center: Vector2 = spawn_points[spawn_index]
		var accepted: bool = false
		for i in range(limit):
			var angle: float = rng.randf() * 6.28319
			var direction: Vector2 = Vector2(sin(angle), cos(angle))
			var candidate: Vector2 = spawn_center + direction * rng.randf_range(radius, 2 * radius)
			if is_valid(candidate, region_size, cell_size, radius, points, grid):
				points.append(candidate)
				spawn_points.append(candidate)
				grid[floor(candidate.x / cell_size)][floor(candidate.y / cell_size)] = len(points)
				accepted = true
				break
		if not accepted:
			spawn_points.remove_at(spawn_index)
	return points

func is_valid(candidate: Vector2, region_size: Vector2, cell_size: float, radius: float, points: Array, grid: Array):
	if candidate.x >= 0 and candidate.x < region_size.x and candidate.y >= 0 and candidate.y < region_size.y:
		var cell: Vector2i = Vector2i(candidate / cell_size)
		var search_start: Vector2i = Vector2i(max(0, cell.x - 2), max(0, cell.y - 2))
		var search_end: Vector2i = Vector2i(min(cell.x + 2, len(grid)), min(cell.y + 2, len(grid[0])))
		for x in range(search_start.x, search_end.x):
			for y in range(search_start.y, search_end.y):
				var point_index: int = grid[x][y] - 1
				if point_index != -1:
					var square_distance: float = candidate.distance_squared_to(points[point_index])
					if square_distance < radius * radius:
						return false
		return true
