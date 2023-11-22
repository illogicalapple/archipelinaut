using Godot;
using OpenTopDownAI;
using System.Collections.Generic;

public partial class Unit2D : Unit<Vector2>
{
    [Export]
    public float speed = 200.0f;
    private Vector2 moveDirection = Vector2.Zero;

    public override void SetMoveDirection(Vector2 direction)
    {
        moveDirection = direction;
    }

    public override void _Process(double _delta)
    {
        float delta = (float)_delta;
        Utils.GetAncestorOfType<Node2D>(this).Position += delta * speed * moveDirection;
    }
}
