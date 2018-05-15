xquery version "3.0"  encoding "UTF-8";
(:Author Li, Boning; Zhang, Yushen:)


module namespace Table = "blackjack/Table";
import module namespace Server = "blackjack/Server" at "Server.xquery";
import module namespace Card = "blackjack/Card" at "Card.xquery";
import module namespace Player = "blackjack/Player" at "Player.xquery";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace random = "http://basex.org/modules/random";



declare function Table:new($players as xs:integer, $id as xs:integer) as element(Table){
    <Table>
        <id>{$id}</id>
        <state>1</state>
        <players onTurn="0">
            {
            Player:newDealer(0)
          }{
            for $plyrid in (1 to $players)
            return Player:new(500, $plyrid)
          }
        </players>
        <deck>
            {
            for $types in ("a","b","c","d"),
                $num in (1 to 13)
            return Card:new($types, $num)
            }
        </deck>
        <betCredits>
        {
            for $plyrid in (1 to $players)
            return Table:newEmptyBet($plyrid)
          }
        </betCredits>
    </Table>
};

declare function Table:newEmptyBet($plyrid) as element(){
    <bet id='{$plyrid}' pay="0">0</bet>
};


declare %updating function Table:draw($tbid as xs:integer, $plyrid as xs:integer){

  
    (: remove($Server:gameBase/Tables/Table[id=$tbid]/deck, $c) :)
    
    let $cdNum :=  count ($Server:gameBase/Tables/Table[id=$tbid]/deck/Card)
    let $c := random:integer($cdNum) + 1
    let $cd := $Server:gameBase/Tables/Table[id=$tbid]/deck/Card[$c]
  
    return (
       delete node $Server:gameBase/Tables/Table[id=$tbid]/deck/Card[$c], 
      (:try{
         Player:draw($cd, $tbid, $plyrid) 
         }
         catch err:XPTY0004{
         Table:draw($tbid, $plyrid)
         }:)
       
      Player:draw($cd, $tbid, $plyrid))
    
};

declare %updating function Table:calcPay($tbid as xs:integer){
        
        for $p in $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id !=0]
        let $sum := Table:sumHandCard($tbid, $p/id)
        let $dealerSum := Table:sumHandCard($tbid, 0)
        return(
        if($p/@insurAgrd = 'true') then(
            if($dealerSum = 21 and count($Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=0]/handCards/Card) = 2) then
            (
            
                  if($sum = 21 and count($p/handCards/Card) = 2)then(
                    replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2)
                  )else(
                    replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text())
                  )            

        
            )else(
                        if($sum = 21 and count($p/handCards/Card) = 2)then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2.5)
            )else(
            
            if($sum<=21 and $dealerSum < $sum)then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2)
            )else(
            if($dealerSum>21 and $sum<=21)then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2)
            )else(
            
            if($dealerSum=$sum or ($dealerSum >21 and $sum>21))then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with  sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text())
            )else()
            )
            
            )        
         )
            ))
        else(
         if($dealerSum = 21 and count($Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=0]/handCards/Card) = 2) then (
             if($sum = 21 and count($p/handCards/Card) = 2)then(
                    replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text())
            )else(
            )
         ) else(
            if($sum = 21 and count($p/handCards/Card) = 2)then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2.5)
            )else(
            
            if($sum<=21 and $dealerSum < $sum)then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2)
            )else(
            if($dealerSum>21 and $sum<=21)then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with xs:integer(sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text()) *2)
            )else(
            
            if($dealerSum=$sum or ($dealerSum >21 and $sum>21))then(
            replace value of node ($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]/@pay)[1] with  sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id]//text())
            )else()
            )
            
            )        
         )
        )
        )
        
        )
};


declare %updating function Table:updateHandCardSum($tbid as xs:integer){
    for $p in $Server:gameBase/Tables/Table[id=$tbid]/players/Player
    let $sum := Table:sumHandCard($tbid, $p/id)
    return replace value of node ($p/handCards/@sum) with $sum
};

declare function Table:playerBusted($tbid as xs:integer, $plyrid as xs:integer) as xs:string{
    if(Table:sumHandCard($tbid, $plyrid) >21) then ("true") else ("false")
};

declare function Table:sumHandCard($tbid as xs:integer, $plyrid as xs:integer) as xs:integer{
 copy $sum := <sum></sum>
    modify(
    for $cd in $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]/handCards/Card[number<=10 and number>1]
    return insert node $cd/number into $sum,
    for $cd in $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]/handCards/Card[number>10]
    return insert node <number>10</number> into $sum,
    for $cd in $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]/handCards/Card[number=1]
    return insert node <number>11</number> into $sum

    )
    return (
    if(xs:integer(sum($sum/number))>21 and exists($sum[number=11])) then(
    
    xs:integer(sum(Table:modAce($sum)/number)
    ))
    else(xs:integer(sum($sum/number))))
};

declare function Table:modAce($sumSet as element()) as element(){
copy $sum := $sumSet
modify(
    replace value of node ($sum/number[text()=11])[1] with '1'
    )
    return     
    if(xs:integer(sum($sum/number))>21 and exists($sum[number=11])) then(
    Table:modAce($sum)
    )
    else($sum) 
};


declare %updating function Table:setTurn($tbid as xs:integer, $plyrid as xs:integer){

  replace value of node $Server:gameBase/Tables/Table[id=$tbid]/players/@onTurn with $plyrid
    
};

