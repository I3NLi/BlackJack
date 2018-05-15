xquery version "3.0"  encoding "UTF-8";


module namespace mc = "blackjack/mapcontroller";

import module namespace Table = "blackjack/Table" at "Table.xquery";
import module namespace Server = "blackjack/Server" at "Server.xquery";


declare variable $mc:index := doc("index.xml");
declare variable $mc:startPage := doc("../static/startPage.xml");

declare %private function mc:xslHead(){
 "<?xml version='1.0' encoding='UTF-8'?><?xml-stylesheet type='text/xsl' href='static/startPage.xsl'?>"
 
};

declare
%rest:path("/blackjack")
%rest:GET
function mc:start() {
 $mc:startPage
};


declare
%rest:path("/blackjack/t/{$tbid}/newTurn")
%rest:GET
function mc:new($tbid as xs:integer) {
   let $new := Table:gameWin($tbid)
   let $url := fn:concat("/blackjack/showGame/",$tbid)
   return db:output(mc:redirect($url))
   
};



declare
%rest:path("/blackjack/newGame/{$pyrnum}")
%rest:GET
%updating
function mc:start($pyrnum as xs:integer) {
   let $tbid:= Server:addNewGame($pyrnum)
   let $url := fn:concat("/blackjack/showGame/",$tbid)
   return db:output(mc:redirect($url))
   
};

declare
%rest:path("/blackjack/showDB")
%rest:GET
function mc:showDB() {
   $Server:gameBase
};

declare
%rest:path("/blackjack/stopGame/{$tbid}")
%rest:GET
function mc:deleteGame($tbid){

    Server:deleteGame($tbid),
    mc:redirect("/blackjack")
};


declare
%rest:path("/blackjack/t/{$tbid}/addPlayer")
%rest:GET
%updating
function mc:addPlayer($tbid){

    Table:addPlayer($tbid),
    let $url := fn:concat("/blackjack/showGame/",$tbid)
   return db:output(mc:redirect($url))
};

declare
%rest:path("/blackjack/t/{$tbid}/p/{$plyrid}/bet/{$credits}")
%rest:GET
%updating
function mc:addPlayer($tbid as xs:integer, $plyrid as xs:integer, $credits as xs:integer){

    Table:setBet($credits, $tbid, $plyrid),
    let $url := fn:concat("/blackjack/showGame/",$tbid)
   return db:output(mc:redirect($url))
};


declare
%rest:path("/blackjack/t/{$tbid}/p/{$plyrid}/deal")
%rest:GET
%updating
function mc:plyerDeal($tbid as xs:integer, $plyrid as xs:integer){
    if(exists($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id=$plyrid and text()='0']))
    then(
    let $url := fn:concat("/blackjack/showGame/",$tbid)
    return db:output(mc:redirect($url))
    )else(
    let $plyrBet := Table:changePlayerState($tbid, $plyrid, 2)  
    let $url := fn:concat("/blackjack/showGame/",$tbid)
    let $url1 := fn:concat(fn:concat("/blackjack/t/",$tbid),"/openTurn")
    let $undld := Table:getUndealedNum($tbid)
    return (if($undld=1) then (Table:changeState($tbid, 2),db:output(mc:redirect($url1)))
    else(db:output(mc:redirect($url))))
    )
};

declare
%rest:path("/blackjack/t/{$tbid}/openTurn")
%rest:GET
%updating
function mc:openTurn($tbid as xs:integer){
    let $plyrs:=$Server:gameBase/Tables/Table[id=$tbid]/players/Player
    let $url := fn:concat(fn:concat("/blackjack/t/",$tbid),"/draw2ndCard")
    for $plyr in $plyrs
    return (Table:draw($tbid, $plyr/id),
    Table:changePlayerState($tbid, $plyr/id, 3),
    db:output(mc:redirect($url))
    )
};

declare
%rest:path("/blackjack/t/{$tbid}/draw2ndCard")
%rest:GET
%updating
function mc:draw2ndCard($tbid as xs:integer){
    let $plyrs:=$Server:gameBase/Tables/Table[id=$tbid]/players/Player
    let $url := fn:concat("/blackjack/showGame/",$tbid)
    for $plyr in $plyrs
    return (Table:draw($tbid, $plyr/id),
    db:output(mc:redirect($url))
    ), if($Server:gameBase/Tables/Table[id=$tbid]/players/Player[1]/handCards/Card[1]/number = 1 ) then (Table:changePlayerState($tbid, 0, 0)) else()
};

