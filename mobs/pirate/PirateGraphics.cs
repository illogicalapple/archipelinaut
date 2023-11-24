using Godot;
using System;

public partial class PirateGraphics : Node
{
	[Export] public Area2D islandCollider;
	[Export] public Texture2D swimmingSprite;
	[Export] public Texture2D standingSprite;

	[Export] public Sprite2D bodySprite;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (islandCollider.HasOverlappingAreas()) {
			bodySprite.Texture = standingSprite;
		}
		else {
			bodySprite.Texture = swimmingSprite;
		}
	}
}
