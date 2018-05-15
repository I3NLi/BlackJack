xquery version "3.0"  encoding "UTF-8";
(:Author Li, Boning; Zhang, Yushen:)



module namespace Server = "blackjack/Server";
import module namespace Table = "blackjack/Table" at "Table.xquery";

declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace math = "http://www.w3.org/2005/xpath-functions/math";
import module namespace random = "http://basex.org/modules/random";

declare variable $Server:gameBase := doc("blackJack")/gameBase;
declare variable $Server:tbNum := 0;


declare %updating function Server:addNewGame($players as xs:integer)  {
      let $tbnum :=  $Server:gameBase/@tbCount
      let $newNum := (xs:integer($tbnum) +1)
      let $info := Table:new($players, $newNum)
     return (
     $newNum,
     replace value of node $tbnum with $newNum,
     insert node $info as last into $Server:gameBase/Tables)
     
     
     
};

declare %updating function Server:deleteGame($tbid as xs:integer){
    delete node $Server:gameBase/Tables/Table[id=$tbid]
    (: remove($Server:gameBase/Tables, $tbid) :)
};

(:replace value of node $Server:gameBase/Tables/Table[id=7]/deck with "":)
