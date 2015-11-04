using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MyConsoleApp {
    public class Program {
        public void Main(string[] args) {
            var keys = Environment.GetEnvironmentVariables();
            foreach(string key in Environment.GetEnvironmentVariables().Keys) {
                if (key.StartsWith("MVP") || key.StartsWith("Hosting:Environment")) {
                    Console.WriteLine($"'{key}'='{Environment.GetEnvironmentVariable(key)}'");
                }
            }
            Console.WriteLine("press enter to exit");
            Console.ReadLine();
        }
    }
}
