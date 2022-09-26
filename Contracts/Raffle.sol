// Raffle
// Enter by paying some amount
// Pick a random winner, verifyibly random
// Winner to be selected every X minutes -> completely automated
// We need to use a Chainlink Oracle for randomness and automation (Cainlink Keepers)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

error Raffle_NotEnoughETHEntered();

contract Raffle {

    // State variables
    // we always have to set visibility // we append s_ to storage variables and i_ to immutable variables
    uint256 private immutable i_entranceFee;
    // keeping track of players who join 
    address payable[] private s_players;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // our msg.value > entrance fee to enter raffle
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughETHEntered();
        }else{
            s_players.push(payable(msg.sender));
        }

    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns(address){
        return s_players[index];
    }
}
