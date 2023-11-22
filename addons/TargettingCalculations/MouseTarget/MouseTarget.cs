using Godot;
using TargettingCalculations;

namespace TargettingCalculations
{
    public partial class MouseTarget : Target
    {
        public override Vector2 GetCalculatedPosition()
        {
            return Utils.GetAncestorOfType<Node2D>(this).GetGlobalMousePosition();
        }
    }
}
