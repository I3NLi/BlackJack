xquery version "3.0"  encoding "UTF-8";
(:Author Li, Boning; Zhang, Yushen:)



module namespace Player = "blackjack/Player";
import module namespace Server = "blackjack/Server" at "Server.xquery";


declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace random = "http://basex.org/modules/random";

declare function Player:new($credits as xs:integer, $id as xs:integer) as element(Player){
    <Player insurAgrd="">
        <id>{$id}</id>
        <state>1</state>
        <credits>{$credits}</credits>
        <handCards sum="0">
        </handCards>
    </Player>
};
declare function Player:newDealer($id as xs:integer) as element (Player){
    Player:new(99999, $id)
};

declare %updating function Player:bet($credits as xs:integer, $tbid as xs:integer, $plyrid as xs:integer) {
    let $plyr := $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]
    let $currentCr := $plyr/credits
    let $newCr := xs:string(xs:integer($currentCr/text()) - $credits)
    return replace value of node $currentCr with $newCr
};

declare %updating function Player:insurance($credits as xs:integer, $tbid as xs:integer, $plyrid as xs:integer){
    Player:bet($credits, $tbid, $plyrid)
};
declare %updating function Player:winCredits($credits as xs:integer, $tbid as xs:integer, $plyrid as xs:integer){
let $plyr := $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]
    let $currentCr := $plyr/credits
    let $newCr := xs:string(xs:integer($currentCr/text()) + $credits)
    return replace value of node $currentCr with $newCr
};
declare %updating function Player:draw($card as element(Card), $tbid as xs:integer, $plyrid as xs:integer){
    let $plyr := $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]
    return 
    if($plyrid = 0) then (
    insert node $card as last into $plyr/handCards)
    else (
    insert node $card as first into $plyr/handCards)
    
};

declare %updating function Player:changeState($tbid as xs:integer, $plyrid as xs:integer, $newState as xs:integer){
    let $plyr := $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]
    return replace value of node $plyr/state with $newState
};

