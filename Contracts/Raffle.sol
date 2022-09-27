// Raffle
// Enter by paying some amount
// Pick a random winner, verifyibly random
// Winner to be selected every X minutes -> completely automated
// We need to use a Chainlink Oracle for randomness and automation (Cainlink Keepers)

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error Raffle_NotEnoughETHEntered();

contract Raffle is VRFConsumerBaseV2 {
    // State variables
    // we always have to set visibility // we append s_ to storage variables and i_ to immutable variables
    uint256 private immutable i_entranceFee;
    // keeping track of players who join
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLImit;
    uint32 private constant NUMWORDS = 1;

    // Events
    // namming convection is the function name reversed
    event RaffleEnter(address indexed player);
    event RequestedRaffleWinner(uint256 indexed requestId);

    constructor(
        address vrfCoordinatorV2,
        uint256 entranceFee,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLImit = callbackGasLimit;
    }

    function enterRaffle() public payable {
        // our msg.value > entrance fee to enter raffle
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughETHEntered();
        } else {
            s_players.push(payable(msg.sender));
        }
        emit RaffleEnter(msg.sender);
    }

    function requestRandomWinner() external {
        // request random number
        // do something with it
        uint256 requestId =  i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLImit,
            NUMWORDS
        );
        // the above returns a request id with information on our request
        emit RequestedRaffleWinner(requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords)
        internal
        override
    {
        uint256 imdexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[imdexOfWinner];
    }

    // view/pure functions
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
