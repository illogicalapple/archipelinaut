using Godot;

namespace TargettingCalculations
{
    public abstract partial class Target : Node
    {
        public abstract Vector2 GetCalculatedPosition();
    }
}
