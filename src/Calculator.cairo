use starknet::contract_address::ContractAddress;

#[starknet::interface]
trait ICalculator<TContractState> {
    fn set_owner(ref self: TContractState, new_owner: ContractAddress);
    fn is_on(self: @TContractState) -> bool;
    fn turn_off(ref self: TContractState);
    fn turn_on(ref self: TContractState);
    fn sum(ref self: TContractState, a: i128, b: i128);
    fn sub(ref self: TContractState, a: i128, b: i128);
    fn mult(ref self: TContractState, a: i128, b: i128);
    fn div(ref self: TContractState, a: i128, b: i128);
    fn sum_result(self: @TContractState) -> i128;
    fn sub_result(self: @TContractState) -> i128;
    fn mult_result(self: @TContractState) -> i128;
    fn div_result(self: @TContractState) -> i128;
}

#[starknet::contract]
mod Calculator {
    use starknet::get_caller_address;
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use super::ContractAddress;

    #[storage]
    struct Storage {
        is_on: bool,
        sum_result: i128,
        sub_result: i128,
        mult_result: i128,
        div_result: i128,
        owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.is_on.write(true);
        self.owner.write(get_caller_address());
    }

    #[external(v0)]
    fn set_owner(ref self: ContractState, new_owner: ContractAddress) {
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Only owner can set new owner');
        self.owner.write(new_owner);
    }

    #[external(v0)]
    fn turn_off(ref self: ContractState) {
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Only owner can turn off');
        self.is_on.write(false);
    }

    #[external(v0)]
    fn turn_on(ref self: ContractState) {
        let caller = get_caller_address();
        assert(caller == self.owner.read(), 'Only owner can turn on');
        self.is_on.write(true);
    }

    #[external(v0)]
    fn sum(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        self.sum_result.write(a + b);
    }

    #[external(v0)]
    fn sum_result(self: @ContractState) -> i128 {
        self.sum_result.read()
    }

    #[external(v0)]
    fn sub(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        self.sub_result.write(a - b);
    }

    #[external(v0)]
    fn sub_result(self: @ContractState) -> i128 {
        self.sub_result.read()
    }

    #[external(v0)]
    fn mult(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        self.mult_result.write(a * b);
    }

    #[external(v0)]
    fn mult_result(self: @ContractState) -> i128 {
        self.mult_result.read()
    }

    #[external(v0)]
    fn div(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        assert(b != 0, 'Division by zero');
        self.div_result.write(a / b);
    }

    #[external(v0)]
    fn div_result(self: @ContractState) -> i128 {
        self.div_result.read()
    }

    #[external(v0)]
    fn is_on(self: @ContractState) -> bool {
        self.is_on.read()
    }
}
