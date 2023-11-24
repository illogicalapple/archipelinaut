using Godot;
using System;

public partial class PirateMovement : Unit2D
{
	[Export]
	public Area2D islandCollider;

	[Export]
	public float swimSpeed;

	[Export]
	public float walkSpeed;

	public override void _Process(double _delta)
    {
        if (islandCollider.HasOverlappingAreas()) {
			speed = walkSpeed;
		}
		else {
			speed = swimSpeed;
		}
		
		base._Process(_delta);
    }
}
