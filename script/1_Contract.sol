// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MyContract {
    uint public storeNum;
    bool public storeBool;
    address public owner;
    struct Payment {
        uint amount;
        uint timestamp;
        address to;
    }
    struct Payments {
        uint totalPayments;
        mapping (uint => Payment) paymentsOfAddress;
    }
    mapping (address => bool) public allowedToSend;
    mapping (address => Payments) public paymentsBook;


    event AddSender(address _who, address indexed _whom, bool _state);
    event Paid(address _from, address _to, uint _amount, uint _timestamp);


    constructor() payable {
        owner = msg.sender;
    }

    receive() external payable {
    }

    function addSendersToBC(address addressInBC, bool permission) public {
        allowedToSend[addressInBC] = permission;
        emit AddSender(owner, addressInBC, permission);
    }

    function sendCoins(address payable targetAddr, uint amount) public payable {
        require(msg.sender == owner, "You are not an owner!");
        require(allowedToSend[owner], "Congrats! You can't send coins in this BlockChain.");
        uint paymentNum = paymentsBook[owner].totalPayments;
        paymentsBook[owner].totalPayments++;
        Payment memory newPayment = Payment(
            amount,
            block.timestamp,
            targetAddr
        );
        targetAddr.transfer(amount);
        paymentsBook[owner].paymentsOfAddress[paymentNum] = newPayment;
        
        emit Paid(owner, targetAddr, amount, block.timestamp);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function writeNum(uint yourNum) public returns(uint) {
        storeNum = yourNum;
        return storeNum;
    }

    function writeBool(bool yourBool) public returns(bool) {
        storeBool = yourBool;
        return storeBool;
    }

}