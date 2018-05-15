<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
    <xsl:output method='html' version="5.0"
                encoding="UTF-8" indent="yes"/>
    
    <xsl:template name="state1">
        <xsl:param name="id"/>
        <!--PlayerBtn-->
          
        <xsl:for-each select="Game/players/Player[id!=0]">
            <xsl:variable name="i" select="position()"></xsl:variable>
            <xsl:variable name="plyrID" select="id"></xsl:variable>
            <xsl:variable name="disabled">
                <xsl:if test="state!=1">disabled greyOut</xsl:if>
            </xsl:variable>
            
            <div class="coinArea{$i}">
                <xsl:for-each select="//Game/betCredits/bet[@id = $plyrID]">
                    <xsl:choose>
                        <xsl:when test="text() = 1">
                        <img src = "http://localhost:8984/static/chip1.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 5">
                        <img src = "http://localhost:8984/static/chip5.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 25">
                        <img src = "http://localhost:8984/static/chip25.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 50">
                        <img src = "http://localhost:8984/static/chip50.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 100">
                        <img src = "http://localhost:8984/static/chip100.svg" class="coinChip"></img>
                        </xsl:when>
                    </xsl:choose>
                    
                </xsl:for-each>
                
            </div>
            
            
            
            
            
            <div class="plyr{$i} align-ctr {$disabled}">    
                <div class = "btnArea">         
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/bet/1" >
                        <img src = "http://localhost:8984/static/chip1.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/bet/5" >
                        <img src = "http://localhost:8984/static/chip5.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/bet/25" >
                        <img src = "http://localhost:8984/static/chip25.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/bet/50" >
                        <img src = "http://localhost:8984/static/chip50.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/bet/100" >
                        <img src = "http://localhost:8984/static/chip100.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/deal">
                        <img src = "http://localhost:8984/static/checked.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                </div>            
                <div class="betInfo">
                                
                    <span id="left" class="plyrLable">P<xsl:value-of select="$plyrID"/></span>
                    <span id="right">
                        Total Bet:&#160;<xsl:value-of select="sum(for $crd in //Game/betCredits/bet[@id=$plyrID] return $crd)"/>
                        <br/>Balance:&#160;<xsl:value-of select="credits"></xsl:value-of>
                    </span>
                </div>
            </div>
        </xsl:for-each>
        <xsl:variable name="plyrNum" select="count(Game/players/Player[id!=0])"></xsl:variable>
                    
        <xsl:if test="$plyrNum &lt; 5">
            <div class="plyr{$plyrNum + 1} align-ctr">
                <a href="http://localhost:8984/blackjack/t/{$id}/addPlayer" >
                    <img src = "http://localhost:8984/static/join.svg" class="joinBtn hvr-buzz"></img>
                </a>
            </div>
                    
        </xsl:if>
                    
        <xsl:for-each select="$plyrNum + 1 to 4">
                    
            <xsl:variable name="x" select="position()"></xsl:variable>
            <div class="plyr{$x+$plyrNum+1} align-ctr">
                        
                <img src = "http://localhost:8984/static/join.svg" class="joinBtn greyOut"></img>
                               
            </div>
        </xsl:for-each>
                    
    </xsl:template>
    
    <xsl:template name="state2">
        <xsl:param name="id"/>
        <xsl:variable name="onTurn" select="Game/players/@onTurn"></xsl:variable>
        <div class="deck"></div>
        <xsl:if test="$onTurn != -1">
            <div class="pseudoCard">
                <img src="http://localhost:8984/static/Cards/back.svg" class="globalSizeCard"></img> 
            </div>
        </xsl:if>
        <xsl:variable name="firstTurn">
            <xsl:if test="$onTurn = 0">animateFadeIn</xsl:if>
        </xsl:variable>
        
        <div class="dealersCardsArea align-ctr">
            <xsl:variable name="type" select="Game/players/Player[id=0]/handCards/Card[1]/type"/>
            <xsl:variable name="num" select="Game/players/Player[id=0]/handCards/Card[1]/number"/>
            <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="dealersCard {$firstTurn}"></img>
            <img src="http://localhost:8984/static/Cards/back.svg" class="dealersCard {$firstTurn}"></img>
        </div>
        
        
        <xsl:for-each select="Game/players/Player[id!=0]">
            <xsl:variable name="i" select="position()"></xsl:variable>
            <xsl:variable name="plyrID" select="id"></xsl:variable>
            
            <div class="coinArea{$i}">
                <xsl:for-each select="//Game/betCredits/bet[@id = $plyrID]">
                    <xsl:choose>
                        <xsl:when test="text() = 1">
                        <img src = "http://localhost:8984/static/chip1.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 5">
                        <img src = "http://localhost:8984/static/chip5.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 25">
                        <img src = "http://localhost:8984/static/chip25.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 50">
                        <img src = "http://localhost:8984/static/chip50.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 100">
                        <img src = "http://localhost:8984/static/chip100.svg" class="coinChip"></img>
                        </xsl:when>
                    </xsl:choose>
                    
                </xsl:for-each>
                
            </div>
            
            <div class="cardArea{$i} align-ctr ">    
                <div class="playersCardsArea ">       
                    <xsl:for-each select="handCards/Card">
                        
                        <xsl:variable name="type" select="type"/>
                        <xsl:variable name="num" select="number"/>
                        
                        <xsl:variable name="n" select="position()"/>
                        <xsl:choose>
                            <xsl:when test="$plyrID = $onTurn and $n = 1">
                                <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="playersCard animateFadeIn newHandCard"></img>
                            </xsl:when>
                            <xsl:when test="0=$onTurn">
                                <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="playersCard animateFadeIn"></img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="playersCard"></img>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        
                    
                    
                    </xsl:for-each>
                    <xsl:variable name="burstedAnimate">
                        <xsl:if test="$plyrID = $onTurn">animateFadeIn</xsl:if>
                    </xsl:variable>
                    <xsl:if test="state = 4">
                        <div class="bursted">
                            <img src="http://localhost:8984/static/bursted.svg" class="{$burstedAnimate}"></img>
                        </div>
                    </xsl:if>        
                </div>  
            </div>
            
            <xsl:variable name="disabled">
                <xsl:if test="state!=3">disabled greyOut</xsl:if>
            </xsl:variable>
            <xsl:variable name="insuranceDisabled">
                <xsl:choose>
                    <xsl:when test="@insurAgrd = 'true'">disabled</xsl:when>
                    <xsl:when test="//Game/players/Player[id=0]/handCards/Card[1]/number != 1">disabled greyOut</xsl:when>
                    <xsl:when test="//Game/players/Player[id=0]/handCards/Card[1]/number = 1 and state = 3">pulse</xsl:when>
                </xsl:choose>
                
            </xsl:variable>
            
            <xsl:variable name="insurChk">
                <xsl:if test="@insurAgrd = 'true'">Chk</xsl:if>
            </xsl:variable>

            
            <div class="plyr{$i} align-ctr {$disabled}">
                <div class = "btnArea">               
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/hit">
                        <img src = "http://localhost:8984/static/hit.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/stand" >
                        <img src = "http://localhost:8984/static/stand.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/insur" class="{$insuranceDisabled}">
                        <img src = "http://localhost:8984/static/insur{$insurChk}.svg" class="chip hvr-grow-shadow {$insuranceDisabled}"></img>
                    </a>
                </div>           
                <div class="betInfo">
                                
                    <span id="left" class="plyrLable">P<xsl:value-of select="$plyrID"/></span>
                    <span id="right">
                        Total Bet:&#160;<xsl:value-of select="sum(for $crd in //Game/betCredits/bet[@id=$plyrID] return $crd)"/>
                        <br/>Balance:&#160;<xsl:value-of select="credits"></xsl:value-of>
                    </span>
                </div>
            </div>
            
            
            
          
        </xsl:for-each>
        
    </xsl:template>
    
    
    
    <xsl:template name="state3">
        <xsl:param name="id"/>
        <xsl:variable name="onTurn" select="Game/players/@onTurn"></xsl:variable>
        <div class="deck"></div>
        <xsl:if test="$onTurn != -1">
            <div class="pseudoCard">
                <img src="http://localhost:8984/static/Cards/back.svg" class="globalSizeCard"></img> 
            </div>
        </xsl:if>
        <div class="pseudoCard2">
            <img src="http://localhost:8984/static/Cards/back.svg" class="globalSizeCard"></img> 
        </div>
       
 
        
        <div class="dealersCardsArea align-ctr">
            <xsl:variable name="type" select="Game/players/Player[id=0]/handCards/Card[1]/type"/>
            <xsl:variable name="num" select="Game/players/Player[id=0]/handCards/Card[1]/number"/>
            <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="dealersCard "></img>
           
            <div class="card">
                <xsl:variable name="flip">
                    <xsl:if test="$onTurn != 0">animateFlip</xsl:if>
                </xsl:variable>
                
                <xsl:variable name="type1" select="Game/players/Player[id=0]/handCards/Card[2]/type"/>
                <xsl:variable name="num1" select="Game/players/Player[id=0]/handCards/Card[2]/number"/>
                <img src="http://localhost:8984/static/Cards/{$type1}{$num1}.svg" class="dealersCard  card__back {$flip}1"></img>
                <img src="http://localhost:8984/static/Cards/back.svg" class="dealersCard card__front {$flip} dFirstCard"></img>
                
                
            </div>
            <div class = "dealerNewCards">
                <xsl:for-each select="Game/players/Player[id=0]/handCards/Card[position() >2]">
                    <xsl:variable name="i" select="position()"/>
                    <xsl:variable name="type" select="type"/>
                    <xsl:variable name="num" select="number"/>
                    <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="dealersCard animateFadeIn{$i} invisible"></img>
                </xsl:for-each>
            </div>
            <xsl:if test="(Game/players/Player[id=0]/handCards/@sum) &gt; 21">
                <img src="http://localhost:8984/static/bursted.svg" class="dealerBurst dealerBurstAnimate"></img>
            </xsl:if>
        </div>
        
        
        <xsl:for-each select="Game/players/Player[id!=0]">
            <xsl:variable name="i" select="position()"></xsl:variable>
            <xsl:variable name="plyrID" select="id"></xsl:variable>
            
            <div class="coinArea{$i}">
                <xsl:for-each select="//Game/betCredits/bet[@id = $plyrID]">
                    <xsl:choose>
                        <xsl:when test="text() = 1">
                        <img src = "http://localhost:8984/static/chip1.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 5">
                        <img src = "http://localhost:8984/static/chip5.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 25">
                        <img src = "http://localhost:8984/static/chip25.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 50">
                        <img src = "http://localhost:8984/static/chip50.svg" class="coinChip"></img>
                        </xsl:when>
                        <xsl:when test="text() = 100">
                        <img src = "http://localhost:8984/static/chip100.svg" class="coinChip"></img>
                        </xsl:when>
                    </xsl:choose>
                    
                </xsl:for-each>
                
            </div>
            <div class="cardArea{$i} align-ctr ">    
                <div class="playersCardsArea ">       
                    <xsl:for-each select="handCards/Card">
                        
                        <xsl:variable name="type" select="type"/>
                        <xsl:variable name="num" select="number"/>
                        
                        <xsl:variable name="n" select="position()"/>
                        <xsl:choose>
                            <xsl:when test="$plyrID = $onTurn and $n = 1">
                                <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="playersCard animateFadeIn newHandCard"></img>
                            </xsl:when>
                            <xsl:when test="0=$onTurn">
                                <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="playersCard animateFadeIn"></img>
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="http://localhost:8984/static/Cards/{$type}{$num}.svg" class="playersCard"></img>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                        
                    
                    
                    </xsl:for-each>
                    <xsl:variable name="burstedAnimate">
                        <xsl:if test="$plyrID = $onTurn">animateFadeIn</xsl:if>
                    </xsl:variable>
                    <xsl:if test="state = 4">
                        <div class="bursted">
                            <img src="http://localhost:8984/static/bursted.svg" class="{$burstedAnimate}"></img>
                        </div>
                    </xsl:if>        
                </div>  
            </div>
            


            
            <xsl:variable name="insurChk">
                <xsl:if test="@insurAgrd = 'true'">Chk</xsl:if>
            </xsl:variable>

            
            <div class="plyr{$i} align-ctr disabled greyOut">
                <div class = "btnArea">               
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/hit">
                        <img src = "http://localhost:8984/static/hit.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/stand" >
                        <img src = "http://localhost:8984/static/stand.svg" class="chip hvr-grow-shadow"></img>
                    </a>
                    
                    <a href="http://localhost:8984/blackjack/t/{$id}/p/{$plyrID}/insur" class="disabled greyOut">
                        <img src = "http://localhost:8984/static/insur{$insurChk}.svg" class="chip hvr-grow-shadow disabled greyOut"></img>
                    </a>
                </div>           
                <div class="betInfo">
                                
                    <span id="left" class="plyrLable">P<xsl:value-of select="$plyrID"/></span>
                    <span id="right">
                        Total Bet:&#160;<xsl:value-of select="sum(for $crd in //Game/betCredits/bet[@id=$plyrID] return $crd)"/>
                        <br/>Balance:&#160;<xsl:value-of select="credits"></xsl:value-of>
                    </span>
                </div>
            </div>
            
            
            
          
        </xsl:for-each>
        
    </xsl:template>
    
    
    <xsl:template match="/">
        <xsl:variable name="id" select="Game/id"></xsl:variable>
        <html>
            <head>
                <link href="http://localhost:8984/static/style_Tb.css" rel="stylesheet"/>
                <link href="http://ianlunn.github.io/Hover/css/hover.css" rel="stylesheet"/>
                <xsl:if test="not(Game/id)">
                    <meta http-equiv = "refresh" content = "5; url='http://localhost:8984/blackjack'"></meta>
                </xsl:if>
                <title>Black Jack</title>
                <xsl:variable name="onTurn" select="Game/players/@onTurn"></xsl:variable>
                <style>
                    <xsl:if test="Game/state=3">
                    
                    
                    
                    </xsl:if>
                    <xsl:if test="$onTurn = -1">
                        .animateFlip{
                        animation-name: flipCard;
                        animation-duration: 3s;

                        }
                        .animateFlip1{
                        animation-name: flipCard1;
                        animation-duration: 3s;

                        }
                        @keyframes flipCard{
                        0%      {   transform: rotateY(0deg); visibility: visible;}
                        10%     {   transform: rotateY(0deg); visibility: visible;}
                        100%    {	transform: rotateY(-180deg); visibility:hidden;}
                        animation-fill-mode: forwards;
                        }
                        @keyframes flipCard1{
                        0%      {   transform: rotateY(-180deg); visibility: hidden;}
                        10%     {   transform: rotateY(-180deg); visibility: hidden;}
                        100%    {	transform: rotateY(0deg); visibility: visible;}
                        animation-fill-mode: forwards;
                        }
                        
                        
                      
                    </xsl:if>
                    
                    .pseudoCard2{
                    width: 10%;
                    /*height: 100%;*/
                    position: absolute;
                    animation-name: plyr2Draw;
                    animation-duration: 3s;
                    animation-iteration-count:<xsl:value-of select="count(Game/players/Player[id=0]/handCards/Card[position() >2])"></xsl:value-of>;
                    animation-delay: 3s;
                    opacity: 0;
                    z-index: 99;
                    }
                    <xsl:for-each select="Game/players/Player[id=0]/handCards/Card[position() >2]">
                        
                        .animateFadeIn<xsl:value-of  select="position()"/>{
                        animation-name: cardFadeIn;
                        animation-duration: 3s;
                        animation-delay: <xsl:value-of  select="position() * 3"/>s;
                        animation-fill-mode: forwards;
                        }
                    
                    </xsl:for-each>
                    .dealerBurstAnimate{
                    animation-name: cardFadeIn;
                    animation-duration: 3s;
                    animation-delay: <xsl:value-of select="count(Game/players/Player[id=0]/handCards/Card[position() >2])*2+3"></xsl:value-of>s;
                    animation-fill-mode: forwards;
                    }
                    
                    .blur-Out{
                    animation-name: blur;
                    animation-duration: 4s;
                    animation-delay: <xsl:value-of select="count(Game/players/Player[id=0]/handCards/Card[position() >2])*2+6"></xsl:value-of>s;
                    animation-fill-mode: forwards;
                    }
                    .result{
                    animation-name: cardFadeIn;
                    animation-duration: 2s;
                    animation-delay: <xsl:value-of select="count(Game/players/Player[id=0]/handCards/Card[position() >2])*2+7"></xsl:value-of>s;
                    animation-fill-mode: forwards;
                    opacity: 0;
                    }
                    
                    
                    <xsl:variable name="left">
                        <xsl:choose>
                            <xsl:when test="$onTurn = 1">
                                5%
                            </xsl:when>
                            <xsl:when test="$onTurn = 2">
                                25%
                            </xsl:when>
                            <xsl:when test="$onTurn = 3">
                                45%
                            </xsl:when>
                            <xsl:when test="$onTurn = 4">
                                65%
                            </xsl:when>
                            <xsl:when test="$onTurn = 5">
                                85%
                            </xsl:when>
                            <xsl:otherwise>
                                45%
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    
                    @keyframes plyr1Draw {
                    0%  {opacity: 0; display: block; left:7%; top:1%; transform: rotate(90deg)}
                    20% {opacity: 1; display: block; left:7%; top:1%;transform: rotate(90deg)}
                    /*    50%  {left:25%; top:25%;}*/
                    80% {opacity: 1; display: block; left:<xsl:value-of select="$left"/>; top: 40% transform: rotate(0deg)}
                    100%{opacity: 0; display: block; left:<xsl:value-of select="$left"/>;  top: 40%}

                    }
                    
