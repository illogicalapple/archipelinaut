using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using OpenTopDownAI;

public partial class NDirectionalAgent2D : Agent
{
    [Export]
    public int directions = 8;

    public override void _Ready()
    {
        base._Ready();
        directionsToTravel = GetLocalMapCoordinatesInCircle(1.0f, directions);
        directionsToTravel.Add(Vector2I.Zero);
        InitializeEmptyWeights();
    }
}