declare %updating function Table:changeState($tbid as xs:integer, $newState as xs:integer){
    let $tb := $Server:gameBase/Tables/Table[id=$tbid]
    return replace value of node $tb/state with $newState
};

declare %updating function Table:changePlayerState($tbid as xs:integer, $plyrid as xs:integer, $newState as xs:integer){
    Player:changeState($tbid, $plyrid, $newState)  
};

declare function Table:getUndealedNum($tbid as xs:integer) as xs:integer{
    count($Server:gameBase/Tables/Table[id=$tbid]/players/Player[state = "1" and id!='0'])
};

declare function Table:isDealersTurn($tbid as xs:integer) as xs:string{
    let $sbPlyr := count($Server:gameBase/Tables/Table[id=$tbid]/players/Player[state = "4" or state = "5"])
    let $plyrs := count($Server:gameBase/Tables/Table[id=$tbid]/players/Player[id != "0"])
    return if($sbPlyr = $plyrs) then ("true") else ("false")
};

declare %updating function Table:setBet($credits as xs:integer, $tbid as xs:integer, $plyrid as xs:integer){
   
   
    let $tbcrdt := $Server:gameBase/Tables/Table[id=$tbid]/betCredits
    let $crd := <bet id='{$plyrid}' pay="0">{$credits}</bet>
    return (insert node $crd as last into $tbcrdt,
    Player:bet($credits, $tbid, $plyrid),
    delete node $Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id=$plyrid and text()="0"])
};


declare %updating function Table:setInsur($credits as xs:integer, $tbid as xs:integer, $plyrid as xs:integer){
  
    Player:bet($credits, $tbid, $plyrid)
   
};

declare %updating function Table:addPlayer($tbid as xs:integer){
    let $maxId := $Server:gameBase/Tables/Table[id=$tbid]/players/Player[last()]/id
    let $player := Player:new(1000, xs:integer($maxId+1))
    return (insert node $player as last into $Server:gameBase/Tables/Table[id=$tbid]/players,
    insert node Table:newEmptyBet($maxId+1) as last into $Server:gameBase/Tables/Table[id=$tbid]/betCredits
    )
    
};

declare %updating function Table:deletePlayer($tbid as xs:integer, $plyrid as xs:integer){
    delete node $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]
    (: remove($Server:gameBase/Tables/Table[id=$tbid]/players/, $plyrid) :)
};

declare %updating function Table:gameStart($tbid as xs:integer){
        Table:gameStartShuffleTakeBack($tbid),(:   remove each Player's handCards   :)
        Table:gameStartShuffle($tbid)   (:   rebuild deck   :)
        
};

declare %updating function Table:gameStartShuffle($tbid){
  let $deckCard:=<deck>Table:gameStartShuffleNew()</deck>
  return  replace node  $Server:gameBase/Tables/Table[id=$tbid]/deck with  $deckCard
};

declare %private function Table:gameStartShuffleNew(){
    for $types in ("a","b","c","d"),
        $num in (1 to 13)
    return Card:new($types, $num)
};
declare %updating %private function Table:gameStartShuffleTakeBack($tbid){
    for $player in (1 to 5)
    return replace node  $Server:gameBase/Tables/Table[id=$tbid]/players/player[$player]/handCards with  "<handCards\>"
};

declare %updating function Table:gameWin($tbid as xs:integer){
    
   
     
     for $p in $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id!=0]

     let $pay := 0-xs:integer(($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id = $p/id])[1]/@pay)
     

     return (
     Player:bet($pay, $tbid, $p/id),
     replace node $p/handCards with <handCards sum="0"/>, 
     Table:changePlayerState($tbid, $p/id, 1),
     replace value of node $p/@insurAgrd with ""
     
     ),
      (:let $betCrd := <bet id='{$p/id}' pay="0">0</bet>:)
      let $deck := <deck>
            {
            for $types in ("a","b","c","d"),
                $num in (1 to 13)
            return Card:new($types, $num)
            }
        </deck>
     return (
     replace node $Server:gameBase/Tables/Table[id=$tbid]/deck with $deck,
     Table:changeState($tbid, 1)
     (:insert node $betCrd as first into $Server:gameBase/Tables/Table[id=$tbid]/betCredits:)
     ),
     let $betCrd := 
     <betCredits>{
     for $p in $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id!=0]
     return <bet id='{$p/id}' pay="0">0</bet>}
     </betCredits>
     return 
     replace node $Server:gameBase/Tables/Table[id=$tbid]/betCredits with $betCrd,
     Table:setTurn($tbid,0),
     replace node $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=0] with Player:newDealer(0)
};

declare function Table:dealerStratFullfilled($tbid as xs:integer) as xs:string{
    if(Table:sumHandCard($tbid, 0) <17)
    then
    (
    "false"
    )
    else
    (
    "true"
    )
};

declare %updating function Table:dealerPlays($tbid as xs:integer){
    Table:draw($tbid, 0),
    db:output(
    if(Table:dealerStratFullfilled($tbid) = "false")
    then(
    Table:dealerDraw($tbid)
    )
    else(
    ))
};

declare %updating function Table:dealerDraw($tbid as xs:integer){
    Table:draw($tbid, 0),
    db:output(
    if(Table:dealerStratFullfilled($tbid) = "false")
    then(
    Table:dealerDraw($tbid)
    )
    else(
    ))
};