declare
%rest:path("/blackjack/t/{$tbid}/p/{$plyrid}/stand")
%rest:GET
%updating
function mc:plyrStand($tbid as xs:integer, $plyrid as xs:integer){
    let $url := fn:concat(fn:concat("/blackjack/t/",$tbid),"/dealerTurnCheck")
    return (
       Table:changePlayerState($tbid, $plyrid, 5),
       Table:setTurn($tbid, -1),
       db:output(mc:redirect($url))
       )      
};




declare
%rest:path("/blackjack/t/{$tbid}/p/{$plyrid}/hit")
%rest:GET
%updating
function mc:plyrHit($tbid as xs:integer, $plyrid as xs:integer){
    let $url := fn:concat(fn:concat(fn:concat(fn:concat("/blackjack/t/",$tbid),"/p/"),$plyrid),"/hitCheck")
    return (
       Table:draw($tbid, $plyrid),
       Table:setTurn($tbid, $plyrid),
      
       db:output(mc:redirect($url))
       )
     
};

declare
%rest:path("/blackjack/t/{$tbid}/p/{$plyrid}/hitCheck")
%rest:GET
%updating 
function mc:checkSB($tbid as xs:integer, $plyrid as xs:integer){
     if(Table:playerBusted($tbid, $plyrid)="true") then (
     Table:changePlayerState($tbid, $plyrid, 4),
     let $url := fn:concat(fn:concat("/blackjack/t/",$tbid),"/dealerTurnCheck")
     return db:output(mc:redirect($url))) 
     else (
     let $url := fn:concat("/blackjack/showGame/",$tbid)
     return db:output(mc:redirect($url))
     )
    
};


declare
%rest:path("/blackjack/t/{$tbid}/dealerDraw")
%rest:GET
%updating 
function mc:dealerDraw($tbid as xs:integer){
    Table:draw($tbid, 0),
     let $url := fn:concat(fn:concat("/blackjack/t/",$tbid),"/dealerFullfill")
     return db:output(mc:redirect($url))
};

declare
%rest:path("/blackjack/t/{$tbid}/dealerFullfill")
%rest:GET 
%updating
function mc:dealerFullfill($tbid as xs:integer){
    if(Table:dealerStratFullfilled($tbid) = "false")
    then(
    let $url := fn:concat(fn:concat("/blackjack/t/",$tbid),"/dealerDraw")
     return db:output(mc:redirect($url))
    )
    else(
     let $url := fn:concat("/blackjack/showGame/",$tbid)
     let $upd := Table:updateHandCardSum($tbid)
     let $pay := Table:calcPay($tbid)
     return (db:output(mc:redirect($url)))
    )
};


declare
%rest:path("/blackjack/t/{$tbid}/dealerTurnCheck")
%rest:GET
%updating 
function mc:checkDealersTurn($tbid as xs:integer){
     if(Table:isDealersTurn($tbid) = "true") then (
     Table:changeState($tbid, 3),
     let $url := fn:concat(fn:concat("/blackjack/t/",$tbid),"/dealerFullfill")
     return db:output(mc:redirect($url))
     
     ) else (
     let $url := fn:concat("/blackjack/showGame/",$tbid)
     return db:output(mc:redirect($url))
     )
};


declare
%rest:path("/blackjack/t/{$tbid}/p/{$plyrid}/insur")
%rest:GET
%updating
function mc:plyrInsur($tbid as xs:integer, $plyrid as xs:integer){
    let $plyr := $Server:gameBase/Tables/Table[id=$tbid]/players/Player[id=$plyrid]
    let $plyrBet := sum($Server:gameBase/Tables/Table[id=$tbid]/betCredits/bet[@id=$plyrid])
    
    let $url := fn:concat("/blackjack/showGame/",$tbid)
    return (replace value of node $plyr/@insurAgrd with 'true',
    Table:setInsur(xs:integer($plyrBet div 2), $tbid, $plyrid),
    Table:setTurn($tbid, -1),
    db:output(mc:redirect($url))
    )
};


declare
%rest:path("/blackjack/t")
%rest:GET
%updating
function mc:test(){
   
    Table:dealerDraw(184),
    db:output("/blackjack/showGame/184")
    
};



declare
%rest:path("/blackjack/showGame/{$tbid}")
%rest:GET
function mc:showGame($tbid as xs:integer) {

<rest:response>
    <http:response status="200" message="Yushen is Cool.">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/html; charset=utf-8"/>
    </http:response>
</rest:response>,

   let $tb:=$Server:gameBase/Tables/Table[id=$tbid]

   let $info :=<Game>{(
        $tb/id,
        $tb/state,
        $tb/betCredits,
        $tb/players
        )
    }
    </Game>
    
   
    
   return    xslt:transform-text($info,doc("http://localhost:8984/static/inGame.xsl"))
   
 
};

declare function mc:redirect ($url as xs:string) as element(restxq:redirect){
<restxq:redirect>{ $url }</restxq:redirect>
};
