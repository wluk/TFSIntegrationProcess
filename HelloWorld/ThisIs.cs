using System;
using System.Threading;

namespace HelloWorld
{
    class ThisIs
    {
        static void Main()
        {
            PrintMessage();
        }

        public static void PrintMessage()
        {
            var msg = "Hello world!";

            Console.WriteLine($"Show message: {msg}");

            Thread.Sleep(5000);
        }
    }
}
