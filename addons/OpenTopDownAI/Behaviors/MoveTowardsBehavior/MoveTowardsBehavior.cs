using Godot;
using OpenTopDownAI;
using System;
using System.Collections.Generic;
using TargettingCalculations;

namespace OpenTopDownAI
{
    public partial class MoveTowardsBehavior : SteeringBehavior
    {
        Node2D rootObjectNode;

        [Export]
        Target target;

        [Export]
        public float smoothnessRadius = 10.0f;

        [Export]
        public float scalingPower = 1.0f;

        [Export]
        public float minDistance = 0.0f;

        [Export]
        public float maxDistance = 10.0f;

        public override void _Ready()
        {
            rootObjectNode = Utils.GetAncestorOfType<Node2D>(this);
        }

        public override List<float> CalculateWeights(List<Vector2> directions)
        {
            Vector2 diff = target.GetCalculatedPosition() - rootObjectNode.GlobalPosition;
            float dist = diff.Length();
            diff /= dist;
            List<float> weights = new List<float>();
            foreach (Vector2 potentialDirection in directions)
            {
                // 0 direction edge case and within bounds
                if (potentialDirection == Vector2.Zero)
                {
                    weights.Add(0.0f);
                }
                // Too close
                else if (dist < minDistance)
                {
                    weights.Add(
                        -weight
                            * CalculateStrengthByDist(minDistance - dist)
                            * potentialDirection.Normalized().Dot(diff)
                    );
                }
                // Too far
                else if (dist > maxDistance)
                {
                    weights.Add(
                        weight
                            * CalculateStrengthByDist(dist - maxDistance)
                            * potentialDirection.Normalized().Dot(diff)
                    );
                }
                // Within bounds, not 0
                else
                {
                    weights.Add(0.0f);
                }
            }

            return weights;
        }

        float CalculateStrengthByDist(float dist)
        {
            // If scalingPower is 0, the max strength will be 1. Scale linearly with 1, etc.
            float maxValue = Mathf.Pow(dist, scalingPower);
            return Utils.MapFloat(0, smoothnessRadius, 0, maxValue, dist, true);
        }
    }
}
