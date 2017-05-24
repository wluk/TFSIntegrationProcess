using System;
using System.Linq;
using Machine.Specifications;

namespace WebAppCI.Tests
{
    internal class MSpecTest
    {
        [Subject("MSpec - adding two operands")]
        public class when_adding_two_operands
        {
            private static decimal value;

            private Establish context = () =>
            {
                value = 0m;
                Console.WriteLine($"Value before: {value}");
            };


            private Because of = () =>
            {
                value = new Operator().Add(42m, 42m);
                Console.WriteLine($"Value before: {value}");
            };


            private It should_add_both_operands = () =>
            {
                value.Equals(84.0m);
                Console.WriteLine($"Value: {value} schould be 84");
            };
        }

        [Subject("MSpec - adding multiple operands")]
        public class when_adding_multiple_operands
        {
            private static decimal value;

            private Establish context = () =>
            {
                value = 0m;
                Console.WriteLine($"Value before: {value}");
            };

            private Because of = () =>
            {
                value = new Operator().Add(42m, 42m, 42m);
                Console.WriteLine($"Value before: {value}");
            };

            private It should_add_all_operands = () =>
            {
                value.Equals(126m);
                Console.WriteLine($"Value: {value} schould be 126");
            };
        }
    }

    public class Operator
    {
        public decimal Add(decimal firstOperand, decimal secondOperand)
        {
            return firstOperand + secondOperand;
        }

        public decimal Add(params decimal[] operands)
        {
            return operands.Sum();
        }
    }
}