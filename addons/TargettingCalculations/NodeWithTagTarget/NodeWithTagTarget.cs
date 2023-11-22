using Godot;
using System;
using TargettingCalculations;

namespace TargettingCalculations
{
    public partial class NodeWithTagTarget : Target
    {
        Node2D targetObject;

        [Export]
        public string group;

        public override void _Ready()
        {
            base._Ready();
        }

        public override Vector2 GetCalculatedPosition()
        {
            if (targetObject == null)
            {
                var nodes = GetTree().GetNodesInGroup(group);
                foreach (Node node in nodes)
                {
                    if (node is Node2D)
                    {
                        targetObject = node as Node2D;
                        break;
                    }
                }
            }
            return targetObject?.Position ?? Vector2.Zero;
        }
    }
}
