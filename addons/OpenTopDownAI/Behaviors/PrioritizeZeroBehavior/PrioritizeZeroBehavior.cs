using Godot;
using OpenTopDownAI;
using System;
using System.Collections.Generic;
using TargettingCalculations;

namespace OpenTopDownAI
{
    public partial class PrioritizeZeroBehavior : SteeringBehavior
    {
        public override List<float> CalculateWeights(List<Vector2> directions)
        {
            List<float> result = new List<float>();
            for (int i = 0; i < directions.Count; i++)
            {
                // 0 should map to 1, distance of 1 should map to 0
                result.Add(weight * (2.0f / (directions[i].LengthSquared() + 1.0f) - 1.0f));
            }
            return result;
        }
    }
}
