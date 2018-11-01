const quiz = artifacts.require('quiz')
const assert = require('assert')

let contractInstance

  contract('quiz',  (accounts) => {
    beforeEach(async () => {
      contractInstance = await quiz.deployed()
    })
    for(i=1;i<5;i++){
      const z = i;
      it('Check if participant is getting registered', async() => {
        var prevcnt  = await contractInstance.get_current_participant_count()      
        try{
          await contractInstance.registerplayers([2, 3, 1, 4], {
            from: accounts[z], value: web3.toWei(16,'ether')
          })
        }
        catch(err){
          console.log(err)
        }
        var newcnt  = await contractInstance.get_current_participant_count() 
        console.log(Number(prevcnt));           
        assert.equal(Number(prevcnt)+1,Number(newcnt), 'Participant is not registered')
    
      })
    }
    // it('Check if same participant is not getting registered again', async() => {
    //   var prevcnt  = await contractInstance.get_current_participant_count()
    //   try{
    //     await contractInstance.regester_as_participant({from: accounts[1], value: web3.toWei(0.000000000000000010,'ether')})
    //   }
    //   catch(err){
    //     // console.log(err)
    //   }
    //   var newcnt  = await contractInstance.get_current_participant_count()
    //   assert.equal(prevcnt.c[0],newcnt.c[0], 'Duplicate participant is registered')
    // })
    // it('Check if participant is not organizer', async() => {
    //   var prevcnt  = await contractInstance.get_current_participant_count()
    //   console.log(Number(prevcnt));
    //   try{
    //     await contractInstance.registerplayers([2, 2, 1, 3], {from: accounts[0], value: web3.toWei(16,'ether')})
    //   }
    //   catch(err){
    //     // console.log(err)
    //   }
    //   var newcnt  = await contractInstance.get_current_participant_count()
    //   assert.equal(Number(prevcnt),Number(newcnt), 'Organizer registered as participant')
    // })
    it('Check if participant is not getting registered on paying less than participation fees', async() => {
      var prevcnt  = await contractInstance.get_current_participant_count()
      console.log(Number(prevcnt));
      try{
        await contractInstance.registerplayers([2, 2, 1, 3], {from: accounts[5], value: web3.toWei(15,'ether')})
      }
      catch(err){
        // console.log(err)
      }
      var newcnt  = await contractInstance.get_current_participant_count()
      assert.equal(Number(prevcnt) + 1, Number(newcnt), 'participant registered with less than participation fees')
    })
    it('Check if organizer receives the participation fees on participant registration', async() => {
      var prev_balance  = await contractInstance.get_tfee()
      try{
        await contractInstance.registerplayers([2, 2, 1, 3], {from: accounts[6], value: web3.toWei(16,'ether')})
      }
      catch(err){
        // console.log(err)
      }
      var new_balance  = await contractInstance.get_tfee()
      assert.equal(Number(new_balance),Number(prev_balance) + 16, 'Organizer didnt receive the participation fees')
    })
    // it('Check if participant can answer a question', async() => {
    //   var check_flag = 0
    //   try{
    //     await contractInstance.play_game_question_answer(1,1,{from: accounts[1]})
    //     check_flag = 1;
    //   }
    //   catch(err){
    //     console.log(err)
    //   }
    //   assert.equal(check_flag,1, 'participant could not answer question')
    // })
    

})
