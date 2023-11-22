using Godot;
using System;
using System.Collections.Generic;

public abstract partial class SteeringBehavior : Node
{
    [Export]
    public float weight = 1.0f;
    public abstract List<float> CalculateWeights(List<Vector2> directions);
}
