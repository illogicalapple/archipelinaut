using Godot;
using OpenTopDownAI;
using System;
using System.Collections.Generic;
using TargettingCalculations;

namespace OpenTopDownAI
{
    public partial class SmoothWeightsBehavior : SteeringBehavior
    {
        Agent agent;

        public override void _Ready()
        {
            agent = Utils.GetAncestorOfType<Agent>(this);
        }

        public override List<float> CalculateWeights(List<Vector2> directions)
        {
            List<float> result = agent.GetWeights();
            float maxWeight = float.MinValue;
            for (int i = 0; i < result.Count; i++)
            {
                maxWeight = Mathf.Max(maxWeight, result[i]);
            }

            // Not really sure what happens when it's less than 0, but it doesn't sound good.
            if (maxWeight > 0.0f)
            {
                for (int i = 0; i < result.Count; i++)
                {
                    result[i] *= weight / maxWeight;
                }
            }

            return result;
        }
    }
}
