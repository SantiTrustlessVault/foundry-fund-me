

## 🏦 FundMe – Smart Contract Funding Project

FundMe es un smart contract escrito en Solidity que permite a los usuarios enviar fondos al contrato, y al propietario retirarlos una vez acumulados. Es un proyecto típico para entender patrones de financiamiento en Web3 y aplicar buenas prácticas de desarrollo y seguridad de contratos inteligentes.

---

### 🚀 Tecnologías

* Solidity
* Foundry (para testing y scripting)
* Chainlink (para obtener precios de ETH/USD)
* Forge (CLI de Foundry)

---

### 📁 Estructura del Proyecto

```
├── src/
│   ├── FundMe.sol
│   └── PriceConverter.sol
├── script/
│   └── DeployFundMe.s.sol
├── test/
├   ├──mocks 
│   ├── FundMeTest.t.sol
│   └── HelperConfig.s.sol
├── lib/
│   └── (dependencias instaladas como Chainlink)
├── foundry.toml
```

---

### ⚙️ Instalación

```bash
forge install
```

Instalá las dependencias necesarias. Asegurate de tener `foundry` instalado.

---

### 🧪 Testing

```bash
forge test -vv
```

Este comando ejecuta todos los tests con información detallada (`-vv`).

---

### 📜 Despliegue

Usamos un script con `forge script`:

```bash
forge script script/DeployFundMe.s.sol --rpc-url <RPC_URL> --broadcast --private-key <YOUR_PRIVATE_KEY>
```

> ⚠️ ¡Nunca subas tu private key al repositorio!

---

### 🧠 Conceptos Aprendidos

* Uso de Chainlink AggregatorV3Interface para obtener precios ETH/USD.
* Validaciones con `require`, `revert` y custom errors.
* Uso de `call` en lugar de `transfer` o `send`.
* Testing con `vm.startPrank`, `hoax` y `cheatcodes` de Foundry.

---

## 🛠️ ¿Qué hace `forge init`?

Cuando ejecutás `forge init <nombre-del-proyecto>`, Foundry crea la estructura básica de un proyecto, que incluye:

* `src/`: donde se guardan los contratos.
* `test/`: carpeta para escribir tus pruebas.
* `script/`: scripts de despliegue o automatización.
* `lib/`: carpeta para dependencias externas (como Chainlink).
* `foundry.toml`: archivo de configuración del proyecto.
* `.gitignore`: para ignorar archivos innecesarios como `out/` y `broadcast/`.

Opcionalmente, podés agregar `--template` si querés clonar un template específico, como uno con pruebas listas o deploys automatizados.






## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
