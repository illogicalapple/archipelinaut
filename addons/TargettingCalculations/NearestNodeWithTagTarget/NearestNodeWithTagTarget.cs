using Godot;
using System;
using TargettingCalculations;

namespace TargettingCalculations
{
    public partial class NearestNodeWithTagTarget : Target
    {
        [Export]
        public string group;

		Node2D rootObjectNode;

        public override void _Ready()
        {
			rootObjectNode = Utils.GetAncestorOfType<Node2D>(this);
            base._Ready();
        }

        public override Vector2 GetCalculatedPosition()
        {
			float distSquared = float.MaxValue;
			var nodes = GetTree().GetNodesInGroup(group);
			Node2D closestNode = null;
			foreach (Node node in nodes)
			{
				if (node is Node2D)
				{
					if (node != rootObjectNode) {
						float currDist = (node as Node2D).Position.DistanceSquaredTo(rootObjectNode.Position);
						if (currDist < distSquared) {
							distSquared = currDist;
							closestNode = node as Node2D;
						}
					}
					
				}
			}
            
            return closestNode?.Position ?? Vector2.Zero;
        }
    }
}
