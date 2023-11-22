using System;
using System.Collections.Generic;
using Godot;
using Godot.Collections;

namespace TargettingCalculations
{
    public class Utils
    {
        public static T? GetAncestorOfType<[MustBeVariant] T>(Node self, int maxDepth = 10)
            where T : Node
        {
            T result = null;
            Node currNode = self.GetParent();
            for (int i = 0; i < maxDepth; i++)
            {
                if (currNode is T)
                {
                    return (T)currNode;
                }
                currNode = currNode.GetParent();
            }
            return result;
        }
    }
}
