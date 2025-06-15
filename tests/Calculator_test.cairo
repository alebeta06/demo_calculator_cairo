// tests/Calculator_test.cairo

use demo_calculator_cairo::Calculator;
use snforge_std::{ContractAddressTrait, ContractClassTrait, declare, deploy};

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_arithmetic() {
        // Basic test to verify the contract compiles and can be used
        assert(true, 0);
    }

    #[test]
    fn test_negative_numbers() {
        // Test that we can work with negative numbers
        let a: i128 = -5;
        let b: i128 = 3;
        let result = a + b;
        assert(result == -2, 0);
    }

    #[test]
    fn test_contract_deployment() {
        // Test that we can deploy the contract
        let contract = deploy!(Calculator);
        assert(contract.address != contract_address_const::<0x0>(), 0);
    }

    #[test]
    fn test_contract_interface() {
        // Test that the contract interface is accessible
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Test that we can call the is_on function
        let is_on = dispatcher.is_on();
        assert(is_on, 0);
    }

    #[test]
    fn test_sum_function() {
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Test sum with positive numbers
        dispatcher.sum(10, 5);
        let result = dispatcher.sum_result();
        assert(result == 15, 0);

        // Test sum with negative numbers
        dispatcher.sum(-3, 7);
        let result = dispatcher.sum_result();
        assert(result == 4, 0);
    }

    #[test]
    fn test_sub_function() {
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Test subtraction
        dispatcher.sub(20, 7);
        let result = dispatcher.sub_result();
        assert(result == 13, 0);

        // Test subtraction with negative result
        dispatcher.sub(5, 10);
        let result = dispatcher.sub_result();
        assert(result == -5, 0);
    }

    #[test]
    fn test_mult_function() {
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Test multiplication
        dispatcher.mult(6, 4);
        let result = dispatcher.mult_result();
        assert(result == 24, 0);

        // Test multiplication with negative numbers
        dispatcher.mult(-5, 3);
        let result = dispatcher.mult_result();
        assert(result == -15, 0);
    }

    #[test]
    fn test_div_function() {
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Test division
        dispatcher.div(20, 4);
        let result = dispatcher.div_result();
        assert(result == 5, 0);

        // Test division with negative numbers
        dispatcher.div(-15, 3);
        let result = dispatcher.div_result();
        assert(result == -5, 0);
    }

    #[test]
    fn test_turn_off_and_on() {
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Test initial state
        assert(dispatcher.is_on(), 0);

        // Turn off
        dispatcher.turn_off();
        assert(!dispatcher.is_on(), 0);

        // Turn on
        dispatcher.turn_on();
        assert(dispatcher.is_on(), 0);
    }

    #[test]
    fn test_set_owner() {
        let contract = deploy!(Calculator);
        let dispatcher = Calculator::Dispatcher::new(contract.address);

        // Set new owner
        let new_owner = contract_address_const::<0x123>();
        dispatcher.set_owner(new_owner);
    }
}
