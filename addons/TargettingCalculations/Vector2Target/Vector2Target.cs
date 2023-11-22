using Godot;
using System;
using TargettingCalculations;

namespace TargettingCalculations
{
    public partial class Vector2Target : Target
    {
        [Export]
        public Vector2 targetPosition;

        public override Vector2 GetCalculatedPosition()
        {
            return targetPosition;
        }
    }
}
