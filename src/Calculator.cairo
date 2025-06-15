// Importamos la librería de direcciones de contratos de Starknet
use starknet::contract_address::ContractAddress;

// ===== INTERFAZ DEL CONTRATO =====
// Definimos la interfaz que otros contratos pueden usar para interactuar con este
#[starknet::interface]
trait ICalculator<TContractState> {
    // Funciones de control de ownership
    fn set_owner(ref self: TContractState, new_owner: ContractAddress);
    fn is_on(self: @TContractState) -> bool;
    fn turn_off(ref self: TContractState);
    fn turn_on(ref self: TContractState);

    // Funciones de operaciones aritméticas
    fn sum(ref self: TContractState, a: i128, b: i128);
    fn sub(ref self: TContractState, a: i128, b: i128);
    fn mult(ref self: TContractState, a: i128, b: i128);
    fn div(ref self: TContractState, a: i128, b: i128);

    // Funciones para obtener resultados de las operaciones
    fn sum_result(self: @TContractState) -> i128;
    fn sub_result(self: @TContractState) -> i128;
    fn mult_result(self: @TContractState) -> i128;
    fn div_result(self: @TContractState) -> i128;
}

// ===== CONTRATO PRINCIPAL =====
#[starknet::contract]
mod Calculator {
    // Importamos las funciones necesarias de Starknet
    use starknet::get_caller_address; // Para obtener la dirección del caller
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess,
    }; // Para acceso al storage
    use super::ContractAddress; // Importamos ContractAddress del módulo padre

    // ===== ESTRUCTURA DE STORAGE =====
    // Define qué datos se almacenan en el contrato
    #[storage]
    struct Storage {
        is_on: bool, // Estado del calculador (encendido/apagado)
        sum_result: i128, // Resultado de la última suma
        sub_result: i128, // Resultado de la última resta
        mult_result: i128, // Resultado de la última multiplicación
        div_result: i128, // Resultado de la última división
        owner: ContractAddress // Dirección del propietario del contrato
    }

    // ===== CONSTRUCTOR =====
    // Se ejecuta cuando se despliega el contrato
    #[constructor]
    fn constructor(ref self: ContractState) {
        // Inicializamos el calculador como encendido
        self.is_on.write(true);
        // El propietario inicial es quien despliega el contrato
        self.owner.write(get_caller_address());
    }

    // ===== FUNCIONES DE CONTROL DE OWNERSHIP =====

    // Permite al propietario actual transferir la propiedad a una nueva dirección
    #[external(v0)]
    fn set_owner(ref self: ContractState, new_owner: ContractAddress) {
        // Obtenemos la dirección del caller
        let caller = get_caller_address();
        // Verificamos que solo el propietario actual puede cambiar el propietario
        assert(caller == self.owner.read(), 'Only owner can set new owner');
        // Asignamos el nuevo propietario
        self.owner.write(new_owner);
    }

    // Permite al propietario apagar el calculador
    #[external(v0)]
    fn turn_off(ref self: ContractState) {
        let caller = get_caller_address();
        // Solo el propietario puede apagar el calculador
        assert(caller == self.owner.read(), 'Only owner can turn off');
        self.is_on.write(false);
    }

    // Permite al propietario encender el calculador
    #[external(v0)]
    fn turn_on(ref self: ContractState) {
        let caller = get_caller_address();
        // Solo el propietario puede encender el calculador
        assert(caller == self.owner.read(), 'Only owner can turn on');
        self.is_on.write(true);
    }

    // ===== FUNCIONES DE OPERACIONES ARITMÉTICAS =====

    // Realiza la suma de dos números
    #[external(v0)]
    fn sum(ref self: ContractState, a: i128, b: i128) {
        // Verificamos que el calculador esté encendido
        assert(self.is_on.read(), 'Calculator is off');
        // Guardamos el resultado de la suma
        self.sum_result.write(a + b);
    }

    // Obtiene el resultado de la última suma
    #[external(v0)]
    fn sum_result(self: @ContractState) -> i128 {
        self.sum_result.read()
    }

    // Realiza la resta de dos números
    #[external(v0)]
    fn sub(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        self.sub_result.write(a - b);
    }

    // Obtiene el resultado de la última resta
    #[external(v0)]
    fn sub_result(self: @ContractState) -> i128 {
        self.sub_result.read()
    }

    // Realiza la multiplicación de dos números
    #[external(v0)]
    fn mult(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        self.mult_result.write(a * b);
    }

    // Obtiene el resultado de la última multiplicación
    #[external(v0)]
    fn mult_result(self: @ContractState) -> i128 {
        self.mult_result.read()
    }

    // Realiza la división de dos números
    #[external(v0)]
    fn div(ref self: ContractState, a: i128, b: i128) {
        assert(self.is_on.read(), 'Calculator is off');
        // Verificamos que no se divida por cero
        assert(b != 0, 'Division by zero');
        self.div_result.write(a / b);
    }

    // Obtiene el resultado de la última división
    #[external(v0)]
    fn div_result(self: @ContractState) -> i128 {
        self.div_result.read()
    }

    // ===== FUNCIÓN DE ESTADO =====

    // Permite verificar si el calculador está encendido
    #[external(v0)]
    fn is_on(self: @ContractState) -> bool {
        self.is_on.read()
    }
}
