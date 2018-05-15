<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="Game">
        <html>
            <head>
                <title>TODO supply a title</title>
                
                <meta charset="UTF-8">
                    
                </meta>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    
                </meta>
                <link href="static/style_Tb.css" rel="stylesheet">
                    
                </link>
            </head>
            <body>
                <div class="container">
                    <!--            <div class="deck"> </div>-->
                    <div class="desktitle">
                        <b>BLACK JACK</b>
                        <div style="color: orange; font-size: 0.5em; padding-bottom: 10px">
                            PAYS 3 to 2
                        </div>
                        
                    </div>
                    <div class="indexBtn">
                        
                        
                        <form method="get" action="/blackjack/newGame/0">
                            
                            <button type="submit" value="Start" class="startBtn" ><span>Start Game</span></button>
                        </form>
                        
                    </div>
                    <!--            <div class="subtitle"></div>
                        <div class="cardArea1"></div>
                        <div class="cardArea2"></div>
                        <div class="cardArea3"></div>
                        <div class="cardArea4"></div>
                        <div class="cardArea5"></div>-->
                </div>
                
            </body>
        </html>
        
        
    </xsl:template>
    <xsl:template match="Table">
        <html>
            <head>
                <title>TODO supply a title</title>
                <meta charset="UTF-8"></meta>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"></meta>
                <link href="static/style_Tb.css" rel="stylesheet"></link>
            </head>
            <body>
                <div class="container">
                    <!--            <div class="deck"> </div>-->
                    <div class="desktitle">
                        <b>Table</b>
                        <div style="color: orange; font-size: 0.5em; padding-bottom: 10px">
                            Test
                        </div>
                        
                    </div>
                    <div class="indexBtn">
                        
                        
                        <form method="get" action="/blackjack/newGame/0">
                            
                            <button type="submit" value="Start" class="startBtn" ><span>Start Game</span></button>
                        </form>
                        
                    </div>
                    <!--            <div class="subtitle"></div>
                        <div class="cardArea1"></div>
                        <div class="cardArea2"></div>
                        <div class="cardArea3"></div>
                        <div class="cardArea4"></div>
                        <div class="cardArea5"></div>-->
                </div>
                
            </body>
        </html>
        
        
    </xsl:template>
</xsl:stylesheet>