<!--                    <xsl:choose>
                        <xsl:when test="$onTurn = 0">
                            .pseudoCard{
                            width: 10%;
                            /*height: 100%;*/
                            position: absolute;
                            animation-name: plyr1Draw;
                            animation-duration: <xsl:value-of select="1.6 div count(Game/players/Player)"/>s;
                            animation-iteration-count:<xsl:value-of select="count(Game/players/Player)"/>;
                            opacity: 0;
                            z-index: 99;
                            }
                            
                        </xsl:when>
                        <xsl:otherwise>-->
                            .pseudoCard{
                            width: 10%;
                            /*height: 100%;*/
                            position: absolute;
                            animation-name: plyr1Draw;
                            animation-duration: 2s;
                            opacity: 0;
                            z-index: 99;
                            }
<!--                            
                            
                        </xsl:otherwise>
                    </xsl:choose>-->
                    
                    
                </style>
                
                
                
            </head>
            <body>
                
                <xsl:variable name="blur">
                    <xsl:if test="Game/state=3">blur-Out</xsl:if>
                </xsl:variable>
                <div class="container {$blur}">
                    <!--            <div class="deck"> </div>-->
          
          
          
                    <xsl:choose>
                        <xsl:when test="not(Game/id)">
                            <div class="desktitle">
                                <b>Game Not Available</b>
                                <div style="color: orange; font-size: 0.5em; padding-bottom: 10px">
                                    Please Start a Game
                                </div>
                
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="desktitle">
                                <b>BLACK JACK&#160;T<xsl:value-of select="Game/id"/></b>
                                <div style="color: orange; font-size: 0.5em; padding-bottom: 10px">
                                    PAYS 3 to 2
                                </div>
                
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                    <div class="exitBtn">
                        <a href="/blackjack/stopGame/{$id}" class="exBtn hvr-hang">Exit Game</a>
                    </div>
                    <div class="subtitle"></div>
                    <div class="cardArea1"></div>
                    <div class="cardArea2"></div>
                    <div class="cardArea3"></div>
                    <div class="cardArea4"></div>
                    <div class="cardArea5"></div>
                    <xsl:choose>
                        <xsl:when test="Game/state=1">
                            <xsl:call-template name="state1">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        
                        </xsl:when>
                        <xsl:when test="Game/state=2">
                            <xsl:call-template name="state2">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="Game/state=3">
                            <xsl:call-template name="state3">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        </xsl:when>
                    </xsl:choose>
                    

                    
          
        
                </div>
                <xsl:if test="Game/state=3">
                    <div class="result">
                        <h1>Result</h1>
                        <table style="width:100%; filter: drop-shadow(6px 16px 18px black);">
                            <tr>
                                <th>Players</th>
                                <th>Status</th>
                                <th>Points</th> 
                                <th>Bet</th>
                                <th>Pay</th>
                                <th>Win</th>
                            </tr>
                            <tr>
                                <td>Dealer</td>
                                <td>
                                    <xsl:if test="(//Game/players/Player[id=0]/handCards/@sum) &gt; 21">Busted</xsl:if>
                                    <xsl:if test="//Game/players/Player[id=0]/handCards/@sum = 21 and count(//Game/players/Player[id=0]/handCards/Card) = 2">Black Jack</xsl:if>
                                </td>
                                <td>
                                    <xsl:value-of select="Game/players/Player[id=0]/handCards/@sum"/>
                                </td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                            </tr>
                            <xsl:for-each select="Game/players/Player[id!=0]">
                                <xsl:variable name="plyrID" select="id"></xsl:variable>
                                <xsl:variable name="insur">
                                    <xsl:if test="@insurAgrd = 'true'">
                                        &#160;(Insured)
                                    </xsl:if>
                                </xsl:variable>
                                <xsl:variable name="pay" select="(//Game/betCredits/bet[@id=$plyrID])[1]/@pay">
                                    
                                </xsl:variable>
                                
                                <xsl:variable name="bets" select="sum(for $crd in //Game/betCredits/bet[@id=$plyrID] return $crd)"/>
                                
                                <tr>
                                    <td>Player&#160;<xsl:value-of select="id"></xsl:value-of>
                                        <xsl:value-of select="$insur"></xsl:value-of>
                                    </td>
                                    <td>
                                        <xsl:if test="handCards/@sum &gt; 21">Busted</xsl:if>
                                        <xsl:if test="handCards/@sum = 21 and count(//Game/players/Player[id=$plyrID]/handCards/Card) = 2">Black Jack</xsl:if>
                                    </td> 
                                    <td>
                                        <xsl:value-of select="handCards/@sum"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="$bets"/>
                                    </td>
                                    <td>
                                        <xsl:value-of select="$pay"></xsl:value-of>
                                    </td>
                                    <td>
                                        <xsl:value-of select="$pay - $bets"></xsl:value-of>
                                    </td>
                                </tr>                                
                                
                            </xsl:for-each>
                        </table>
                        <form method="get" action="/blackjack/t/{$id}/newTurn">
 
                            <button type="submit" value="Start" class="newBtn" >
                                <span>New Turn</span>
                            </button>
                        </form>
                    </div>    
                     
                     
                </xsl:if>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>