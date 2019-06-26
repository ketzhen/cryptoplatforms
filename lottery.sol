contract Lottery {
    address[5] participants;
    uint8 participantsCount = 0;
    uint randNonce = 0;

    function join() public payable {
        require(msg.value == 0.1 ether, "Must send 0.1 ether");
        require(participantsCount < 5, "User limit reached");
        require(joinedAlready(msg.sender) == false, "User already joined");
        participants[participantsCount] = msg.sender;
        participantsCount++;
        if (participantsCount == 5) {
            selectWinner();
        }
    }
    
    function joinedAlready(address _participant) private view returns(bool) {
        bool containsParticipant = false;
        for(uint i = 0; i < 5; i++) {
            if (participants[i] == _participant) {
                containsParticipant = true;
            }
        }
        return containsParticipant;
    }
    
    function selectWinner() private returns(address) {
        require(participantsCount == 5, "Waiting for more users");
        address winner = participants[randomNumber()];
        winner.transfer(address(this).balance);
        delete participants;
        participantsCount = 0;
        return winner;
    }
    
    function randomNumber() private returns(uint) {
        uint rand = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % 5;
        randNonce++;
        return rand;
    }
        
}
