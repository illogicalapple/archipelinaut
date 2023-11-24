using Godot;
using OpenTopDownAI;
using System;
using System.Collections.Generic;

public partial class AvoidCollisionsWithArea2DsBehavior : SteeringBehavior
{
	List<Vector2> directionsToCheck;
	List<Area2D> area2Ds;

	Node2D rootObjectNode;
	
	[Export]
	public float circleDistance = 100.0f;

	[Export]
	public float colliderRadius = 40.0f;

	[Export(PropertyHint.Layers2DPhysics)]
	public uint layer;
	[Export(PropertyHint.Layers2DPhysics)]
	public uint mask;

	[Export]
	float weightOnCollision = 0.0f;
	[Export]
	float weightOnNoCollision = 1.0f;


	NDirectionalAgent2D agent;

    public override void _Ready()
    {
		agent = GetParent<NDirectionalAgent2D>();
		
        rootObjectNode = Utils.GetAncestorOfType<Node2D>(this);
		directionsToCheck = new List<Vector2>();
		area2Ds = new List<Area2D>();


		foreach (Vector2 direction in agent.GetDirectionVectors()) {
			var scaledDirection = direction * circleDistance;
			directionsToCheck.Add(scaledDirection);
			var shape = new CollisionShape2D();
			var circleShape = new CircleShape2D();
			var area2D = new Area2D();
			area2D.CollisionMask = mask;
			area2D.CollisionLayer = layer;
			circleShape.Radius = colliderRadius;
			shape.Shape = circleShape;
			area2D.CallDeferred("add_child", shape);
			rootObjectNode.CallDeferred("add_child", area2D);
			area2D.CallDeferred("set_global_position", rootObjectNode.Position);
			shape.CallDeferred("set_global_position", rootObjectNode.Position + scaledDirection);
			area2Ds.Add(area2D);
		}
        
    }

	public override List<float> CalculateWeights(List<Vector2> directions) {
		var weights = new List<float>();
		foreach (Area2D area in area2Ds) {
			if (area.HasOverlappingAreas()) {
				weights.Add(weightOnCollision * weight);
			}
			else {
				weights.Add(weightOnNoCollision * weight);
			}
		}
		return weights;
	}
}
