pragma solidity ^0.4.24;

contract quiz
{
    
    struct Question_Paper
    {
        uint256 correct_ans_1;
        uint256 correct_ans_2;
        uint256 correct_ans_3;
        uint256 correct_ans_4;
    }
    
    struct Player
    {
        address account; // stores his adress
        uint256[4] ans_arr; // stores his 4 answers
        uint256 time_stamp ; // stores the block number
    }
    
    address public quiz_master; // adress of the quizmaster i.e the host of the game
    Player[] private players; //will store a list of all the players registered for the game
    uint public pfee; // stores the participation fees of each player
    uint tfee; // total fees of the game
    
    function registerplayers(uint256[4] ans_arr) public payable // function to register the players
    {
        require(msg.value > pfee,"Not Enough Participation Fee"); // the value must be greater than the pfee
        players.push(Player(msg.sender, ans_arr, block.number)); // push that player and his 4 choices in the player array
        tfee += pfee;

    }
    
    
    function get_tfee() public view returns(uint256)
    {
        return tfee;
    }
    
    function getplayers() external view returns(address[]) //displays all registered players so far
    {
        address[] memory ids = new address[](players.length);
        uint counter = 0;
        for(uint i = 0; i < players.length; i++)
        {
            ids[counter] = players[i].account;
            counter++;
        }
        return ids;
    }
    function get_current_participant_count() public view returns(uint256){
        return players.length;
    }
    modifier restricted()
    {
        // Ensure the participant awarding the ether is the manager
        require(msg.sender == quiz_master,"Only quiz master is allowed to perform this operation");
        _;
    }
    
    // function random() private view returns (uint)
    // {
    //     return uint(keccak256(block.difficulty, now, players.length));
    // }
    
    function pickWinner(uint256[4]ans) public restricted returns(address)
    {
        
        Question_Paper storage question; // Question paper declared
        question.correct_ans_1 = ans[0]; // correct ans decided by quiz_master as this is a restricted function
        question.correct_ans_2 = ans[1];
        question.correct_ans_3 = ans[2];
        question.correct_ans_4 = ans[3];
        Player[][4] q_correct_ans; // stores the ans for all the players in all the questions
        for(uint i = 0;i < players.length; i++)
        {
            if(players[i].ans_arr[0] == question.correct_ans_1)
            {
                q_correct_ans[0].push(players[i]); // getting possible winnners of q1 based on ans
            }
            if(players[i].ans_arr[1] == question.correct_ans_2)
            {
                q_correct_ans[1].push(players[i]); // getting possible winners of q2 based on ans
            }
            if(players[i].ans_arr[2] == question.correct_ans_3)
            {
                q_correct_ans[2].push(players[i]); // getting possible winners of q3 based on ans
            }
            if(players[i].ans_arr[3] == question.correct_ans_4)
            {
                q_correct_ans[3].push(players[i]); // getting possible winners of q4 based on ans
            }
            
            for(uint j = 0; j < 4; j++) // For each question
            {
                address round_winner;
                uint256 round_stamp;
                round_winner = q_correct_ans[j][0].account; // stores that question's winner's address
                round_stamp = q_correct_ans[j][0].time_stamp; // stores that question's winning time stamp
                for(uint k = 0; k < q_correct_ans[j].length; k++) // For Each Player
                {
                    if(round_stamp < q_correct_ans[j][k].time_stamp) // If time stamp is greater then replace winner
                    {
                        round_stamp = q_correct_ans[j][k].time_stamp;
                        round_winner = q_correct_ans[j][k].account;
                    }
                }
                
                round_winner.transfer((tfee*2)/3); // Need to send this amount to the account, But some error in Remix Right Now
                
            }
        }

        return round_winner;
    }
    
    function host_reward(uint256 amount) public payable {
        msg.sender.transfer(amount);
    }
    // function calcul(uint a, uint b, uint precision) view returns ( uint) { // just a multiplier with specified precision

    //  return a*(10**precision)/b;
    // }
    
    constructor (uint num_players, uint regpfee) public { //quiz master will dictate # of players and pfee
        quiz_master = msg.sender;// store the address of the quiz_master
        pfee = regpfee;
    }
    
}

