//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the InclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root

    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves

        for (uint256 i=0; i < 8; i++) {
            hashes.push(0);
        }

        uint256 k = 0;
        for (uint256 i=8; i < 15; i++) {
            hashes.push(PoseidonT3.poseidon([hashes[k*2],hashes[k*2+1]]));
            k++;
        }

        root = hashes[14];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree

        require( index < 8, " tree is full");

        hashes[index] = hashedLeaf;

        uint256 k = 0;
        for (uint256 i=8; i < 15; i++) {
            hashes[i] = PoseidonT3.poseidon([hashes[k*2],hashes[k*2+1]]);
            k++;
        }

        root = hashes[14];
        index++;
        return index;
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify a inclusion proof and check that the proof root matches current root

        require(verifyProof(a, b, c, input), "invalid proof");

        return (root==input[0]);
    }
}
