// SPDX-License-Identifier: UNLICENSED
import "forge-std/Test.sol";
import {Safe} from "@safe-contracts/Safe.sol";
import "../../script/DeploySafeFactory.t.sol";
import "../../../src/utils/SigningUtils.sol";
import "./SignDigestHelper.t.sol";
import "./SignersHelper.t.sol";
// src/utils/SigningUtils.sol
// /home/cristianrom66/curso/eth_hackathon_oct_2023/daovation-contracts-1/test/helpers/SafeHelpers.t.sol
// /home/cristianrom66/curso/eth_hackathon_oct_2023/daovation-contracts-1/src/utils/SigningUtils.sol

pragma solidity ^0.8.19;

contract SafeHelper is Test, SigningUtils, SignDigestHelper, SignersHelper {
    Safe public gnosisSafe;
    DeploySafeFactory public safeFactory;

    address public daovationEventModule;
    address public gnosisMasterCopy;

    uint256 public salt;

    function setupSafeEnv() public returns (address) {
        safeFactory = new DeploySafeFactory();
        safeFactory.run();
        gnosisMasterCopy = address(safeFactory.gnosisSafeContract());
        bytes memory emptyData;
        address gnosisSafeProxy = safeFactory.newSafeProxy(emptyData);
        gnosisSafe = Safe(payable(gnosisSafeProxy));
        initOnwers(30);

        // Setup gnosis safe with 3 owners, 1 threshold
        address[] memory owners = new address[](3);
        owners[0] = vm.addr(privateKeyOwners[0]);
        owners[1] = vm.addr(privateKeyOwners[1]);
        owners[2] = vm.addr(privateKeyOwners[2]);
        // Update privateKeyOwners used
        updateCount(3);

        gnosisSafe.setup(
            owners,
            uint256(1),
            address(0x0),
            emptyData,
            address(0x0),
            address(0x0),
            uint256(0),
            payable(address(0x0))
        );

        return address(gnosisSafe);
    }

    function createDefaultTx(address to, bytes memory data)
        public
        pure
        returns (Transaction memory)
    {
        bytes memory emptyData;
        Transaction memory defaultTx = Transaction(
            to,
            0 gwei,
            data,
            Enum.Operation(0),
            0,
            0,
            0,
            address(0),
            address(0),
            emptyData
        );
        return defaultTx;
    }

    function createSafeTxHash(Transaction memory safeTx, uint256 nonce)
        public
        view
        returns (bytes32)
    {
        bytes32 txHashed = gnosisSafe.getTransactionHash(
            safeTx.to,
            safeTx.value,
            safeTx.data,
            safeTx.operation,
            safeTx.safeTxGas,
            safeTx.baseGas,
            safeTx.gasPrice,
            safeTx.gasToken,
            safeTx.refundReceiver,
            nonce
        );

        return txHashed;
    }

    function encodeSignaturesModuleSafeTx(Transaction memory mockTx)
        public
        view
        returns (bytes memory)
    {
        // Create encoded tx to be signed
        uint256 nonce = gnosisSafe.nonce();
        bytes32 enableModuleSafeTx = createSafeTxHash(mockTx, nonce);

        address[] memory owners = gnosisSafe.getOwners();
        // Order owners
        address[] memory sortedOwners = sortAddresses(owners);
        uint256 threshold = gnosisSafe.getThreshold();

        // Get pk for the signing threshold
        uint256[] memory privateKeySafeOwners = new uint256[](threshold);
        for (uint256 i = 0; i < threshold; i++) {
            privateKeySafeOwners[i] = ownersPK[sortedOwners[i]];
        }

        bytes memory signatures =
            signDigestTx(privateKeySafeOwners, enableModuleSafeTx);

        return signatures;
    }

    function executeSafeTx(Transaction memory mockTx, bytes memory signatures)
        internal
        returns (bool)
    {
        bool result = gnosisSafe.execTransaction(
            mockTx.to,
            mockTx.value,
            mockTx.data,
            mockTx.operation,
            mockTx.safeTxGas,
            mockTx.baseGas,
            mockTx.gasPrice,
            mockTx.gasToken,
            payable(address(0)),
            signatures
        );

        return result;
    }

    function enableModuleTx(address safe) public returns (bool) {
        // Create enableModule calldata
        bytes memory data = abi.encodeWithSignature(
            "enableModule(address)", daovationEventModule
        );

        // Create enable module safe tx
        Transaction memory mockTx = createDefaultTx(safe, data);
        bytes memory signatures = encodeSignaturesModuleSafeTx(mockTx);
        bool result = executeSafeTx(mockTx, signatures);
        return result;
    }
}
