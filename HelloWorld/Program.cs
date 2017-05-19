using System;
using System.Threading;

namespace HelloWorld
{
    class Program
    {
        static void Main()
        {
            var msg = "Hello world!";

            Console.WriteLine($"Show message: {msg}");

            Thread.Sleep(5000);
        }
    }
}
