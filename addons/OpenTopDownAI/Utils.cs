using System;
using System.Collections.Generic;
using Godot;
using Godot.Collections;
using System.Diagnostics;
using System.Linq;
using OpenTopDownAI;

namespace OpenTopDownAI
{
    public class Utils
    {
        public static List<T> GetChildrenOfType<[MustBeVariant] T>(Node parent)
            where T : Node
        {
            List<T> items = new List<T>();
            foreach (Node child in parent.GetChildren())
            {
                if (child is T)
                {
                    items.Add(child as T);
                }
            }

            return items;
        }

        public static T? GetChildOfType<[MustBeVariant] T>(Node parent)
            where T : Node
        {
            var result = Utils.GetChildrenOfType<T>(parent);
            return result.Count > 0 ? result[0] : null;
        }

        public static I GetChildOfInterfaceType<[MustBeVariant] T, I>(Node parent)
            where T : Node
            where I : class
        {
            var results = Utils.GetChildrenOfType<T>(parent);
            foreach (T result in results)
            {
                if (result is I)
                {
                    return result as I;
                }
            }
            return default;
        }

        public static List<I> GetChildrenOfInterfaceType<[MustBeVariant] T, I>(Node parent)
            where T : Node
            where I : class
        {
            var nodes = Utils.GetChildrenOfType<T>(parent);
            List<I> result = new List<I>();
            foreach (T node in nodes)
            {
                if (node is I)
                {
                    result.Add(node as I);
                }
            }
            return result;
        }

        public static I GetSiblingOfInterfaceType<[MustBeVariant] T, I>(Node node)
            where T : Node
            where I : class
        {
            return GetChildOfInterfaceType<T, I>(node.GetParent());
        }

        public static T? GetSiblingOfType<[MustBeVariant] T>(Node self)
            where T : Node
        {
            if (self is T)
            {
                return (T)self;
            }
            return GetChildOfType<T>(self.GetParent());
        }

        public static T? GetAncestorSiblingOfType<[MustBeVariant] T>(Node self, int maxDepth = 10)
            where T : Node
        {
            T result = null;
            Node currNode = self.GetParent();
            for (int i = 0; i < maxDepth; i++)
            {
                result = GetSiblingOfType<T>(currNode);
                if (result != null)
                {
                    return result;
                }
                currNode = currNode.GetParent();
            }
            return result;
        }

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

        public static Node2D GetClosestNodeInGroup(SceneTree tree, Vector2 position, string group)
        {
            Array<Node> nodes = tree.GetNodesInGroup(group);

            Node2D closest = null;
            if (nodes.Count > 0)
            {
                float closestDist = float.MaxValue;
                foreach (Node node in nodes)
                {
                    float distSqr = ((node as Node2D).GlobalPosition - position).LengthSquared();
                    if (distSqr < closestDist)
                    {
                        closestDist = distSqr;
                        closest = node as Node2D;
                    }
                }
            }

            return closest;
        }

        // Maps a float that is between [fromMin, fromMax] to the range [toMin, toMax].
        // For example, MapFloat(10,20, 0,10, 15) => 5
        public static float MapFloat(
            float fromMin,
            float fromMax,
            float toMin,
            float toMax,
            float fromValue,
            bool clamp = false
        )
        {
            float percent = (fromValue - fromMin) / (fromMax - fromMin);
            if (clamp)
            {
                percent = Mathf.Max(Mathf.Min(1.0f, percent), 0.0f);
            }
            return toMin + (toMax - toMin) * percent;
        }

        // Useful for spreading out expensive calculations that don't need to happen every frame, but still need to run frequently.
        public static Timer RepeatFunctionOnTimer(Node node, float waitTime, Action callback)
        {
            var timer = new Godot.Timer();
            timer.OneShot = false; // Make sure it loops
            timer.WaitTime = waitTime;
            node.AddChild(timer);
            timer.Timeout += () =>
            {
                callback();
            };
            timer.Start();
            return timer;
        }

        public static List<T> SortListByWeights<T>(List<T> values, List<float> weights)
        {
            System.Collections.Generic.Dictionary<T, float> weightMap =
                new System.Collections.Generic.Dictionary<T, float>();
            for (int i = 0; i < values.Count; i++)
            {
                weightMap.Add(values[i], weights[i]);
            }
            values.Sort(
                delegate(T item1, T item2)
                {
                    return weightMap[item1] > weightMap[item2] ? -1 : 1;
                }
            );

            return values;
        }
    }
}
