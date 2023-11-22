using Godot;
using System.Collections.Generic;

public abstract partial class Unit<T> : Node
{
    public abstract void SetMoveDirection(T direction);
}
